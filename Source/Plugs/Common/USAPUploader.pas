{*******************************************************************************
  作者: dmzn@163.com 2012-4-6
  描述: 数据自动上行SAP
*******************************************************************************}
unit USAPUploader;

interface

uses
  Windows, Classes, SysUtils, UBusinessWorker, UBusinessPacker, UBusinessConst,
  UMgrDBConn, UWaitItem, ULibFun, USysDB, UMITConst, USysLoger;

type
  TSAPUploader = class;
  TSAPUploadThread = class(TThread)
  private
    FOwner: TSAPUploader;
    //拥有者
    FDB: string;
    FDBConn: PDBWorker;
    //数据对象
    FWorker: TBusinessWorkerBase;
    FPacker: TBusinessPackerBase;
    //业务对象
    FListA,FListB: TStrings;
    //列表对象
    FNumUploadPound: Integer;
    FNumPickupBill: Integer;
    FNumLoadBillStatisticInfo: Integer;
    //计时计数
    FWaiter: TWaitObject;
    //等待对象
    FSyncLock: TCrossProcWaitObject;
    //同步锁定
    FISPick: string;
    //是否延时拣配
  protected
    procedure DoPickupBill;
    procedure DoLoadBillStatisticInfo;
    procedure Execute; override;
    //执行线程
  public
    constructor Create(AOwner: TSAPUploader);
    destructor Destroy; override;
    //创建释放
    procedure Wakeup;
    procedure StopMe;
    //启止线程
  end;

  TSAPUploader = class(TObject)
  private
    FDB: string;
    //数据标识
    FThread: TSAPUploadThread;
    //扫描线程
  public
    constructor Create;
    destructor Destroy; override;
    //创建释放
    procedure Start(const nDB: string = '');
    procedure Stop;
    //起停上传
  end;

var
  gSAPUploader: TSAPUploader = nil;
  //全局使用

implementation

procedure WriteLog(const nMsg: string);
begin
  gSysLoger.AddLog(TSAPUploader, '数据延时同步', nMsg);
end;

constructor TSAPUploadThread.Create(AOwner: TSAPUploader);
begin
  inherited Create(False);
  FreeOnTerminate := False;

  FOwner := AOwner;
  FDB := FOwner.FDB;
  
  FListA := TStringList.Create;
  FListB := TStringList.Create;

  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 60 * 1000;
  //1 minute

  FSyncLock := TCrossProcWaitObject.Create('BusMIT_SAPUpload_Sync');
  //process sync
end;

destructor TSAPUploadThread.Destroy;
begin
  FWaiter.Free;
  FListA.Free;
  FListB.Free;

  FSyncLock.Free;
  inherited;
end;

procedure TSAPUploadThread.Wakeup;
begin
  FWaiter.Wakeup;
end;

procedure TSAPUploadThread.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TSAPUploadThread.Execute;
var nErr: Integer;
    nInit: Int64;
    nStr: string;
begin
  FNumUploadPound := 0;
  FNumPickupBill := 0;
  FNumLoadBillStatisticInfo := 0;
  //init counter

  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    Inc(FNumUploadPound);
    Inc(FNumPickupBill);
    Inc(FNumLoadBillStatisticInfo);
    //inc counter

 //   if FNumUploadPound >= 12 then
 //     FNumUploadPound := 0;
    //原材料上行SAP: 5次/小时

    if FNumPickupBill >= 4 then
      FNumPickupBill := 0;
    //延时简配: 15次/小时

 //   if FNumLoadBillStatisticInfo >= 5 then
 //     FNumLoadBillStatisticInfo := 0;
    //交货单统计: 12次/小时

    if (FNumUploadPound <> 0) and (FNumPickupBill <> 0) and
       (FNumLoadBillStatisticInfo <> 0) then
      Continue;
    //无业务可做

    //--------------------------------------------------------------------------
    if not FSyncLock.SyncLockEnter() then Continue;
    //其它进程正在执行                                                          
    
    FDBConn := nil;
    try
      FDBConn := gDBConnManager.GetConnection(FDB, nErr);
      if not Assigned(FDBConn) then Continue;

      FWorker := nil;
      FPacker := nil;

      nStr := 'Select D_Value From %s Where D_Name=''SysParam'' And D_Memo=''ISPickAuto''';
      nStr := Format(nStr, [sTable_SysDict]);

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      begin
        if (RecordCount > 0) and (Fields[0].AsString = 'Y') then FISPick := 'Y' else FISPick := 'N';
      end;

      if (FNumPickupBill = 0) and (FISPick = 'Y') then
      try
        FWorker := gBusinessWorkerManager.LockWorker(sBus_PickSaleBill);
        FPacker := gBusinessPackerManager.LockPacker(sSAP_PickSaleBill);

        WriteLog('开始袋装延时拣配...');
        nInit := GetTickCount;
        DoPickupBill;
        WriteLog('袋装延时拣配完毕,耗时: ' + IntToStr(GetTickCount - nInit));
      finally
        gBusinessPackerManager.RelasePacker(FPacker);
        FPacker := nil;
        gBusinessWorkerManager.RelaseWorker(FWorker);
        FWorker := nil;
      end;
    finally
      FSyncLock.SyncLockLeave();
      gDBConnManager.ReleaseConnection(FDBConn);
    end;
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

//Date: 2013-5-30
//Desc: 延时拣配
procedure TSAPUploadThread.DoPickupBill;
var nStr: string;
    nIn: TWorkerPickBillIn;
begin
  nStr := 'Select L_ID ,L_VALUE From %s Where (L_PickDate Is Null) And ' +
          '(%s - L_OutFact < 1) And L_Type=''%s''';
  nStr := Format(nStr, [sTable_Bill, sField_SQLServer_Now, sFlag_Dai]);
  //当天出厂未拣配袋装

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then Exit;
    FPacker.InitData(@nIn, True);
    First;
    while not Eof do
    begin
      with nIn do
      begin
        FDELIVERYORDERNO := Fields[0].AsString;
        FAMOUNT          := Fields[1].AsString;
        FBase.FMsgNO := sFlag_ForceDone + sFlag_BillPick + FDELIVERYORDERNO;
        WriteLog('延时拣配交货单：'+ FDELIVERYORDERNO + FBase.FMsgNO);
      end;
      nStr := FPacker.PackIn(@nIn);
      FWorker.WorkActive(nStr);

      Next;
    end;
  end;
end;

//Date: 2013-6-4
//Desc: 合并交货单统计信息
procedure TSAPUploadThread.DoLoadBillStatisticInfo;
var nStr: string;
    nIdx: Integer;
    nIn: TWorkerPostBillIn;
begin
  nStr := 'Select L_ID From %s Where (' +
          'L_ExtInfo < 2 and L_PostDate Is not Null)';
  nStr := Format(nStr, [sTable_Bill]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount < 1 then Exit;
    FListA.Clear;
    First;

    while not Eof do
    begin
      FListA.Add(Fields[0].AsString);
      Next;
    end;

    nStr := 'Update %s Set L_ExtInfo=L_ExtInfo+1 ' +
            'Where (L_ExtInfo < 2 and L_PostDate Is not Null)';
    nStr := Format(nStr, [sTable_Bill]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;

  FPacker.InitData(@nIn, True);
  FListB.Clear;

  for nIdx:=0 to FListA.Count - 1 do
  begin
    FListB.Add(FListA[nIdx]);
    if (FListB.Count < 10) and (nIdx < FListA.Count - 1) then Continue;
    //split
    
    nIn.FData := FListB.Text;
    FListB.Clear;
	nIn.FBase.FMsgNO := sFlag_NotMatter;

    nStr := FPacker.PackIn(@nIn);
    FWorker.WorkActive(nStr);
  end;
end;

//------------------------------------------------------------------------------
constructor TSAPUploader.Create;
begin
  FThread := nil;
end;

destructor TSAPUploader.Destroy;
begin
  Stop;
  inherited;
end;

procedure TSAPUploader.Start(const nDB: string);
begin
  if nDB = '' then
  begin
    if Assigned(FThread) then
      FThread.Wakeup;
    //start upload
  end else
  if not Assigned(FThread) then
  begin
    FDB := nDB;
    FThread := TSAPUploadThread.Create(Self);
  end;
end;

procedure TSAPUploader.Stop;
begin
  if Assigned(FThread) then
  begin
    FThread.StopMe;
    FThread := nil;
  end;
end;

initialization
  gSAPUploader := TSAPUploader.Create;
finalization
  FreeAndNil(gSAPUploader);
end.

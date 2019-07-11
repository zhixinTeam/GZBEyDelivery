{*******************************************************************************
  ����: dmzn@163.com 2012-4-6
  ����: �����Զ�����SAP
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
    //ӵ����
    FDB: string;
    FDBConn: PDBWorker;
    //���ݶ���
    FWorker: TBusinessWorkerBase;
    FPacker: TBusinessPackerBase;
    //ҵ�����
    FListA,FListB: TStrings;
    //�б����
    FNumUploadPound: Integer;
    FNumPickupBill: Integer;
    FNumLoadBillStatisticInfo: Integer;
    //��ʱ����
    FWaiter: TWaitObject;
    //�ȴ�����
    FSyncLock: TCrossProcWaitObject;
    //ͬ������
    FISPick: string;
    //�Ƿ���ʱ����
  protected
    procedure DoPickupBill;
    procedure DoLoadBillStatisticInfo;
    procedure Execute; override;
    //ִ���߳�
  public
    constructor Create(AOwner: TSAPUploader);
    destructor Destroy; override;
    //�����ͷ�
    procedure Wakeup;
    procedure StopMe;
    //��ֹ�߳�
  end;

  TSAPUploader = class(TObject)
  private
    FDB: string;
    //���ݱ�ʶ
    FThread: TSAPUploadThread;
    //ɨ���߳�
  public
    constructor Create;
    destructor Destroy; override;
    //�����ͷ�
    procedure Start(const nDB: string = '');
    procedure Stop;
    //��ͣ�ϴ�
  end;

var
  gSAPUploader: TSAPUploader = nil;
  //ȫ��ʹ��

implementation

procedure WriteLog(const nMsg: string);
begin
  gSysLoger.AddLog(TSAPUploader, '������ʱͬ��', nMsg);
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
    //ԭ��������SAP: 5��/Сʱ

    if FNumPickupBill >= 4 then
      FNumPickupBill := 0;
    //��ʱ����: 15��/Сʱ

 //   if FNumLoadBillStatisticInfo >= 5 then
 //     FNumLoadBillStatisticInfo := 0;
    //������ͳ��: 12��/Сʱ

    if (FNumUploadPound <> 0) and (FNumPickupBill <> 0) and
       (FNumLoadBillStatisticInfo <> 0) then
      Continue;
    //��ҵ�����

    //--------------------------------------------------------------------------
    if not FSyncLock.SyncLockEnter() then Continue;
    //������������ִ��                                                          
    
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

        WriteLog('��ʼ��װ��ʱ����...');
        nInit := GetTickCount;
        DoPickupBill;
        WriteLog('��װ��ʱ�������,��ʱ: ' + IntToStr(GetTickCount - nInit));
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
//Desc: ��ʱ����
procedure TSAPUploadThread.DoPickupBill;
var nStr: string;
    nIn: TWorkerPickBillIn;
begin
  nStr := 'Select L_ID ,L_VALUE From %s Where (L_PickDate Is Null) And ' +
          '(%s - L_OutFact < 1) And L_Type=''%s''';
  nStr := Format(nStr, [sTable_Bill, sField_SQLServer_Now, sFlag_Dai]);
  //�������δ�����װ

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
        WriteLog('��ʱ���佻������'+ FDELIVERYORDERNO + FBase.FMsgNO);
      end;
      nStr := FPacker.PackIn(@nIn);
      FWorker.WorkActive(nStr);

      Next;
    end;
  end;
end;

//Date: 2013-6-4
//Desc: �ϲ�������ͳ����Ϣ
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

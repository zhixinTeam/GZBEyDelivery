{*******************************************************************************
  作者: dmzn@163.com 2015-07-24
  描述: 远程业务对象,如:SAP,XBOX
*******************************************************************************}
unit UWorkerBusinessRemote;

{$I Link.Inc}
interface

uses
  Windows, Classes, Controls, DB, SysUtils, UBusinessWorker, UBusinessPacker,  UBusinessConst, UMgrDBConn, UMgrParam, UMgrChannel, UWorkerBusinessCommand,
  UWorkerBusinessBill, IdHTTP, UObjectList;

type
  TMIT2SAPWorker = class(TMITDBWorker)
  protected
    FMITChannel: PChannelItem;
    //连接通道
    procedure GetMsgNo(nPairID: string; var nMsgNo,nKey: string);
    procedure UpdateMsgStatus(const nMsgNo,nStatus: string);
    //消息号
    function DoDBWork(var nData: string): Boolean; override;
    function DoAfterDBWork(var nData: string; nResult: Boolean): Boolean; override;
    //执行业务
    function DoAfterCallSAP(var nData: string): Boolean; virtual;
    function DoAfterCallSAPDone(var nData: string): Boolean; virtual;
    //SAP调用结束
  end;

  TBusWorkerReadXSSaleOrder = class(TMIT2SAPWorker)
  protected
    FIn: TReadXSSaleOrderIn;
    FOut: TReadXSSaleOrderOut;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TBusWorkerReadCRMOrder = class(TMIT2SAPWorker)
  protected
    FIn: TReadCRMOrderIn;
    FOut: TReadCrmOrderOut;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TBusWorkerCreateSaleBill = class(TMIT2SAPWorker)
  protected
    FTYPE: string;              //包散标识
    FCARDID : string;           //电子标签号
    FOrder: string;
    FIn: TWorkerCreateBillIn;
    FOut: TBWDataBase;
    FStockItems: array of TStockMatchItem;
    FMatchItems: array of TStockMatchItem;
    //xxxxx
    function GetStockGroup(const nStock: string): string;
    function GetMatchRecord(const nStock: string): string;
    //物料分组
    function VerifyParamIn(var nData: string): Boolean; override;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoAfterCallSAPDone(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    class function VerifyTruckNO(nTruck: string; var nData: string): Boolean;
    //验证车牌是否有效
  end;

  TBusWorkerModifySaleBill = class(TMIT2SAPWorker)
  protected
    FIn: TWorkerModfiyBillIn;
    FOut: TBWDataBase;
    //xxxxx
    FOldTruck: string;
    FOldValue: Double;
    FZTRecordID: string;
    FMultiBill: Boolean;
    FBills,FRecords: TStrings;
    function VerifyParamIn(var nData: string): Boolean; override;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoAfterCallSAPDone(var nData: string): Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TBusWorkerDeleteSaleBill = class(TMIT2SAPWorker)
  protected
    FIn: TWorkerDeleteBillIn;
    FOut: TBWDataBase;
    //xxxxx
    FBills: TStrings;
    FOldBill: string;
    FOldValue: Double;
    FZTRecordID: string;
    FTrucklogID: string;
    function VerifyParamIn(var nData: string): Boolean; override;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoAfterCallSAPDone(var nData: string): Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TBusWorkerPickSaleBill = class(TMIT2SAPWorker)
  protected
    FIn: TWorkerPickBillIn;
    FOut: TWorkerPickBillOut;
    function VerifyParamIn(var nData: string): Boolean; override;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoAfterCallSAP(var nData: string): Boolean; override;
    function DoAfterCallSAPDone(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TBusWorkerPostSaleBill = class(TMIT2SAPWorker)
  protected
    FList: TStrings;
    FIn: TWorkerPostBillIn;
    FOut: TWorkerPostBillOut;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoAfterCallSAPDone(var nData: string): Boolean; override;
  public
    constructor Create; override;
    destructor destroy; override;
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TBusWorkerDiaozhangBill = class(TMIT2SAPWorker)
  protected
    FIn: TWorkerDiaozhangBillIn;
    FOut: TWorkerDiaozhangBillOut;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
    function DoAfterCallSAPDone(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TBusWorkerTZROrderForCus = class(TMIT2SAPWorker)
  protected
    FIn: TWorkerROrderForCusin;
    FOut: TWorkerROrderForCusOut;
    procedure GetInOutData(var nIn,nOut: PBWDataBase); override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

implementation

uses
  ULibFun, ZnMD5, UFormCtrl, MIT_Service_Intf, UMITConst, USysLoger, USysDB;

//Date: 2015-03-03
//Desc: 创建对象
function NewHttp(const nClass: TClass): TObject;
begin
  Result := TIdHTTP.Create(nil);
end;

//Date: 2015-03-03
//Desc: 释放对象
procedure FreeHttp(const nObject: TObject);
begin
  TIdHTTP(nObject).Free;
end;

//Date: 2015-03-03
//Parm: 入参数据
//Desc: 使用XBox链路读写SAP
function TMIT2SAPWorker.DoDBWork(var nData: string): Boolean;
var nStr: string;
    nInt,nIdx: Integer;
    nWorker: TBusinessWorkerBase;
begin
  Result := False;
  nInt := InterlockedExchange(gXBoxURLInited, 10);
  //get init status
  
  try
    if nInt < 1 then
    begin
      if not Assigned(gObjectPoolManager) then
        gObjectPoolManager := TObjectPoolManager.Create;
      gObjectPoolManager.RegClass(TIdHTTP, NewHttp, FreeHttp);

      SetLength(gXBoxURLs, 0);
      nStr := 'Select * From ' + sTable_XBoxURL;

      with gDBConnManager.WorkerQuery(FDBConn, nStr) do
      if RecordCount > 0 then
      begin
        SetLength(gXBoxURLs, RecordCount);
        nIdx := 0;
        First;

        while not Eof do
        begin
          with gXBoxURLs[nIdx] do
          begin
            FSAPName := FieldByName('U_Name').AsString;
            FXBoxURL := FieldByName('U_Host').AsString +
                        FieldByName('U_Path').AsString;
            //xxxxx

            FXBoxParam := StringReplace(FieldByName('U_FixParam').AsString,
                          '$method',
                          FieldByName('U_Method').AsString, [rfIgnoreCase]);
            //xxxxx;

            FEncodeURL := FieldByName('U_EncodeURL').AsString <> sFlag_No;
            FEncodeXML := FieldByName('U_EncodeXML').AsString = sFlag_Yes;
          end;

          Inc(nIdx);
          Next;
        end;
      end;
    end;
  except
    InterlockedExchange(gXBoxURLInited, nInt);
  end;

  nWorker := nil;
  try
    if FDataIn.FMSGNO = '' then
    begin
      nData := '无效的业务操作编号(MsgNo Invalid).';
      Exit;
    end;

    GetMsgNo(FDataIn.FMsgNO, FDataIn.FMsgNO, FDataIn.FKEY);
    //get serial message no

    nData := FPacker.PackIn(FDataIn);
    //pack data

    nWorker := gBusinessWorkerManager.LockWorker(GetFlagStr(cWorker_GetSAPName));
    //get worker

    Result := nWorker.WorkActive(nData);
    //do business
  finally
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Date: 2012-3-22
//Parm: 数据;结果
//Desc: 数据业务调用完毕,执行结果
function TMIT2SAPWorker.DoAfterDBWork(var nData: string;
 nResult: Boolean): Boolean;
begin
  Result := True;
  if not nResult then
  begin
    UpdateMsgStatus(FDataIn.FMSGNO, sFlag_No);
    Exit;
  end;

  Result := DoAfterCallSAP(nData);
  if not Result then Exit;

  if FDataOut.FResult then
  begin
    Result := DoAfterCallSAPDone(nData);
    if not Result then Exit;
  end; //business is done

  if FDataOut.FResult then
       FDataIn.FKEY := sFlag_Yes
  else FDataIn.FKEY := sFlag_No;

  UpdateMsgStatus(FDataIn.FMsgNO, FDataIn.FKEY);
  //update status
end;

//Date: 2012-3-18
//Parm: 入参数据
//Desc: SAP调用结束后
function TMIT2SAPWorker.DoAfterCallSAP(var nData: string): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-14
//Parm: 入参数据
//Desc: SAP调用成功后
function TMIT2SAPWorker.DoAfterCallSAPDone(var nData: string): Boolean;
begin
  Result := True;
end;

//Date: 2012-3-9
//Parm: 匹配号;消息号;重复标记
//Desc: 获取nPairID对应的nMsg和nKey
procedure TMIT2SAPWorker.GetMsgNo(nPairID: string; var nMsgNo, nKey: string);
var nStr,nKeyM: string;
begin

  nKeyM :=  nKey;    //接口业务描述
  
  if Pos(sFlag_ManualNo, nPairID) = 1 then
  begin
    nMsgNo := nPairID;
    System.Delete(nMsgNo, 1, Length(sFlag_ManualNo));
    Exit;
  end;
  //用户指定编号,系统不做任何动作

  if Pos(sFlag_NotMatter, nPairID) = 1 then
  begin
    nStr := 'Select B_Prefix,B_IDLen From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, sFlag_SerialSAP, sFlag_SAPMsgNo]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      nKey := Fields[0].AsString;
      nStr := StringOfChar('0', Fields[1].AsInteger-Length(nKey));

      nMsgNo := nKey + nStr;
      nKey := '0';
      Exit;
    end;
  end;
  //任意编号模式,除前缀外都是0

  if Pos(sFlag_FixedNo, nPairID) = 1 then
  begin
    nStr := 'Select Top 1 S_SerailID From %s ' +
            'Where S_PairID=''%s'' And S_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialStatus, nPairID, sFlag_SAPMsgNo]);
  end else
  //指定编号模式,使用相同的编号

  if Pos(sFlag_ForceDone, nPairID) = 1 then
  begin
    nStr := 'Select Top 1 S_SerailID From %s ' +
            'Where S_Status=''%s'' And S_PairID=''%s'' And S_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialStatus, sFlag_Unknow,
            nPairID, sFlag_SAPMsgNo]);
  end else
  //强制完成模式,完成前(Unknow)使用相同编号

  begin
    nStr := 'Select Top 1 S_SerailID From %s Where S_Date>%s-1 And ' +
            'S_Status=''%s'' And S_Object=''%s'' And S_PairID=''%s''';
    nStr := Format(nStr, [sTable_SerialStatus, sField_SQLServer_Now,
            sFlag_Unknow, sFlag_SAPMsgNo, nPairID]);
  end;
  //常规模式,完成前(Unknow)编号一天内匹配

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    nMsgNo := Fields[0].AsString;
    nKey := '3';
    Exit;
  end;

  FDBConn.FConn.BeginTrans;
  try
    nStr := 'Update %s Set B_Base=B_Base+1 ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, sFlag_SerialSAP, sFlag_SAPMsgNo]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Select B_Prefix,B_IDLen,B_Base From %s ' +
            'Where B_Group=''%s'' And B_Object=''%s''';
    nStr := Format(nStr, [sTable_SerialBase, sFlag_SerialSAP, sFlag_SAPMsgNo]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      nKey := Fields[0].AsString;
      nMsgNo := Fields[2].AsString;
      nStr := StringOfChar('0', Fields[1].AsInteger-Length(nKey)-Length(nMsgNo));

      nMsgNo := nKey + nStr + nMsgNo;
      nKey := '0';
    end;

    nStr := MakeSQLByStr([SF('S_Object', sFlag_SAPMsgNo), SF('S_PairID', nPairID),
            SF('S_SerailID', nMsgNo), SF('S_Status', sFlag_Unknow),
            SF('S_Date', sField_SQLServer_Now, sfVal),sf('S_Key',nKeyM)
            ],sTable_SerialStatus, '', True);          
    //xxxxx

    gDBConnManager.WorkerExec(FDBConn, nStr);
    FDBConn.FConn.CommitTrans;
  except
    FDBConn.FConn.RollbackTrans;
  end;
end;

//Date: 2012-3-9
//Parm: 消息号;状态
//Desc: 更新nMsgNo的状态为nStatus
procedure TMIT2SAPWorker.UpdateMsgStatus(const nMsgNo, nStatus: string);
var nStr: string;
begin
  if (Pos(sFlag_NotMatter, nMsgNo) = 1) and (Pos('NT', nMsgNo) <> 1) then
  begin
    Exit;
  end;
  //任意编号模式无需更新

  nStr := 'Update %s Set S_Status=''%s'' ' +
          'Where S_SerailID=''%s'' And S_Object=''%s''';
  nStr := Format(nStr, [sTable_SerialStatus, nStatus, nMsgNo, sFlag_SAPMsgNo]);
  gDBConnManager.WorkerExec(FDBConn, nStr);
end;

//------------------------------------------------------------------------------
class function TBusWorkerReadXSSaleOrder.FunctionName: string;
begin
  Result := sBus_ReadXSSaleOrder;
end;

function TBusWorkerReadXSSaleOrder.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_ReadXSSaleOrder;
   cWorker_GetSAPName    : Result := sSAP_ReadXSSaleOrder;
  end;
end;

procedure TBusWorkerReadXSSaleOrder.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
end;

//------------------------------------------------------------------------------
class function TBusWorkerReadCRMOrder.FunctionName: string;
begin
  Result := sBus_ReadCRMOrder;
end;

function TBusWorkerReadCRMOrder.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_ReadCrmOrder;
   cWorker_GetSAPName    : Result := sSAP_ReadCrmOrder;
  end;
end;

procedure TBusWorkerReadCRMOrder.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
end;

//------------------------------------------------------------------------------
class function TBusWorkerCreateSaleBill .FunctionName: string;
begin
  Result := sBus_CreateSaleBill;
end;

function TBusWorkerCreateSaleBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_CreateSaleBill;
   cWorker_GetSAPName    : Result := sSAP_CreateSaleBill;
  end;
end;

procedure TBusWorkerCreateSaleBill.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
end;


//Date: 2014/7/30
//Parm: 品种编号
//Desc: 检索nStock对应的物料分组
function TBusWorkerCreateSaleBill.GetStockGroup(const nStock: string): string;
var nIdx: Integer;
begin
  Result := '';
  //init

  for nIdx:=Low(FStockItems) to High(FStockItems) do
  if FStockItems[nIdx].FStock = nStock then
  begin
    Result := FStockItems[nIdx].FGroup;
    Exit;
  end;
end;

//Date: 2014/7/30
//Parm: 品种编号
//Desc: 检索车辆队列中与nStock同品种,或同组的记录
function TBusWorkerCreateSaleBill.GetMatchRecord(const nStock: string): string;
var nStr: string;
    nIdx: Integer;
begin
  Result := '';
  //init

  for nIdx:=Low(FMatchItems) to High(FMatchItems) do
  if FMatchItems[nIdx].FStock = nStock then
  begin
    Result := FMatchItems[nIdx].FRecord;
    Exit;
  end;

  nStr := GetStockGroup(nStock);
  if nStr = '' then Exit;

  for nIdx:=Low(FMatchItems) to High(FMatchItems) do
  if FMatchItems[nIdx].FGroup = nStr then
  begin
    Result := FMatchItems[nIdx].FRecord;
    Exit;
  end;
end;


//Date: 2014-09-16
//Parm: 车牌号;
//Desc: 验证nTruck是否有效
class function TBusWorkerCreateSaleBill.VerifyTruckNO(nTruck: string;
  var nData: string): Boolean;
var nIdx: Integer;
    nWStr: WideString;
begin
  Result := False;
  nIdx := Length(nTruck);
  if (nIdx < 3) or (nIdx > 10) then
  begin
    nData := '有效的车牌号长度为3-10.';
    Exit;
  end;

  nWStr := LowerCase(nTruck);
  //lower

  for nIdx:=1 to Length(nWStr) do
  begin
    case Ord(nWStr[nIdx]) of
     Ord('-'): Continue;
     Ord('0')..Ord('9'): Continue;
     Ord('a')..Ord('z'): Continue;
    end;

    if nIdx > 1 then
    begin
      nData := Format('车牌号[ %s ]无效.', [nTruck]);
      Exit;
    end;
  end;

  Result := True;
end;

function TBusWorkerCreateSaleBill.VerifyParamIn(var nData: string): Boolean;
var nStr,nTruck: string;
    nIdx: Integer;
begin
  Result := False;
  nTruck := FIn.FDELIVERYNUMBER;
  if not VerifyTruckNO(nTruck, nData) then Exit;
  //truck no

  FCARDID :=  '';
  nStr := 'Select a.t_VALID ,b.C_CARD From %s a '+
          ' Left Join %s b on t_card = c_card2 '+
          'WHERE T_TRUCK = ''%S''';
  nStr := Format(nStr, [sTable_Truck, sTable_Card ,nTruck]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
     if Fields[0].AsString = 'N' then
     begin
         nStr := '车辆[ %s ] 已是黑名单,不允许开单';
         nData := Format(nStr, [FIn.FDELIVERYNUMBER]);
         Exit;
     end;
     FCARDID :=  Fields[1].AsString ;  //电子标签号
  end;
  //绑定电子标签

  nStr := 'Select D_VALUE,D_ParamB From %s Where D_NAME =''%s'' AND D_VALUE = ''%S''';
  nStr := Format(nStr, [sTable_Dict, sFlag_LineStock,FIn.FPRODUCTCODE]);
  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
     FTYPE :=  Fields[1].AsString ;  //  包、散类型
  end else
  begin
    nStr := '系统未维护对应品种[ %s ] 包、散类型';
    nData := Format(nStr, [FIn.FPRODUCTCODE]);
    Exit;
  end;
  //检查是否维护对应品种类型

  //----------------------------------------------------------------------------
  SetLength(FStockItems, 0);
  SetLength(FMatchItems, 0);
  //init

  nStr := 'Select M_ID,M_Group From %s Where M_Status=''%s'' ';
  nStr := Format(nStr, [sTable_StockMatch, sFlag_Yes]);
  //品种分组匹配

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    SetLength(FStockItems, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      FStockItems[nIdx].FStock := Fields[0].AsString;
      FStockItems[nIdx].FGroup := Fields[1].AsString;

      Inc(nIdx);
      Next;
    end;
  end;

  nStr := 'Select R_ID,T_Bill,T_StockNo,T_Type,T_InFact,T_Valid From %s ' +
          'Where T_Truck=''%s'' ';
  nStr := Format(nStr, [sTable_ZTTrucks, FIn.FDELIVERYNUMBER]);
  //还在队列中车辆

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    SetLength(FMatchItems, RecordCount);
    nIdx := 0;
    First;

    while not Eof do
    begin
      if FieldByName('T_Type').AsString = sFlag_San then
      begin
        nStr := '车辆[ %s ]在未完成[ %s ]交货单之前禁止开单.';
        nData := Format(nStr, [FIn.FDELIVERYNUMBER, Fields[1].AsString]);
        Exit;
      end else

      if (FieldByName('T_Type').AsString = sFlag_Dai) and
         (FieldByName('T_InFact').AsString <> '') then
      begin
        nStr := '车辆[ %s ]在未完成[ %s ]交货单之前禁止开单.';
        nData := Format(nStr, [FIn.FDELIVERYNUMBER, Fields[1].AsString]);
        Exit;
      end else

      if FieldByName('T_Valid').AsString = sFlag_No then
      begin
        nStr := '车辆[ %s ]有已出队的交货单[ %s ],需先处理.';
        nData := Format(nStr, [FIn.FDELIVERYNUMBER, Fields[2].AsString]);
        Exit;
      end;

      with FMatchItems[nIdx] do
      begin
        FStock := FieldByName('T_StockNo').AsString;
        FGroup := GetStockGroup(FStock);
        FRecord := FieldByName('R_ID').AsString;
      end;

      Inc(nIdx);
      Next;
    end;
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select Count(*) From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_Truck, FIn.FDELIVERYNUMBER]);
  //xxxxx

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if Fields[0].AsInteger < 1 then
  begin
    nStr := 'Insert Into %s(T_Truck, T_PY) Values(''%s'', ''%s'')';
    nStr := Format(nStr, [sTable_Truck, FIn.FDELIVERYNUMBER, GetPinYinOfStr(FIn.FDELIVERYNUMBER)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
  end;
  //写入车辆表

  FOrder := PackerDecodeStr(FIn.fFOrder);
  FIn.FFOrder := '';
  
  Result := True;
end;

//Date: 2012-3-14
//Parm: 入参
//Desc: SAP生成提货单完毕,写入数据库
function TBusWorkerCreateSaleBill.DoAfterCallSAPDone(var nData: string): Boolean;
var nStr,nTruck,nBill,nXSOrder: string;
    nXSOut: TReadXSSaleOrderOut;
    nCRMOut: TReadCrmOrderOut;
    nPacker: TBusinessPackerBase;
begin
  nPacker := nil;
  Result := False;

  with gBusinessPackerManager do
  try
    if FIn.FFType = sFlag_XS then
    begin
      nPacker := LockPacker(sSAP_ReadXSSaleOrder);
      nPacker.UnPackOut(FOrder, @nXSOut);
    end else

    if FIn.FFType = sFlag_CRM then
    begin
      nPacker := LockPacker(sSAP_ReadCrmOrder);
      nPacker.UnPackOut(FOrder, @nCRMOut);
    end else
    begin
      nData := '无效的创单类型';
      Exit;
    end;
  finally
    RelasePacker(nPacker);
  end;
//------------------------------------------------------------------------------

  FDBConn.FConn.BeginTrans;
  try
    if FIn.FDELIVERLISYNO = '' then     //提货委托单号
         nStr := nXSOut.FPRODUCTCODE
    else nStr := nCRMOut.FPRODUCTCODE;

    nStr := GetMatchRecord(nStr);
    //该品种在装车队列中的记录号

    if nStr <> '' then
    begin
      nTruck := 'Update $TK Set T_Value=T_Value + $Val,' +
                'T_HKBills=T_HKBills+''$BL.'' Where R_ID=$RD';
      nTruck := MacroValue(nTruck, [MI('$TK', sTable_ZTTrucks), MI('$RD', nStr),
                MI('$Val', FloatToStr(FIn.FAMOUNT)), MI('$BL', FIn.FDELIVERYORDERNO)]);
      //update value
    end else
    begin
      nTruck := MakeSQLByStr([
        SF('T_Truck'   , FIn.FDELIVERYNUMBER),
        SF('T_StockNo' , FIn.FPRODUCTCODE),
        SF('T_Stock'   , FIn.FPRODUCTNAME),
        SF('T_Type'    , FTYPE),                                                //品种类型(D,S)
        SF('T_InTime'  , sField_SQLServer_Now, sfVal),                          //入队时间
        SF('T_Bill'    , FIn.FDELIVERYORDERNO),
        SF('T_Valid'   , sFlag_Yes),                                            //T_Valid: 是否有效
        SF('T_Value'   , FIn.FAMOUNT),
        SF('T_VIP'     , FIn.FCHANNELTYPE),
        SF('T_HKBills' , FIn.FDELIVERYORDERNO + '.')
        ], sTable_ZTTrucks, '', True);
      //insert ZTTrucks record
    end;
    if nTruck <> '' then
    gDBConnManager.WorkerExec(FDBConn, nTruck);
    //车辆入队


  //--------------------------------------------------------------------------

    nBill := MakeSQLByStr([
      SF('L_ID'      , FIn.FDELIVERYORDERNO),                                   //交货单号
      SF('L_ZhiKa'   , FIn.FORDERNO),                                           //订单编号
      SF('L_Area'    , FIn.FREGIONTEXT),                                        //区域名称
      SF('L_CusID'   , FIn.FBUYPARTCODE),                                       //客户编号
      SF('L_CusName' , FIn.FBUYPARTNAME),                                       //客户名称
      SF('L_SaleMan' , FIn.FBase.FFrom.FUser),                                  //业务员
      SF('L_Type'    , FTYPE),                                                  //品种类型(D,S)
      SF('L_StockNo' , FIn.FPRODUCTCODE),                                       //库存编号
      SF('L_StockName',FIn.FPRODUCTNAME),                                       //库存名称
      SF('L_Value'   , FIn.FAMOUNT),                                            //提货量
      SF('L_Truck'   , FIn.FDELIVERYNUMBER),                                    //车牌号
      SF('L_TruckName',FIn.FTRUCKNAME),                                         //司机姓名
      SF('L_TruckTel' ,FIn.FTRUCKTEL),                                          //司机电话
      SF('L_IsVIP'   , FIn.FCHANNELTYPE),                                       //业务类型（VIP单、船运、 栈台 、普通 ）
      SF('L_Seal'    , FIn.FSEALATEXT),                                         //封签号
      SF('L_CRM'     , FIn.FDELIVERLISYNO),                                     //提货委托单编号
      SF('L_Status'  , sFlag_BillNew),                                          //车辆当前状态
      SF('L_Price'   , FIn.FTOTALPRICE),                                        //到位价
      SF('L_Project' , FIn.FNONUMBER),                                          //证件号码
      SF('L_Action'  , sFlag_BillNew),
      SF('L_Result'  , sFlag_Yes),
      SF('L_ELabel'  , FCARDID),                                                //电子标签
      SF('L_Man'     , FIn.FBase.FFrom.FUser),                                  //创建人
      SF('L_Date'    , sField_SQLServer_Now,sfVal)                              //创建时间
      ], sTable_Bill, '', True);
    //insert Bill record
      gDBConnManager.WorkerExec(FDBConn, nBill);
      gSysLoger.AddLog(nBill);

   //---------------------------------------------------------------------------
   if FIn.FFType = sFlag_XS then
   begin
     nXSOrder := MakeSQLByStr([
        SF('BILLID'        ,  FIn.FDELIVERYORDERNO),
        SF('ORDERCODE'     ,  nXSOut.FORDERCODE),
        SF('ORDERTYPE    ' ,  nXSOut.FORDERTYPE),
        SF('STATUS       ' ,  nXSOut.FSTATUS),
        SF('BUYPARTCODE  ' ,  nXSOut.FBUYPARTCODE),
        SF('BUYPARTNAME  ' ,  nXSOut.FBUYPARTNAME),
        SF('PRODUCTCODE  ' ,  nXSOut.FPRODUCTCODE),
        SF('PRODUCTNAME  ' ,  nXSOut.FPRODUCTNAME),
        SF('STANDARD     ' ,  nXSOut.FSTANDARD),
        SF('UNIT         ' ,  nXSOut.FUNIT),
        SF('FACTORYPRICE ' ,  nXSOut.FFACTORYPRICE),
        SF('TOTALPRICE   ' ,  nXSOut.FTOTALPRICE),
        SF('OUTAMOUNT    ' ,  nXSOut.FOUTAMOUNT),
        SF('SURPLUSAMOUNT' ,  nXSOut.FSURPLUSAMOUNT),
        SF('AMOUNT       '  , nXSOut.FAMOUNT),
        SF('TRANSTYPE    '  , nXSOut.FTRANSTYPE),
        SF('TOTALMONEY   '  , nXSOut.FTOTALMONEY),
        SF('CONTRACTNO   '  , nXSOut.FCONTRACTNO),
        SF('REGIONCODE '    , nXSOut.FREGIONCODE ),
        SF('REVEIVENAME '   , FIn.FREVEIVENAME ),
        SF('REGIONNAME '    , nXSOut.FREGIONNAME)
        ], sTable_OrderXS, '', True);
      //insert record
   end;

   if FIn.FFType = sFlag_CRM then
    begin
       nXSOrder := MakeSQLByStr([
        SF('BILLID'        ,  FIn.FDELIVERYORDERNO),
        SF('ORDERCODE'     ,  nCRMOut.FORDERNO),
        SF('ORDERTYPE    ' ,  nCRMOut.FORDERTYPE),
        SF('STATUS       ' ,  nCRMOut.FSTATUS),
        SF('BUYPARTCODE  ' ,  nCRMOut.FBUYPARTCODE),
        SF('BUYPARTNAME  ' ,  nCRMOut.FBUYPARTNAME),
        SF('PRODUCTCODE  ' ,  nCRMOut.FPRODUCTCODE),
        SF('PRODUCTNAME  ' ,  nCRMOut.FPRODUCTNAME),
        SF('STANDARD     ' ,  nCRMOut.FSTATUS),
        SF('UNIT         ' ,  nCRMOut.FUNIT),
        SF('FACTORYPRICE ' ,  nCRMOut.FFACTORYPRICE),
        SF('TOTALPRICE   ' ,  nCRMOut.FTOTALPRICE),
        SF('OUTAMOUNT    ' ,  nCRMOut.FOUTAMOUNT),
        SF('SURPLUSAMOUNT' ,  nCRMOut.FSURPLUSAMOUNT),
        SF('AMOUNT       '  , nCRMOut.FAMOUNT),
        SF('TRANSTYPE    '  , nCRMOut.FTRANSTYPE),
        SF('TOTALMONEY   '  , nCRMOut.FTOTALMONEY),
        SF('CONTRACTNO   '  , nCRMOut.FCONTRACTNO),
        SF('REGIONCODE '    , nCRMOut.FREGIONCODE ),
        SF('REVEIVENAME '   , FIn.FREVEIVENAME ),
        SF('REGIONNAME '    , nCRMOut.FREGIONNAME)
        ], sTable_OrderXS, '', True);
      //insert record
    end;
    gDBConnManager.WorkerExec(FDBConn, nXSOrder);

    FDBConn.FConn.CommitTrans;
    Result := True;
  except
    on E:Exception do
    begin
      FDBConn.FConn.RollbackTrans;
      nData := Format('保存交货单失败,描述: %s', [E.Message]);
    end;
  end;
end;

//-----------------------------------------------------------------------------
class function TBusWorkerModifySaleBill.FunctionName: string;
begin
  Result := sBus_ModifySaleBill;
end;

constructor TBusWorkerModifySaleBill.Create;
begin
  inherited;
  FBills := TStringList.Create;
  FRecords := TStringList.Create;
end;

destructor TBusWorkerModifySaleBill.Destroy;
begin
  FRecords.Free;
  FBills.Free;
  inherited;
end;

function TBusWorkerModifySaleBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_ModifySaleBill;
   cWorker_GetSAPName    : Result := sSAP_ModifySaleBill;
  end;
end;

procedure TBusWorkerModifySaleBill.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
end;

function TBusWorkerModifySaleBill.VerifyParamIn(var nData: string): Boolean;
var nStr: string;
    nList: TStrings;
begin
  Result := True;
  FBills.Clear;
  FRecords.Clear;

  FOldValue := 0;
  FZTRecordID := '';
  FMultiBill := False;
  
  nStr := 'Select L_Value,L_Truck From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FIn.FDELIVERYORDERNO]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount <> 1 then
    begin
      nData := '交货单[ %s ]已无效.';
      nData := Format(nData, [FIn.FDELIVERYORDERNO]);

      Result := False;
      Exit;
    end;

    FOldValue := Fields[0].AsFloat;
    FOldTruck := Fields[1].AsString;
  end;

  nList := nil;
  nStr := 'Select R_ID,T_HKBills From %s Where T_Truck=''%s''';
  nStr := Format(nStr, [sTable_ZTTrucks, FOldTruck]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  try
    nList := TStringList.Create;
    First;

    while not Eof do
    begin
      SplitStr(Fields[1].AsString, nList, 0, '.');
      FBills.AddStrings(nList);

      if nList.IndexOf(FIn.FDELIVERYORDERNO) >= 0 then
      begin
        FMultiBill := nList.Count > 1;
        FZTRecordID := Fields[0].AsString;
      end; //交货单所在记录

      FRecords.Add(Fields[0].AsString);
      Next;
    end;
  finally
    nList.Free;
  end;
end;
function TBusWorkerModifySaleBill.DoAfterCallSAPDone(var nData: string): Boolean;
var nStr: string;
    nIdx: Integer;
    nBool: Boolean;
    nELabel : string;
begin
  nBool := FDBConn.FConn.InTransaction;
  try
    if not nBool then
      FDBConn.FConn.BeginTrans;
    //xxxxx

    if FMultiBill then
    begin
      FOldValue := StrToFloat(FIn.FAMOUNT) - FOldValue;
      //修改前后的差值

      nStr := 'Update %s Set T_Truck=''%s'',T_Value=T_Value+(%.3f) ' +
              'Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, FIn.FDELIVERYNUMBER, FOldValue,
              FZTRecordID]);
      //xxxxx

      gDBConnManager.WorkerExec(FDBConn, nStr);
      //同步修改量
    end else

    if FZTRecordID <> '' then
    begin
      nStr := 'Update %s Set T_Truck=''%s'',T_Value=%s Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, FIn.FDELIVERYNUMBER, FIn.FAMOUNT,
              FZTRecordID]);
      //xxxxx

      gDBConnManager.WorkerExec(FDBConn, nStr);
      //更新队列表提货量
    end;

    nELabel := '';
    nStr := 'Select C_Card From %s Where C_TruckNo=''%s'' and C_TYPE = ''%s'' ';
    nStr := Format(nStr, [sTable_Card, FIn.FDELIVERYNUMBER, sFlag_BillEdit]);

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    if RecordCount > 0 then
    begin
      nELabel := Fields[0].AsString;
    end;
    //提取车辆对应电子标签

    nStr := ' Update %s Set L_Truck=''%s'',L_Value=%s , L_ELabel= ''%s'' '+
            ' Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FDELIVERYNUMBER, FIn.FAMOUNT,nELabel,
                   FIn.FDELIVERYORDERNO]);
    //xxxxx

    gDBConnManager.WorkerExec(FDBConn, nStr);
    //更新交货单修改信息

    if (FBills.Count > 0) and (CompareText(FOldTruck, FIn.FDELIVERYNUMBER) <> 0) then
    begin
      for nIdx:=FBills.Count - 1 downto 0 do
      if CompareText(FIn.FDELIVERYORDERNO, FBills[nIdx]) <> 0 then
      begin
        nStr := 'Update %s Set L_Truck=''%s'' Where L_ID=''%s''';
        nStr := Format(nStr, [sTable_Bill, FIn.FDELIVERYNUMBER, FBills[nIdx]]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        //同步合单车牌号
      end;
    end;

    if (FRecords.Count > 0) and (CompareText(FOldTruck, FIn.FDELIVERYNUMBER) <> 0) then
    begin
      for nIdx:=FRecords.Count - 1 downto 0 do
      if CompareText(FZTRecordID, FRecords[nIdx]) <> 0 then
      begin
        nStr := 'Update %s Set T_Truck=''%s'' Where R_ID=%s';
        nStr := Format(nStr, [sTable_ZTTrucks, FIn.FDELIVERYNUMBER, FRecords[nIdx]]);

        gDBConnManager.WorkerExec(FDBConn, nStr);
        //同步合单车牌号
      end;
    end;

    if not nBool then
      FDBConn.FConn.CommitTrans;
    Result := True;
  except
    on E:Exception do
    begin
      if not nBool then
        FDBConn.FConn.RollbackTrans;
      //xxxxx

      nData := E.Message;
      Result := False;
    end;
  end;
end;

//-----------------------------------------------------------------------------
class function TBusWorkerDeleteSaleBill.FunctionName: string;
begin
  Result := sBus_DeleteSaleBill;
end;

constructor TBusWorkerDeleteSaleBill.Create;
begin
  inherited;
  FBills := TStringList.Create;
end;

destructor TBusWorkerDeleteSaleBill.Destroy;
begin
  FBills.Free;
  inherited;
end;


function TBusWorkerDeleteSaleBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_DeleteSaleBill;
   cWorker_GetSAPName    : Result := sSAP_DeleteSaleBill;
  end;
end;

procedure TBusWorkerDeleteSaleBill.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
end;

function TBusWorkerDeleteSaleBill.VerifyParamIn(var nData: string): Boolean;
var nStr: string;
begin
  Result := True;
  FOldValue := 0;
  FOldBill := '';

  FZTRecordID := '';
  FTrucklogID := '';
  FBills.Clear;

  nStr := 'Select R_ID,T_HKBills,T_Bill From %s ' +
          'Where T_HKBills Like ''%%%s%%''';
  nStr := Format(nStr, [sTable_ZTTrucks, FIn.FDELIVERYORDERNO]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  if RecordCount > 0 then
  begin
    if RecordCount <> 1 then
    begin
      nData := '交货单[ %s ]出现在多条记录上,异常终止!';
      nData := Format(nData, [FIn.FDELIVERYORDERNO]);

      Result := False;
      Exit;
    end;

    FZTRecordID := Fields[0].AsString;
    FOldBill := Fields[2].AsString;
    SplitStr(Fields[1].AsString, FBills, 0, '.')
  end;

  nStr := 'Select L_Value,L_Truck From %s Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, FIn.FDELIVERYORDERNO]);

  with gDBConnManager.WorkerQuery(FDBConn, nStr) do
  begin
    if RecordCount <> 1 then
    begin
      nData := '交货单[ %s ]已无效.';
      nData := Format(nData, [FIn.FDELIVERYORDERNO]);

      Result := False;
      Exit;
    end;

    if (FZTRecordID = '') or (FBills.Count = 1) then 
         FTrucklogID := Fields[1].AsString   //单车单单时删除行车记录
    else FOldValue := Fields[0].AsFloat;
  end;
end;

function TBusWorkerDeleteSaleBill.DoAfterCallSAPDone(var nData: string): Boolean;
var nStr,nP: string;
    nIdx: Integer;
    nBool: Boolean;
begin
  nBool := FDBConn.FConn.InTransaction;
  try
    if not nBool then
      FDBConn.FConn.BeginTrans;
    //xxxxx

    if FOldValue > 0 then
    begin
      nIdx := FBills.IndexOf(FIn.FDELIVERYORDERNO);
      if nIdx >= 0 then
        FBills.Delete(nIdx);
      //移出合单列表

      if FOldBill = FIn.FDELIVERYORDERNO then
        FOldBill := FBills[0];
      //更换交货单

      nStr := 'Update %s Set T_Bill=''%s'',T_Value=T_Value-%.3f,' +
              'T_HKBills=''%s'' Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, FOldBill, FOldValue,
              CombinStr(FBills, '.'), FZTRecordID]);
      //xxxxx

      gDBConnManager.WorkerExec(FDBConn, nStr);
      //更新合单信息
    end else

    if FZTRecordID <> '' then
    begin
      nStr := 'Delete From %s Where R_ID=%s';
      nStr := Format(nStr, [sTable_ZTTrucks, FZTRecordID]);
      gDBConnManager.WorkerExec(FDBConn, nStr);
    end;

    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_Bill]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('L_Del', Fields[nIdx].FieldName) < 1) then
        nP := nP + Fields[nIdx].FieldName + ',';
      //所有字段,不包括删除

      System.Delete(nP, Length(nP), 1);
    end;

    nStr := 'Insert Into $BB($FL,L_DelMan,L_DelDate) ' +
            'Select $FL,''$User'',$Now From $BI Where L_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$BB', sTable_BillBak),
            MI('$FL', nP), MI('$User', FIn.FBase.FFrom.FUser),
            MI('$Now', sField_SQLServer_Now),
            MI('$BI', sTable_Bill), MI('$ID', FIn.FDELIVERYORDERNO)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    nStr := 'Delete From %s Where L_ID=''%s''';
    nStr := Format(nStr, [sTable_Bill, FIn.FDELIVERYORDERNO]);
    gDBConnManager.WorkerExec(FDBConn, nStr);

    if not nBool then
      FDBConn.FConn.CommitTrans;
    Result := True;
  except
    on E:Exception do
    begin
      if not nBool then
        FDBConn.FConn.RollbackTrans;
      //xxxxx

      nData := E.Message;
      Result := True;
    end;
  end;
end;

//-----------------------------------------------------------------------------
class function TBusWorkerPickSaleBill.FunctionName: string;
begin
  Result := sBus_PickSaleBill;
end;

function TBusWorkerPickSaleBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_PickSaleBill;
   cWorker_GetSAPName    : Result := sSAP_PickSaleBill;
  end;
end;

procedure TBusWorkerPickSaleBill.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
end;

function TBusWorkerPickSaleBill.VerifyParamIn(var nData: string): Boolean;
var nStr: string;
begin
  if Pos(sFlag_ForceDone, FIn.FBase.FMsgNO) = 1 then
  begin
    Result := True;
    Exit;
  end; //允许多次减配

  nStr := 'Select Count(*) From %s Where L_ID=''%s'' And ' +
          '(L_Status=''%s'' or L_Status=''%s'')';
  nStr := Format(nStr, [sTable_Bill, FIn.FDELIVERYORDERNO, sFlag_BillPick, sFlag_BillPost]);
  Result := gDBConnManager.WorkerQuery(FDBConn, nStr).Fields[0].AsInteger < 1;

  if not Result then
    nData := Format('交货单[ %s ]已拣配.', [FIn.FDELIVERYORDERNO]);
  //xxxxx
end;

function TBusWorkerPickSaleBill.DoAfterCallSAP(var nData: string): Boolean;
var nStr: string;
begin
  Result := True;
 // if FOut.FBase.FResult then Exit;                            //已拣配数据不处理

  nStr := 'L_ID=''%s'' And L_Status<>''%s'' And L_Result=''%s''';
  nStr := Format(nStr, [FIn.FDELIVERYORDERNO, sFlag_BillPick, sFlag_yes]);
  //已拣配成功不予处理

  nStr := MakeSQLByStr([SF('L_Action', sFlag_BillPick),
          SF('L_PickDate', sField_SQLServer_Now, sfVal),
          SF('L_PickMan', FIn.FBase.FFrom.FUser),
          SF('L_Result', sFlag_NO), SF('L_Memo', FOut.FBase.FErrDesc)
          ], sTable_Bill, nStr, False);
  gDBConnManager.WorkerExec(FDBConn, nStr);
end;

function TBusWorkerPickSaleBill.DoAfterCallSAPDone(var nData: string): Boolean;
var nVal: Double;
    nBool: Boolean;
    nBill,nTruck: string;
    nDate: string;
begin
  Result := True;
  nBool := FDBConn.FConn.InTransaction;
  try
    if not nBool then
      FDBConn.FConn.BeginTrans;
    //xxxxx

    nDate := FOut.FDATE;                                                        //拣配时间
    nVal  := StrToFloat(FOut.FNUMBER);                                          //需拣配量

    if nVal <=0 then
    begin
      nBill := MakeSQLByStr([SF('L_Action', sFlag_BillPick),
               SF('L_Result', sFlag_Yes),
               SF('L_PickDate', nDate),
               SF('L_PickMan', FIn.FBase.FFrom.FUser)
               ], sTable_Bill, SF('L_ID', FOut.FDELIVERYORDERNO), False);
      gDBConnManager.WorkerExec(FDBConn, nBill);
    end else
    begin
      nBill := MakeSQLByStr([SF('L_Value', FOut.FNUMBER,sfVal),
               SF('L_Action', sFlag_BillPick),
               SF('L_Result', sFlag_Yes),
               SF('L_PickDate', nDate),
               SF('L_PickMan', FIn.FBase.FFrom.FUser)
               ], sTable_Bill, SF('L_ID', FOut.FDELIVERYORDERNO), False);
      gDBConnManager.WorkerExec(FDBConn, nBill);
      gSysLoger.AddLog(nBill);
    end;

    nBill := 'Update %s Set L_OutFact=%s , L_Status=''%s'',L_NextStatus=''%s''' +
             'Where L_ID=''%s'' And L_OutFact Is Null';
    nBill := Format(nBill, [sTable_Bill, sField_SQLServer_Now,sFlag_TruckBFM,
                            sFlag_TruckOut, FOut.FDELIVERYORDERNO]);

    gDBConnManager.WorkerExec(FDBConn, nBill);
    //拣配更新出厂时间,车辆状态,以便入报表

    nTruck := 'Delete From %s Where T_Bill=''%s'' And T_InFact Is Null';
    nTruck := Format(nTruck, [sTable_ZTTrucks, FOut.FDELIVERYORDERNO]);
    gDBConnManager.WorkerExec(FDBConn, nTruck);
    //将未进厂的车辆移出队列(手工拣配)

    if not nBool then
      FDBConn.FConn.CommitTrans;
    //xxxxx
  except
    on E:Exception do
    begin
      if not nBool then
        FDBConn.FConn.RollbackTrans;
      //xxxxx

      nData := E.Message;
      Result := False;
    end;
  end;
end;


//-----------------------------------------------------------------------------
constructor TBusWorkerPostSaleBill.Create;
begin
  FList := TStringList.Create;
  inherited;
end;

destructor TBusWorkerPostSaleBill.destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

class function TBusWorkerPostSaleBill.FunctionName: string;
begin
  Result := sBus_PostSaleBill;
end;

function TBusWorkerPostSaleBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_PostSaleBill;
   cWorker_GetSAPName    : Result := sSAP_PostSaleBill;
  end;
end;

procedure TBusWorkerPostSaleBill.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
end;

function TBusWorkerPostSaleBill.DoAfterCallSAPDone(var nData: string): Boolean;
var nStr: string;
    nBool:Boolean;
    nIdx: Integer;
begin
  Result := True;

  nBool := FDBConn.FConn.InTransaction;
  try

      if not nBool then
        FDBConn.FConn.BeginTrans;
      //xxxxx

     with FPacker do
      begin
        StrBuilder.Text := PackerDecodeStr(FOut.FData);

        for nIdx:=0 to StrBuilder.Count - 1 do
        begin
          FList.Text := PackerDecodeStr(StrBuilder[nIdx]);
          if FList.Values['TYPE'] <> 'S' then
          begin
            nStr := ' Update $TB Set L_PostDate=$PD,L_PostMan=''$PM'',' +
                    ' L_Action=''$PO'',L_Result=''$NO'',' +
                    ' L_Memo=''$ME'' Where L_ID=''$ID''';
          end else
          begin
            nStr := 'Update $TB Set L_PostDate=$PD,L_PostMan=''$PM'',' +
                    'L_Action=''$PO'',L_Result=''$YES'', L_Memo=''$ME'' ' +
                    'Where L_ID=''$ID'' ';
          end;

          nStr := MacroValue(nStr, [MI('$TB', sTable_Bill),
             MI('$ID', FList.Values['DELIVERORDERNO']), MI('$PD', sField_SQLServer_Now),
             MI('$PM', FIn.FBase.FFrom.FUser), MI('$PO',sFlag_BillPost ),
             MI('$YES', sFlag_Yes), MI('$NO', sFlag_NO),
             MI('$ME', FList.Values['MSGTXT'])]);
          gDBConnManager.WorkerExec(FDBConn, nStr);
        end;
      end;
      //处理回写操作
      if not nBool then
      FDBConn.FConn.CommitTrans;
      //xxxxx
  except
      on E:Exception do
      begin
        if not nBool then
          FDBConn.FConn.RollbackTrans;
        //xxxxx

        nData := E.Message;
        Result := False;
      end;
  end;
end;

//-----------------------------------------------------------------------------
class function TBusWorkerDiaozhangBill.FunctionName: string;
begin
  Result := sBus_TiaoZSaleBill;
end;

function TBusWorkerDiaozhangBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_TiaoZSaleBill;
   cWorker_GetSAPName    : Result := sSAP_TiaoZSaleBill;
  end;
end;

procedure TBusWorkerDiaozhangBill.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
end;

function TBusWorkerDiaozhangBill.DoAfterCallSAPDone(var nData: string): Boolean;
var nStr,nP: string;
    nBool:Boolean;
    nIdx: Integer;
begin
  nBool := FDBConn.FConn.InTransaction;
  try
    if not nBool then
      FDBConn.FConn.BeginTrans;
    //xxxxx
    //--------------------------------------------------------------------------
    nStr := Format('Select * From %s Where 1<>1', [sTable_Bill]);
    //only for fields
    nP := '';

    with gDBConnManager.WorkerQuery(FDBConn, nStr) do
    begin
      for nIdx:=0 to FieldCount - 1 do
       if (Fields[nIdx].DataType <> ftAutoInc) and
          (Pos('L_ID', Fields[nIdx].FieldName) < 1)then
        nP := nP + Fields[nIdx].FieldName + ',';
      //所有字段

      System.Delete(nP, Length(nP), 1);
    end;

     nStr := 'Update $TB Set L_TiaoZDate=$TD,L_TiaoZMan=''$TM'',' +
                    ' L_TiaoZBill = ''$bill'', '+
                    ' L_Action= ''$action'' ,'+
                    ' L_Result = ''$result'', '+
                    ' L_Memo= ''$memo'' '+
                    ' Where L_ID=''$ID'' ';
    nStr := MacroValue(nStr, [ MI('$TB', sTable_Bill),
                               MI('$TD', sField_SQLServer_Now),
                               MI('$TM', FIn.FBase.FFrom.FUser),
                               MI('$bill', FIn.FTZDELIVERYNO),
                               MI('$ID', FIn.FODELIVERYNO),
                               MI('$action',sFlag_BillTiao ),
                               MI('$result', sFlag_Yes),
                               MI('$memo',FOut.FDATA ) ]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //更新原始交货单【蓝字交货单】


    nStr := 'Insert Into $BB(L_ID,$FL) ' +
            'Select ''$L_ID'', $FL From $BI Where L_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$BB', sTable_Bill),
            MI('$FL', nP),MI('$BI', sTable_Bill),
            MI('$ID', FIn.FODELIVERYNO),MI('$L_ID', FIn.FTZDELIVERYNO)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //复制原交货单数据（使用新交货单号【红字交货单】）

    nStr := 'Update $TB Set L_TiaoZDate=$TD,L_TiaoZMan=''$TM'',' +
                    ' L_Value=0 - L_Value ,L_TiaoZBill = ''$bill'', '+
                    ' L_Action= ''$action'' ,L_Result = ''$result'', '+
                    ' L_Memo= ''$memo'' '+
                    ' Where L_ID=''$ID'' ';
    nStr := MacroValue(nStr, [ MI('$TB', sTable_Bill),
                               MI('$TD', sField_SQLServer_Now),
                               MI('$TM', FIn.FBase.FFrom.FUser),
                               MI('$bill', FIn.FODELIVERYNO),
                               MI('$ID', FIn.FTZDELIVERYNO),
                               MI('$action',sFlag_BillTiao ),
                               MI('$result', sFlag_Yes),
                               MI('$memo',FOut.FDATA ) ]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //更新原交货单数量、调账人、调账时间 ,新交货单号,当前状态,结果状态，结果描述,新交货单（红字交货单）


    nStr := 'Insert Into $BB(L_ID,$FL) ' +
            'Select ''$L_ID'', $FL From $BI Where L_ID=''$ID''';
    nStr := MacroValue(nStr, [MI('$BB', sTable_Bill),
            MI('$FL', nP),MI('$BI', sTable_Bill),
            MI('$ID', FIn.FODELIVERYNO),MI('$L_ID', FIn.FDELIVERYNO)]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //复制原交货单数据（使用新交货单号【蓝字交货单】）

    nStr := 'Update $TB Set L_TiaoZDate=$TD,L_TiaoZMan=''$TM'',L_TiaoZBill = ''$TZ'', ' +
                    ' L_Date=$IO,L_Man=''$LM'',' +
                    ' L_Action= ''$action'' ,L_Result = ''$result'', '+
                    ' L_Memo= ''$memo'' , L_CusID =''$cusid'',L_CusName=''$cusname'',  '+
                    ' L_StockNo= ''$stockno'' , L_StockName =''$stockname'',L_ZHIKA = ''$order''  '+
                    ' Where L_ID=''$ID'' ';

    nStr := MacroValue(nStr,[MI('$TB', sTable_Bill),
                             MI('$TD', sField_SQLServer_Now),
                             MI('$TM', FIn.FBase.FFrom.FUser),
                             MI('$TZ', FIn.FODELIVERYNO),
                             MI('$ID', FIn.FDELIVERYNO),
                             MI('$IO', sField_SQLServer_Now),
                             MI('$LM', FIn.FBase.FFrom.FUser),
                             MI('$action',sFlag_BillTiao ),
                             MI('$result', sFlag_Yes),
                             MI('$cusid', FIn.FCUSTOMCODE),
                             MI('$cusname', FIn.FCUSTOMNAME),
                             MI('$stockno', FIn.FPRODUCTCODE),
                             MI('$stockname', FIn.FPRODUCTNAME),
                             MI('$order', FIn.FORDERNO),
                             MI('$memo',FOut.FDATA )]);
    gDBConnManager.WorkerExec(FDBConn, nStr);
    //更新新交货单所有时间，操作人，及调账人、调账时间 ,新交货单号,新订单，当前状态,结果状态，结果描述


    if not nBool then
      FDBConn.FConn.CommitTrans;
    Result := True;
  except
    on E:Exception do
    begin
      if not nBool then
        FDBConn.FConn.RollbackTrans;
      //xxxxx

      nData := E.Message;
      Result := True;
    end;
  end;
end;

//-----------------------------------------------------------------------------
class function TBusWorkerTZROrderForCus.FunctionName: string;
begin
  Result := sBus_TiaoZROrder;
end;

function TBusWorkerTZROrderForCus.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_TiaoZROrder;
   cWorker_GetSAPName    : Result := sSAP_TiaoZROrder;
  end;
end;

procedure TBusWorkerTZROrderForCus.GetInOutData(var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
end;


initialization
  gBusinessWorkerManager.RegisteWorker(TBusWorkerReadXSSaleOrder, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TBusWorkerReadCRMOrder, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TBusWorkerCreateSaleBill, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TBusWorkerModifySaleBill, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TBusWorkerDeleteSaleBill, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TBusWorkerPickSaleBill, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TBusWorkerPostSaleBill, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TBusWorkerDiaozhangBill, sPlug_ModuleBus);
  gBusinessWorkerManager.RegisteWorker(TBusWorkerTZROrderForCus, sPlug_ModuleBus);
end.

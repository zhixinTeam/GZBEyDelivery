{*******************************************************************************
  作者: dmzn@163.com 2011-10-22
  描述: 客户端业务处理工作对象
*******************************************************************************}
unit UClientWorker;

interface

uses
  Windows, SysUtils, Classes, UMgrChannel, UChannelChooser, UBusinessWorker,
  UBusinessConst, UBusinessPacker, ULibFun;

type
  TClient2MITWorker = class(TBusinessWorkerBase)
  protected
    FListA,FListB: TStrings;
    //字符列表
    procedure WriteLog(const nEvent: string);
    //记录日志
    function ErrDescription(const nCode,nDesc: string;
      const nInclude: TDynamicStrArray): string;
    //错误描述
    function MITWork(var nData: string): Boolean;
    //执行业务
    function GetFixedServiceURL: string; virtual;
    //固定地址
  public
    constructor Create; override;
    destructor destroy; override;
    //创建释放
    function DoWork(const nIn, nOut: Pointer): Boolean; override;
    //执行业务
  end;

  TClientWorkerQueryField = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientBusinessCommand = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientBusinessSaleBill = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientBusinessHardware = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
    function GetFixedServiceURL: string; override;
  end;

  TClientWorkerReadXSSaleOrder = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientWorkerReadCrmOrder = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientWorkerCreateBill = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientWorkerModifyBill = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientWorkerDeleteBill = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientWorkerPickBill = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientWorkerPostBill = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientWorkersTiaoZBill = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TClientWorkersTZROrderForCus = class(TClient2MITWorker)
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

implementation

uses
  UFormWait, Forms, USysLoger, USysConst, USysDB, MIT_Service_Intf,UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TClient2MITWorker.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

//Date: 2012-3-11
//Parm: 日志内容
//Desc: 记录日志
procedure TClient2MITWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(ClassType, '客户业务对象', nEvent);
end;

constructor TClient2MITWorker.Create;
begin
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  inherited;
end;

destructor TClient2MITWorker.destroy;
begin
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  inherited;
end;

//Date: 2012-3-11
//Parm: 入参;出参
//Desc: 执行业务并对异常做处理
function TClient2MITWorker.DoWork(const nIn, nOut: Pointer): Boolean;
var nStr: string;
    nParam: string;
    nArray: TDynamicStrArray;
begin
  with PBWDataBase(nIn)^,gSysParam do
  begin
    nParam := FParam;
    FPacker.InitData(nIn, True, False);

    with FFrom do
    begin
      FUser   := FUserID;
      FIP     := FLocalIP;
      FMAC    := FLocalMAC;
      FTime   := Now;
      FKpLong := GetTickCount;
    end;
  end;

  nStr := FPacker.PackIn(nIn);
  Result := MITWork(nStr);

  if not Result then
  begin
    if Pos(sParam_NoHintOnError, nParam) < 1 then
    begin
      CloseWaitForm;
      Application.ProcessMessages;
      ShowDlg(nStr, MLang(sHint), Screen.ActiveForm.Handle);
    end else PBWDataBase(nOut)^.FErrDesc := nStr;
    
    Exit;
  end;

  FPacker.UnPackOut(nStr, nOut);
  with PBWDataBase(nOut)^ do
  begin
    nStr := 'User:[ %s ] FUN:[ %s ] TO:[ %s ] KP:[ %d ]';
    nStr := Format(nStr, [gSysParam.FUserID, FunctionName, FVia.FIP,
            GetTickCount - FWorkTimeInit]);
    WriteLog(nStr);

    Result := FResult;
    if Result then
    begin
      if FErrCode = sFlag_ForceHint then
      begin
        nStr := MLang('业务执行成功,提示信息如下: ') + #13#10#13#10 + FErrDesc;
        ShowDlg(nStr, MLang(sWarn), Screen.ActiveForm.Handle);
      end;

      Exit;
    end;

    if Pos(sParam_NoHintOnError, nParam) < 1 then
    begin
      CloseWaitForm;
      Application.ProcessMessages;
      SetLength(nArray, 0);

      nStr := MLang('业务执行异常,描述如下: ') + #13#10#13#10 +

              ErrDescription(FErrCode, FErrDesc, nArray) +

              MLang('请检查输入参数、操作是否有效,或联系管理员!') + #32#32#32;
      ShowDlg(nStr, MLang(sWarn), Screen.ActiveForm.Handle);
    end;
  end;
end;

//Date: 2012-3-20
//Parm: 代码;描述
//Desc: 格式化错误描述
function TClient2MITWorker.ErrDescription(const nCode, nDesc: string;
  const nInclude: TDynamicStrArray): string;
var nIdx: Integer;
begin
  FListA.Text := StringReplace(nCode, #9, #13#10, [rfReplaceAll]);
  FListB.Text := StringReplace(nDesc, #9, #13#10, [rfReplaceAll]);

  if FListA.Count <> FListB.Count then
  begin
    Result := MLang('※.代码: ') + nCode + #13#10 +
              MLang('   描述: ') + nDesc + #13#10#13#10;
  end else Result := '';

  for nIdx:=0 to FListA.Count - 1 do
  if (Length(nInclude) = 0) or (StrArrayIndex(FListA[nIdx], nInclude) > -1) then
  begin
    Result := Result + MLang('※.代码: ') + FListA[nIdx] + #13#10 +
                       MLang('   描述: ') + FListB[nIdx] + #13#10#13#10;
  end;
end;

//Desc: 强制指定服务地址
function TClient2MITWorker.GetFixedServiceURL: string;
begin
  Result := '';
end;

//Date: 2012-3-9
//Parm: 入参数据
//Desc: 连接MIT执行具体业务
function TClient2MITWorker.MITWork(var nData: string): Boolean;
var nChannel: PChannelItem;
begin
  Result := False;
  nChannel := nil;
  try
    nChannel := gChannelManager.LockChannel(cBus_Channel_Business);
    if not Assigned(nChannel) then
    begin
      nData := MLang('连接MIT服务失败(BUS-MIT No Channel).');
      Exit;
    end;

    with nChannel^ do
    while True do
    try
      if not Assigned(FChannel) then
        FChannel := CoSrvBusiness.Create(FMsg, FHttp);
      //xxxxx

      if GetFixedServiceURL = '' then
           FHttp.TargetURL := gChannelChoolser.ActiveURL
      else FHttp.TargetURL := GetFixedServiceURL;

      if gSysParam.FSysLangID <> 'cn' then
        nData := nData + #13#10 + '$LangID:=' + gSysParam.FSysLangID;
      //传递语言标识

      Result := ISrvBusiness(FChannel).Action(GetFlagStr(cWorker_GetMITName),
                                              nData);
      //call mit funciton
      Break;
    except
      on E:Exception do
      begin
        if (GetFixedServiceURL <> '') or
           (gChannelChoolser.GetChannelURL = FHttp.TargetURL) then
        begin
          nData := Format('%s(BY %s ).', [E.Message, gSysParam.FLocalName]);
          WriteLog('Function:[ ' + FunctionName + ' ]' + E.Message);
          Exit;
        end;
      end;
    end;
  finally
    gChannelManager.ReleaseChannel(nChannel);
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkerQueryField.FunctionName: string;
begin
  Result := sCLI_GetQueryField;
end;

function TClientWorkerQueryField.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_GetQueryField;
   cWorker_GetMITName    : Result := sBus_GetQueryField;
  end;
end;

//------------------------------------------------------------------------------
class function TClientBusinessCommand.FunctionName: string;
begin
  Result := sCLI_BusinessCommand;
end;

function TClientBusinessCommand.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_BusinessCommand;
  end;
end;

//------------------------------------------------------------------------------
class function TClientBusinessSaleBill.FunctionName: string;
begin
  Result := sCLI_BusinessSaleBill;
end;

function TClientBusinessSaleBill.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_BusinessSaleBill;
  end;
end;

//------------------------------------------------------------------------------
class function TClientBusinessHardware.FunctionName: string;
begin
  Result := sCLI_HardwareCommand;
end;

function TClientBusinessHardware.GetFlagStr(const nFlag: Integer): string;
begin
  Result := inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sBus_BusinessCommand;
   cWorker_GetMITName    : Result := sBus_HardwareCommand;
  end;
end;

function TClientBusinessHardware.GetFixedServiceURL: string;
begin
  Result := gSysParam.FHardMonURL;
end;

//------------------------------------------------------------------------------
class function TClientWorkerReadXSSaleOrder.FunctionName: string;
begin
  Result := sCLI_ReadXSSaleOrder;
end;

function TClientWorkerReadXSSaleOrder.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_ReadXSSaleOrder;
   cWorker_GetMITName    : Result := sBus_ReadXSSaleOrder;
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkerReadCrmOrder.FunctionName: string;
begin
  Result := sCLI_ReadCRMOrder;
end;

function TClientWorkerReadCrmOrder.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_ReadCRMOrder;
   cWorker_GetMITName    : Result := sBus_ReadCRMOrder;
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkerCreateBill.FunctionName: string;
begin
  Result := sCLI_CreateSaleBill;
end;

function TClientWorkerCreateBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_CreateSaleBill;
   cWorker_GetMITName    : Result := sBus_CreateSaleBill;
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkerModifyBill.FunctionName: string;
begin
  Result := sCLI_ModifySaleBill;
end;

function TClientWorkerModifyBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_ModifySaleBill;
   cWorker_GetMITName    : Result := sBus_ModifySaleBill;
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkerDeleteBill.FunctionName: string;
begin
  Result := sCLI_DeleteSaleBill;
end;

function TClientWorkerDeleteBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_DeleteSaleBill;
   cWorker_GetMITName    : Result := sBus_DeleteSaleBill;
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkerPickBill.FunctionName: string;
begin
  Result := sCLI_PickSaleBill;
end;

function TClientWorkerPickBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_PickSaleBill;
   cWorker_GetMITName    : Result := sBus_PickSaleBill;
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkerPostBill.FunctionName: string;
begin
  Result := sCLI_PostSaleBill;
end;

function TClientWorkerPostBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_PostSaleBill;
   cWorker_GetMITName    : Result := sBus_PostSaleBill;
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkersTiaoZBill.FunctionName: string;
begin
  Result := sCLI_TiaoZSaleBill;
end;

function TClientWorkersTiaoZBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_TiaoZSaleBill;
   cWorker_GetMITName    : Result := sBus_TiaoZSaleBill;
  end;
end;

//------------------------------------------------------------------------------
class function TClientWorkersTZROrderForCus.FunctionName: string;
begin
  Result := sCLI_ROrderForCus;
end;

function TClientWorkersTZROrderForCus.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
   cWorker_GetPackerName : Result := sSAP_TiaoZROrder;
   cWorker_GetMITName    : Result := sBus_TiaoZROrder;
  end;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TClientWorkerQueryField);
  gBusinessWorkerManager.RegisteWorker(TClientBusinessCommand);
  gBusinessWorkerManager.RegisteWorker(TClientBusinessSaleBill);
  gBusinessWorkerManager.RegisteWorker(TClientBusinessHardware);
  gBusinessWorkerManager.RegisteWorker(TClientWorkerReadXSSaleOrder);
  gBusinessWorkerManager.RegisteWorker(TClientWorkerReadCrmOrder);
  gBusinessWorkerManager.RegisteWorker(TClientWorkerCreateBill);
  gBusinessWorkerManager.RegisteWorker(TClientWorkerModifyBill);
  gBusinessWorkerManager.RegisteWorker(TClientWorkerDeleteBill);
  gBusinessWorkerManager.RegisteWorker(TClientWorkerPickBill);
  gBusinessWorkerManager.RegisteWorker(TClientWorkerPostBill);
  gBusinessWorkerManager.RegisteWorker(TClientWorkersTiaoZBill);
  gBusinessWorkerManager.RegisteWorker(TClientWorkersTZROrderForCus);
end.

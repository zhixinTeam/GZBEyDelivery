{*******************************************************************************
  ����: dmzn@163.com 2011-10-22
  ����: �ͻ���ҵ����������
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
    //�ַ��б�
    procedure WriteLog(const nEvent: string);
    //��¼��־
    function ErrDescription(const nCode,nDesc: string;
      const nInclude: TDynamicStrArray): string;
    //��������
    function MITWork(var nData: string): Boolean;
    //ִ��ҵ��
    function GetFixedServiceURL: string; virtual;
    //�̶���ַ
  public
    constructor Create; override;
    destructor destroy; override;
    //�����ͷ�
    function DoWork(const nIn, nOut: Pointer): Boolean; override;
    //ִ��ҵ��
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
//Parm: ��־����
//Desc: ��¼��־
procedure TClient2MITWorker.WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(ClassType, '�ͻ�ҵ�����', nEvent);
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
//Parm: ���;����
//Desc: ִ��ҵ�񲢶��쳣������
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
        nStr := MLang('ҵ��ִ�гɹ�,��ʾ��Ϣ����: ') + #13#10#13#10 + FErrDesc;
        ShowDlg(nStr, MLang(sWarn), Screen.ActiveForm.Handle);
      end;

      Exit;
    end;

    if Pos(sParam_NoHintOnError, nParam) < 1 then
    begin
      CloseWaitForm;
      Application.ProcessMessages;
      SetLength(nArray, 0);

      nStr := MLang('ҵ��ִ���쳣,��������: ') + #13#10#13#10 +

              ErrDescription(FErrCode, FErrDesc, nArray) +

              MLang('������������������Ƿ���Ч,����ϵ����Ա!') + #32#32#32;
      ShowDlg(nStr, MLang(sWarn), Screen.ActiveForm.Handle);
    end;
  end;
end;

//Date: 2012-3-20
//Parm: ����;����
//Desc: ��ʽ����������
function TClient2MITWorker.ErrDescription(const nCode, nDesc: string;
  const nInclude: TDynamicStrArray): string;
var nIdx: Integer;
begin
  FListA.Text := StringReplace(nCode, #9, #13#10, [rfReplaceAll]);
  FListB.Text := StringReplace(nDesc, #9, #13#10, [rfReplaceAll]);

  if FListA.Count <> FListB.Count then
  begin
    Result := MLang('��.����: ') + nCode + #13#10 +
              MLang('   ����: ') + nDesc + #13#10#13#10;
  end else Result := '';

  for nIdx:=0 to FListA.Count - 1 do
  if (Length(nInclude) = 0) or (StrArrayIndex(FListA[nIdx], nInclude) > -1) then
  begin
    Result := Result + MLang('��.����: ') + FListA[nIdx] + #13#10 +
                       MLang('   ����: ') + FListB[nIdx] + #13#10#13#10;
  end;
end;

//Desc: ǿ��ָ�������ַ
function TClient2MITWorker.GetFixedServiceURL: string;
begin
  Result := '';
end;

//Date: 2012-3-9
//Parm: �������
//Desc: ����MITִ�о���ҵ��
function TClient2MITWorker.MITWork(var nData: string): Boolean;
var nChannel: PChannelItem;
begin
  Result := False;
  nChannel := nil;
  try
    nChannel := gChannelManager.LockChannel(cBus_Channel_Business);
    if not Assigned(nChannel) then
    begin
      nData := MLang('����MIT����ʧ��(BUS-MIT No Channel).');
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
      //�������Ա�ʶ

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

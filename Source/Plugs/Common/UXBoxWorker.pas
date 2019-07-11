{*******************************************************************************
  ����: dmzn@163.com 2011-10-22
  ����: SAPҵ����������
*******************************************************************************}
unit UXBoxWorker;

{$I Link.Inc}
interface

uses
  Windows, SysUtils, Classes, Variants, NativeXml, UObjectList, UBusinessWorker,
  UBusinessConst, UBusinessPacker, UMgrParam, IdHTTP, IdURI, UMITPacker;

type
  TSAPWorkerBase = class(TBusinessWorkerBase)
  protected
    FListA,FListB: TStrings;
    //list data
    FChannel: TIdHTTP;
    FStream: TStringStream;
    //client channel
    FErrCode: Integer;
    FDataIn,FDataOut: PBWDataBase;
    //in out
    FSAPFunction: OleVariant;
    //function object
    function GetXBoxURL: Integer;
    //find url
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); virtual; abstract;
    //set param
    function DoXBoxWork(var nData: string): Boolean; virtual; abstract;
    //xbox work
    function ParseDefine: Boolean; virtual;
    function ParseErr(var nData: string): Boolean; virtual;
    function ParseData(var nData: string): Boolean; virtual;
    //parse output
  public
    constructor Create; override;
    destructor Destroy; override;
    //new and free
    function DoWork(var nData: string): Boolean; override;
  end;

  TWorkerReadXSSaleOrder = class(TSAPWorkerBase)
  protected
    FIn: TReadXSSaleOrderIn;
    FOut: TReadXSSaleOrderOut;
    nTLang :string;
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); override;
    function DoXBoxWork(var nData: string): Boolean; override;
    function ParseData(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TWorkerReadCRMOrder = class(TSAPWorkerBase)
  protected
    FIn: TReadCRMOrderIn;
    FOut: TReadCrmOrderOut;
    nTLang :string;
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); override;
    function DoXBoxWork(var nData: string): Boolean; override;
    function ParseData(var nData: string): Boolean; override;
  public
    class function FunctionName: string; override;
    function GetFlagStr(const nFlag: Integer): string; override;
  end;

  TWorkerCreateSaleBill = class(TSAPWorkerBase)
  protected
    FIn: TWorkerCreateBillIn;
    FOut: TBWDataBase;
    nTLang :string;
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); override;
    function DoXBoxWork(var nData: string): Boolean; override;
    function ParseData(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TWorkerModifyBill = class(TSAPWorkerBase)
  protected
    FIn: TWorkerModfiyBillIn;
    FOut: TBWDataBase;
    nTLang :string;
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); override;
    function DoXBoxWork(var nData: string): Boolean; override;
    function ParseData(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TWorkerDeleteBill = class(TSAPWorkerBase)
  protected
    FIn: TWorkerDeleteBillIn;
    FOut: TBWDataBase;
    nTLang :string;
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); override;
    function DoXBoxWork(var nData: string): Boolean; override;
    function ParseData(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;

  TWorkerPickBill = class(TSAPWorkerBase)
  protected
    FIn: TWorkerPickBillIn;
    FOut: TWorkerPickBillOut;
    nTLang :string;
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); override;
    function DoXBoxWork(var nData: string): Boolean; override;
    function ParseData(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;
  //����������

  TWorkerPostBill = class(TSAPWorkerBase)
  protected
    FIn: TWorkerPostBillIn;
    FOut: TWorkerPostBillOut;
    nTLang : string;
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); override;
    function DoXBoxWork(var nData: string): Boolean; override;
    function ParseData(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;
  //������ȷ��(����)

  TWorkerDiaozhangBill = class(TSAPWorkerBase)
  protected
    FIn: TWorkerDiaozhangBillIn;
    FOut: TWorkerDiaozhangBillOut;
    nTLang : string;
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); override;
    function DoXBoxWork(var nData: string): Boolean; override;
    function ParseData(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;
  //����������

  TWorkerTZROrderForCus = class(TSAPWorkerBase)
  protected
    FIn:  TWorkerROrderForCusin;
    FOut: TWorkerROrderForCusOut;
    nTLang : string;
    procedure SetRFCParam(const nData: string; var nIn,
      nOut: PBWDataBase); override;
    function DoXBoxWork(var nData: string): Boolean; override;
    function ParseData(var nData: string): Boolean; override;
  public
    function GetFlagStr(const nFlag: Integer): string; override;
    class function FunctionName: string; override;
  end;
  //���������� ��ȡ�ͻ��б�

implementation

uses
  ULibFun, USysLoger, UMITConst;

constructor TSAPWorkerBase.Create;
begin
  inherited;
  FListA := TStringList.Create;
  FListB := TStringList.Create;
  FStream := TStringStream.Create('');
end;

destructor TSAPWorkerBase.Destroy;
begin
  FStream.Free;
  FListA.Free;
  FListB.Free;
  inherited;
end;

//Date: 2015-03-04
//Desc: ���������ַ
function TSAPWorkerBase.GetXBoxURL: Integer;
var nIdx: Integer;
begin
  Result := -1;

  for nIdx:=Low(gXBoxURLs) to High(gXBoxURLs) do
  if CompareText(FunctionName, gXBoxURLs[nIdx].FSAPName) = 0 then
  begin
    Result := nIdx;
    Break;
  end;
end;

//Date: 2015-03-04
//Parm: �������
//Desc: ִ��SAPҵ�����
function TSAPWorkerBase.DoWork(var nData: string): Boolean;
var nItem: PObjectPoolItem;
begin
  nItem := nil;
  try
    Result := False;
    nItem := gObjectPoolManager.LockObject(TIdHTTP);
    
    if not Assigned(nItem) then
    begin
      nData := 'Failed to connect XBox(IdHTTP Is Null)';
      //'����XBoxʧ��(IdHTTP Is Null).';
      Exit;
    end;

    FChannel := nItem.FObject as TIdHTTP;
    //get client
    
    FDataIn := nil;
    FDataOut := nil;
    SetRFCParam(nData, FDataIn, FDataOut);

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' InData:'+ FPacker.PackIn(FDataIn, False));
    {$ENDIF}

    try
      Result := DoXBoxWork(nData);
    except
      on E:Exception do
      begin
        nData := 'Call XBOX-HTTP service failed(Call %s Failure).' ;
        //'����XBOX-HTTP����ʧ��(Call %s Failure).';
        nData := Format(nData, [GetFlagStr(cWorker_GetRFCName)]);
        Exit;
      end;
    end;

    FDataOut^ := FDataIn^;
    FDataOut.FResult := False;
    //init out data
    
    if not ParseDefine then
    begin
      if not ParseErr(nData) then
      begin
        FDataOut.FErrCode := 'E.00';
        FDataOut.FErrDesc := 'XBOX-HTTP returns an unknown error';
        //'XBOX-HTTP����δ֪����.';
      end; //error desc

      ParseData(nData);
      //valid data
    end;

    with FDataOut.FFinal do
    begin
      FUser   := gSysParam.FProgID;
      FIP     := gSysParam.FLocalIP;
      FMAC    := gSysParam.FLocalMAC;
      FTime   := FWorkTime;
      FKpLong := GetTickCount - FWorkTimeInit;
    end;

    nData := FPacker.PackOut(FDataOut);
    //pack it

    {$IFDEF DEBUG}
    WriteLog('Fun: '+FunctionName+' OutData:'+ FPacker.PackOut(FDataOut, False));
    {$ENDIF}
  finally
    gObjectPoolManager.ReleaseObject(nItem);
  end;
end;

//Date: 2015-03-04
//Desc: �Զ��������ʽ
function TSAPWorkerBase.ParseDefine: Boolean;
begin
  Result := False;
end;

//Date: 2015-03-04
//Parm: SAP����
//Desc: ����SAP���ص�nData����
function TSAPWorkerBase.ParseData(var nData: string): Boolean;
begin
  Result := True;
end;

//Date: 2015-03-04
//Parm: SAP����
//Desc: ����SAP���ص�nData������ʾ����
function TSAPWorkerBase.ParseErr(var nData: string): Boolean;
var nItem: TXmlNode;
    //nIdx: Integer;
begin
  with FPacker.XMLBuilder,FDataOut^ do
  begin
    Result := False;
    nItem := Root.FindNode('MESSAGE');

    if not Assigned(nItem) then
    begin
      nData := 'XBoxӦ������[ MESSAGE ]�ڵ㲻����.';
      Exit;
    end;

    nItem := Root.FindNode('STATUS');
    if not Assigned(nItem) then
    begin
      nData := 'XBoxӦ������[ STATUS ]�ڵ㲻����.';
      Exit;
    end;

    FErrCode := '';
    FErrDesc := '';

    FErrCode := FErrCode + Root.NodeByName('STATUS').ValueAsString  + #9;
    FErrDesc := FErrDesc + Root.NodeByName('MESSAGE').ValueAsString + #9;

//    for nIdx:=0 to nItem.NodeCount - 1 do
//    with nItem.Nodes[nIdx] do
//    begin
//      FErrCode := FErrCode + NodeByName('STATUS').ValueAsString + #9;
//      FErrDesc := FErrDesc + NodeByName('MESSAGE').ValueAsString + #9;
//    end;

    Result := True;
  end;
end;

//------------------------------------------------------------------------------
class function TWorkerReadXSSaleOrder.FunctionName: string;
begin
  Result := sSAP_ReadXSSaleOrder;
end;

function TWorkerReadXSSaleOrder.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);

  case nFlag of
    cWorker_GetPackerName : Result := sSAP_ReadXSSaleOrder;
    cWorker_GetRFCName    : Result := 'ec.order.search';
  end;
end;

procedure TWorkerReadXSSaleOrder.SetRFCParam(const nData: string;
 var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FPacker.UnPackIn(nData, @FIn);
end;

//Date: 2015-03-04
//Parm: ����
//Desc: ִ��XBoxҵ��
function TWorkerReadXSSaleOrder.DoXBoxWork(var nData: string): Boolean;
var nStr: string;
    nTime: Int64;
begin
  with gXBoxURLs[GetXBoxURL] do
  begin
    nTime := GetTickCount;

    nStr := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
            '<IN><orderCode>$order</orderCode></IN>';

    nStr := MacroValue(nStr, [MI('$order', FIn.FORDERCODE)]);
    //business data

     nStr := StringReplace(FXBoxParam, '$data', nStr, [rfIgnoreCase]);
    //full url

     if GetMultiLangID = 'en' then   nTLang := 'en_US';
     if GetMultiLangID = ''   then   nTLang := 'zh_CH';
     
     nStr := StringReplace(nStr, '$Language', nTLang, [rfIgnoreCase]);
    //Replace language full url

    FListA.Text := nStr;

    WriteLog( gXBoxURLs[0].FSAPName +'  ����: '+ FXBoxURL+ nStr );

    FStream.Size := 0;
    FChannel.Post(FXBoxURL,FListA,FStream);

    nStr := UTF8Decode(FStream.DataString);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nStr);

    WriteLog( gXBoxURLs[0].FSAPName + '  ��ʱ:  ' + IntToStr(GetTickCount - nTime) +
              ' ����ֵ:  ' + 'MSGNO:' + FIn.FBase.FMSGNO +  StringReplace(nStr,' ','',[rfReplaceAll]));

    Result := True;
  end;
end;

//Date: 2012-3-12
//Parm: SAP����
//Desc: ������ȡ����nData���
function TWorkerReadXSSaleOrder.ParseData(var nData: string): Boolean;
var nItem: TXmlNode;
begin
  with FPacker.XMLBuilder,FOut do
  begin
    Result := False;

    nItem := Root.FindNode('RESULT');

    if not Assigned(nItem) then
    begin
      FOut.FBase.FErrCode  := 'E.00';
      FOut.FBase.FErrDesc  := 'Service is currently unavailable, please save the error message and contact the service platform administrator';
      FOut.FBase.FResult   := False;
      Exit;
    end;
    // error dump
    
    if  Root.NodeByName('STATUS').ValueAsString  <> '1' then
    begin
      FOut.FBase.FErrCode  := 'E.00';
      FOut.FBase.FErrDesc  := Root.NodeByName('MESSAGE').ValueAsString;
      FOut.FBase.FResult   := False;
      Exit;
    end;
    //error

    FORDERCODE        := nItem.NodeByName('ORDERCODE').ValueAsString;           //���۶�����
    FORDERTYPE        := nItem.NodeByName('ORDERTYPE').ValueAsString;           //���۶�������
    FSTATUS           := nItem.NodeByName('STATUS').ValueAsString;              //����״̬
    FBUYPARTCODE      := nItem.NodeByName('BUYPARTCODE').ValueAsString;         //����λ
    FBUYPARTNAME      := nItem.NodeByName('BUYPARTNAME').ValueAsString;         //����λ����
    FRECEIVEPART      := nItem.NodeByName('RECEIVEPART').ValueAsString;         //�ջ���λ
    if Assigned(nItem.NodeByName('DISPATCHINGCODE')) then
    begin
       FDISPATCHINGCODE  := nItem.NodeByName('DISPATCHINGCODE').ValueAsString;  //�����̱��
    end;
    FPRODUCTCODE      := nItem.NodeByName('PRODUCTCODE').ValueAsString;         //��Ʒ����
    FPRODUCTNAME      := nItem.NodeByName('PRODUCTNAME').ValueAsString;         //��Ʒ����
    FSTANDARD         := nItem.NodeByName('STANDARD').ValueAsString;            //��Ʒ���
    FUNIT             := nItem.NodeByName('UNIT').ValueAsString;                //��λ
    FFACTORYPRICE     := nItem.NodeByName('FACTORYPRICE').ValueAsFloat;         //������
    FTOTALPRICE       := nItem.NodeByName('TOTALPRICE').ValueAsFloat;           //��λ��
    FOUTAMOUNT        := nItem.NodeByName('OUTAMOUNT').ValueAsFloat;            //�ѿ�����
    FSURPLUSAMOUNT    := nItem.NodeByName('SURPLUSAMOUNT').ValueAsFloat;        //ʣ������
    FAMOUNT           := nItem.NodeByName('AMOUNT').ValueAsFloat;               //��������
    if Assigned(nItem.NodeByName('TRANSTYPE')) then
    begin
       FTRANSTYPE     := nItem.NodeByName('TRANSTYPE').ValueAsString;           //���䷽ʽ
    end;
    FTOTALMONEY       := nItem.NodeByName('TOTALMONEY').ValueAsFloat;           //�ܽ��
    FCONTRACTNO       := nItem.NodeByName('CONTRACTNO').ValueAsString;          //��ͬ���
    FREGIONCODE       := nItem.NodeByName('REGIONCODE').ValueAsString;          //����������
    FREGIONNAME       := nItem.NodeByName('REGIONTEXT').ValueAsString;          //������������

    Result := True;
    FBase.FResult := True;
  end;
end;

//------------------------------------------------------------------------------
class function TWorkerReadCRMOrder.FunctionName: string;
begin

  Result := sSAP_ReadCRMOrder;
end;

function TWorkerReadCRMOrder.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);
  case nFlag of
    cWorker_GetPackerName : Result := sSAP_ReadCRMOrder;
    cWorker_GetRFCName    : Result := 'ec.delive.search';
  end;
end;

procedure TWorkerReadCRMOrder.SetRFCParam(const nData: string;
 var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FPacker.UnPackIn(nData, nIn);
end;

//Date: 2015-03-04
//Parm: ����
//Desc: ִ��XBoxҵ��
function TWorkerReadCRMOrder.DoXBoxWork(var nData: string): Boolean;
var nStr: string;
    nTime: Int64;
begin
  with gXBoxURLs[GetXBoxURL] do
  begin
    nTime := GetTickCount;

    nStr := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
            '<IN><deliverNo>$no</deliverNo></IN>';

    nStr := MacroValue(nStr, [MI('$no', FIn.FDELIVERNO)]);
    //business data

    nStr := StringReplace(FXBoxParam, '$data', nStr, [rfIgnoreCase]);
    //full url

    if GetMultiLangID = 'en' then   nTLang := 'en_US';
    if GetMultiLangID = ''   then   nTLang := 'zh_CH';

     nStr := StringReplace(nStr, '$Language', nTLang, [rfIgnoreCase]);
    //Replace language full url
    
    FListA.Text :=  nStr ;

    WriteLog( gXBoxURLs[1].FSAPName +'  ����: '+ FXBoxURL+ nStr );

    FStream.Size := 0;
    FChannel.Post(FXBoxURL, FListA,FStream);

    nStr := UTF8Decode(FStream.DataString);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nStr);

    WriteLog(gXBoxURLs[1].FSAPName  + '  ��ʱ:  ' + IntToStr(GetTickCount - nTime) +
             ' ����ֵ:  '  + 'MSGNO:' + FIn.FBase.FMSGNO + StringReplace(nStr,' ','',[rfReplaceAll]));
    Result := True;
  end;
end;

//Date: 2012-3-12
//Parm: SAP����
//Desc: ������ȡ����nData���
function TWorkerReadCRMOrder.ParseData(var nData: string): Boolean;
var nItem: TXmlNode;
begin
 with FPacker.XMLBuilder,FOut do
  begin
    Result := False;

    nItem := Root.FindNode('RESULT');

    if not Assigned(nItem) then
    begin
      FOut.FBase.FErrCode  := 'E.00';
      FOut.FBase.FErrDesc  := 'Service is currently unavailable, please save the error message and contact the service platform administrator';
      FOut.FBase.FResult   := False;
      Exit;
    end;
    // error dump

    if  Root.NodeByName('STATUS').ValueAsString  <> '1' then
    begin
      FOut.FBase.FErrCode  := 'E.00';
      FOut.FBase.FErrDesc  := Root.NodeByName('MESSAGE').ValueAsString;
      FOut.FBase.FResult   := False;
      Exit;
    end;
    //error

    FDELIVERLISTNO    := nItem.NodeByName('DELIVERLISTNO').ValueAsString;       //���ί�е����
    FTRAVELNUMBER     := nItem.NodeByName('TRAVELNUMBER').ValueAsString;        //������
    FTELEPHONE        := nItem.NodeByName('TELEPHONE').ValueAsString;           //��ϵ�绰
    FAMOUNT           := nItem.NodeByName('AMOUNT').ValueAsFloat;               //������� (ί�е�)
    FORDERNO          := nItem.NodeByName('ORDERNO').ValueAsString;             //�������
    FORDERTYPE        := nItem.NodeByName('ORDERTYPE').ValueAsString;           //��������
    FSTATUS           := nItem.NodeByName('STATUS').ValueAsString;              //����״̬
    FBUYPARTCODE      := nItem.NodeByName('BUYPARTCODE').ValueAsString;         //����λ
    FBUYPARTNAME      := nItem.NodeByName('BUYPARTNAME').ValueAsString;         //����λ����
    FRECEIVEPART      := nItem.NodeByName('RECEIVEPART').ValueAsString;         //�ջ���λ
    FPRODUCTCODE      := nItem.NodeByName('PRODUCTCODE').ValueAsString;         //��Ʒ����
    FPRODUCTNAME      := nItem.NodeByName('PRODUCTNAME').ValueAsString;         //��Ʒ����
    FUNIT             := nItem.NodeByName('UNIT').ValueAsString;                //��λ
    FFACTORYPRICE     := nItem.NodeByName('FACTORYPRICE').ValueAsFloat;         //������
    FTOTALPRICE       := nItem.NodeByName('TOTALPRICE').ValueAsFloat;           //��λ��
    FOUTAMOUNT        := nItem.NodeByName('OUTAMOUNT').ValueAsFloat;            //�ѿ�����
    FSURPLUSAMOUNT    := nItem.NodeByName('SURPLUSAMOUNT').ValueAsFloat;        //ʣ������
    if Assigned(nItem.NodeByName('TRANSTYPE')) then
    begin
       FTRANSTYPE        := nItem.NodeByName('TRANSTYPE').ValueAsString;        //���䷽ʽ
    end;
    if Assigned(nItem.NodeByName('TOTALMONEY')) then
    begin
       FTOTALMONEY       := nItem.NodeByName('TOTALMONEY').ValueAsFloat;        //�ܽ��
    end;
    if Assigned(nItem.NodeByName('CONTRACTNO')) then
    begin
       FCONTRACTNO       := nItem.NodeByName('CONTRACTNO').ValueAsString;       //��ͬ���
    end;
    if Assigned(nItem.NodeByName('REGIONCODE')) then
    begin
       FREGIONCODE       := nItem.NodeByName('REGIONCODE').ValueAsString;       //����������
    end;
    if Assigned(nItem.NodeByName('REGIONTEXT')) then
    begin
      FREGIONNAME        := nItem.NodeByName('REGIONTEXT').ValueAsString;       //������������
    end;
    if Assigned(nItem.NodeByName('noNumber')) then
    begin
      FNONUMBER         := nItem.NodeByName('noNumber').ValueAsString;          //֤������
    end;
    FDRIVERNAME         := nItem.NodeByName('DRIVERNAME').ValueAsString;        //˾������

    Result := True;
    FBase.FResult := True;
  end;
end;

//------------------------------------------------------------------------------
class function TWorkerCreateSaleBill.FunctionName: string;
begin

  Result := sSAP_CreateSaleBill;
end;

function TWorkerCreateSaleBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);
  case nFlag of
    cWorker_GetPackerName : Result := sSAP_CreateSaleBill;
    cWorker_GetRFCName    : Result := 'ec.deliverOrder.create';
  end;
end;

procedure TWorkerCreateSaleBill.SetRFCParam(const nData: string;
 var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FPacker.UnPackIn(nData, nIn);
end;

//Date: 2015-03-04
//Parm: ����
//Desc: ִ��XBoxҵ��
function TWorkerCreateSaleBill.DoXBoxWork(var nData: string): Boolean;
var nStr: string;
    nTime: Int64;
begin
  with gXBoxURLs[GetXBoxURL] do
  begin
    nTime := GetTickCount;

    nStr := '<?xml version="1.0" encoding="gb2312" standalone="yes"?>' +
            '<IN><deliveryOrderNo>$no</deliveryOrderNo><amount>$amount</amount>'+
            '<deliveryNumber>$dnumber</deliveryNumber><productCode>$pcode</productCode>'+
            '<productName>$pname</productName><buyPartName>$buyname</buyPartName>'+
            '<buyPartCode>$buycode</buyPartCode><orderNo>$ordero</orderNo>'+
            '<deliverListNo>$dlistno</deliverListNo><createDate>$cdate</createDate>'+
            '<createUser>$cuser</createUser><reveiveName>$rname</reveiveName>'+
            '<driverName>$dname</driverName><measurementUnit>$unit</measurementUnit>'+
            '<telephone>$telno</telephone><transType>$ttype</transType>'+
            '<regionCode>$rcode</regionCode><regionText>$rtext</regionText>'+
            '<totalPrice>$price</totalPrice></IN>';

    nStr := MacroValue(nStr, [MI('$no', FIn.FDELIVERYORDERNO),MI('$amount',  FloatToStr(FIn.FAMOUNT)),
                              MI('$dnumber', FIn.FDELIVERYNUMBER),MI('$pcode', FIn.FPRODUCTCODE),
                              MI('$pname', FIn.FPRODUCTNAME),MI('$buycode',''),
                              MI('$ordero', FIn.FORDERNO),MI('$dlistno', FIn.FDELIVERLISYNO),
                              MI('$cdate', DateToStr(fin.FCREATEDATE)),MI('$cuser', FIn.FCREATEUSER),
                              MI('$rname', ''),MI('$dname', FIn.FDRIVERNAME),
                              MI('$unit', FIn.FMEASUREMENTUNIT),MI('$telno', FIn.FTELEPHONE),
                              MI('$ttype', FIn.FTRANSTYPE),MI('$rcode', FIn.FREGIONCODE),
                              MI('$rtext', FIn.FREGIONTEXT), MI('$buyname', ''),
                              MI('$price', FloatToStr(FIn.FTOTALPRICE))]);
    //business data

    nStr := StringReplace(FXBoxParam, '$data', nStr, [rfIgnoreCase]);
    //full url

    if GetMultiLangID = 'en' then   nTLang := 'en_US';
    if GetMultiLangID = ''   then   nTLang := 'zh_CH';

     nStr := StringReplace(nStr, '$Language', nTLang, [rfIgnoreCase]);
    //Replace language full url

    FListA.Text := Utf8Encode(nStr) ;

    WriteLog( gXBoxURLs[2].FSAPName +'  ����: '+ FXBoxURL+ nStr );

    FStream.Size := 0;

    FChannel.Post(FXBoxURL,FListA,FStream);
    nStr := UTF8Decode(FStream.DataString);

    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nStr);

    WriteLog(gXBoxURLs[2].FSAPName  + '  ��ʱ:  ' + IntToStr(GetTickCount - nTime) +
             ' ����ֵ:  '  + 'MSGNO:' + FIn.FBase.FMSGNO + StringReplace(nStr,' ','',[rfReplaceAll]));
    Result := True;
  end;
end;

//Date: 2012-3-12
//Parm: SAP����
//Desc: ������ȡ����nData���
function TWorkerCreateSaleBill.ParseData(var nData: string): Boolean;
var nOut: TXmlNode;
begin
 with FPacker.XMLBuilder,FOut do
  begin
    Result := False;

    nOut := Root.FindNode('STATUS');

    if not Assigned(nOut) then
    begin

      FOut.FErrCode  := 'E.00';
      FOut.FErrDesc  := 'Service is currently unavailable, please save the error message and contact the service platform administrator';
      FOut.FResult   := False;
      Exit;
    end;
    // error dump

    if  Root.NodeByName('STATUS').ValueAsString  <> '1' then
    begin
      FOut.FErrCode  := 'E.00';
      FOut.FErrDesc  := Root.NodeByName('MESSAGE').ValueAsString;
      FOut.FResult   := False;
      Exit;
    end;
    //error

    Result := True;
    FResult := True;
  end;
end;
//------------------------------------------------------------------------------
class function TWorkerModifyBill.FunctionName: string;
begin

  Result := sSAP_ModifySaleBill;
end;

function TWorkerModifyBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);
  case nFlag of
    cWorker_GetPackerName : Result := sSAP_ModifySaleBill;
    cWorker_GetRFCName    : Result := 'ec.deliverOrder.update';
  end;
end;

procedure TWorkerModifyBill.SetRFCParam(const nData: string;
 var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FPacker.UnPackIn(nData, nIn);
end;

//Date: 2015-03-04
//Parm: ����
//Desc: ִ��XBoxҵ��
function TWorkerModifyBill.DoXBoxWork(var nData: string): Boolean;
var nStr: string;
    nTime: Int64;
begin
  with gXBoxURLs[GetXBoxURL] do
  begin
    nTime := GetTickCount;

    nStr := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
            '<IN><deliverOrderNo>$no</deliverOrderNo><amount>$amount</amount> '+
            '<deliveryNumber>$dnumber</deliveryNumber></IN>';

    nStr := MacroValue(nStr, [MI('$no', FIn.FDELIVERYORDERNO),MI('$amount', FIn.FAMOUNT),
                              MI('$dnumber', FIn.FDELIVERYNUMBER)]);
    //business data

    nStr := StringReplace(FXBoxParam, '$data', nStr, [rfIgnoreCase]);
    //full url

    if GetMultiLangID = 'en' then   nTLang := 'en_US';
    if GetMultiLangID = ''   then   nTLang := 'zh_CH';

     nStr := StringReplace(nStr, '$Language', nTLang, [rfIgnoreCase]);
    //Replace language full url
    
    FListA.Text :=  nStr ;

    WriteLog( gXBoxURLs[3].FSAPName +'  ����: '+ FXBoxURL+ nStr );

    FStream.Size := 0;
    FChannel.Post(FXBoxURL, FListA,FStream);

    nStr := UTF8Decode(FStream.DataString);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nStr);

    WriteLog(gXBoxURLs[3].FSAPName  + '  ��ʱ:  ' + IntToStr(GetTickCount - nTime) +
             ' ����ֵ:  '  + 'MSGNO:' + FIn.FBase.FMSGNO + StringReplace(nStr,' ','',[rfReplaceAll]));
    Result := True;
  end;
end;

//Date: 2012-3-12
//Parm: SAP����
//Desc: ������ȡ����nData���
function TWorkerModifyBill.ParseData(var nData: string): Boolean;
var nOut: TXmlNode;
begin
 with FPacker.XMLBuilder,FOut do
  begin
    Result := False;

    nOut := Root.FindNode('STATUS');

    if not Assigned(nOut) then
    begin
      FOut.FErrCode  := 'E.00';
      FOut.FErrDesc  := 'Service is currently unavailable, please save the error message and contact the service platform administrator';
      FOut.FResult   := False;
      Exit;
    end;
    // error dump
    
    if  Root.NodeByName('STATUS').ValueAsString  <> '1' then
    begin
      FOut.FErrCode  := 'E.00';
      FOut.FErrDesc  := Root.NodeByName('MESSAGE').ValueAsString;
      FOut.FResult   := False;
      Exit;
    end;
    //error

    Result := True;
    FResult := True;
  end;
end;
//------------------------------------------------------------------------------

class function TWorkerDeleteBill.FunctionName: string;
begin

  Result := sSAP_DeleteSaleBill;
end;

function TWorkerDeleteBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);
  case nFlag of
    cWorker_GetPackerName : Result := sSAP_DeleteSaleBill;
    cWorker_GetRFCName    : Result := 'ec.deliverOrder.delete';
  end;
end;

procedure TWorkerDeleteBill.SetRFCParam(const nData: string;
 var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FPacker.UnPackIn(nData, nIn);
end;

//Date: 2015-03-04
//Parm: ����
//Desc: ִ��XBoxҵ��
function TWorkerDeleteBill.DoXBoxWork(var nData: string): Boolean;
var nStr: string;
    nTime: Int64;
begin
  with gXBoxURLs[GetXBoxURL] do
  begin
    nTime := GetTickCount;

    nStr := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
            '<IN><deliveryOrderNo>$no</deliveryOrderNo></IN>';

    nStr := MacroValue(nStr, [MI('$no', FIn.FDELIVERYORDERNO)]);
    //business data

    nStr := StringReplace(FXBoxParam, '$data', nStr, [rfIgnoreCase]);
    //full url

    if GetMultiLangID = 'en' then   nTLang := 'en_US';
    if GetMultiLangID = ''   then   nTLang := 'zh_CH';

     nStr := StringReplace(nStr, '$Language', nTLang, [rfIgnoreCase]);
    //Replace language full url
    
    FListA.Text :=  nStr ;

    WriteLog( gXBoxURLs[4].FSAPName +'  ����: '+ FXBoxURL+ nStr );

    FStream.Size := 0;
    FChannel.Post(FXBoxURL, FListA,FStream);

    nStr := UTF8Decode(FStream.DataString);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nStr);

    WriteLog(gXBoxURLs[4].FSAPName  + '  ��ʱ:  ' + IntToStr(GetTickCount - nTime) +
             ' ����ֵ:  '  + 'MSGNO:' + FIn.FBase.FMSGNO + StringReplace(nStr,' ','',[rfReplaceAll]));
    Result := True;
  end;
end;

//Date: 2012-3-12
//Parm: SAP����
//Desc: ������ȡ����nData���
function TWorkerDeleteBill.ParseData(var nData: string): Boolean;
var nOut: TXmlNode;
begin
 with FPacker.XMLBuilder,FOut do
  begin
    Result := False;

    nOut := Root.FindNode('STATUS');

    if not Assigned(nOut) then
    begin
      FOut.FErrCode  := 'E.00';
      FOut.FErrDesc  := 'Service is currently unavailable, please save the error message and contact the service platform administrator';
      //'����Ŀǰ�޷�ʹ�ã��뱣��ô�����Ϣ���ͷ���ƽ̨����Ա��ϵ';
      FOut.FResult   := False;
      Exit;
    end;
    // error dump

    if  Root.NodeByName('STATUS').ValueAsString  <> '1' then
    begin
      FOut.FErrCode  := 'E.00';
      FOut.FErrDesc  := Root.NodeByName('MESSAGE').ValueAsString;
      FOut.FResult   := False;
      Exit;
    end;
    //error


    Result := True;
    FResult := True;
  end;
end;
//------------------------------------------------------------------------------

class function TWorkerPickBill.FunctionName: string;
begin

  Result := sSAP_PickSaleBill;
end;

function TWorkerPickBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);
  case nFlag of
    cWorker_GetPackerName : Result := sSAP_PickSaleBill;
    cWorker_GetRFCName    : Result := 'ec.deliverOrder.pick';
  end;
end;

procedure TWorkerPickBill.SetRFCParam(const nData: string;
 var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FPacker.UnPackIn(nData, nIn);
end;

//Date: 2015-03-04
//Parm: ����
//Desc: ִ��XBoxҵ��
function TWorkerPickBill.DoXBoxWork(var nData: string): Boolean;
var nStr: string;
    nTime: Int64;
begin
  with gXBoxURLs[GetXBoxURL] do
  begin
    nTime := GetTickCount;

    nStr := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
            '<IN><deliverOrderNo>$no</deliverOrderNo><amount>$amount</amount></IN>';

   nStr := MacroValue(nStr, [MI('$no', FIn.FDELIVERYORDERNO),MI('$amount', FIn.FAMOUNT)]);
    //business data

    nStr := StringReplace(FXBoxParam, '$data', nStr, [rfIgnoreCase]);
    //full url

    if GetMultiLangID = 'en' then   nTLang := 'en_US';
    if GetMultiLangID = ''   then   nTLang := 'zh_CH';

     nStr := StringReplace(nStr, '$Language', nTLang, [rfIgnoreCase]);
    //Replace language full url
    
    FListA.Text :=  nStr ;

    WriteLog( gXBoxURLs[5].FSAPName +'  ����: '+ FXBoxURL+ nStr );

    FStream.Size := 0;
    FChannel.Post(FXBoxURL, FListA,FStream);

    nStr := UTF8Decode(FStream.DataString);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nStr);

    WriteLog(gXBoxURLs[5].FSAPName  + '  ��ʱ:  ' + IntToStr(GetTickCount - nTime) +
             ' ����ֵ:  '  + 'MSGNO:' + FIn.FBase.FMSGNO + StringReplace(nStr,' ','',[rfReplaceAll]));
    Result := True;
  end;
end;

//Date: 2012-3-12
//Parm: SAP����
//Desc: ������ȡ����nData���
function TWorkerPickBill.ParseData(var nData: string): Boolean;
var nItem: TXmlNode;
begin
 with FPacker.XMLBuilder,FOut do
  begin
    Result := False;

    nItem := Root.FindNode('RESULT');

    if not Assigned(nItem) then
    begin
      FOut.FBase.FErrCode  := 'E.00';
      FOut.FBase.FErrDesc  := 'Service is currently unavailable, please save the error message and contact the service platform administrator';
      //'����Ŀǰ�޷�ʹ�ã��뱣��ô�����Ϣ���ͷ���ƽ̨����Ա��ϵ';
      FOut.FBase.FResult   := False;
      Exit;
    end;
    // error dump

    if  Root.NodeByName('STATUS').ValueAsString  <> '1' then
    begin
      FOut.FBase.FErrCode  := 'E.00';
      FOut.FBase.FErrDesc  := Root.NodeByName('MESSAGE').ValueAsString;
      FOut.FBase.FResult   := False;
      Exit;
    end;
    //error

    FDATE                := nItem.NodeByName('DATE').ValueAsString;           //������������(YYYY-MM-DD)
    FDELIVERYORDERNO     := nItem.NodeByName('deliverOrderNo').ValueAsString;  //��������
    FNUMBER              := nItem.NodeByName('number').ValueAsString;           //��������

    Result := True;
    FBase.FResult := True;
  end;
end;

//------------------------------------------------------------------------------
class function TWorkerPostBill.FunctionName: string;
begin
  Result := sSAP_PostSaleBill;
end;

function TWorkerPostBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);
  case nFlag of
    cWorker_GetPackerName : Result := sSAP_PostSaleBill;
    cWorker_GetRFCName    : Result := 'ec.outboundOrder.confirm';
  end;
end;

procedure TWorkerPostBill.SetRFCParam(const nData: string;
 var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FPacker.UnPackIn(nData, nIn);
end;

//Date: 2015-03-04
//Parm: ����
//Desc: ִ��XBoxҵ��
function TWorkerPostBill.DoXBoxWork(var nData: string): Boolean;
var nItem,nStr: string;
    nTime: Int64;
    nIdx:Integer;
begin
  with gXBoxURLs[GetXBoxURL] do
  begin
    nTime := GetTickCount;

    with FPacker do
    begin
      StrBuilder.Text := PackerDecodeStr(FIn.FData);
      nItem := '';

      for nIdx:=0 to StrBuilder.Count - 1 do
      begin
        FListA.Text := PackerDecodeStr(StrBuilder[nIdx]);
        nItem := nItem +
                Format('<deliveryOrderNo>%s</deliveryOrderNo>', [FListA.Values['DELIVERYORDERNO']]);
        //items
      end;
    end;

    nStr := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
            '<IN>$item</IN>';

    nStr := MacroValue(nStr, [MI('$item', nItem)]);
    //business data

    nStr := StringReplace(FXBoxParam, '$data', nStr, [rfIgnoreCase]);
    //full url

    if GetMultiLangID = 'en' then   nTLang := 'en_US';
    if GetMultiLangID = ''   then   nTLang := 'zh_CH';

     nStr := StringReplace(nStr, '$Language', nTLang, [rfIgnoreCase]);
    //Replace language full url
    
    FListA.Text :=  nStr ;

    WriteLog( gXBoxURLs[6].FSAPName +'  ����: '+ FXBoxURL+ nStr );

    FStream.Size := 0;
    FChannel.Post(FXBoxURL, FListA,FStream);

    nStr := UTF8Decode(FStream.DataString);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nStr);

    WriteLog(gXBoxURLs[6].FSAPName  + '  ��ʱ:  ' + IntToStr(GetTickCount - nTime) +
             ' ����ֵ:  '  + 'MSGNO:' + FIn.FBase.FMSGNO + StringReplace(nStr,' ','',[rfReplaceAll]));
    Result := True;
  end;
end;

//Date: 2012-3-12
//Parm: SAP����
//Desc: ������ȡ����nData���
function TWorkerPostBill.ParseData(var nData: string): Boolean;
var nItem: TXmlNode;
    nIdx:Integer;
    nMessage: string;
begin
 with FPacker.XMLBuilder,FOut do
  begin
    Result := False;

    nItem := Root.FindNode('RESULT');

    if not Assigned(nItem) then
    begin
      FOut.FBase.FErrDesc  := 'E.00';
      FOut.FBase.FErrDesc  := 'Service is currently unavailable, please save the error message and contact the service platform administrator';
      //'����Ŀǰ�޷�ʹ�ã��뱣��ô�����Ϣ���ͷ���ƽ̨����Ա��ϵ';
      FOut.FBase.FResult   := False;
      Exit;
    end;
    // error dump
    FPacker.StrBuilder.Clear;
    nMessage :=Root.NodeByName('MESSAGE').ValueAsString ;

    if  Root.NodeByName('STATUS').ValueAsString  = '0' then
    begin
      for nIdx:=0 to Root.NodeCount - 1 do
      begin
        if CompareText(Root.Nodes[nIdx].Name, 'result') <> 0 then Continue;
        //ignor invalid node

        with Root.Nodes[nIdx] do
        begin
          FListB.Values['OUTBOUNDORDERNO'] := '';                                  //���ⵥ��
          FListB.Values['DELIVERORDERNO']  := NodeByName('deliverOrderNo').ValueAsString;    //��������
          FListB.Values['MSGTXT']          := nMessage;
          FListB.Values['TYPE']            := 'E';
          FPacker.StrBuilder.Add(PackerEncodeStr(FListB.Text));
        end;
      end;
    end else
    begin
      for nIdx:=0 to Root.NodeCount - 1 do
      begin
        if CompareText(Root.Nodes[nIdx].Name, 'result') <> 0 then Continue;
        //ignor invalid node

        with Root.Nodes[nIdx] do
        begin
          FListB.Values['OUTBOUNDORDERNO'] := NodeByName('outboundOrderNo').ValueAsString;   //���ⵥ��
          FListB.Values['DELIVERORDERNO']  := NodeByName('deliverOrderNo').ValueAsString;    //��������
          FListB.Values['MSGTXT']          := nMessage;
          FListB.Values['TYPE']            := 'S';
          FPacker.StrBuilder.Add(PackerEncodeStr(FListB.Text));
        end;
      end;
    end;


    Result := True;
    FBase.FResult := True;
    FOut.FData := PackerEncodeStr(FPacker.StrBuilder.Text);
  end;
end;

//-----------------------------------------------------------------------------
class function TWorkerDiaozhangBill.FunctionName: string;
begin

  Result := sSAP_TiaoZSaleBill;
end;

function TWorkerDiaozhangBill.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);
  case nFlag of
    cWorker_GetPackerName : Result := sSAP_TiaoZSaleBill;
    cWorker_GetRFCName    : Result := 'ec.deliverOrder.tcvh';
  end;
end;

procedure TWorkerDiaozhangBill.SetRFCParam(const nData: string;
 var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FPacker.UnPackIn(nData, nIn);
end;

//Date: 2015-03-04
//Parm: ����
//Desc: ִ��XBoxҵ��
function TWorkerDiaozhangBill.DoXBoxWork(var nData: string): Boolean;
var nStr: string;
    nTime: Int64;
begin
  with gXBoxURLs[GetXBoxURL] do
  begin
    nTime := GetTickCount;

    nStr := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
            '<IN><oldDeliveryNo>$odno</oldDeliveryNo><orderNo>$orderno</orderNo>'+
            '<deliveryNo>$dno</deliveryNo><deliverListNo>$dListno</deliverListNo>'+
            '<redDeliveryNo>$tzno</redDeliveryNo></IN>';

    nStr := MacroValue(nStr, [MI('$odno', FIn.FODELIVERYNO) ,MI('$orderno', FIn.FORDERNO),
                              MI('$dno',  FIn.FDELIVERYNO)  ,MI('$dListno', FIn.FDELIVERLISTNO),
                              MI('$tzno', FIn.FTZDELIVERYNO)]);
    //business data

    nStr := StringReplace(FXBoxParam, '$data', nStr, [rfIgnoreCase]);
    //full url

    if GetMultiLangID = 'en' then   nTLang := 'en_US';
    if GetMultiLangID = ''   then   nTLang := 'zh_CH';

     nStr := StringReplace(nStr, '$Language', nTLang, [rfIgnoreCase]);
    //Replace language full url

    FListA.Text :=  nStr ;

    WriteLog( gXBoxURLs[8].FSAPName +'  ����: '+ FXBoxURL+ nStr );

    FStream.Size := 0;
    FChannel.Post(FXBoxURL, FListA,FStream);

    nStr := UTF8Decode(FStream.DataString);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nStr);

    WriteLog(gXBoxURLs[8].FSAPName  + '  ��ʱ:  ' + IntToStr(GetTickCount - nTime) +
             ' ����ֵ:  '  + 'MSGNO:' + FIn.FBase.FMSGNO + StringReplace(nStr,' ','',[rfReplaceAll]));
    Result := True;
  end;
end;

//Date: 2012-3-12
//Parm: SAP����
//Desc: ������ȡ����nData���
function TWorkerDiaozhangBill.ParseData(var nData: string): Boolean;
var nItem: TXmlNode;
begin
 with FPacker.XMLBuilder,FOut do
  begin
    Result := False;

    nItem := Root.FindNode('STATUS');

    if not Assigned(nItem) then
    begin
      FOut.FBase.FErrCode  := 'E.00';
      FOut.FBase.FErrDesc  := 'Service is currently unavailable, please save the error message and contact the service platform administrator';
     // '����Ŀǰ�޷�ʹ�ã��뱣��ô�����Ϣ���ͷ���ƽ̨����Ա��ϵ';
      FOut.FBase.FResult   := False;
      Exit;
    end;
    // error dump


    if  Root.NodeByName('STATUS').ValueAsString  <> '1' then
    begin
      FOut.FBase.FErrCode  := 'E.00';
      FOut.FBase.FErrDesc  := Root.FindNode('MESSAGE').ValueAsString ;
      FOut.FBase.FResult   := False;
      Exit;

    end;
    //error

    FOut.FDATA := Root.FindNode('MESSAGE').ValueAsString ;
    Result := True;
    FBase.FResult := True;
  end;
end ;

//------------------------------------------------------------------------------

class function TWorkerTZROrderForCus.FunctionName: string;
begin
  Result := sSAP_TiaoZROrder;
end;

function TWorkerTZROrderForCus.GetFlagStr(const nFlag: Integer): string;
begin
  inherited GetFlagStr(nFlag);
  case nFlag of
    cWorker_GetPackerName : Result := sSAP_TiaoZROrder;
    cWorker_GetRFCName    : Result := 'ec.outboundOrder.confirm';
  end;
end;

procedure TWorkerTZROrderForCus.SetRFCParam(const nData: string;
 var nIn,nOut: PBWDataBase);
begin
  nIn := @FIn;
  nOut := @FOut;
  FPacker.UnPackIn(nData, nIn);
end;

//Date: 2015-03-04
//Parm: ����
//Desc: ִ��XBoxҵ��
function TWorkerTZROrderForCus.DoXBoxWork(var nData: string): Boolean;
var nStr: string;
    nTime: Int64;
begin
  with gXBoxURLs[GetXBoxURL] do
  begin
    nTime := GetTickCount;

    nStr := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
            '<IN><customerNo>$code</customerNo><customerName>$name</customerName></IN>';

    nStr := MacroValue(nStr, [MI('$code',FIn.FCUSTOMCODE),
                              MI('$name',FIn.FCUSTOMNAME)]);
    //business data

    nStr := StringReplace(FXBoxParam, '$data', nStr, [rfIgnoreCase]);
    //full url

    if GetMultiLangID = 'en' then   nTLang := 'en_US';
    if GetMultiLangID = ''   then   nTLang := 'zh_CH';

     nStr := StringReplace(nStr, '$Language', nTLang, [rfIgnoreCase]);
    //Replace language full url
    
    FListA.Text := UTF8Encode(nStr) ;

    WriteLog( gXBoxURLs[8].FSAPName +'  ����: '+ FXBoxURL+ nStr );

    FStream.Size := 0;
    FChannel.Post(FXBoxURL, FListA,FStream);

    nStr := UTF8Decode(FStream.DataString);
    FPacker.XMLBuilder.Clear;
    FPacker.XMLBuilder.ReadFromString(nStr);

    WriteLog(gXBoxURLs[8].FSAPName  + '  ��ʱ:  ' + IntToStr(GetTickCount - nTime) +
             ' ����ֵ:  '  + 'MSGNO:' + FIn.FBase.FMSGNO + StringReplace(nStr,' ','',[rfReplaceAll]));
    Result := True;
  end;
end;

//Date: 2012-3-12
//Parm: SAP����
//Desc: ������ȡ����nData���
function TWorkerTZROrderForCus.ParseData(var nData: string): Boolean;
var nItem: TXmlNode;
    nIdx:Integer;
begin
 with FPacker.XMLBuilder,FOut do
  begin
    Result := False;

    nItem := Root.FindNode('status');


    if not Assigned(nItem) then
    begin
      FOut.FBase.FErrDesc  := 'E.00';
      FOut.FBase.FErrDesc  := 'Service is currently unavailable, please save the error message and contact the service platform administrator';
      //'����Ŀǰ�޷�ʹ�ã��뱣��ô�����Ϣ���ͷ���ƽ̨����Ա��ϵ';
      FOut.FBase.FResult   := False;
      Exit;
    end;
    // error dump

    FPacker.StrBuilder.Clear;
    for nIdx:=0 to Root.NodeCount - 1 do
    begin
      if CompareText(Root.Nodes[nIdx].Name, 'result') <> 0 then Continue;
      //ignor invalid node

      with Root.Nodes[nIdx] do
      begin
        FListA.Values['amount']         := NodeByName('amount').ValueAsString;     //��������
        FListA.Values['orderCode']      := NodeByName('orderCode').ValueAsString;  //�������
        FListA.Values['surplusAmount']  := NodeByName('surplusAmount').ValueAsString; //����������
        FListA.Values['cusCode']        := NodeByName('cusCode').ValueAsString;      //�ͻ����
        FListA.Values['cusName']        := NodeByName('cusName').ValueAsString;      //�ͻ�����
        FListA.Values['productCode']    := NodeByName('productCode').ValueAsString;  //���ϱ��
        FListA.Values['productName']    := NodeByName('productName').ValueAsString; //��������
        FPacker.StrBuilder.Add(PackerEncodeStr(FListA.Text));
      end;
    end;

    Result := True;
    FBase.FResult := True;
    FOut.FData := PackerEncodeStr(FPacker.StrBuilder.Text);
  end;
end;

initialization
  gBusinessWorkerManager.RegisteWorker(TWorkerReadXSSaleOrder);
  gBusinessWorkerManager.RegisteWorker(TWorkerReadCRMOrder);
  gBusinessWorkerManager.RegisteWorker(TWorkerCreateSaleBill);
  gBusinessWorkerManager.RegisteWorker(TWorkerModifyBill);
  gBusinessWorkerManager.RegisteWorker(TWorkerDeleteBill);
  gBusinessWorkerManager.RegisteWorker(TWorkerPickBill);
  gBusinessWorkerManager.RegisteWorker(TWorkerPostBill);
  gBusinessWorkerManager.RegisteWorker(TWorkerDiaozhangBill);
  gBusinessWorkerManager.RegisteWorker(TWorkerTZROrderForCus);
end.

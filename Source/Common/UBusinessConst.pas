{*******************************************************************************
  ����: dmzn@163.com 2012-02-03
  ����: ҵ��������

  ��ע:
  *.����In/Out����,��ô���TBWDataBase������,��λ�ڵ�һ��Ԫ��.
*******************************************************************************}
unit UBusinessConst;

interface

uses
  Classes, SysUtils, UBusinessPacker, ULibFun, USysDB;

const
  {*channel type*}
  cBus_Channel_Connection     = $0002;
  cBus_Channel_Business       = $0005;

  {*query field define*}
  cQF_Bill                    = $0001;

  {*business command*}
  cBC_GetSerialNO             = $0001;   //��ȡ���б��
  cBC_ServerNow               = $0002;   //��������ǰʱ��
  cBC_IsSystemExpired         = $0003;   //ϵͳ�Ƿ��ѹ���

  cBC_SaveTruckInfo           = $0013;   //���泵����Ϣ
  cBC_GetTruckPoundData       = $0015;   //��ȡ������������
  cBC_SaveTruckPoundData      = $0016;   //���泵����������

  cBC_SaveBills               = $0020;   //���潻�����б�
  cBC_DeleteBill              = $0021;   //ɾ��������
  cBC_ModifyBillTruck         = $0022;   //�޸ĳ��ƺ�
  cBC_SaleAdjust              = $0023;   //���۵���
  cBC_SaveBillCard            = $0024;   //�󶨽������ſ�
  cBC_LogoffCard              = $0025;   //ע���ſ�
  cBC_SaveTruckRFIDCard       = $0026;   //�趨����ǩ
  cBC_DeleteTruckDocument     = $0027;   //ɾ����������

  cBC_GetPostBills            = $0030;   //��ȡ��λ������
  cBC_SavePostBills           = $0031;   //�����λ������

  cBC_ChangeDispatchMode      = $0053;   //�л�����ģʽ
  cBC_GetPoundCard            = $0054;   //��ȡ��վ����
  cBC_GetQueueData            = $0055;   //��ȡ��������
  cBC_PrintCode               = $0056;
  cBC_PrintFixCode            = $0057;   //����
  cBC_PrinterEnable           = $0058;   //�������ͣ

  cBC_JSStart                 = $0060;
  cBC_JSStop                  = $0061;
  cBC_JSPause                 = $0062;
  cBC_JSGetStatus             = $0063;
  cBC_SaveCountData           = $0064;   //����������
  cBC_RemoteExecSQL           = $0065;

  cBC_IsTunnelOK              = $0075;
  cBC_TunnelOC                = $0076;   //���̵ƿ���
  cBC_PlayVoice               = $0077;   //��������

type
  PWorkerQueryFieldData = ^TWorkerQueryFieldData;
  TWorkerQueryFieldData = record
    FBase     : TBWDataBase;
    FType     : Integer;           //����
    FData     : string;            //����
  end;

  PWorkerBusinessCommand = ^TWorkerBusinessCommand;
  TWorkerBusinessCommand = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //����
    FData     : string;            //����
    FExtParam : string;            //����
  end;

  TPoundStationData = record
    FStation  : string;            //��վ��ʶ
    FValue    : Double;            //Ƥ��
    FDate     : TDateTime;         //��������
    FOperator : string;            //����Ա
  end;

  PLadingBillItem = ^TLadingBillItem;
  TLadingBillItem = record
    FID         : string;          //��������
    FZhiKa      : string;          //ֽ�����
    FCusID      : string;          //�ͻ����
    FCusName    : string;          //�ͻ�����
    FTruck      : string;          //���ƺ���

    FType       : string;          //Ʒ������
    FStockNo    : string;          //Ʒ�ֱ��
    FStockName  : string;          //Ʒ������
    FValue      : Double;          //�����
    FPrice      : Double;          //�������

    FCard       : string;          //�ſ���
    FIsVIP      : string;          //ͨ������
    FStatus     : string;          //��ǰ״̬
    FNextStatus : string;          //��һ״̬

    FPData      : TPoundStationData; //��Ƥ
    FMData      : TPoundStationData; //��ë
    FFactory    : string;          //�������
    FPModel     : string;          //����ģʽ
    FPType      : string;          //ҵ������
    FPoundID    : string;          //���ؼ�¼
    FSelected   : Boolean;         //ѡ��״̬
  end;

  TLadingBillItems = array of TLadingBillItem;
  //�������б�

  PReadXSSaleOrderIn = ^TReadXSSaleOrderIn;
  TReadXSSaleOrderIn = record
    FBase  : TBWDataBase;          //��������
    FORDERCODE : string;           //���۶�����
  end;

  PReadXSSaleOrderOut = ^TReadXSSaleOrderOut;
  TReadXSSaleOrderOut = record
    FBase     : TBWDataBase;
    FORDERCODE    : string;             //���۶�����
    FORDERTYPE    : string;             //���۶�������
    FSTATUS       : string;             //����״̬
    FBUYPARTCODE  : string;             //����λ���
    FBUYPARTNAME  : string;             //����λ����
    FRECEIVEPART : string;              //�ջ���λ
    FDISPATCHINGCODE  : string;         //�����̱��
    FPRODUCTCODE   : string;            //��Ʒ����
    FPRODUCTNAME   : string;            //��Ʒ����
    FSTANDARD      : string;            //��Ʒ���
    FUNIT          : string;            //��λ
    FFACTORYPRICE  : Double;            //������
    FTOTALPRICE    : Double;            //��λ��
    FOUTAMOUNT     : Double;            //�ѿ�����
    FSURPLUSAMOUNT : Double;            //ʣ������
    FAMOUNT        : Double;            //��������
    FTRANSTYPE     : string;            //���䷽ʽ
    FTOTALMONEY    : Double;            //�ܽ��
    FCONTRACTNO    : string;            //��ͬ���
    FREGIONCODE    : string;            //����������
    FREGIONNAME    : string;            //������������
  end;
  //���۶���

  PReadCRMOrderIn = ^TReadCRMOrderIn;
  TReadCRMOrderIn = record
    FBase       : TBWDataBase;       //��������
    FDELIVERNO  : string;           //ί�е���
  end;

  PReadCrmOrderOut = ^TReadCrmOrderOut;
  TReadCrmOrderOut = record
    FBase           : TBWDataBase;
    FDELIVERLISTNO  : STRING;           //���ί�е����
    FTRAVELNUMBER   : STRING;           //������
    FTELEPHONE:     STRING;             //��ϵ�绰
    FAMOUNT:        Double;             //������� (ί�е�)
    FORDERNO:       string;             //�������
    FORDERTYPE:     string;             //��������
    FSTATUS:        string;             //����״̬
    FBUYPARTCODE  : string;             //����λ���
    FBUYPARTNAME:   string;             //����λ����
    FRECEIVEPART:   string;             //�ջ���λ
    FPRODUCTCODE:   string;             //��Ʒ����
    FPRODUCTNAME:   string;             //��Ʒ����
    FUNIT:          string;             //��λ
    FFACTORYPRICE  : Double;            //������
    FTOTALPRICE    : Double;            //��λ��
    FOUTAMOUNT     : Double;            //�ѿ�����
    FSURPLUSAMOUNT : Double;            //ʣ������
    FTRANSTYPE     : string;            //���䷽ʽ
    FTOTALMONEY    : Double;            //�ܽ��
    FCONTRACTNO    : string;            //��ͬ���
    FREGIONCODE    : string;            //����������
    FREGIONNAME    : string;            //������������
    FDRIVERNAME    : string;            //˾������
    FNONUMBER      : string;            //֤������
  end;
  //�������ί�е�

  PWorkerCreateBillIn = ^TWorkerCreateBillIn;
  TWorkerCreateBillIn = record
    FBase                    : TBWDataBase;       //��������
    FFType                    : string;            //����(����,CRM)
    FFOrder                   : string;            //��ȡ��������

    FDELIVERYORDERNO         : string;            //��������
    FAMOUNT                  : Double;            //��������
    FDELIVERYNUMBER          : string;            //���ƺ�
    FPRODUCTCODE             : string;            //��Ʒ����
    FPRODUCTNAME             : string;            //��Ʒ����
    FBUYPARTCODE             : string;            //����λ
    FBUYPARTNAME             : string;            //����λ����
    FORDERNO                 : string;            //���۶�����
    FDELIVERLISYNO           : string;            //���ί�е����
    FCREATEDATE              : TDateTime;         //����ʱ��
    FCREATEUSER              : string;            //������
    FREVEIVENAME             : string;            //�ջ�������
    FDRIVERNAME              : string;            //˾������
    FMEASUREMENTUNIT         : string;            //������λ
    FTELEPHONE               : string;            //��ϵ�绰
    FTRANSTYPE               : string;            //���䷽ʽ
    FREGIONCODE              : string;            //����
    FREGIONTEXT              : string;            //��������
    FCHANNELTYPE             : string;            //���ͨ��
    FTRUCKNAME               : string;            //˾������
    FTRUCKTEL                : string;            //˾���绰
    FSEALATEXT               : string;            //��ǩ���
    FTOTALPRICE              : Double;            //��λ��
    FNONUMBER                : string;            //֤������
  end;
  //����������

  PWorkerModfiyBillIn = ^TWorkerModfiyBillIn;
  TWorkerModfiyBillIn = record
    FBase                    : TBWDataBase;       //��������
    FDELIVERYORDERNO         : string;            //��������
    FAMOUNT                  : string;            //��������
    FDELIVERYNUMBER          : string;            //���ƺ�
  end;
  //�������޸�

  PWorkerDeleteBillIn = ^TWorkerDeleteBillIn;
  TWorkerDeleteBillIn  = record
    FBase                    : TBWDataBase;        //��������
    FDELIVERYORDERNO         : string;             //��������
  end;
 //������ɾ��

  PWorkerPickBillIn = ^TWorkerPickBillIn;
  TWorkerPickBillIn  = record
    FBase                    : TBWDataBase;       //��������
    FDELIVERYORDERNO         : string;            //��������
    FAMOUNT                  : string;            //��������
    FTYPE                    : string;            //��ɢ��ʶ
    FPValue                  : string;            //Ƥ��
    FMValue                  : string;            //ë��
  end;

  PWorkerPickBillOut = ^TWorkerPickBillOut;
  TWorkerPickBillOut  = record
    FBase                : TBWDataBase;          //��������
    FDATE                : STRING;               //������������(YYYY-MM-DD)
    FDELIVERYORDERNO     : string;               //��������
    FNUMBER              : string;               //��������
  end;
  //����������

  PWorkerPostBillIn = ^TWorkerPostBillIn;
  TWorkerPostBillIn  = record
    FBase                    : TBWDataBase;       //��������
    FDATA                    : string;            //��������
  end;

  PWorkerPostBillOut = ^TWorkerPostBillOut;
  TWorkerPostBillOut  = record
    FBase                : TBWDataBase;           //��������
    FDATA                : string;                //���˽��
  end;
  //������ȷ��(����)

  PWorkerDiaozhangBillIn = ^TWorkerDiaozhangBillIn;
  TWorkerDiaozhangBillIn = record
    FBase               : TBWDataBase;            //��������
    FODELIVERYNO        : string;                  //��������(��)
    FDELIVERLISTNO      : string;                 //�������ί�е���(��)
    FORDERNO            : string;                 //������(��)
    FDELIVERYNO         : string;                 //��������(��)
    FTZDELIVERYNO       : string;                 //��������(���ֽ�������)
    FCUSTOMCODE         : string;                 //�ͻ����
    FCUSTOMNAME         : string;                 //�ͻ�����
    FPRODUCTCODE        : string;                 //��Ʒ���
    FPRODUCTNAME        : string;                 //��Ʒ����

  end;

  PWorkerDiaozhangBillOut = ^TWorkerDiaozhangBillOut;
  TWorkerDiaozhangBillOut = record
    FBase               : TBWDataBase;            //��������
    FDATA               : String;                 //��������
  end;
  //����������

  PWorkerROrderForCusin = ^TWorkerROrderForCusin;
  TWorkerROrderForCusin = record
    FBase               : TBWDataBase;            //��������
    FCUSTOMCODE         : string;                 //�ͻ����
    FCUSTOMNAME         : string;                 //�ͻ�����
  end;

  PWorkerROrderForCusOut = ^TWorkerROrderForCusOut;
  TWorkerROrderForCusOut = record
    FBase               : TBWDataBase;            //��������
    FDATA               : String;                 //��������
  end;
  //��ȡ�ͻ���ض�����Ϣ�б� for ����������

  TWorkerXBoxURL = record
    FSAPName: string;              //������
    FXBoxURL: string;              //ҵ���ַ
    FXBoxParam: string;            //ҵ�����
    FEncodeURL: Boolean;           //���ܵ�ַ
    FEncodeXML: Boolean;           //����XML
  end;

  TWorkerXBoxURLs = array of TWorkerXBoxURL;
  //��ַ�б�

var
  gXBoxURLs: TWorkerXBoxURLs;      //ҵ���б�
  gXBoxURLInited: Integer = 0;     //�Ƿ��ʼ��

procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
//������ҵ����󷵻صĽ���������
function CombineBillItmes(const nItems: TLadingBillItems): string;
//�ϲ�����������Ϊҵ������ܴ�����ַ���

resourcestring
  {*PBWDataBase.FParam*}
  sParam_NoHintOnError        = 'NHE';                  //����ʾ����

  {*plug module id*}
  sPlug_ModuleBus             = '{DF261765-48DC-411D-B6F2-0B37B14E014E}';
                                                        //ҵ��ģ��
  sPlug_ModuleHD              = '{B584DCD6-40E5-413C-B9F3-6DD75AEF1C62}';
                                                        //Ӳ���ػ�
                                                                                                   
  {*common function*}  
  sSys_BasePacker             = 'Sys_BasePacker';       //���������

  {*sap mit function name*}
  sSAP_ReadXSSaleOrder        = 'Read_CRM_XSSaleOrder';   //���۶���
  sSAP_ReadCRMOrder           = 'Read_CRM_TrustOrder';    //�������ί�е�
  sSAP_CreateSaleBill         = 'Create_CRM_BillOrder';  //����������
  sSAP_ModifySaleBill         = 'Modify_CRM_BillOrder';  //�޸Ľ�����
  sSAP_DeleteSaleBill         = 'Delete_CRM_BillOrder';  //ɾ��������
  sSAP_PickSaleBill           = 'Pick_CRM_BillOrder';    //���佻����
  sSAP_PostSaleBill           = 'Post_CRM_BillOrder';    //���˽�����(ȷ��)
  sSAP_TiaoZSaleBill          = 'Tiaoz_CRM_BillOrder';   //���˽�����
  sSAP_TiaoZROrder            = 'Tiaoz_CRM_ROrder';      //���˶�ȡ�ӿ�

  {*business mit function name*}
  sBus_ReadXSSaleOrder        = 'Bus_Read_XSSaleOrder'; //���۶���
  sBus_ReadCRMOrder           = 'Bus_Read_CRMOrder';    //�������ί�е�
  sBus_CreateSaleBill         = 'Bus_Create_SaleBill';  //����������
  sBus_ModifySaleBill         = 'Bus_Modify_SaleBill';  //�޸Ľ�����
  sBus_DeleteSaleBill         = 'Bus_Delete_SaleBill';  //ɾ��������
  sBus_PickSaleBill           = 'Bus_Pick_SaleBill';    //���佻����
  sBus_PostSaleBill           = 'Bus_Post_SaleBill';    //���˽�����(ȷ��)
  sBus_TiaoZSaleBill          = 'Bus_TiaoZ_SaleBill';   //���˽�����
  sBus_TiaoZROrder            = 'Bus_TiaoZ_ROrderForCus'; //���˶�ȡ�ӿ�

  sBus_ServiceStatus          = 'Bus_ServiceStatus';    //����״̬
  sBus_GetQueryField          = 'Bus_GetQueryField';    //��ѯ���ֶ�

  sBus_BusinessSaleBill       = 'Bus_BusinessSaleBill'; //���������
  sBus_BusinessCommand        = 'Bus_BusinessCommand';  //ҵ��ָ��
  sBus_HardwareCommand        = 'Bus_HardwareCommand';  //Ӳ��ָ��

  {*client function name*}
  sCLI_ReadXSSaleOrder        = 'CLI_Read_XSSaleOrder'; //���۶���
  sCLI_ReadCRMOrder           = 'CLI_Read_CRMOrder';    //�������ί�е�
  sCLI_CreateSaleBill         = 'CLI_Create_SaleBill';  //����������
  sCLI_ModifySaleBill         = 'CLI_Modify_SaleBill';  //�޸Ľ�����
  sCLI_DeleteSaleBill         = 'CLI_Delete_SaleBill';  //ɾ��������
  sCLI_PickSaleBill           = 'CLI_Pick_SaleBill';    //���佻����
  sCLI_PostSaleBill           = 'CLI_Post_SaleBill';    //���˽����� (ȷ��)
  sCLI_TiaoZSaleBill          = 'CLI_TiaoZ_SaleBill';   //���˽�����
  sCLI_ROrderForCus           = 'CLI_TiaoZ_ROrderForCus';   //���˶�ȡ�ӿ�

  sCLI_ServiceStatus          = 'CLI_ServiceStatus';    //����״̬
  sCLI_GetQueryField          = 'CLI_GetQueryField';    //��ѯ���ֶ�

  sCLI_BusinessSaleBill       = 'CLI_BusinessSaleBill'; //������ҵ��
  sCLI_BusinessCommand        = 'CLI_BusinessCommand';  //ҵ��ָ��
  sCLI_HardwareCommand        = 'CLI_HardwareCommand';  //Ӳ��ָ��

implementation

//Date: 2014-09-17
//Parm: ����������;�������
//Desc: ����nDataΪ�ṹ���б�����
procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
var nStr: string;
    nIdx,nInt: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    nListA.Text := PackerDecodeStr(nData);
    //bill list
    nInt := 0;
    SetLength(nItems, nListA.Count);

    for nIdx:=0 to nListA.Count - 1 do
    begin
      nListB.Text := PackerDecodeStr(nListA[nIdx]);
      //bill item

      with nListB,nItems[nInt] do
      begin
        FID         := Values['ID'];
        FZhiKa      := Values['ZhiKa'];
        FCusID      := Values['CusID'];
        FCusName    := Values['CusName'];
        FTruck      := Values['Truck'];

        FType       := Values['Type'];
        FStockNo    := Values['StockNo'];
        FStockName  := Values['StockName'];

        FCard       := Values['Card'];
        FIsVIP      := Values['IsVIP'];
        FStatus     := Values['Status'];
        FNextStatus := Values['NextStatus'];

        FFactory    := Values['Factory'];
        FPModel     := Values['PModel'];
        FPType      := Values['PType'];
        FPoundID    := Values['PoundID'];
        FSelected   := Values['Selected'] = sFlag_Yes;

        with FPData do
        begin
          FStation  := Values['PStation'];
          FDate     := Str2DateTime(Values['PDate']);
          FOperator := Values['PMan'];

          nStr := Trim(Values['PValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FPData.FValue := StrToFloat(nStr)
          else FPData.FValue := 0;
        end;

        with FMData do
        begin
          FStation  := Values['MStation'];
          FDate     := Str2DateTime(Values['MDate']);
          FOperator := Values['MMan'];

          nStr := Trim(Values['MValue']);
          if (nStr <> '') and IsNumber(nStr, True) then
               FMData.FValue := StrToFloat(nStr)
          else FMData.FValue := 0;
        end;

        nStr := Trim(Values['Value']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FValue := StrToFloat(nStr)
        else FValue := 0;

        nStr := Trim(Values['Price']);
        if (nStr <> '') and IsNumber(nStr, True) then
             FPrice := StrToFloat(nStr)
        else FPrice := 0;
      end;

      Inc(nInt);
    end;
  finally
    nListB.Free;
    nListA.Free;
  end;   
end;

//Date: 2014-09-18
//Parm: �������б�
//Desc: ��nItems�ϲ�Ϊҵ������ܴ����
function CombineBillItmes(const nItems: TLadingBillItems): string;
var nIdx: Integer;
    nListA,nListB: TStrings;
begin
  nListA := TStringList.Create;
  nListB := TStringList.Create;
  try
    Result := '';
    nListA.Clear;
    nListB.Clear;

    for nIdx:=Low(nItems) to High(nItems) do
    with nItems[nIdx] do
    begin
      if not FSelected then Continue;
      //ignored

      with nListB do
      begin
        Values['ID']         := FID;
        Values['ZhiKa']      := FZhiKa;
        Values['CusID']      := FCusID;
        Values['CusName']    := FCusName;
        Values['Truck']      := FTruck;

        Values['Type']       := FType;
        Values['StockNo']    := FStockNo;
        Values['StockName']  := FStockName;
        Values['Value']      := FloatToStr(FValue);
        Values['Price']      := FloatToStr(FPrice);

        Values['Card']       := FCard;
        Values['IsVIP']      := FIsVIP;
        Values['Status']     := FStatus;
        Values['NextStatus'] := FNextStatus;

        Values['Factory']    := FFactory;
        Values['PModel']     := FPModel;
        Values['PType']      := FPType;
        Values['PoundID']    := FPoundID;

        with FPData do
        begin
          Values['PStation'] := FStation;
          Values['PValue']   := FloatToStr(FPData.FValue);
          Values['PDate']    := DateTime2Str(FDate);
          Values['PMan']     := FOperator;
        end;

        with FMData do
        begin
          Values['MStation'] := FStation;
          Values['MValue']   := FloatToStr(FMData.FValue);
          Values['MDate']    := DateTime2Str(FDate);
          Values['MMan']     := FOperator;
        end;

        if FSelected then
             Values['Selected'] := sFlag_Yes
        else Values['Selected'] := sFlag_No;
      end;

      nListA.Add(PackerEncodeStr(nListB.Text));
      //add bill
    end;

    Result := PackerEncodeStr(nListA.Text);
    //pack all
  finally
    nListB.Free;
    nListA.Free;
  end;
end;

end.



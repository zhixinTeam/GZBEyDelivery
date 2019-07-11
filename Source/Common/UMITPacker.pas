{*******************************************************************************
  ����: dmzn@163.com 2011-10-22
  ����: �м��ҵ�����ݷ������
*******************************************************************************}
unit UMITPacker;

interface

uses
  Windows, SysUtils, Classes, ULibFun, UBusinessPacker, UBusinessConst;

type
  TMITPackerBase = class(TBusinessPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  end;

  TMITQueryField = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;

  TMITBusinessCommand = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;

  TMITReaddXSSaleOrder  = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //��ȡ���۶���

  TMITReaddCRMOrder = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //��ȡ�������ί�е�

  TMITCreateSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //����������

  TMITModifySaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //�������޸�

  TMITDeleteSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //������ɾ��

  TMITPickSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //����������

  TMITPostSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //������ȷ��

  TMITDiaozhangSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //����������

  TMITTiaoZROrderForCus = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //��ȡ�ͻ�����б���������

implementation

//Date: 2012-3-7
//Parm: ��������
//Desc: ����������nData�������
procedure TMITPackerBase.DoPackIn(const nData: Pointer);
begin
  inherited;
  
  with FStrBuilder,PBWDataBase(nData)^ do
  begin
    Values['Worker'] := PackerName;
    Values['MSGNO'] := PackerEncode(FMsgNo);
    Values['KEY']   := PackerEncode(FKey);

    PackWorkerInfo(FStrBuilder, FFrom, 'Frm');
    PackWorkerInfo(FStrBuilder, FVia, 'Via');
    PackWorkerInfo(FStrBuilder, FFinal, 'Fin');
  end;
end;

//Date: 2012-3-7
//Parm: �ַ�����
//Desc: ��nStr�������
procedure TMITPackerBase.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PBWDataBase(nData)^ do
  begin
    PackerDecode(Values['MSGNO'], FMsgNO);
    PackerDecode(Values['KEY'], FKey);

    PackWorkerInfo(FStrBuilder, FFrom, 'Frm', False);
    PackWorkerInfo(FStrBuilder, FVia, 'Via', False);
    PackWorkerInfo(FStrBuilder, FFinal, 'Fin', False);
  end;
end;

//Date: 2012-3-7
//Parm: �ṹ����
//Desc: �Խṹ����nData�������
procedure TMITPackerBase.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PBWDataBase(nData)^ do
  begin
    Values['Worker'] := PackerName;
    Values['Result'] := BoolToStr(FResult);
    Values['ErrCode'] := PackerEncode(FErrCode);
    Values['ErrDesc'] := PackerEncode(FErrDesc);

    PackWorkerInfo(FStrBuilder, FFrom, 'Frm');
    PackWorkerInfo(FStrBuilder, FVia, 'Via');
    PackWorkerInfo(FStrBuilder, FFinal, 'Fin');
  end;
end;

//Date: 2012-3-7
//Parm: �ַ�����
//Desc: ��nStr�������
procedure TMITPackerBase.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PBWDataBase(nData)^ do
  begin
    if Values['Result'] = '' then
         FResult := False
    else FResult := StrToBool(Values['Result']);
    
    PackerDecode(Values['ErrCode'], FErrCode);
    PackerDecode(Values['ErrDesc'], FErrDesc);

    PackWorkerInfo(FStrBuilder, FFrom, 'Frm', False);
    PackWorkerInfo(FStrBuilder, FVia, 'Via', False);
    PackWorkerInfo(FStrBuilder, FFinal, 'Fin', False);
  end; 
end;

//------------------------------------------------------------------------------
class function TMITQueryField.PackerName: string;
begin
  Result := sBus_GetQueryField;
end;

procedure TMITQueryField.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerQueryFieldData(nData)^ do
  begin
    Values['Type'] := IntToStr(FType);
    Values['Data']   := PackerEncode(FData);
  end;
end;

procedure TMITQueryField.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerQueryFieldData(nData)^ do
  begin
    PackerDecode(Values['Type'], FType);
    PackerDecode(Values['Data'], FData);
  end;
end;

procedure TMITQueryField.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerQueryFieldData(nData)^ do
  begin
    Values['Type']   := IntToStr(FType);
    Values['Data']   := PackerEncode(FData);
  end;
end;

procedure TMITQueryField.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerQueryFieldData(nData)^ do
  begin
    PackerDecode(Values['Type'], FType);
    PackerDecode(Values['Data'], FData);
  end;
end;

//------------------------------------------------------------------------------
class function TMITBusinessCommand.PackerName: string;
begin
  Result := sBus_BusinessCommand;
end;

procedure TMITBusinessCommand.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerBusinessCommand(nData)^ do
  begin
    Values['Command'] := IntToStr(FCommand);
    Values['Data']    := PackerEncode(FData);
    Values['ExtParam']  := PackerEncode(FExtParam);
  end;
end;

procedure TMITBusinessCommand.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerBusinessCommand(nData)^ do
  begin
    PackerDecode(Values['Command'], FCommand);
    PackerDecode(Values['Data'], FData);
    PackerDecode(Values['ExtParam'], FExtParam);
  end;
end;

procedure TMITBusinessCommand.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerBusinessCommand(nData)^ do
  begin
    Values['Command'] := IntToStr(FCommand);
    Values['Data']    := PackerEncode(FData);
    Values['ExtParam']  := PackerEncode(FExtParam);
  end;
end;

procedure TMITBusinessCommand.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerBusinessCommand(nData)^ do
  begin
    PackerDecode(Values['Command'], FCommand);
    PackerDecode(Values['Data'], FData);
    PackerDecode(Values['ExtParam'], FExtParam);
  end;
end;

//--------------------------------------------------------------------------
class function TMITReaddXSSaleOrder.PackerName:string;
begin
  Result := sSAP_ReadXSSaleOrder;
end;

procedure TMITReaddXSSaleOrder.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PReadXSSaleOrderIn(nData)^ do
  begin
    Values['ORDERCODE'] := PackerEncode(FORDERCODE);
  end;
end;

procedure TMITReaddXSSaleOrder.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PReadXSSaleOrderIn(nData)^ do
  begin
    PackerDecode(Values['ORDERCODE'], FORDERCODE);
  end;
end;

procedure TMITReaddXSSaleOrder.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PReadXSSaleOrderOut(nData)^ do
  begin
    Values['ORDERCODE'] := PackerEncode(FORDERCODE);      //���۶�����
    Values['ORDERTYPE'] := PackerEncode(FORDERTYPE);      //���۶�������
    Values['STATUS'] := PackerEncode(FSTATUS);            //����״̬
    Values['BUYPARTCODE'] := PackerEncode(FBUYPARTCODE);   //����λ����
    Values['BUYPARTNAME'] := PackerEncode(FBUYPARTNAME);    //����λ����
    Values['RECEIVEPART'] := PackerEncode(FRECEIVEPART);   //�ջ���λ
    Values['DISPATCHINGCODE'] := PackerEncode(FDISPATCHINGCODE); //�����̱��
    Values['PRODUCTCODE'] := PackerEncode(FPRODUCTCODE);          //��Ʒ����
    Values['PRODUCTNAME'] := PackerEncode(FPRODUCTNAME);           //��Ʒ����
    Values['STANDARD'] := PackerEncode(FSTANDARD);                 //��Ʒ���
    Values['UNIT'] := PackerEncode(FUNIT);                          //��λ
    Values['FACTORYPRICE'] := FloatToStr(FFACTORYPRICE);           //������
    Values['TOTALPRICE'] := FloatToStr(FTOTALPRICE);               //��λ��
    Values['OUTAMOUNT'] := FloatToStr(FOUTAMOUNT);                 //�ѿ�����
    Values['SURPLUSAMOUNT'] := FloatToStr(FSURPLUSAMOUNT);       //ʣ������
    Values['AMOUNT'] := FloatToStr(FAMOUNT);                   //��������
    Values['TRANSTYPE'] := PackerEncode(FTRANSTYPE);              //���䷽ʽ
    Values['TOTALMONEY'] := FloatToStr(FTOTALMONEY);            //�ܽ��
    Values['CONTRACTNO'] := PackerEncode(FCONTRACTNO);            //��ͬ���
    Values['REGIONCODE'] := PackerEncode(FREGIONCODE);            //����������
    Values['REGIONNAME'] := PackerEncode(FREGIONNAME);             //������������
  end;
end;

procedure TMITReaddXSSaleOrder.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PReadXSSaleOrderOut(nData)^ do
  begin
    PackerDecode(Values['ORDERCODE'], FORDERCODE);        //���۶�����
    PackerDecode(Values['ORDERTYPE'],FORDERTYPE);        //���۶�������
    PackerDecode(Values['STATUS'],FSTATUS);              //����״̬
    PackerDecode(Values['BUYPARTCODE'],FBUYPARTCODE);    //����λ����
    PackerDecode(Values['BUYPARTNAME'],FBUYPARTNAME);    //����λ����
    PackerDecode(Values['RECEIVEPART'],FRECEIVEPART);   //�ջ���λ
    PackerDecode(Values['DISPATCHINGCODE'],FDISPATCHINGCODE); //�����̱��
    PackerDecode(Values['PRODUCTCODE'],FPRODUCTCODE);          //��Ʒ����
    PackerDecode(Values['PRODUCTNAME'],FPRODUCTNAME);           //��Ʒ����
    PackerDecode(Values['STANDARD'],FSTANDARD);                 //��Ʒ���
    PackerDecode(Values['UNIT'] ,FUNIT);                          //��λ
    PackerDecode(Values['FACTORYPRICE'] ,FFACTORYPRICE);           //������
    PackerDecode(Values['TOTALPRICE'] ,FTOTALPRICE);               //��λ��
    PackerDecode(Values['OUTAMOUNT'] ,FOUTAMOUNT);                 //�ѿ�����
    PackerDecode(Values['SURPLUSAMOUNT'] ,FSURPLUSAMOUNT);       //ʣ������
    PackerDecode(Values['AMOUNT'] ,FAMOUNT);                   //��������
    PackerDecode(Values['TRANSTYPE'],FTRANSTYPE);              //���䷽ʽ
    PackerDecode(Values['TOTALMONEY'],FTOTALMONEY);            //�ܽ��
    PackerDecode(Values['CONTRACTNO'],FCONTRACTNO);            //��ͬ���
    PackerDecode(Values['REGIONCODE'],FREGIONCODE);          //����������
    PackerDecode(Values['REGIONNAME'],FREGIONNAME);          //������������
  end;
end;
//-----------------------------------------------------------------------
class function TMITReaddCRMOrder.PackerName:string;
begin
     Result := sSAP_ReadCrmOrder;
end;


procedure TMITReaddCRMOrder.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PReadCRMOrderIn(nData)^ do
  begin
    Values['DELIVERNO'] := PackerEncode(FDELIVERNO);
  end;
end;

procedure TMITReaddCRMOrder.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PReadCRMOrderIn(nData)^ do
  begin
     PackerDecode(Values['DELIVERNO'], FDELIVERNO);
  end;
end;

procedure TMITReaddCRMOrder.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PReadCrmOrderOut(nData)^ do
  begin
    Values['DELIVERLISTNO'] := PackerEncode(FDELIVERLISTNO);
    Values['TRAVELNUMBER'] := PackerEncode(FTRAVELNUMBER);
    Values['TELEPHONE'] := PackerEncode(FTELEPHONE);
    Values['AMOUNT'] := FloatToStr(FAMOUNT);
    Values['ORDERNO'] := PackerEncode(FORDERNO);
    Values['ORDERTYPE'] := PackerEncode(FORDERTYPE);
    Values['STATUS'] := PackerEncode(FSTATUS);
    Values['BUYPARTNAME'] := PackerEncode(FBUYPARTNAME);
    Values['RECEIVEPART'] := PackerEncode(FRECEIVEPART);
    Values['PRODUCTCODE'] := PackerEncode(FPRODUCTCODE);
    Values['PRODUCTNAME'] := PackerEncode(FPRODUCTNAME);
    Values['UNIT'] := PackerEncode(FUNIT);
    Values['FACTORYPRICE'] := FloatToStr(FFACTORYPRICE);
    Values['TOTALPRICE'] := FloatToStr(FTOTALPRICE);
    Values['OUTAMOUNT'] := FloatToStr(FOUTAMOUNT);
    Values['SURPLUSAMOUNT'] := FloatToStr(FSURPLUSAMOUNT);
    Values['AMOUNT'] := FloatToStr(FAMOUNT);
    Values['TRANSTYPE'] := PackerEncode(FTRANSTYPE);
    Values['TOTALMONEY'] := FloatToStr(FTOTALMONEY);
    Values['CONTRACTNO'] := PackerEncode(FCONTRACTNO);
    Values['REGIONCODE'] := PackerEncode(FREGIONCODE);                          //����������
    Values['REGIONNAME'] := PackerEncode(FREGIONNAME);                          //������������
    Values['DRIVERNAME'] := PackerEncode(FDRIVERNAME);                          //˾������
    Values['NONUMBER'] := PackerEncode(FNONUMBER);                          //֤������
  end;
end;

procedure TMITReaddCRMOrder.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PReadCrmOrderOut(nData)^ do
  begin
    PackerDecode(Values['DELIVERLISTNO'], FDELIVERLISTNO);
    PackerDecode(Values['TRAVELNUMBER'], FTRAVELNUMBER);
    PackerDecode(Values['TELEPHONE'], FTELEPHONE);
    PackerDecode(Values['AMOUNT'], FAMOUNT);
    PackerDecode(Values['ORDERNO'], FORDERNO);
    PackerDecode(Values['ORDERTYPE'], FORDERTYPE);
    PackerDecode(Values['STATUS'], FSTATUS);
    PackerDecode(Values['BUYPARTNAME'], FBUYPARTNAME);
    PackerDecode(Values['RECEIVEPART'], FRECEIVEPART);
    PackerDecode(Values['PRODUCTCODE'], FPRODUCTCODE);
    PackerDecode(Values['PRODUCTNAME'], FPRODUCTNAME);
    PackerDecode(Values['UNIT'], FUNIT);
    PackerDecode(Values['FACTORYPRICE'], FFACTORYPRICE);
    PackerDecode(Values['TOTALPRICE'], FTOTALPRICE);
    PackerDecode(Values['OUTAMOUNT'], FOUTAMOUNT);
    PackerDecode(Values['SURPLUSAMOUNT'], FSURPLUSAMOUNT);
    PackerDecode(Values['AMOUNT'], FAMOUNT);
    PackerDecode(Values['TRANSTYPE'], FTRANSTYPE);
    PackerDecode(Values['TOTALMONEY'], FTOTALMONEY);
    PackerDecode(Values['CONTRACTNO'], FCONTRACTNO);
    PackerDecode(Values['REGIONCODE'],FREGIONCODE);                             //����������
    PackerDecode(Values['REGIONNAME'],FREGIONNAME);                             //������������
    PackerDecode(Values['DRIVERNAME'],FDRIVERNAME);                             //˾������
    PackerDecode(Values['NONUMBER'],FNONUMBER);                                 //֤������
  end;
end;

//----------------------------------------------------------------
class function TMITCreateSaleBill.PackerName:string;
begin
  Result := sSAP_CreateSaleBill;
end;

procedure TMITCreateSaleBill.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerCreateBillIn(nData)^ do
  begin
    Values['FType'] := PackerEncode(FFType);                        //����(����,CRM)
    Values['FOrder'] := PackerEncode(FFOrder);                      //��ȡ��������

    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);    //��������
    Values['AMOUNT'] := FloatToStr(FAMOUNT);                        //��������
    Values['DELIVERYNUMBER'] := PackerEncode(FDELIVERYNUMBER);      //���ƺ�
    Values['PRODUCTCODE'] := PackerEncode(FPRODUCTCODE);            //��Ʒ����
    Values['PRODUCTNAME'] := PackerEncode(FPRODUCTNAME);            //��Ʒ����
    Values['BUYPARTCODE'] := PackerEncode(FBUYPARTCODE);            //����λ���
    Values['BUYPARTNAME'] := PackerEncode(FBUYPARTNAME);            //����λ����
    Values['ORDERNO'] := PackerEncode(FORDERNO);
    Values['DELIVERLISYNO'] := PackerEncode(FDELIVERLISYNO);        //���ί�е����
    Values['CREATEDATE'] := PackerEncode(FCREATEDATE);              //����ʱ��
    Values['CREATEUSER'] := PackerEncode(FCREATEUSER);              //������
    Values['REVEIVENAME'] := PackerEncode(FREVEIVENAME);            //����ʱ��
    Values['CREATEUSER'] := PackerEncode(FCREATEUSER);              //�ջ�������
    Values['DRIVERNAME'] := PackerEncode(FDRIVERNAME);              //˾������
    Values['MEASUREMENTUNIT'] := PackerEncode(FMEASUREMENTUNIT);    //������λ
    Values['TELEPHONE'] := PackerEncode(FTELEPHONE);                //��ϵ�绰
    Values['TRANSTYPE'] := PackerEncode(FTRANSTYPE);                //���䷽ʽ
    Values['REGIONCODE'] := PackerEncode(FREGIONCODE);              //����
    Values['REGIONTEXT'] := PackerEncode(FREGIONTEXT);              //��������
    Values['CHANNELTYPE'] := PackerEncode(FCHANNELTYPE);            //���ͨ��
    Values['TRUCKNAME'] := PackerEncode(FTRUCKNAME);                //˾������
    Values['TRUCKTEL']  := PackerEncode(FTRUCKTEL);                 //˾���绰
    Values['SEALATEXT']  := PackerEncode(FSEALATEXT);               //��ǩ���
    Values['TOTALPRICE'] := FloatToStr(FTOTALPRICE);                //��λ��
    Values['NONUMBER'] := PackerEncode(FNONUMBER);                 //֤������
  end;
end;

procedure TMITCreateSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerCreateBillIn(nData)^ do
  begin
   PackerDecode(Values['FType'],FFType);                         //����(����,CRM)
   PackerDecode(Values['FOrder'],FFOrder);                       //��ȡ��������

   PackerDecode(Values['DELIVERYORDERNO'],FDELIVERYORDERNO);     //��������
   PackerDecode(Values['AMOUNT'],FAMOUNT);                       //��������
   PackerDecode(Values['DELIVERYNUMBER'] ,FDELIVERYNUMBER);      //���ƺ�
   PackerDecode(Values['PRODUCTCODE'] ,FPRODUCTCODE);            //��Ʒ����
   PackerDecode(Values['PRODUCTNAME'] ,FPRODUCTNAME);            //��Ʒ����
   PackerDecode(Values['BUYPARTCODE'] ,FBUYPARTCODE);            //����λ���
   PackerDecode(Values['BUYPARTNAME'] ,FBUYPARTNAME);            //����λ����
   PackerDecode(Values['ORDERNO'] ,FORDERNO);                    //
   PackerDecode(Values['DELIVERLISYNO'] ,FDELIVERLISYNO);        //���ί�е����
   PackerDecode(Values['CREATEDATE'] ,FCREATEDATE);              //����ʱ��
   PackerDecode(Values['CREATEUSER'] ,FCREATEUSER);              //������
   PackerDecode(Values['REVEIVENAME'] ,FREVEIVENAME);            //����ʱ��
   PackerDecode(Values['CREATEUSER'] ,FCREATEUSER);              //�ջ�������
   PackerDecode(Values['DRIVERNAME'],FDRIVERNAME);               //˾������
   PackerDecode(Values['MEASUREMENTUNIT'] ,FMEASUREMENTUNIT);    //������λ
   PackerDecode(Values['TELEPHONE'] ,FTELEPHONE);                //��ϵ�绰
   PackerDecode(Values['TRANSTYPE'] ,FTRANSTYPE);                //���䷽ʽ
   PackerDecode(Values['REGIONCODE'],FREGIONCODE);               //����
   PackerDecode(Values['REGIONTEXT'],FREGIONTEXT);               //��������
   PackerDecode(Values['CHANNELTYPE'],FCHANNELTYPE);             //���ͨ��
   PackerDecode(Values['TRUCKNAME'],FTRUCKNAME);                 //˾������
   PackerDecode(Values['TRUCKTEL'],FTRUCKTEL);                   //˾���绰
   PackerDecode(Values['SEALATEXT'],FSEALATEXT);                 //��ǩ���
   PackerDecode(Values['TOTALPRICE'],FTOTALPRICE);               //��λ��
   PackerDecode(Values['NONUMBER'],FNONUMBER);                   //֤������
  end;
end;

//----------------------------------------------------------------------
class function TMITModifySaleBill.PackerName:string;
begin
     Result := sSAP_ModifySaleBill;
end;

procedure TMITModifySaleBill.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerModfiyBillIn(nData)^ do
  begin
    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);       //��������
    Values['AMOUNT']          := PackerEncode(FAMOUNT);                //��������
    Values['DELIVERYNUMBER']  := PackerEncode(FDELIVERYNUMBER);        //���ƺ�
  end;
end;

procedure TMITModifySaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerModfiyBillIn(nData)^ do
  begin
    PackerDecode(Values['DELIVERYORDERNO'], FDELIVERYORDERNO);
    PackerDecode(Values['AMOUNT'], FAMOUNT);
    PackerDecode(Values['DELIVERYNUMBER'], FDELIVERYNUMBER);
  end;
end;

//-------------------------------------------------------------------------
class function TMITDeleteSaleBill.PackerName:string;
begin
     Result := sSAP_DeleteSaleBill;
end;

procedure TMITDeleteSaleBill.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerDeleteBillIn(nData)^ do
  begin
    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);     //��������
  end;
end;

procedure TMITDeleteSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerDeleteBillIn(nData)^ do
  begin
    PackerDecode(Values['DELIVERYORDERNO'], FDELIVERYORDERNO);      //��������
  end;
end;

//-------------------------------------------------------------------------
class function TMITPickSaleBill.PackerName:string;
begin
     Result := sSAP_PickSaleBill;
end;


procedure TMITPickSaleBill.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPickBillIn(nData)^ do
  begin
    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);                //��������
    Values['AMOUNT']          := PackerEncode(FAMOUNT);                         //��������
    Values['TYPE']            := PackerEncode(FTYPE);                           //��ɢ��ʶ
    Values['PValue']          := PackerEncode(FPValue);                         //Ƥ��
    Values['MValue']          := PackerEncode(FMValue);                         //ë��
  end;
end;

procedure TMITPickSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPickBillIn(nData)^ do
  begin
    PackerDecode(Values['DELIVERYORDERNO'], FDELIVERYORDERNO);                  //��������
    PackerDecode(Values['AMOUNT'], FAMOUNT);                                    //��������
    PackerDecode(Values['TYPE'] ,FTYPE);                                        //��ɢ��ʶ
    PackerDecode(Values['PValue'] ,FPValue);                                    //Ƥ��
    PackerDecode(Values['MValue'] ,FMValue);                                    //ë��
  end;
end;

procedure TMITPickSaleBill.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPickBillOut(nData)^ do
  begin
    Values['DATE'] := PackerEncode(FDATE);                           //������������(YYYY-MM-DD)
    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);     //��������
    Values['NUMBER'] := PackerEncode(FNUMBER);                       //��������
  end;
end;

procedure TMITPickSaleBill.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPickBillOut(nData)^ do
  begin
    PackerDecode(Values['DATE'], FDATE);                                        //������������(YYYY-MM-DD)
    PackerDecode(Values['DELIVERYORDERNO'], FDELIVERYORDERNO);                  //��������
    PackerDecode(Values['NUMBER'], FNUMBER);                                    //��������
  end;
end;

//-------------------------------------------------------------------------
class function TMITPostSaleBill.PackerName:string;
begin
     Result := sSAP_PostSaleBill;
end;


procedure TMITPostSaleBill.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPostBillIn(nData)^ do
  begin
    //Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);     //��������
      Values['DATA']         :=       PackerEncode(FDATA);                 //��������
  end;
end;

procedure TMITPostSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPostBillIn(nData)^ do
  begin
   // PackerDecode(Values['DELIVERYORDERNO'], FDELIVERYORDERNO);       //��������
    PackerDecode(Values['DATA'], FDATA);                           //������
  end;
end;

procedure TMITPostSaleBill.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPostBillOut(nData)^ do
  begin
    Values['DATA']         :=       PackerEncode(FDATA);                 //��������
   // Values['OUTBOUNDORDERNO'] := PackerEncode(FOUTBOUNDORDERNO);      //���ⵥ��
   // Values['MSGTXT']          := PackerEncode(FMSGTXT);              //������
  end;
end;

procedure TMITPostSaleBill.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPostBillOut(nData)^ do
  begin
    PackerDecode(Values['DATA'], FDATA);                         //������
    //PackerDecode(Values['OUTBOUNDORDERNO'], FOUTBOUNDORDERNO);       //���ⵥ��
    //PackerDecode(Values['MSGTXT'], FMSGTXT);                         //������
  end;
end;

//---------------------------------------------------------------------------
class function TMITDiaozhangSaleBill.PackerName:string;
begin
     Result := sSAP_TiaoZSaleBill;
end;


procedure TMITDiaozhangSaleBill.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerDiaozhangBillIn(nData)^ do
  begin
    Values['ODELIVERYNO']   := PackerEncode(FODELIVERYNO);                      //��������(��)
    Values['ORDERNO']       := PackerEncode(FORDERNO);                          //������(��)
    Values['TZDELIVERYNO']  := PackerEncode(FTZDELIVERYNO);                    //��������(���ֽ�����)
    Values['DELIVERYNO']    := PackerEncode(FDELIVERYNO);                       //��������
    Values['DELIVERLISTNO'] := PackerEncode(FDELIVERLISTNO);                    //�������ί�е���
    Values['PRODUCTCODE']   := PackerEncode(FPRODUCTCODE);                      //��Ʒ���
    Values['PRODUCTNAME']   := PackerEncode(FPRODUCTNAME);                      //��Ʒ����
    Values['CUSTOMCODE']    := PackerEncode(FCUSTOMCODE);                       //�ͻ����
    Values['CUSTOMNAME']    := PackerEncode(FCUSTOMNAME);                       //�ͻ�����
  end;
end;

procedure TMITDiaozhangSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerDiaozhangBillIn(nData)^ do
  begin
    PackerDecode(Values['ODELIVERYNO'], FODELIVERYNO);                          //��������
    PackerDecode(Values['ORDERNO'], FORDERNO);                                  //������(��)
    PackerDecode(Values['TZDELIVERYNO'],FTZDELIVERYNO);                         //��������(���ֽ�����)
    PackerDecode(Values['DELIVERYNO'], FDELIVERYNO);                            //��������
    PackerDecode(Values['DELIVERLISTNO'], FDELIVERLISTNO);                      //�������ί�е���
    PackerDecode(Values['PRODUCTCODE'], FPRODUCTCODE);                          //��Ʒ���
    PackerDecode(Values['PRODUCTNAME'], FPRODUCTNAME);                          //��Ʒ����
    PackerDecode(Values['CUSTOMCODE'], FCUSTOMCODE);                            //�ͻ����
    PackerDecode(Values['CUSTOMNAME'], FCUSTOMNAME);                            //�ͻ�����
  end;
end;

procedure TMITDiaozhangSaleBill.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusOut(nData)^ do
  begin
    Values['DATA']         :=       PackerEncode(FDATA);                        //������
  end;
end;

procedure TMITDiaozhangSaleBill.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusOut(nData)^ do
  begin
    PackerDecode(Values['DATA'], FDATA);                                        //������
  end;
end;



//---------------------------------------------------------------------------
class function TMITTiaoZROrderForCus.PackerName:string;
begin
     Result := sSAP_TiaoZROrder;
end;


procedure TMITTiaoZROrderForCus.DoPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusin(nData)^ do
  begin
    Values['CUSTOMCODE'] := PackerEncode(FCUSTOMCODE);                          //�ͻ����
    Values['CUSTOMNAME'] := PackerEncode(FCUSTOMNAME);                          //�ͻ�����
  end;
end;

procedure TMITTiaoZROrderForCus.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusin(nData)^ do
  begin
    PackerDecode(Values['CUSTOMCODE'], FCUSTOMCODE);                            //�ͻ����
    PackerDecode(Values['CUSTOMNAME'], FCUSTOMNAME);                            //�ͻ�����
  end;
end;

procedure TMITTiaoZROrderForCus.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusOut(nData)^ do
  begin
    Values['DATA']         :=       PackerEncode(FDATA);                        //������
  end;
end;

procedure TMITTiaoZROrderForCus.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusOut(nData)^ do
  begin
    PackerDecode(Values['DATA'], FDATA);                                        //������
  end;
end;


//------------------------------------------------------------------------------
initialization
  gBusinessPackerManager.RegistePacker(TMITQueryField, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITBusinessCommand, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITReaddXSSaleOrder, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITReaddCRMOrder, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITCreateSaleBill, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITModifySaleBill, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITDeleteSaleBill, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITPickSaleBill, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITPostSaleBill, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITDiaozhangSaleBill, sPlug_ModuleBus);
  gBusinessPackerManager.RegistePacker(TMITTiaoZROrderForCus, sPlug_ModuleBus);
end.

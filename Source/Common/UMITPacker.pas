{*******************************************************************************
  作者: dmzn@163.com 2011-10-22
  描述: 中间件业务数据封包对象
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
  //读取销售订单

  TMITReaddCRMOrder = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //读取电子提货委托单

  TMITCreateSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //交货单创建

  TMITModifySaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //交货单修改

  TMITDeleteSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //交货单删除

  TMITPickSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //交货单拣配

  TMITPostSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //交货单确认

  TMITDiaozhangSaleBill = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //交货单调帐

  TMITTiaoZROrderForCus = class(TMITPackerBase)
  protected
    procedure DoPackIn(const nData: Pointer); override;
    procedure DoUnPackIn(const nData: Pointer); override;
    procedure DoPackOut(const nData: Pointer); override;
    procedure DoUnPackOut(const nData: Pointer); override;
  public
    class function PackerName: string; override;
  end;
  //读取客户相关列表交货单调账

implementation

//Date: 2012-3-7
//Parm: 参数数据
//Desc: 对输入数据nData打包处理
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
//Parm: 字符数据
//Desc: 对nStr拆包处理
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
//Parm: 结构数据
//Desc: 对结构数据nData打包处理
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
//Parm: 字符数据
//Desc: 对nStr拆包处理
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
    Values['ORDERCODE'] := PackerEncode(FORDERCODE);      //销售订单号
    Values['ORDERTYPE'] := PackerEncode(FORDERTYPE);      //销售订单类型
    Values['STATUS'] := PackerEncode(FSTATUS);            //订单状态
    Values['BUYPARTCODE'] := PackerEncode(FBUYPARTCODE);   //购买单位编码
    Values['BUYPARTNAME'] := PackerEncode(FBUYPARTNAME);    //购买单位名称
    Values['RECEIVEPART'] := PackerEncode(FRECEIVEPART);   //收货单位
    Values['DISPATCHINGCODE'] := PackerEncode(FDISPATCHINGCODE); //配送商编号
    Values['PRODUCTCODE'] := PackerEncode(FPRODUCTCODE);          //产品代码
    Values['PRODUCTNAME'] := PackerEncode(FPRODUCTNAME);           //产品名称
    Values['STANDARD'] := PackerEncode(FSTANDARD);                 //产品规格
    Values['UNIT'] := PackerEncode(FUNIT);                          //单位
    Values['FACTORYPRICE'] := FloatToStr(FFACTORYPRICE);           //出厂价
    Values['TOTALPRICE'] := FloatToStr(FTOTALPRICE);               //到位价
    Values['OUTAMOUNT'] := FloatToStr(FOUTAMOUNT);                 //已开数量
    Values['SURPLUSAMOUNT'] := FloatToStr(FSURPLUSAMOUNT);       //剩余数量
    Values['AMOUNT'] := FloatToStr(FAMOUNT);                   //可提数量
    Values['TRANSTYPE'] := PackerEncode(FTRANSTYPE);              //运输方式
    Values['TOTALMONEY'] := FloatToStr(FTOTALMONEY);            //总金额
    Values['CONTRACTNO'] := PackerEncode(FCONTRACTNO);            //合同编号
    Values['REGIONCODE'] := PackerEncode(FREGIONCODE);            //销售区域编号
    Values['REGIONNAME'] := PackerEncode(FREGIONNAME);             //销售区域名称
  end;
end;

procedure TMITReaddXSSaleOrder.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PReadXSSaleOrderOut(nData)^ do
  begin
    PackerDecode(Values['ORDERCODE'], FORDERCODE);        //销售订单号
    PackerDecode(Values['ORDERTYPE'],FORDERTYPE);        //销售订单类型
    PackerDecode(Values['STATUS'],FSTATUS);              //订单状态
    PackerDecode(Values['BUYPARTCODE'],FBUYPARTCODE);    //购买单位编码
    PackerDecode(Values['BUYPARTNAME'],FBUYPARTNAME);    //购买单位名称
    PackerDecode(Values['RECEIVEPART'],FRECEIVEPART);   //收货单位
    PackerDecode(Values['DISPATCHINGCODE'],FDISPATCHINGCODE); //配送商编号
    PackerDecode(Values['PRODUCTCODE'],FPRODUCTCODE);          //产品代码
    PackerDecode(Values['PRODUCTNAME'],FPRODUCTNAME);           //产品名称
    PackerDecode(Values['STANDARD'],FSTANDARD);                 //产品规格
    PackerDecode(Values['UNIT'] ,FUNIT);                          //单位
    PackerDecode(Values['FACTORYPRICE'] ,FFACTORYPRICE);           //出厂价
    PackerDecode(Values['TOTALPRICE'] ,FTOTALPRICE);               //到位价
    PackerDecode(Values['OUTAMOUNT'] ,FOUTAMOUNT);                 //已开数量
    PackerDecode(Values['SURPLUSAMOUNT'] ,FSURPLUSAMOUNT);       //剩余数量
    PackerDecode(Values['AMOUNT'] ,FAMOUNT);                   //可提数量
    PackerDecode(Values['TRANSTYPE'],FTRANSTYPE);              //运输方式
    PackerDecode(Values['TOTALMONEY'],FTOTALMONEY);            //总金额
    PackerDecode(Values['CONTRACTNO'],FCONTRACTNO);            //合同编号
    PackerDecode(Values['REGIONCODE'],FREGIONCODE);          //销售区域编号
    PackerDecode(Values['REGIONNAME'],FREGIONNAME);          //销售区域名称
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
    Values['REGIONCODE'] := PackerEncode(FREGIONCODE);                          //销售区域编号
    Values['REGIONNAME'] := PackerEncode(FREGIONNAME);                          //销售区域名称
    Values['DRIVERNAME'] := PackerEncode(FDRIVERNAME);                          //司机姓名
    Values['NONUMBER'] := PackerEncode(FNONUMBER);                          //证件号码
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
    PackerDecode(Values['REGIONCODE'],FREGIONCODE);                             //销售区域编号
    PackerDecode(Values['REGIONNAME'],FREGIONNAME);                             //销售区域名称
    PackerDecode(Values['DRIVERNAME'],FDRIVERNAME);                             //司机姓名
    PackerDecode(Values['NONUMBER'],FNONUMBER);                                 //证件号码
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
    Values['FType'] := PackerEncode(FFType);                        //类型(销售,CRM)
    Values['FOrder'] := PackerEncode(FFOrder);                      //读取订单内容

    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);    //交货单号
    Values['AMOUNT'] := FloatToStr(FAMOUNT);                        //交货数量
    Values['DELIVERYNUMBER'] := PackerEncode(FDELIVERYNUMBER);      //车牌号
    Values['PRODUCTCODE'] := PackerEncode(FPRODUCTCODE);            //产品代码
    Values['PRODUCTNAME'] := PackerEncode(FPRODUCTNAME);            //产品名称
    Values['BUYPARTCODE'] := PackerEncode(FBUYPARTCODE);            //购买单位编号
    Values['BUYPARTNAME'] := PackerEncode(FBUYPARTNAME);            //购买单位名称
    Values['ORDERNO'] := PackerEncode(FORDERNO);
    Values['DELIVERLISYNO'] := PackerEncode(FDELIVERLISYNO);        //提货委托单编号
    Values['CREATEDATE'] := PackerEncode(FCREATEDATE);              //创建时间
    Values['CREATEUSER'] := PackerEncode(FCREATEUSER);              //创建人
    Values['REVEIVENAME'] := PackerEncode(FREVEIVENAME);            //创建时间
    Values['CREATEUSER'] := PackerEncode(FCREATEUSER);              //收货方名称
    Values['DRIVERNAME'] := PackerEncode(FDRIVERNAME);              //司机名称
    Values['MEASUREMENTUNIT'] := PackerEncode(FMEASUREMENTUNIT);    //计量单位
    Values['TELEPHONE'] := PackerEncode(FTELEPHONE);                //联系电话
    Values['TRANSTYPE'] := PackerEncode(FTRANSTYPE);                //运输方式
    Values['REGIONCODE'] := PackerEncode(FREGIONCODE);              //区域
    Values['REGIONTEXT'] := PackerEncode(FREGIONTEXT);              //区域名称
    Values['CHANNELTYPE'] := PackerEncode(FCHANNELTYPE);            //提货通道
    Values['TRUCKNAME'] := PackerEncode(FTRUCKNAME);                //司机姓名
    Values['TRUCKTEL']  := PackerEncode(FTRUCKTEL);                 //司机电话
    Values['SEALATEXT']  := PackerEncode(FSEALATEXT);               //封签编号
    Values['TOTALPRICE'] := FloatToStr(FTOTALPRICE);                //到位价
    Values['NONUMBER'] := PackerEncode(FNONUMBER);                 //证件号码
  end;
end;

procedure TMITCreateSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerCreateBillIn(nData)^ do
  begin
   PackerDecode(Values['FType'],FFType);                         //类型(销售,CRM)
   PackerDecode(Values['FOrder'],FFOrder);                       //读取订单内容

   PackerDecode(Values['DELIVERYORDERNO'],FDELIVERYORDERNO);     //交货单号
   PackerDecode(Values['AMOUNT'],FAMOUNT);                       //交货数量
   PackerDecode(Values['DELIVERYNUMBER'] ,FDELIVERYNUMBER);      //车牌号
   PackerDecode(Values['PRODUCTCODE'] ,FPRODUCTCODE);            //产品代码
   PackerDecode(Values['PRODUCTNAME'] ,FPRODUCTNAME);            //产品名称
   PackerDecode(Values['BUYPARTCODE'] ,FBUYPARTCODE);            //购买单位编号
   PackerDecode(Values['BUYPARTNAME'] ,FBUYPARTNAME);            //购买单位名称
   PackerDecode(Values['ORDERNO'] ,FORDERNO);                    //
   PackerDecode(Values['DELIVERLISYNO'] ,FDELIVERLISYNO);        //提货委托单编号
   PackerDecode(Values['CREATEDATE'] ,FCREATEDATE);              //创建时间
   PackerDecode(Values['CREATEUSER'] ,FCREATEUSER);              //创建人
   PackerDecode(Values['REVEIVENAME'] ,FREVEIVENAME);            //创建时间
   PackerDecode(Values['CREATEUSER'] ,FCREATEUSER);              //收货方名称
   PackerDecode(Values['DRIVERNAME'],FDRIVERNAME);               //司机名称
   PackerDecode(Values['MEASUREMENTUNIT'] ,FMEASUREMENTUNIT);    //计量单位
   PackerDecode(Values['TELEPHONE'] ,FTELEPHONE);                //联系电话
   PackerDecode(Values['TRANSTYPE'] ,FTRANSTYPE);                //运输方式
   PackerDecode(Values['REGIONCODE'],FREGIONCODE);               //区域
   PackerDecode(Values['REGIONTEXT'],FREGIONTEXT);               //区域名称
   PackerDecode(Values['CHANNELTYPE'],FCHANNELTYPE);             //提货通道
   PackerDecode(Values['TRUCKNAME'],FTRUCKNAME);                 //司机姓名
   PackerDecode(Values['TRUCKTEL'],FTRUCKTEL);                   //司机电话
   PackerDecode(Values['SEALATEXT'],FSEALATEXT);                 //封签编号
   PackerDecode(Values['TOTALPRICE'],FTOTALPRICE);               //到位价
   PackerDecode(Values['NONUMBER'],FNONUMBER);                   //证件号码
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
    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);       //交货单号
    Values['AMOUNT']          := PackerEncode(FAMOUNT);                //交货数量
    Values['DELIVERYNUMBER']  := PackerEncode(FDELIVERYNUMBER);        //车牌号
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
    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);     //交货单号
  end;
end;

procedure TMITDeleteSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerDeleteBillIn(nData)^ do
  begin
    PackerDecode(Values['DELIVERYORDERNO'], FDELIVERYORDERNO);      //交货单号
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
    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);                //交货单号
    Values['AMOUNT']          := PackerEncode(FAMOUNT);                         //交货数量
    Values['TYPE']            := PackerEncode(FTYPE);                           //袋散标识
    Values['PValue']          := PackerEncode(FPValue);                         //皮重
    Values['MValue']          := PackerEncode(FMValue);                         //毛重
  end;
end;

procedure TMITPickSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPickBillIn(nData)^ do
  begin
    PackerDecode(Values['DELIVERYORDERNO'], FDELIVERYORDERNO);                  //交货单号
    PackerDecode(Values['AMOUNT'], FAMOUNT);                                    //交货数量
    PackerDecode(Values['TYPE'] ,FTYPE);                                        //袋散标识
    PackerDecode(Values['PValue'] ,FPValue);                                    //皮重
    PackerDecode(Values['MValue'] ,FMValue);                                    //毛重
  end;
end;

procedure TMITPickSaleBill.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPickBillOut(nData)^ do
  begin
    Values['DATE'] := PackerEncode(FDATE);                           //交货拣配日期(YYYY-MM-DD)
    Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);     //交货单号
    Values['NUMBER'] := PackerEncode(FNUMBER);                       //交货数量
  end;
end;

procedure TMITPickSaleBill.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPickBillOut(nData)^ do
  begin
    PackerDecode(Values['DATE'], FDATE);                                        //交货拣配日期(YYYY-MM-DD)
    PackerDecode(Values['DELIVERYORDERNO'], FDELIVERYORDERNO);                  //交货单号
    PackerDecode(Values['NUMBER'], FNUMBER);                                    //交货数量
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
    //Values['DELIVERYORDERNO'] := PackerEncode(FDELIVERYORDERNO);     //交货单号
      Values['DATA']         :=       PackerEncode(FDATA);                 //过账数据
  end;
end;

procedure TMITPostSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPostBillIn(nData)^ do
  begin
   // PackerDecode(Values['DELIVERYORDERNO'], FDELIVERYORDERNO);       //交货单号
    PackerDecode(Values['DATA'], FDATA);                           //处理结果
  end;
end;

procedure TMITPostSaleBill.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPostBillOut(nData)^ do
  begin
    Values['DATA']         :=       PackerEncode(FDATA);                 //过账数据
   // Values['OUTBOUNDORDERNO'] := PackerEncode(FOUTBOUNDORDERNO);      //出库单号
   // Values['MSGTXT']          := PackerEncode(FMSGTXT);              //处理结果
  end;
end;

procedure TMITPostSaleBill.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerPostBillOut(nData)^ do
  begin
    PackerDecode(Values['DATA'], FDATA);                         //处理结果
    //PackerDecode(Values['OUTBOUNDORDERNO'], FOUTBOUNDORDERNO);       //出库单号
    //PackerDecode(Values['MSGTXT'], FMSGTXT);                         //处理结果
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
    Values['ODELIVERYNO']   := PackerEncode(FODELIVERYNO);                      //交货单号(新)
    Values['ORDERNO']       := PackerEncode(FORDERNO);                          //订单号(新)
    Values['TZDELIVERYNO']  := PackerEncode(FTZDELIVERYNO);                    //交货单号(红字交货单)
    Values['DELIVERYNO']    := PackerEncode(FDELIVERYNO);                       //交货单号
    Values['DELIVERLISTNO'] := PackerEncode(FDELIVERLISTNO);                    //电子提货委托单号
    Values['PRODUCTCODE']   := PackerEncode(FPRODUCTCODE);                      //产品编号
    Values['PRODUCTNAME']   := PackerEncode(FPRODUCTNAME);                      //产品名称
    Values['CUSTOMCODE']    := PackerEncode(FCUSTOMCODE);                       //客户编号
    Values['CUSTOMNAME']    := PackerEncode(FCUSTOMNAME);                       //客户名称
  end;
end;

procedure TMITDiaozhangSaleBill.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerDiaozhangBillIn(nData)^ do
  begin
    PackerDecode(Values['ODELIVERYNO'], FODELIVERYNO);                          //交货单号
    PackerDecode(Values['ORDERNO'], FORDERNO);                                  //订单号(新)
    PackerDecode(Values['TZDELIVERYNO'],FTZDELIVERYNO);                         //交货单号(红字交货单)
    PackerDecode(Values['DELIVERYNO'], FDELIVERYNO);                            //交货单号
    PackerDecode(Values['DELIVERLISTNO'], FDELIVERLISTNO);                      //电子提货委托单号
    PackerDecode(Values['PRODUCTCODE'], FPRODUCTCODE);                          //产品编号
    PackerDecode(Values['PRODUCTNAME'], FPRODUCTNAME);                          //产品名称
    PackerDecode(Values['CUSTOMCODE'], FCUSTOMCODE);                            //客户编号
    PackerDecode(Values['CUSTOMNAME'], FCUSTOMNAME);                            //客户名称
  end;
end;

procedure TMITDiaozhangSaleBill.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusOut(nData)^ do
  begin
    Values['DATA']         :=       PackerEncode(FDATA);                        //处理结果
  end;
end;

procedure TMITDiaozhangSaleBill.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusOut(nData)^ do
  begin
    PackerDecode(Values['DATA'], FDATA);                                        //处理结果
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
    Values['CUSTOMCODE'] := PackerEncode(FCUSTOMCODE);                          //客户编号
    Values['CUSTOMNAME'] := PackerEncode(FCUSTOMNAME);                          //客户名称
  end;
end;

procedure TMITTiaoZROrderForCus.DoUnPackIn(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusin(nData)^ do
  begin
    PackerDecode(Values['CUSTOMCODE'], FCUSTOMCODE);                            //客户编号
    PackerDecode(Values['CUSTOMNAME'], FCUSTOMNAME);                            //客户名称
  end;
end;

procedure TMITTiaoZROrderForCus.DoPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusOut(nData)^ do
  begin
    Values['DATA']         :=       PackerEncode(FDATA);                        //处理结果
  end;
end;

procedure TMITTiaoZROrderForCus.DoUnPackOut(const nData: Pointer);
begin
  inherited;

  with FStrBuilder,PWorkerROrderForCusOut(nData)^ do
  begin
    PackerDecode(Values['DATA'], FDATA);                                        //处理结果
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

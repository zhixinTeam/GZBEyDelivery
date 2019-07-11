{*******************************************************************************
  作者: dmzn@163.com 2012-02-03
  描述: 业务常量定义

  备注:
  *.所有In/Out数据,最好带有TBWDataBase基数据,且位于第一个元素.
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
  cBC_GetSerialNO             = $0001;   //获取串行编号
  cBC_ServerNow               = $0002;   //服务器当前时间
  cBC_IsSystemExpired         = $0003;   //系统是否已过期

  cBC_SaveTruckInfo           = $0013;   //保存车辆信息
  cBC_GetTruckPoundData       = $0015;   //获取车辆称重数据
  cBC_SaveTruckPoundData      = $0016;   //保存车辆称重数据

  cBC_SaveBills               = $0020;   //保存交货单列表
  cBC_DeleteBill              = $0021;   //删除交货单
  cBC_ModifyBillTruck         = $0022;   //修改车牌号
  cBC_SaleAdjust              = $0023;   //销售调拨
  cBC_SaveBillCard            = $0024;   //绑定交货单磁卡
  cBC_LogoffCard              = $0025;   //注销磁卡
  cBC_SaveTruckRFIDCard       = $0026;   //设定电子签
  cBC_DeleteTruckDocument     = $0027;   //删除车辆档案

  cBC_GetPostBills            = $0030;   //获取岗位交货单
  cBC_SavePostBills           = $0031;   //保存岗位交货单

  cBC_ChangeDispatchMode      = $0053;   //切换调度模式
  cBC_GetPoundCard            = $0054;   //获取磅站卡号
  cBC_GetQueueData            = $0055;   //获取队列数据
  cBC_PrintCode               = $0056;
  cBC_PrintFixCode            = $0057;   //喷码
  cBC_PrinterEnable           = $0058;   //喷码机启停

  cBC_JSStart                 = $0060;
  cBC_JSStop                  = $0061;
  cBC_JSPause                 = $0062;
  cBC_JSGetStatus             = $0063;
  cBC_SaveCountData           = $0064;   //保存计数结果
  cBC_RemoteExecSQL           = $0065;

  cBC_IsTunnelOK              = $0075;
  cBC_TunnelOC                = $0076;   //红绿灯控制
  cBC_PlayVoice               = $0077;   //播放语音

type
  PWorkerQueryFieldData = ^TWorkerQueryFieldData;
  TWorkerQueryFieldData = record
    FBase     : TBWDataBase;
    FType     : Integer;           //类型
    FData     : string;            //数据
  end;

  PWorkerBusinessCommand = ^TWorkerBusinessCommand;
  TWorkerBusinessCommand = record
    FBase     : TBWDataBase;
    FCommand  : Integer;           //命令
    FData     : string;            //数据
    FExtParam : string;            //参数
  end;

  TPoundStationData = record
    FStation  : string;            //磅站标识
    FValue    : Double;            //皮重
    FDate     : TDateTime;         //称重日期
    FOperator : string;            //操作员
  end;

  PLadingBillItem = ^TLadingBillItem;
  TLadingBillItem = record
    FID         : string;          //交货单号
    FZhiKa      : string;          //纸卡编号
    FCusID      : string;          //客户编号
    FCusName    : string;          //客户名称
    FTruck      : string;          //车牌号码

    FType       : string;          //品种类型
    FStockNo    : string;          //品种编号
    FStockName  : string;          //品种名称
    FValue      : Double;          //提货量
    FPrice      : Double;          //提货单价

    FCard       : string;          //磁卡号
    FIsVIP      : string;          //通道类型
    FStatus     : string;          //当前状态
    FNextStatus : string;          //下一状态

    FPData      : TPoundStationData; //称皮
    FMData      : TPoundStationData; //称毛
    FFactory    : string;          //工厂编号
    FPModel     : string;          //称重模式
    FPType      : string;          //业务类型
    FPoundID    : string;          //称重记录
    FSelected   : Boolean;         //选中状态
  end;

  TLadingBillItems = array of TLadingBillItem;
  //交货单列表

  PReadXSSaleOrderIn = ^TReadXSSaleOrderIn;
  TReadXSSaleOrderIn = record
    FBase  : TBWDataBase;          //基础数据
    FORDERCODE : string;           //销售订单号
  end;

  PReadXSSaleOrderOut = ^TReadXSSaleOrderOut;
  TReadXSSaleOrderOut = record
    FBase     : TBWDataBase;
    FORDERCODE    : string;             //销售订单号
    FORDERTYPE    : string;             //销售订单类型
    FSTATUS       : string;             //订单状态
    FBUYPARTCODE  : string;             //购买单位编号
    FBUYPARTNAME  : string;             //购买单位名称
    FRECEIVEPART : string;              //收货单位
    FDISPATCHINGCODE  : string;         //配送商编号
    FPRODUCTCODE   : string;            //产品代码
    FPRODUCTNAME   : string;            //产品名称
    FSTANDARD      : string;            //产品规格
    FUNIT          : string;            //单位
    FFACTORYPRICE  : Double;            //出厂价
    FTOTALPRICE    : Double;            //到位价
    FOUTAMOUNT     : Double;            //已开数量
    FSURPLUSAMOUNT : Double;            //剩余数量
    FAMOUNT        : Double;            //可提数量
    FTRANSTYPE     : string;            //运输方式
    FTOTALMONEY    : Double;            //总金额
    FCONTRACTNO    : string;            //合同编号
    FREGIONCODE    : string;            //销售区域编号
    FREGIONNAME    : string;            //销售区域名称
  end;
  //销售订单

  PReadCRMOrderIn = ^TReadCRMOrderIn;
  TReadCRMOrderIn = record
    FBase       : TBWDataBase;       //基础数据
    FDELIVERNO  : string;           //委托单号
  end;

  PReadCrmOrderOut = ^TReadCrmOrderOut;
  TReadCrmOrderOut = record
    FBase           : TBWDataBase;
    FDELIVERLISTNO  : STRING;           //提货委托单编号
    FTRAVELNUMBER   : STRING;           //车船号
    FTELEPHONE:     STRING;             //联系电话
    FAMOUNT:        Double;             //提货数量 (委托单)
    FORDERNO:       string;             //订单编号
    FORDERTYPE:     string;             //订单类型
    FSTATUS:        string;             //订单状态
    FBUYPARTCODE  : string;             //购买单位编号
    FBUYPARTNAME:   string;             //购买单位名称
    FRECEIVEPART:   string;             //收货单位
    FPRODUCTCODE:   string;             //产品代码
    FPRODUCTNAME:   string;             //产品名称
    FUNIT:          string;             //单位
    FFACTORYPRICE  : Double;            //出厂价
    FTOTALPRICE    : Double;            //到位价
    FOUTAMOUNT     : Double;            //已开数量
    FSURPLUSAMOUNT : Double;            //剩余数量
    FTRANSTYPE     : string;            //运输方式
    FTOTALMONEY    : Double;            //总金额
    FCONTRACTNO    : string;            //合同编号
    FREGIONCODE    : string;            //销售区域编号
    FREGIONNAME    : string;            //销售区域名称
    FDRIVERNAME    : string;            //司机姓名
    FNONUMBER      : string;            //证件号码
  end;
  //电子提货委托单

  PWorkerCreateBillIn = ^TWorkerCreateBillIn;
  TWorkerCreateBillIn = record
    FBase                    : TBWDataBase;       //基础数据
    FFType                    : string;            //类型(销售,CRM)
    FFOrder                   : string;            //读取订单内容

    FDELIVERYORDERNO         : string;            //交货单号
    FAMOUNT                  : Double;            //交货数量
    FDELIVERYNUMBER          : string;            //车牌号
    FPRODUCTCODE             : string;            //产品代码
    FPRODUCTNAME             : string;            //产品名称
    FBUYPARTCODE             : string;            //购买单位
    FBUYPARTNAME             : string;            //购买单位名称
    FORDERNO                 : string;            //销售订单号
    FDELIVERLISYNO           : string;            //提货委托单编号
    FCREATEDATE              : TDateTime;         //创建时间
    FCREATEUSER              : string;            //创建人
    FREVEIVENAME             : string;            //收货方名称
    FDRIVERNAME              : string;            //司机名称
    FMEASUREMENTUNIT         : string;            //计量单位
    FTELEPHONE               : string;            //联系电话
    FTRANSTYPE               : string;            //运输方式
    FREGIONCODE              : string;            //区域
    FREGIONTEXT              : string;            //区域名称
    FCHANNELTYPE             : string;            //提货通道
    FTRUCKNAME               : string;            //司机姓名
    FTRUCKTEL                : string;            //司机电话
    FSEALATEXT               : string;            //封签编号
    FTOTALPRICE              : Double;            //到位价
    FNONUMBER                : string;            //证件号码
  end;
  //交货单创建

  PWorkerModfiyBillIn = ^TWorkerModfiyBillIn;
  TWorkerModfiyBillIn = record
    FBase                    : TBWDataBase;       //基础数据
    FDELIVERYORDERNO         : string;            //交货单号
    FAMOUNT                  : string;            //交货数量
    FDELIVERYNUMBER          : string;            //车牌号
  end;
  //交货单修改

  PWorkerDeleteBillIn = ^TWorkerDeleteBillIn;
  TWorkerDeleteBillIn  = record
    FBase                    : TBWDataBase;        //基础数据
    FDELIVERYORDERNO         : string;             //交货单号
  end;
 //交货单删除

  PWorkerPickBillIn = ^TWorkerPickBillIn;
  TWorkerPickBillIn  = record
    FBase                    : TBWDataBase;       //基础数据
    FDELIVERYORDERNO         : string;            //交货单号
    FAMOUNT                  : string;            //交货数量
    FTYPE                    : string;            //袋散标识
    FPValue                  : string;            //皮重
    FMValue                  : string;            //毛重
  end;

  PWorkerPickBillOut = ^TWorkerPickBillOut;
  TWorkerPickBillOut  = record
    FBase                : TBWDataBase;          //基础数据
    FDATE                : STRING;               //交货拣配日期(YYYY-MM-DD)
    FDELIVERYORDERNO     : string;               //交货单号
    FNUMBER              : string;               //交货数量
  end;
  //交货单拣配

  PWorkerPostBillIn = ^TWorkerPostBillIn;
  TWorkerPostBillIn  = record
    FBase                    : TBWDataBase;       //基础数据
    FDATA                    : string;            //过账数据
  end;

  PWorkerPostBillOut = ^TWorkerPostBillOut;
  TWorkerPostBillOut  = record
    FBase                : TBWDataBase;           //基础数据
    FDATA                : string;                //过账结果
  end;
  //交货单确认(批量)

  PWorkerDiaozhangBillIn = ^TWorkerDiaozhangBillIn;
  TWorkerDiaozhangBillIn = record
    FBase               : TBWDataBase;            //基础数据
    FODELIVERYNO        : string;                  //交货单号(旧)
    FDELIVERLISTNO      : string;                 //电子提货委托单号(旧)
    FORDERNO            : string;                 //订单号(新)
    FDELIVERYNO         : string;                 //交货单号(新)
    FTZDELIVERYNO       : string;                 //交货单号(红字交货单号)
    FCUSTOMCODE         : string;                 //客户编号
    FCUSTOMNAME         : string;                 //客户名称
    FPRODUCTCODE        : string;                 //产品编号
    FPRODUCTNAME        : string;                 //产品名称

  end;

  PWorkerDiaozhangBillOut = ^TWorkerDiaozhangBillOut;
  TWorkerDiaozhangBillOut = record
    FBase               : TBWDataBase;            //基础数据
    FDATA               : String;                 //返回数据
  end;
  //交货单调账

  PWorkerROrderForCusin = ^TWorkerROrderForCusin;
  TWorkerROrderForCusin = record
    FBase               : TBWDataBase;            //基础数据
    FCUSTOMCODE         : string;                 //客户编号
    FCUSTOMNAME         : string;                 //客户名称
  end;

  PWorkerROrderForCusOut = ^TWorkerROrderForCusOut;
  TWorkerROrderForCusOut = record
    FBase               : TBWDataBase;            //基础数据
    FDATA               : String;                 //返回数据
  end;
  //读取客户相关订单信息列表 for 交货单调账

  TWorkerXBoxURL = record
    FSAPName: string;              //函数名
    FXBoxURL: string;              //业务地址
    FXBoxParam: string;            //业务参数
    FEncodeURL: Boolean;           //加密地址
    FEncodeXML: Boolean;           //加密XML
  end;

  TWorkerXBoxURLs = array of TWorkerXBoxURL;
  //地址列表

var
  gXBoxURLs: TWorkerXBoxURLs;      //业务列表
  gXBoxURLInited: Integer = 0;     //是否初始化

procedure AnalyseBillItems(const nData: string; var nItems: TLadingBillItems);
//解析由业务对象返回的交货单数据
function CombineBillItmes(const nItems: TLadingBillItems): string;
//合并交货单数据为业务对象能处理的字符串

resourcestring
  {*PBWDataBase.FParam*}
  sParam_NoHintOnError        = 'NHE';                  //不提示错误

  {*plug module id*}
  sPlug_ModuleBus             = '{DF261765-48DC-411D-B6F2-0B37B14E014E}';
                                                        //业务模块
  sPlug_ModuleHD              = '{B584DCD6-40E5-413C-B9F3-6DD75AEF1C62}';
                                                        //硬件守护
                                                                                                   
  {*common function*}  
  sSys_BasePacker             = 'Sys_BasePacker';       //基本封包器

  {*sap mit function name*}
  sSAP_ReadXSSaleOrder        = 'Read_CRM_XSSaleOrder';   //销售订单
  sSAP_ReadCRMOrder           = 'Read_CRM_TrustOrder';    //电子提货委托单
  sSAP_CreateSaleBill         = 'Create_CRM_BillOrder';  //创建交货单
  sSAP_ModifySaleBill         = 'Modify_CRM_BillOrder';  //修改交货单
  sSAP_DeleteSaleBill         = 'Delete_CRM_BillOrder';  //删除交货单
  sSAP_PickSaleBill           = 'Pick_CRM_BillOrder';    //拣配交货单
  sSAP_PostSaleBill           = 'Post_CRM_BillOrder';    //过账交货单(确认)
  sSAP_TiaoZSaleBill          = 'Tiaoz_CRM_BillOrder';   //调账交货单
  sSAP_TiaoZROrder            = 'Tiaoz_CRM_ROrder';      //调账读取接口

  {*business mit function name*}
  sBus_ReadXSSaleOrder        = 'Bus_Read_XSSaleOrder'; //销售订单
  sBus_ReadCRMOrder           = 'Bus_Read_CRMOrder';    //电子提货委托单
  sBus_CreateSaleBill         = 'Bus_Create_SaleBill';  //创建交货单
  sBus_ModifySaleBill         = 'Bus_Modify_SaleBill';  //修改交货单
  sBus_DeleteSaleBill         = 'Bus_Delete_SaleBill';  //删除交货单
  sBus_PickSaleBill           = 'Bus_Pick_SaleBill';    //拣配交货单
  sBus_PostSaleBill           = 'Bus_Post_SaleBill';    //过账交货单(确认)
  sBus_TiaoZSaleBill          = 'Bus_TiaoZ_SaleBill';   //调账交货单
  sBus_TiaoZROrder            = 'Bus_TiaoZ_ROrderForCus'; //调账读取接口

  sBus_ServiceStatus          = 'Bus_ServiceStatus';    //服务状态
  sBus_GetQueryField          = 'Bus_GetQueryField';    //查询的字段

  sBus_BusinessSaleBill       = 'Bus_BusinessSaleBill'; //交货单相关
  sBus_BusinessCommand        = 'Bus_BusinessCommand';  //业务指令
  sBus_HardwareCommand        = 'Bus_HardwareCommand';  //硬件指令

  {*client function name*}
  sCLI_ReadXSSaleOrder        = 'CLI_Read_XSSaleOrder'; //销售订单
  sCLI_ReadCRMOrder           = 'CLI_Read_CRMOrder';    //电子提货委托单
  sCLI_CreateSaleBill         = 'CLI_Create_SaleBill';  //创建交货单
  sCLI_ModifySaleBill         = 'CLI_Modify_SaleBill';  //修改交货单
  sCLI_DeleteSaleBill         = 'CLI_Delete_SaleBill';  //删除交货单
  sCLI_PickSaleBill           = 'CLI_Pick_SaleBill';    //拣配交货单
  sCLI_PostSaleBill           = 'CLI_Post_SaleBill';    //过账交货单 (确认)
  sCLI_TiaoZSaleBill          = 'CLI_TiaoZ_SaleBill';   //调账交货单
  sCLI_ROrderForCus           = 'CLI_TiaoZ_ROrderForCus';   //调账读取接口

  sCLI_ServiceStatus          = 'CLI_ServiceStatus';    //服务状态
  sCLI_GetQueryField          = 'CLI_GetQueryField';    //查询的字段

  sCLI_BusinessSaleBill       = 'CLI_BusinessSaleBill'; //交货单业务
  sCLI_BusinessCommand        = 'CLI_BusinessCommand';  //业务指令
  sCLI_HardwareCommand        = 'CLI_HardwareCommand';  //硬件指令

implementation

//Date: 2014-09-17
//Parm: 交货单数据;解析结果
//Desc: 解析nData为结构化列表数据
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
//Parm: 交货单列表
//Desc: 将nItems合并为业务对象能处理的
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



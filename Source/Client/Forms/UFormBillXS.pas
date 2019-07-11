{*******************************************************************************
  作者: dmzn@163.com 2012-3-14
  描述: 创建销售订单
*******************************************************************************}
unit UFormBillXS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UBusinessConst, UFormNormal, cxGraphics, cxControls, 
  cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel, cxMaskEdit,
  cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  cxTextEdit, dxLayoutControl, StdCtrls, cxLookAndFeels, cxCheckBox,
  cxRadioGroup;

type
  TfFormNewXSBill = class(TfFormNormal)
    EditReCode: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditPartCode: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    EditPartName: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditPCode: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    EditdRegCode: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    cxTextEdit12: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    cxTextEdit13: TcxTextEdit;
    dxLayout1Item15: TdxLayoutItem;
    cxTextEdit14: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    cxTextEdit15: TcxTextEdit;
    dxLayout1Item17: TdxLayoutItem;
    EditNum: TcxTextEdit;
    dxLayout1Item18: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item19: TdxLayoutItem;
    EditPName: TcxTextEdit;
    dxLayout1Item23: TdxLayoutItem;
    dxLayout1Group8: TdxLayoutGroup;
    cxLabel1: TcxLabel;
    dxLayout1Item27: TdxLayoutItem;
    dxLayout1Group12: TdxLayoutGroup;
    dxLayout1Group14: TdxLayoutGroup;
    dxLayout1Item28: TdxLayoutItem;
    EditSeal: TcxTextEdit;
    dxLayout1Group15: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    EditType: TcxComboBox;
    dxlytmLayout1Item6: TdxLayoutItem;
    EditTruckType: TcxTextEdit;
    dxlytmLayout1Item7: TdxLayoutItem;
    cxTextEdit9: TcxTextEdit;
    dxlytmLayout1Item8: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    EditTruckName: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditTelNo: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditdRegName: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group10: TdxLayoutGroup;
    EditNumber: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditNumKeyPress(Sender: TObject; var Key: Char);
    procedure EditTruckKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FMsgNo: Cardinal;
    FNTYPE:  string;
    FNum:string;                                                            //判定是销售还是CRM
    FXSOut: PReadXSSaleOrderOut;
    FCRMOut: PReadCRMOrderOut;
    FIn: TWorkerCreateBillIn;
    FOut: TWorkerCreateBillIn;
    //参数
    procedure InitFormData(const nOrder: PReadXSSaleOrderOut);
    procedure InitFormDataCRM(const nOrder: PReadCRMOrderOut);
    //初始化界面
    procedure SetEditText(const nFlag, nText: string);
    //设置文本
  public
    { Public declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  ULibFun, UMgrControl, UFormWait, UFormBase, UBusinessWorker, UBusinessPacker,
  UDataModule, UMgrLookupAdapter, USysBusiness, USysConst, USysDB,UAdjustForm,
  UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFormNewXSBill.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

class function TfFormNewXSBill.FormID: integer;
begin
  Result := cFI_FormNewXSBill;
end;

class function TfFormNewXSBill.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  nP := nParam;


  with TfFormNewXSBill.Create(Application) do
  try

    FNum :=  GetSerialNo(sFlag_BusGroup,sFlag_BillNo,False);

    AdjustCtrlData(EditType);

    EditType.ItemIndex := 0;
    FXSOut := Pointer(Integer(nP.FParamA));
    InitFormData(FXSOut);
    //xxxxx

    FCRMOut := Pointer(Integer(nP.FParamB));
    if (FCRMOut.FTRAVELNUMBER <> '') and (FloatToStr(FCRMOut.FAMOUNT) <> '') then
    begin
    InitFormDataCRM(FCRMOut);
    end;
    //xxxxx

    nP.FCommand := cCmd_ModalResult;
    nP.FParamA := ShowModal;
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2012-03-12
//Parm: 标识;标题
//Desc: 设置标识为nFlag的文本为nText
procedure TfFormNewXSBill.SetEditText(const nFlag, nText: string);
var nIdx: Integer;
begin
  for nIdx:=dxLayout1.ControlCount - 1 downto 0 do
  if (dxLayout1.Controls[nIdx] is TcxTextEdit) and
     (TcxTextEdit(dxLayout1.Controls[nIdx]).Hint = nFlag) then
  begin
    TcxTextEdit(dxLayout1.Controls[nIdx]).Text := nText;
    Break;
  end;
end;

procedure TfFormNewXSBill.EditNumKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if Sender = EditSeal then
         ActiveControl := BtnOK
    else SwitchFocusCtrl(Self, True);
  end;
end;

procedure TfFormNewXSBill.EditTruckKeyPress(Sender: TObject; var Key: Char);
var nP: TFormCommandParam;
begin
  if Key = #32 then
  begin
    Key := #0;
    nP.FParamA := EditTruck.Text;
    CreateBaseFormItem(cFI_FormGetTruck, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and(nP.FParamA = mrOk) then
      EditTruck.Text := nP.FParamB;
    EditTruck.SelectAll;
  end;

  if Key = #13 then
  begin
    Key := #0;
    SwitchFocusCtrl(Self, True);
  end;
end;

procedure TfFormNewXSBill.InitFormData(const nOrder: PReadXSSaleOrderOut);
begin
  EditNum.Text := '';
  ActiveControl := EditNum;

  FNTYPE := sFlag_XS;
  //order type

  with nOrder^ do
  begin
    SetEditText('D.1',  FBUYPARTCODE);
    SetEditText('D.2',  FBUYPARTNAME);
    SetEditText('D.3',  FRECEIVEPART);
    SetEditText('D.4',  FRECEIVEPART);
    SetEditText('D.5',  FPRODUCTCODE);
    SetEditText('D.6',  FPRODUCTNAME);
    SetEditText('D.7',  FREGIONCODE);
    SetEditText('D.19', FREGIONNAME);
    SetEditText('D.8',  TransTypeToStr(FTRANSTYPE));
    SetEditText('D.9',  FCONTRACTNO);
    SetEditText('D.10', FloatToStr(FAMOUNT));
    SetEditText('D.11', FloatToStr(FSURPLUSAMOUNT));
    SetEditText('D.12', FloatToStr(FOUTAMOUNT));
    SetEditText('D.13', FloatToStr(FSURPLUSAMOUNT));
  end;
end;

procedure TfFormNewXSBill.InitFormDataCRM(const nOrder: PReadCRMOrderOut);
begin

  EditNum.Text := '';
  ActiveControl := EditNum;

  FNTYPE := sFlag_CRM;
  //order type
  
  with nOrder^ do
  begin
    SetEditText('D.1',  FBUYPARTCODE);
    SetEditText('D.2',  FBUYPARTNAME);
    SetEditText('D.3',  FRECEIVEPART);
    SetEditText('D.4',  FRECEIVEPART);
    SetEditText('D.5',  FPRODUCTCODE);
    SetEditText('D.6',  FPRODUCTNAME);
    SetEditText('D.7',  FREGIONCODE);
    SetEditText('D.19', FREGIONNAME);
    SetEditText('D.8',  TransTypeToStr(FTRANSTYPE));
    SetEditText('D.9',  FCONTRACTNO);
    SetEditText('D.10', FloatToStr(FAMOUNT));
    SetEditText('D.11', FloatToStr(FSURPLUSAMOUNT));
    SetEditText('D.12', FloatToStr(FOUTAMOUNT));
    SetEditText('D.13', FloatToStr(FSURPLUSAMOUNT));
    SetEditText('D.14', FTRAVELNUMBER);
    SetEditText('D.15', FloatToStr(FAMOUNT));
    SetEditText('D.17', FDRIVERNAME);
    SetEditText('D.18', FTELEPHONE);
    SetEditText('D.19', FNONUMBER);
  end;


  EditNum.Properties.ReadOnly := True;
  //EditTruck.Properties.ReadOnly := True;
  EditTelNo.Properties.ReadOnly := True;
  EditTruckName.Properties.ReadOnly := True;
  EditNumber.Properties.ReadOnly := True;
end;

function TfFormNewXSBill.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
var nVal: Double;
    nStr: string;
begin
  Result := True;

  if Sender = EditNum then
  begin
    Result := IsNumber(EditNum.Text, True);
    nHint := MLang('办理吨数为数值型');
    if not Result then Exit;

    nVal := StrToFloat(EditNum.Text);
    nVal := Float2Float(nVal, cThousand, False);

    Result := nVal > 0;
    nHint := MLang('办理吨数为大于0的值');
    if not Result then Exit;

    EditNum.Text := FloatToStr(nVal);
    Result := FloatRelation(StrToFloat(cxTextEdit15.Text), nVal, rtGE);
    nHint := MLang('已超出可用量');
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    Result := Length(EditTruck.Text) >= 3;
    nHint := MLang('车牌号应三位以上');

    nStr := 'Select T_Type,T_InFact,T_Bill From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, EditTruck.Text, sFlag_San]);

    with FDM.QueryTemp(nStr) do
    if (RecordCount > 0) and (Fields[0].AsString = 'D') and (Fields[1].AsString = '') then
    begin
      nStr := '车号[%s]已开交货单[%s],需要合单吗?' +
               #13#10#13#10 +
              '确定请点''是'',否则请点''否''.';
      nStr := MLang(nStr);
      nStr := Format(nStr, [EditTruck.Text,Fields[2].AsString]);
      if not QueryDlg(nStr, MLang(sAsk)) then
      begin
        Result := False;
        nHint := MLang('用户取消开单');;
      end;
    end else if (RecordCount > 0) and (Fields[0].AsString = 'S') and (Fields[1].AsString = '')  THEN
    begin
      nStr := '车号[%s]已开交货单[%s]' +
               #13#10#13#10 +
              '散装不允许合单';
      nStr := MLang(nStr);
      nStr := Format(nStr, [EditTruck.Text,Fields[2].AsString]);
      ShowDlg(nStr, MLang(sHint));
      Result := False;
      nHint := MLang('用户取消开单');
    end;
  end;
end;

//Desc: 创建新单
procedure TfFormNewXSBill.BtnOKClick(Sender: TObject);
var nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
    nLang : string;
begin
  if not IsDataValid then Exit;
  nWorker := nil;
  nPacker := nil;

  BtnOK.Enabled := False;
  try
  //xxxx
  if POS('.',EditNum.Text)>0 then

    nLang := MLang('生成发货单');
    ShowWaitForm(Self, nLang);

    with FIn do
    begin

      IF FNTYPE = sFlag_XS then        //类型(销售,CRM)
      begin
         nPacker := gBusinessPackerManager.LockPacker(sSAP_ReadXSSaleOrder);
         FFType  := sFlag_XS;
         FFOrder := PackerEncodeStr(nPacker.PackOut(FXSOut));
         FORDERNO                 :=  FXSOut.FORDERCODE;                        //销售订单号
         FMEASUREMENTUNIT         :=  FXSOut.FUNIT;                             //计量单位
         FTOTALPRICE              :=  FXSOut.FTOTALPRICE;                       //到位价
      end;

      IF FNTYPE =  sFlag_CRM THEN
      begin
         nPacker := gBusinessPackerManager.LockPacker(sSAP_ReadCrmOrder);
         FFType  :=  sFlag_CRM;
         FFOrder := PackerEncodeStr(nPacker.PackOut(FCRMOut));
         FDELIVERLISYNO        :=  FCRMOut.FDELIVERLISTNO;                      //提货委托单编号
         FTOTALPRICE           :=  FCRMOut.FTOTALPRICE;                         //到位价
         FORDERNO              :=  FCRMOut.FORDERNO;                            //销售订单号
      end;

      FAMOUNT                  :=  StrToFloat(EditNum.Text);                    //交货数量
      FDELIVERYNUMBER          :=  EditTruck.Text;                              //车牌号
      FTRUCKNAME               :=  EditTruckName.Text;                          //司机姓名
      FTRUCKTEL                :=  EditTelNo.Text;                              //司机电话
      FPRODUCTCODE             :=  EditPCode.Text;                              //产品代码
      FPRODUCTNAME             :=  EditPName.Text;                              //产品名称
      FBUYPARTCODE             :=  EditReCode.Text;                             //购买单位（售达方CODE）
      FBUYPARTNAME             :=  cxTextEdit2.Text;                            //购买单位名称（售达方描述）
      FREVEIVENAME             :=  EditPartName.Text;                           //收货方名称（送达方）
      FDRIVERNAME              :=  EditTruckName.Text;                          //司机名称
      FTELEPHONE               :=  EditTelNo.Text;                              //联系电话
      FTRANSTYPE               :=  EditTruckType.Text;                          //运输方式
      FREGIONCODE              :=  EditdRegCode.Text;                           //区域
      FREGIONTEXT              :=  EditdRegName.Text;                           //区域名称
      FNONUMBER                :=  EditNumber.Text;                             //证件号码
      FCHANNELTYPE             :=  GetCtrlData(EditType);                       //提货通道
      FCREATEUSER              :=  gSysParam.FUserName;                         //创建人
      FSEALATEXT                := EditSeal.Text;                               //封扦编号
      FDELIVERYORDERNO         :=  FNum;                                        //交货单号
      
      FBase.FMSGNO := sFlag_ForceDone + sFlag_BillNew + FNum ;
      FBase.FKey   := '交货单创建';
    end;

    nPacker := gBusinessPackerManager.LockPacker(sSAP_CreateSaleBill);
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_CreateSaleBill);
    if not nWorker.WorkActive(@FIn, @FOut) then Exit;
    ModalResult := mrOk;

  finally
    if ModalResult <> mrOk then
      BtnOK.Enabled := True;
    CloseWaitForm;

    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;

  if ModalResult = mrOK then
  begin
     PrintBillReport(FIn.FDELIVERYORDERNO,FIn.FPRODUCTCODE, True);
     SetBillCard(FIn.FDELIVERYORDERNO, EditTruck.Text,True);
  end;
end;

procedure TfFormNewXSBill.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   ReleaseCtrlData(EditType);
end;

initialization
  gControlManager.RegCtrl(TfFormNewXSBill, TfFormNewXSBill.FormID);
end.

{*******************************************************************************
  ����: dmzn@163.com 2012-3-14
  ����: �������۶���
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
    FNum:string;                                                            //�ж������ۻ���CRM
    FXSOut: PReadXSSaleOrderOut;
    FCRMOut: PReadCRMOrderOut;
    FIn: TWorkerCreateBillIn;
    FOut: TWorkerCreateBillIn;
    //����
    procedure InitFormData(const nOrder: PReadXSSaleOrderOut);
    procedure InitFormDataCRM(const nOrder: PReadCRMOrderOut);
    //��ʼ������
    procedure SetEditText(const nFlag, nText: string);
    //�����ı�
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
//Parm: ��ʶ;����
//Desc: ���ñ�ʶΪnFlag���ı�ΪnText
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
    nHint := MLang('�������Ϊ��ֵ��');
    if not Result then Exit;

    nVal := StrToFloat(EditNum.Text);
    nVal := Float2Float(nVal, cThousand, False);

    Result := nVal > 0;
    nHint := MLang('�������Ϊ����0��ֵ');
    if not Result then Exit;

    EditNum.Text := FloatToStr(nVal);
    Result := FloatRelation(StrToFloat(cxTextEdit15.Text), nVal, rtGE);
    nHint := MLang('�ѳ���������');
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    Result := Length(EditTruck.Text) >= 3;
    nHint := MLang('���ƺ�Ӧ��λ����');

    nStr := 'Select T_Type,T_InFact,T_Bill From %s Where T_Truck=''%s''';
    nStr := Format(nStr, [sTable_ZTTrucks, EditTruck.Text, sFlag_San]);

    with FDM.QueryTemp(nStr) do
    if (RecordCount > 0) and (Fields[0].AsString = 'D') and (Fields[1].AsString = '') then
    begin
      nStr := '����[%s]�ѿ�������[%s],��Ҫ�ϵ���?' +
               #13#10#13#10 +
              'ȷ�����''��'',�������''��''.';
      nStr := MLang(nStr);
      nStr := Format(nStr, [EditTruck.Text,Fields[2].AsString]);
      if not QueryDlg(nStr, MLang(sAsk)) then
      begin
        Result := False;
        nHint := MLang('�û�ȡ������');;
      end;
    end else if (RecordCount > 0) and (Fields[0].AsString = 'S') and (Fields[1].AsString = '')  THEN
    begin
      nStr := '����[%s]�ѿ�������[%s]' +
               #13#10#13#10 +
              'ɢװ������ϵ�';
      nStr := MLang(nStr);
      nStr := Format(nStr, [EditTruck.Text,Fields[2].AsString]);
      ShowDlg(nStr, MLang(sHint));
      Result := False;
      nHint := MLang('�û�ȡ������');
    end;
  end;
end;

//Desc: �����µ�
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

    nLang := MLang('���ɷ�����');
    ShowWaitForm(Self, nLang);

    with FIn do
    begin

      IF FNTYPE = sFlag_XS then        //����(����,CRM)
      begin
         nPacker := gBusinessPackerManager.LockPacker(sSAP_ReadXSSaleOrder);
         FFType  := sFlag_XS;
         FFOrder := PackerEncodeStr(nPacker.PackOut(FXSOut));
         FORDERNO                 :=  FXSOut.FORDERCODE;                        //���۶�����
         FMEASUREMENTUNIT         :=  FXSOut.FUNIT;                             //������λ
         FTOTALPRICE              :=  FXSOut.FTOTALPRICE;                       //��λ��
      end;

      IF FNTYPE =  sFlag_CRM THEN
      begin
         nPacker := gBusinessPackerManager.LockPacker(sSAP_ReadCrmOrder);
         FFType  :=  sFlag_CRM;
         FFOrder := PackerEncodeStr(nPacker.PackOut(FCRMOut));
         FDELIVERLISYNO        :=  FCRMOut.FDELIVERLISTNO;                      //���ί�е����
         FTOTALPRICE           :=  FCRMOut.FTOTALPRICE;                         //��λ��
         FORDERNO              :=  FCRMOut.FORDERNO;                            //���۶�����
      end;

      FAMOUNT                  :=  StrToFloat(EditNum.Text);                    //��������
      FDELIVERYNUMBER          :=  EditTruck.Text;                              //���ƺ�
      FTRUCKNAME               :=  EditTruckName.Text;                          //˾������
      FTRUCKTEL                :=  EditTelNo.Text;                              //˾���绰
      FPRODUCTCODE             :=  EditPCode.Text;                              //��Ʒ����
      FPRODUCTNAME             :=  EditPName.Text;                              //��Ʒ����
      FBUYPARTCODE             :=  EditReCode.Text;                             //����λ���۴﷽CODE��
      FBUYPARTNAME             :=  cxTextEdit2.Text;                            //����λ���ƣ��۴﷽������
      FREVEIVENAME             :=  EditPartName.Text;                           //�ջ������ƣ��ʹ﷽��
      FDRIVERNAME              :=  EditTruckName.Text;                          //˾������
      FTELEPHONE               :=  EditTelNo.Text;                              //��ϵ�绰
      FTRANSTYPE               :=  EditTruckType.Text;                          //���䷽ʽ
      FREGIONCODE              :=  EditdRegCode.Text;                           //����
      FREGIONTEXT              :=  EditdRegName.Text;                           //��������
      FNONUMBER                :=  EditNumber.Text;                             //֤������
      FCHANNELTYPE             :=  GetCtrlData(EditType);                       //���ͨ��
      FCREATEUSER              :=  gSysParam.FUserName;                         //������
      FSEALATEXT                := EditSeal.Text;                               //��Ǥ���
      FDELIVERYORDERNO         :=  FNum;                                        //��������
      
      FBase.FMSGNO := sFlag_ForceDone + sFlag_BillNew + FNum ;
      FBase.FKey   := '����������';
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

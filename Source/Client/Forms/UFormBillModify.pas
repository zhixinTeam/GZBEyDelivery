{*******************************************************************************
  作者: dmzn@163.com 2012-3-14
  描述: 修改
*******************************************************************************}
unit UFormBillModify;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, UBusinessConst, cxGraphics, cxControls,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit,
  dxLayoutControl, StdCtrls, cxLookAndFeels, cxLabel;

type
  TfFormModifyBill = class(TfFormNormal)
    EditID: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditTruck: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item7: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    class function FormID: integer; override;
  end;

function ShowModifyBillForm(const nIn: PWorkerModfiyBillIn;
 const nPicked: Boolean): Boolean;
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, UDataModule, USysDB, USysConst,UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFormModifyBill.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

function ShowModifyBillForm(const nIn: PWorkerModfiyBillIn;
 const nPicked: Boolean): Boolean;
begin
  with TfFormModifyBill.Create(Application) do
  try
      Caption :=  MLang('修改交货单');
      EditID.Text    := nIn.FDELIVERYORDERNO;

      EditTruck.Text := nIn.FDELIVERYNUMBER;
      EditTruck.Properties.ReadOnly := nPicked;
      if nPicked then EditTruck.Style.Color := $00F9E6D5;

      EditValue.Text := nIn.FAMOUNT;
      EditValue.Properties.ReadOnly := nPicked;
      if nPicked then EditValue.Style.Color := $00F9E6D5;

      Result := ShowModal = mrOk;
      if Result then
      begin
        nIn.FDELIVERYORDERNO := EditID.Text;
        nIn.FAMOUNT          := EditValue.Text;
        nIn.FDELIVERYNUMBER  := EditTruck.Text;
      end;
  finally
    Free;
  end;
end;

class function TfFormModifyBill.FormID: integer;
begin
  Result := -1;
end;

function TfFormModifyBill.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    Result := Length(EditTruck.Text) >= 3;
    nHint := MLang('车船号应大于3位');
  end else

  if Sender = EditValue then
  begin
    Result := IsNumber(EditValue.Text, True) and (StrToFloat(EditValue.Text) > 0);
    nHint := MLang('请填写有效交货量');
  end;
end;

procedure TfFormModifyBill.BtnOKClick(Sender: TObject);
begin
  if IsDataValid then ModalResult := mrOk;
end;

end.

{*******************************************************************************
  作者: dmzn@163.com 2012-3-14
  描述: 交货单拣配
*******************************************************************************}
unit UFormBillPick;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UBusinessConst, UFormNormal, cxGraphics, cxControls, 
  cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, dxLayoutControl,
  StdCtrls, cxLookAndFeels;

type
  TfFormPickBill = class(TfFormNormal)
    EditID: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditPValue: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditMValue: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditPValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FWeight: Double;
    //净重
    FStockType: string;
    //品种
  public
    { Public declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    class function FormID: integer; override;
  end;

function ShowPickBillForm(const nIn: PWorkerPickBillIn): Boolean;
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, USysDB, USysConst,UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFormPickBill.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

function ShowPickBillForm(const nIn: PWorkerPickBillIn): Boolean;
begin
  with TfFormPickBill.Create(Application) do
  try
    Caption := MLang('交货单拣配');
    EditID.Text     := nIn.FDELIVERYORDERNO;
    EditPValue.Text := nIn.FPValue;
    EditMValue.Text := nIn.FMValue;

    EditPValue.Properties.ReadOnly := StrToFloat(nIn.FPValue) > 0;
    EditMValue.Properties.ReadOnly := StrToFloat(nIn.FMValue) > 0;

    if not EditMValue.Properties.ReadOnly then
      ActiveControl := EditMValue;
    //xxxxx

    if not EditPValue.Properties.ReadOnly then
      ActiveControl := EditPValue;
    //xxxxx

    FStockType := nIn.FType;
    Result := ShowModal = mrOk;
    
    if Result then
    begin
      nIn.FPValue := EditPValue.Text;
      nIn.FMValue := EditMValue.Text;

      FWeight :=  StrToFloat(nIn.FMValue) -  StrToFloat(nIn.FPValue);

      if nIn.FType = sFlag_Dai then
           nIn.FAMOUNT :=  nIn.FAMOUNT//'0'                       //票重
      else nIn.FAMOUNT :=  FloatToStr(FWeight);    //净重
    end;
  finally
    Free;
  end;
end;

class function TfFormPickBill.FormID: integer;
begin
  Result := -1;
end;

function TfFormPickBill.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditPValue then
  begin
    Result := IsNumber(EditPValue.Text, True) and (StrToFloat(EditPValue.Text) >= 0);
    nHint := MLang('请填写有效皮重');
  end else

  if Sender = EditMValue then
  begin
    Result := IsNumber(EditMValue.Text, True) and (StrToFloat(EditMValue.Text) >= 0);
    nHint := MLang('请填写有效毛重');
  end;
end;

procedure TfFormPickBill.EditPValueKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if Sender = EditPValue then ActiveControl := EditMValue else
    if Sender = EditMValue then BtnOK.Click;
  end;
end;

procedure TfFormPickBill.BtnOKClick(Sender: TObject);
var nLang,nHint :string;
begin
  if not IsDataValid then Exit;

  FWeight := StrToFloat(EditMValue.Text) - StrToFloat(EditPValue.Text);

  if (FWeight < 0) or ((FStockType <> sFlag_Dai) and (FWeight = 0)) then
  begin
    ActiveControl := EditPValue;
    nLang := MLang('毛重应大于皮重');
    nHint := MLang(sHint);
    ShowMsg( nLang , nHint); Exit;
  end;

  ModalResult := mrOk;
end;

end.

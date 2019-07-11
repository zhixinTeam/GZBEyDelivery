{*******************************************************************************
  作者: dmzn@163.com 2012-3-10
  描述: 开提货单入口,依据条件调用普通订单或电子提货委托单窗口
*******************************************************************************}
unit UFormBillNew;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFormNormal, cxGraphics, cxControls, cxLookAndFeels, Dialogs,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxMaskEdit, cxDropDownEdit,
  cxTextEdit, cxLabel, dxLayoutControl, StdCtrls, IdBaseComponent, UBusinessConst,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, NativeXml, IdURI;

type
  TfFormNewBill = class(TfFormNormal)
    EditXS: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditCRM: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    procedure BtnOKClick(Sender: TObject);
    procedure EditXSKeyPress(Sender: TObject; var Key: Char);
    
  private
    FMsgNo: Cardinal;
    //参数
    { Private declarations }

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
  ULibFun, UMgrControl, UFormWait, UFormBase, UBusinessWorker,
  UDataModule, USysConst, USysDB, UBusinessPacker, USysLoger,UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFormNewBill.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

class function TfFormNewBill.FormID: integer;
begin
  Result := cFI_FormNewBill;
end;

class function TfFormNewBill.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
    nLang : string;
begin
  Result := nil;
  nP := nParam;

  with TfFormNewBill.Create(Application) do
  try
    nLang := MLang('创建交货单');
    Caption := nLang;
    if Assigned(nP) then
    begin
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
    end else ShowModal;
  finally
    Free;
  end;
end;

function TfFormNewBill.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if (Sender = EditXS) or (Sender = EditCRM) then
  begin
    EditXS.Text := Trim(EditXS.Text);
    EditCRM.Text := Trim(EditCRM.Text);

    Result := (EditXS.Text <> '') or (EditCRM.Text <> '');
    nHint := MLang('请填写有效订单号');
  end;
end;

//Desc: 读取订单
procedure TfFormNewBill.BtnOKClick(Sender: TObject);
var   nXSIn: TReadXSSaleOrderIn;
      nXSOut: TReadXSSaleOrderOut;
      nCRMIn: TReadCRMOrderIn;
      nCRMOut: TReadCrmOrderOut;
      nPacker: TBusinessPackerBase;
      nWorker: TBusinessWorkerBase;
      nParam: TFormCommandParam;
      nLang,nHint: string;
begin

  BtnOK.Enabled := False;

  try
    nLang := MLang( '正在读取单据信息');
    ShowWaitForm(Self, nLang );
    if EditCRM.Text <> '' then
    with nCRMIn do
    begin
      FDELIVERNO   := EditCRM.Text;
      FBase.FMSGNO := sFlag_NotMatter;

      gBusinessWorkerManager.RelaseWorker(nWorker);
      nWorker := gBusinessWorkerManager.LockWorker(sCLI_ReadCRMOrder);
      if not nWorker.WorkActive(@nCRMIn,@nCRMOut) then Exit;
    end;
   //电子提货委托单

    if EditXS.Text <> '' then
    with nXSIn do
    begin
      FORDERCODE := EditXS.Text;
      FBase.FMSGNO := sFlag_NotMatter;

      gBusinessWorkerManager.RelaseWorker(nWorker);
      nWorker := gBusinessWorkerManager.LockWorker(sCLI_ReadXSSaleOrder);
      if not nWorker.WorkActive(@nXSIn, @nXSOut) then Exit;
    end;
   //销售订单

    Visible := False;
    CloseWaitForm;
    Application.ProcessMessages;

    nParam.FCommand := cCmd_AddData;
    if EditXS.Text <> '' then
    begin
      nParam.FParamA := Integer(@nXSOut);
      nParam.FParamB := Integer(@nCRMOut);
      CreateBaseFormItem(cFI_FormNewXSBill, '', @nParam);
    end;

    if EditCRM.Text <> '' then
    begin
      nParam.FParamA := Integer(@nXSOut);
      nParam.FParamB := Integer(@nCRMOut);
      CreateBaseFormItem(cFI_FormNewXSBill, '', @nParam);
    end;

    if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
    begin
      nLang := MLang('交货单创建成功');
      nHint := MLang(sHint);
      ShowMsg( nLang, sHint);
      ModalResult := mrOk;
    end else ModalResult := mrCancel;

  finally
    if ModalResult <> mrOk then
      BtnOK.Enabled := True;
    CloseWaitForm;

    gBusinessPackerManager.RelasePacker(nPacker);
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

procedure TfFormNewBill.EditXSKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
 if Key = #13 then
  begin
    Key := #0;

    if Sender = EditXS then
    begin
      ActiveControl := BtnOK;
    end else

    if Sender = EditCRM then
    begin
      ActiveControl := BtnOK;
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormNewBill, TfFormNewBill.FormID);
end.

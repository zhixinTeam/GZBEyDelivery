{*******************************************************************************
  ����: dmzn@163.com 2010-3-14
  ����: ��������
*******************************************************************************}
unit UFormTruckOut;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  USysBusiness,UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, ComCtrls, cxContainer, cxEdit, cxTextEdit,
  cxListView, cxMCListBox, dxLayoutControl, StdCtrls;

type
  TfFormTruckOut = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    ListInfo: TcxMCListBox;
    dxLayout1Item3: TdxLayoutItem;
    ListBill: TcxListView;
    dxLayout1Item7: TdxLayoutItem;
    EditCus: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditBill: TcxTextEdit;
    LayItem1: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBillSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListInfoClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Protected declarations }
    procedure InitFormData;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormInputbox, USysGrid, UBusinessConst, 
  USysDB, USysConst,UMgrLang;

var
  gBills: TLadingBillItems;
  //������б�

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFormTruckOut.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

class function TfFormTruckOut.FormID: integer;
begin
  Result := cFI_FormTruckOut;
end;

class function TfFormTruckOut.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr,nHint,nLang: string;
    nIdx: Integer;
begin
  Result := nil;
  nStr := '';
  while True do
  begin
    nLang := MLang('����������ſ���:');
    nHint := MLang('����');
    if not ShowInputBox(nLang, nHint, nStr) then Exit;
    nStr := Trim(nStr);

    if nStr = '' then Continue;
    if GetLadingBills(nStr, sFlag_TruckOut, gBills) then Break;
  end;

  nHint := '';
  for nIdx:=Low(gBills) to High(gBills) do
  if gBills[nIdx].FNextStatus <> sFlag_TruckOut then
  begin
    nStr := '��.����:[ %s ] ״̬:[ %-6s -> %-6s ]   ';
    nStr := MLang(nStr);
    if nIdx < High(gBills) then nStr := nStr + #13#10;

    nStr := Format(nStr, [gBills[nIdx].FID,
            TruckStatusToStr(gBills[nIdx].FStatus),
            TruckStatusToStr(gBills[nIdx].FNextStatus)]);
    nHint := nHint + nStr;
  end;

  if nHint <> '' then
  begin
    nHint := MLang('�ó�����ǰ���ܳ���,��������: ' )+ #13#10#13#10 + nHint;
    ShowDlg(nHint, MLang(sHint));
    Exit;
  end;

  with TfFormTruckOut.Create(Application) do
  begin
    Caption := MLang('��������');
    InitFormData;
    ShowModal;
    Free;
  end;
end;

procedure TfFormTruckOut.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  dxGroup1.AlignVert := avClient;
  dxLayout1Item3.AlignVert := avClient;
  //client align
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo, nIni);
    LoadcxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormTruckOut.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo, nIni);
    SavecxListViewConfig(Name, ListBill, nIni);
  finally
    nIni.Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormTruckOut.InitFormData;
var nIdx: Integer;
begin
  ListBill.Clear;

  for nIdx:=Low(gBills) to High(gBills) do
  with ListBill.Items.Add,gBills[nIdx] do
  begin
    Caption := FID;
    SubItems.Add(Format('%.3f', [FValue]));
    SubItems.Add(FStockName);

    ImageIndex := 11;
    Data := Pointer(nIdx);
  end;

  ListBill.ItemIndex := 0;
end;

procedure TfFormTruckOut.ListBillSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var nIdx: Integer;
begin
  if Selected and Assigned(Item) then
  begin
    nIdx := Integer(Item.Data);
    LoadBillItemToMC(gBills[nIdx], ListInfo.Items, ListInfo.Delimiter);

    with gBills[nIdx] do
    begin
      LayItem1.Caption := MLang('��������:');
      EditBill.Text := FID;
      EditCus.Text := FCusName;
    end;
  end;
end;

procedure TfFormTruckOut.ListInfoClick(Sender: TObject);
var nStr: string;
    nPos: Integer;
begin
  if ListInfo.ItemIndex > -1 then
  begin
    nStr := ListInfo.Items[ListInfo.ItemIndex];
    nPos := Pos(':', nStr);
    if nPos < 1 then Exit;

    LayItem1.Caption := Copy(nStr, 1, nPos);
    nPos := Pos(ListInfo.Delimiter, nStr);

    System.Delete(nStr, 1, nPos);
    EditBill.Text := Trim(nStr);
  end;
end;

procedure TfFormTruckOut.BtnOKClick(Sender: TObject);
begin
  if SaveLadingBills(sFlag_TruckOut, gBills) then
  begin
    ShowMsg(MLang('���������ɹ�'), MLang(sHint));
    ModalResult := mrOk;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTruckOut, TfFormTruckOut.FormID);
end.

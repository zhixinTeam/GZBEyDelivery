{*******************************************************************************
  ����: dmzn@163.com 2014-6-02
  ����: ԭ����
*******************************************************************************}
unit UFormPMaterails;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormBase, cxGraphics, dxLayoutControl, StdCtrls,
  cxMaskEdit, cxDropDownEdit, cxMCListBox, cxMemo, cxContainer, cxEdit,
  cxTextEdit, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinsDefaultPainters;

type
  TfFormMaterails = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    dxLayoutControl1Group2: TdxLayoutGroup;
    EditName: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayoutControl1Item4: TdxLayoutItem;
    InfoList1: TcxMCListBox;
    dxLayoutControl1Item5: TdxLayoutItem;
    InfoItems: TcxComboBox;
    dxLayoutControl1Item6: TdxLayoutItem;
    EditInfo: TcxTextEdit;
    dxLayoutControl1Item7: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayoutControl1Item8: TdxLayoutItem;
    BtnDel: TButton;
    dxLayoutControl1Item9: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    dxLayoutControl1Group4: TdxLayoutGroup;
    cxTextEdit3: TcxTextEdit;
    dxLayoutControl1Item14: TdxLayoutItem;
    dxLayoutControl1Group9: TdxLayoutGroup;
    EditPrice: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    dxLayoutControl1Group6: TdxLayoutGroup;
    EditPValue: TcxComboBox;
    dxLayoutControl1Item3: TdxLayoutItem;
    EditPTime: TcxTextEdit;
    dxLayoutControl1Item12: TdxLayoutItem;
    dxLayoutControl1Group8: TdxLayoutGroup;
    dxLayoutControl1Group7: TdxLayoutGroup;
    dxLayoutControl1Group10: TdxLayoutGroup;
    dxLayoutControl1Item13: TdxLayoutItem;
    EditID: TcxTextEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FRecordID: string;
    //��¼��
    procedure InitFormData(const nID: string);
    //��������
    procedure GetData(Sender: TObject; var nData: string);
    function SetData(Sender: TObject; const nData: string): Boolean;
    //���ݴ���
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UFormCtrl, UAdjustForm, USysGrid,
  USysDB, USysConst,UMgrLang;

var
  gForm: TfFormMaterails = nil;
  //ȫ��ʹ��

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFormMaterails.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

class function TfFormMaterails.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
    nLang:string;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormMaterails.Create(Application) do
    begin
      FRecordID := '';
      nLang :=  MLang('ԭ���� - ���');
      Caption := nLang;

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormMaterails.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      nLang :=  MLang('ԭ���� - �޸�');
      Caption := nLang;

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormMaterails.Create(Application);
        with gForm do
        begin
          nLang :=  MLang('ԭ���� - �鿴');
          Caption := nLang;
          FormStyle := fsStayOnTop;

          BtnOK.Visible := False;
          BtnAdd.Enabled := False;
          BtnDel.Enabled := False;
        end;
      end;

      with gForm  do
      begin
        FRecordID := nP.FParamA;
        InitFormData(FRecordID);
        if not Showing then Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormMaterails.FormID: integer;
begin
  Result := cFI_FormMaterails;
end;

//------------------------------------------------------------------------------
procedure TfFormMaterails.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, InfoList1, nIni);
  finally
    nIni.Free;
  end;

  ResetHintAllForm(Self, 'T', sTable_Materails);
  //���ñ�����
end;

procedure TfFormMaterails.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, InfoList1, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
end;

procedure TfFormMaterails.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfFormMaterails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormMaterails.GetData(Sender: TObject; var nData: string);
begin
  if Sender = EditPValue then
  begin
    if EditPValue.ItemIndex = 0 then
         nData := sFlag_Yes
    else nData := sFlag_No;
  end;
end;

function TfFormMaterails.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;

  if Sender = EditPValue then
  begin
    Result := True;
    
    if nData = sFlag_Yes then
         EditPValue.ItemIndex := 0
    else EditPValue.ItemIndex := 1;
  end;
end;

//Desc: ������Ϣ
procedure TfFormMaterails.InitFormData(const nID: string);
var nStr: string;
begin
  if nID = '' then Exit;
  nStr := 'Select * From %s Where M_ID=''%s''';
  nStr := Format(nStr, [sTable_Materails, nID]);
  LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);

  InfoList1.Clear;
  nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                     MI('$Group', sFlag_MaterailsItem), MI('$ID', nID)]);
  //��չ��Ϣ

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := FieldByName('I_Item').AsString + InfoList1.Delimiter +
              FieldByName('I_Info').AsString;
      InfoList1.Items.Add(nStr);

      Next;
    end;
  end;
end;

//Desc: �����Ϣ
procedure TfFormMaterails.BtnAddClick(Sender: TObject);
var nLang:string;
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    InfoItems.SetFocus;
    nLang :=  MLang('����д �� ѡ����Ч����Ϣ��');
    ShowMsg(nLang, sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    nLang :=  MLang('����д��Ч����Ϣ����');
    ShowMsg(nLang, sHint); Exit;
  end;

  InfoList1.Items.Add(InfoItems.Text + InfoList1.Delimiter + EditInfo.Text);
end;

//Desc: ɾ����Ϣ��
procedure TfFormMaterails.BtnDelClick(Sender: TObject);
var nIdx: integer;
    nLang:string;
begin
  if InfoList1.ItemIndex < 0 then
  begin
    nLang :=  MLang('��ѡ��Ҫɾ��������');
    ShowMsg(nLang, sHint); Exit;
  end;

  nIdx := InfoList1.ItemIndex;
  InfoList1.Items.Delete(InfoList1.ItemIndex);

  if nIdx >= InfoList1.Count then Dec(nIdx);
  InfoList1.ItemIndex := nIdx;

  nLang :=  MLang('��Ϣ����ɾ��');
  ShowMsg(nLang, sHint);
end;

//Desc: ��������
procedure TfFormMaterails.BtnOKClick(Sender: TObject);
var nStr,nID,nTmp,nSQL,nLang,nHint: string;
    i,nPos,nCount: Integer;
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    nLang :=  MLang('����дԭ�ϱ��');
    nHint :=   MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  EditName.Text := Trim(EditName.Text);
  if EditName.Text = '' then
  begin
    EditName.SetFocus;
    nLang :=  MLang('����дԭ��������');
    nHint :=   MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  if not IsNumber(EditPrice.Text, True) then
  begin
    EditPrice.SetFocus;
    nLang :=  MLang('��������Ч�ĵ���');
    nHint :=   MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  if (not IsNumber(EditPTime.Text, False)) or (StrToInt(EditPTime.Text) < 1) then
  begin
    EditPTime.SetFocus;
    nHint :=   MLang(sHint);
    ShowMsg('ʱ��Ϊ>0������', nHint); Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    if FRecordID = '' then
    begin
      nSQL := MakeSQLByForm(Self, sTable_Materails, '', True, GetData);
    end else
    begin
      nStr := 'M_ID=''' + FRecordID + '''';
      nSQL := MakeSQLByForm(Self, sTable_Materails, nStr, False, GetData);
    end;

    FDM.ExecuteSQL(nSQL);
    if FRecordID = '' then
    begin
      nID := EditID.Text;
    end else
    begin
      nID := FRecordID;
      nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_MaterailsItem, nID]);
      FDM.ExecuteSQL(nSQL);
    end;

    nCount := InfoList1.Items.Count - 1;
    for i:=0 to nCount do
    begin
      nStr := InfoList1.Items[i];
      nPos := Pos(InfoList1.Delimiter, nStr);

      nTmp := Copy(nStr, 1, nPos - 1);
      System.Delete(nStr, 1, nPos + Length(InfoList1.Delimiter) - 1);

      nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
              'Values(''%s'', ''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_MaterailsItem, nID, nTmp, nStr]);
      FDM.ExecuteSQL(nSQL);
    end;

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    nLang :=  MLang('ԭ����Ϣ�ѱ���');
    nHint :=  MLang(sHint);
    ShowMsg(nLang, nHint);
  except
    FDM.ADOConn.RollbackTrans;
    nLang :=  MLang('���ݱ���ʧ��');
    nHint :=  MLang('δ֪ԭ��');
    ShowMsg(nLang, nHint);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormMaterails, TfFormMaterails.FormID);
end.

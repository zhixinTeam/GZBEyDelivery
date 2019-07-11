{*******************************************************************************
  ����: dmzn@163.com 2008-8-8
  ����: �û���¼����
*******************************************************************************}
unit UFormLogin;

{$I link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfFormLogin = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    Edit_User: TLabeledEdit;
    Edit_Pwd: TLabeledEdit;
    LabelCopy: TLabel;
    BtnExit: TSpeedButton;
    BtnSet: TSpeedButton;
    BtnLogin: TButton;
    EditLang: TComboBox;
    Label1: TLabel;
    procedure BtnSetClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowLoginForm: Boolean;
//��ں���

implementation

{$R *.dfm}
uses
  ULibFun, USysConst, USysDB, USysPopedom, USysMenu, UMgrPopedom, USysLoger,
  UFormWait, UFormConn, UDataModule, UMgrLang;
  
ResourceString
  sUserLogin = '�û�[ %s ]���Ե�½ϵͳ';
  sUserLoginOK = '��½ϵͳ�ɹ�,�û�:[ %s ]';
  sConnDBError = '�������ݿ�ʧ��,���ô����Զ������Ӧ';

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TfFormLogin, '�û���½', nEvent);
end;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFormLogin.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

//Desc: �û���¼
function ShowLoginForm: Boolean;
var nStr,nLang: string;
begin
  with TfFormLogin.Create(Application) do
  begin
    nLang := MLang('��¼');
    Caption := nLang;
    Edit_User.Text := gSysParam.FUserName;

    nStr := gPath + 'Logo.bmp';
    if FileExists(nStr) then
      Image1.Picture.LoadFromFile(nStr);
    //xxxxx

    if gSysParam.FCopyRight <> '' then
      nLang := MLang( gSysParam.FCopyRight);
      LabelCopy.Caption := nLang;
    //xxxxx

    Result := ShowModal = mrOk;
    Free
  end;
end;

procedure TfFormLogin.FormCreate(Sender: TObject);
var nIdx: Integer;
begin
  with gMultiLangManager do
  begin
    EditLang.Items.Clear;
    for nIdx:=Low(LangItems) to High(LangItems) do
    begin
      EditLang.Items.AddObject(LangItems[nIdx].FName, Pointer(nIdx));
      if LangItems[nIdx].FLangID = LangID then
        EditLang.ItemIndex := nIdx;
      //now lang
    end;

    SectionID := 'fFormLogin';
    TranslateAllCtrl(Self);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����nConnStr�Ƿ���Ч
function ConnCallBack(const nConnStr: string): Boolean;
begin
  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := nConnStr;
  FDM.ADOConn.Open;
  Result := FDM.ADOConn.Connected;
end;

//Desc: ����
procedure TfFormLogin.BtnSetClick(Sender: TObject);
begin
  ShowConnectDBSetupForm(ConnCallBack);
end;

//Desc: �˳�
procedure TfFormLogin.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Desc: ������ݼ�
procedure TfFormLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DOWN:
      begin
        Key := 0; SwitchFocusCtrl(Self, True);
      end;
    VK_UP:
      begin
        Key := 0; SwitchFocusCtrl(Self, False);
      end;
  end;
end;

procedure TfFormLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then
  begin
    Key := #0; SwitchFocusCtrl(Self, True);
  end;
end;

//Desc: ��¼
procedure TfFormLogin.BtnLoginClick(Sender: TObject);
var nStr,nMsg,nLang,nHint: string;
    nIdx: Integer;
    nList: TStrings;
begin
  if EditLang.ItemIndex > -1 then
  begin
    nIdx := Integer(EditLang.Items.Objects[EditLang.ItemIndex]);
    gSysParam.FSysLangID := gMultiLangManager.LangItems[nIdx].FLangID;

    if gSysParam.FSysLangID <> gMultiLangManager.LangID then
      gMultiLangManager.LangID := gSysParam.FSysLangID;
    //change default lang
  end;

  Edit_User.Text := Trim(Edit_User.Text);
  Edit_Pwd.Text := Trim(Edit_Pwd.Text);

  if (Edit_User.Text = '') or (Edit_Pwd.Text = '') then
  begin
    nLang := MLang('�������û���������');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  nStr := BuildConnectDBStr;
  while nStr = '' do
  begin
    nLang := MLang('��������ȷ��"���ݿ�"���ò���');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint);

    if ShowConnectDBSetupForm(ConnCallBack) then
         nStr := BuildConnectDBStr
    else Exit;
  end;

  nMsg := '';
  nLang := MLang('�������ݿ�');
  ShowWaitForm(Self, nLang);
  try
    WriteLog(Format(sUserLogin, [Edit_User.Text]));
    //write log

    nList := nil;
    try
      FDM.ADOConn.Connected := False;
      FDM.ADOConn.ConnectionString := nStr;
      FDM.ADOConn.Connected := True;

      nList := TStringList.Create;
      LoadConnecteDBConfig(nList);

      nStr := nList.Values[sConn_Key_DBType];
      if IsNumber(nStr, False) then
        gSysDBType := TSysDatabaseType(StrToInt(nStr));
      nList.Free;
    except
      if Assigned(nList) then nList.Free;
      WriteLog(sConnDBError);
      ShowDlg(MLang(sConnDBError), MLang(sWarn), Handle); Exit;
    end;

    nStr := 'Select U_NAME from $a Where U_NAME=''$b'' and U_PASSWORD=''$c'' ' +
            'and U_State=$d';
    nStr := MacroValue(nStr, [MI('$a',sTable_User),
                              MI('$b',Edit_User.Text),
                              MI('$c',Edit_Pwd.Text),
                              MI('$d', IntToStr(cPopedomUser_Normal))]);
    //xxxxx
    
    if FDM.QuerySQL(nStr).RecordCount <> 1 then
    begin
      Edit_User.SetFocus;
      nMsg := MLang('������û���������,����������');
     // nMsg := '������û���������,����������';
       Exit;
    end;

    gSysParam.FUserID := Edit_User.Text;
    gSysParam.FUserName := FDM.SqlQuery.Fields[0].AsString;
    gSysParam.FUserPwd := Edit_Pwd.Text;

    ShowWaitForm(nil, MLang('��������'));
    {$IFDEF EnableBackupDB}
    gSysParam.FUsesBackDB := FDM.IsEnableBackupDB;
    if gSysParam.FUsesBackDB then
    begin
      nStr := BuildFixedConnStr(sDBConfig_bk, True); 
      FDM.Conn_Bak.Connected := False;
      FDM.Conn_Bak.ConnectionString := nStr;
    end;
    {$ENDIF}

    if not gMenuManager.IsValidProgID then
    begin
      WriteLog('��֤�����ʶʧ��');
      nMsg := '�����ʶ��Ч,�޷�������������'; Exit;
    end;

    ShowWaitForm(nil, MLang('��ʼ���˵�'));
    gMenuManager.LangID := gMultiLangManager.LangID;
    //���ò˵�����
    
    if not gMenuManager.LoadMenuFromDB(gSysParam.FProgID) then
    begin
      WriteLog('����˵�����ʧ��');
      nMsg := '�޷����������������,��������ݿ����'; Exit;
    end;

    ShowWaitForm(nil, MLang('��ȡ�û�Ȩ��'));
    if not gPopedomManager.LoadGroupFromDB(gSysParam.FProgID) then
    begin
      WriteLog('��ȡ�û�Ȩ��ʧ��');
      nMsg := '�޷������û�Ȩ������,��������ݿ����'; Exit;
    end;

    FDM.AdjustAllSystemTables;
    gPopedomManager.GetUserIdentity(gSysParam.FUserName);
    
    nStr := Format(sUserLoginOK, [Edit_User.Text]);
    WriteLog(nStr);
    ModalResult := mrOk;
  finally
    CloseWaitForm;
    if nMsg <> '' then
      ShowDlg(MLang(nMsg), MLang(sHint));
    //xxxxx
  end;
end;

end.
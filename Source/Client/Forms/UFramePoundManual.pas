{*******************************************************************************
  作者: dmzn@163.com 2014-06-10
  描述: 手动称重
*******************************************************************************}
unit UFramePoundManual;

{$I Link.inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameBase, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ADODB, ExtCtrls, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxSplitter, Menus;

type
  TfFramePoundManual = class(TBaseFrame)
    WorkPanel: TScrollBox;
    Timer1: TTimer;
    cxSplitter1: TcxSplitter;
    SQLQuery: TADOQuery;
    DataSource1: TDataSource;
    cxGrid1: TcxGrid;
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure WorkPanelMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    procedure LoadPoundItems;
    //载入通道
    procedure LoadPoundData(const nWhere: string = '');
    //载入数据
  public
    { Public declarations }
    class function FrameID: integer; override;
    function FrameTitle: string; override;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function DealCommand(Sender: TObject; const nCmd: integer): integer; override;
    //子类继承
  end;

implementation

{$R *.dfm}

uses
  IniFiles, UlibFun, UMgrControl, UMgrPoundTunnels, UFramePoundManualItem,
  UDataModule, UFormWait, USysDataDict, USysGrid, USysLoger, USysConst,
  USysDB,UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFramePoundManual.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

class function TfFramePoundManual.FrameID: integer;
begin
  Result := cFI_FramePoundManual;
end;

function TfFramePoundManual.FrameTitle: string;
var nLang:string;
begin
  nLang := MLang('称重 - 人工');
  Result := nLang;
end;

procedure TfFramePoundManual.OnCreateFrame;
var nInt: Integer;
    nIni: TIniFile;
begin
  inherited;
  //gSysParam.FIsManual := True;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nInt := nIni.ReadInteger(Name, 'GridHeight', 0);
    if nInt > 20 then
      cxGrid1.Height := nInt;
    //xxxxx
    gSysEntityManager.LangID := gSysParam.FSysLangID;
    gSysEntityManager.BuildViewColumn(cxView1, 'MAIN_E03');
    InitTableView(Name, cxView1, nIni);
  finally
    nIni.Free;
  end;

  if not Assigned(gPoundTunnelManager) then
  begin
    gPoundTunnelManager := TPoundTunnelManager.Create;
    gPoundTunnelManager.LoadConfig(gPath + 'Tunnels.xml');
  end;
end;

procedure TfFramePoundManual.OnDestroyFrame;
var nIni: TIniFile;
begin
  //gSysParam.FIsManual := False;
  //关闭手动称重

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteInteger(Name, 'GridHeight', cxGrid1.Height);
    SaveUserDefineTableView(Name, cxView1, nIni);
  finally
    nIni.Free;
  end;

  inherited;
end;

function TfFramePoundManual.DealCommand(Sender: TObject;
  const nCmd: integer): integer;
begin
  if (Sender is TfFrameManualPoundItem) and (nCmd = cCmd_RefreshData) then
    LoadPoundData;
  Result := 0;
end;

//------------------------------------------------------------------------------
//Desc: 延时载入通道
procedure TfFramePoundManual.Timer1Timer(Sender: TObject);
var nLang,nHint :string;
begin
  Timer1.Enabled := False;
  if gSysParam.FFactNum = '' then
  begin
    nLang := MLang('系统需要授权才能称重,请联系管理员');
    nHint := MLang(sHint);
    ShowDlg(nLang, nHint);
    Exit;
  end;

  LoadPoundItems;
  LoadPoundData;
end;

//Desc: 支持滚轮
procedure TfFramePoundManual.WorkPanelMouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  with WorkPanel do
    VertScrollBar.Position := VertScrollBar.Position - WheelDelta;
  //xxxxx
end;

//Desc: 载入通道
procedure TfFramePoundManual.LoadPoundItems;
var nIdx: Integer;
    nT: PPTTunnelItem;
begin
  with gPoundTunnelManager do
  begin
    for nIdx:=0 to Tunnels.Count - 1 do
    begin
      nT := Tunnels[nIdx];
      //tunnel

      with TfFrameManualPoundItem.Create(Self) do
      begin
        Name := 'fFrameManualPoundItem' + IntToStr(nIdx);
        Parent := WorkPanel;

        Align := alTop;
        HintLabel.Caption := MLang(nT.FName);
        PoundTunnel := nT;

        Additional.Clear;
        SplitStr(nT.FOptions.Text, Additional, 0, ';', False);
      end;
    end;
  end;
end;

//Desc: 载入数据
procedure TfFramePoundManual.LoadPoundData(const nWhere: string);
var nStr,nLang: string;
begin
  nLang := MLang('读取数据');
  ShowWaitForm(ParentForm, nLang);
  try
    nStr := 'Select * From $TB Where (P_PDate Is Null Or P_MDate Is Null)' +
            ' And (P_PDate > $Now-2 Or P_MDate > $Now-2) And (P_PModel<>''$Tmp'')';
    nStr := MacroValue(nStr, [MI('$TB', sTable_PoundLog),
            MI('$Now', sField_SQLServer_Now), MI('$Tmp', sFlag_PoundLS)]);
    //xxxxx

    if nWhere <> '' then
      nStr := nStr + ' And (' + nWhere + ')';
    FDM.QueryData(SQLQuery, nStr, False);
  finally
    CloseWaitForm;
  end;
end;

procedure TfFramePoundManual.N1Click(Sender: TObject);
begin
  LoadPoundData('');
end;

initialization
  gControlManager.RegCtrl(TfFramePoundManual, TfFramePoundManual.FrameID);
end.

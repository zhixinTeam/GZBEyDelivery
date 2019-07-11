{*******************************************************************************
  作者: dmzn@163.com 2014-11-25
  描述: 车辆档案管理
*******************************************************************************}
unit UFrameTrucks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, dxSkinsCore, dxSkinsDefaultPainters,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData,
  cxContainer, dxLayoutControl, cxMaskEdit, cxButtonEdit, cxTextEdit,
  ADODB, cxLabel, UBitmapPanel, cxSplitter, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, Menus;

type
  TfFrameTrucks = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    VIP1: TMenuItem;
    VIP2: TMenuItem;
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure PMenu1Popup(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure VIP1Click(Sender: TObject);
    procedure VIP2Click(Sender: TObject);
  private
    { Private declarations }
  protected
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysBusiness, USysConst, USysDB, UDataModule, UFormBase,
  UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFrameTrucks.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

class function TfFrameTrucks.FrameID: integer;
begin
  Result := cFI_FrameTrucks;
end;

function TfFrameTrucks.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Truck;
  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  Result := Result + ' Order By T_PY';
end;

//Desc: 添加
procedure TfFrameTrucks.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  nP.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormTrucks, '', @nP);

  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 修改
procedure TfFrameTrucks.BtnEditClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nP.FCommand := cCmd_EditData;
    nP.FParamA := SQLQuery.FieldByName('R_ID').AsString;
    CreateBaseFormItem(cFI_FormTrucks, '', @nP);

    if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    begin
      InitFormData(FWhere);
    end;
  end;
end;

//Desc: 删除
procedure TfFrameTrucks.BtnDelClick(Sender: TObject);
var nStr,nTruck,nEvent: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin 
    nTruck := SQLQuery.FieldByName('T_Truck').AsString;
    nStr   := Format( MLang('确定要删除车辆[ %s ]吗?'), [nTruck]);
    if not QueryDlg(nStr, MLang(sAsk)) then Exit;

    if DeleteTruckDocument(nTruck) then
    begin
      nEvent := MLang('删除[ %s ]档案信息.');
      nEvent := Format(nEvent, [nTruck]);
      FDM.WriteSysLog(sFlag_CommonItem, nTruck, nEvent);

      InitFormData(FWhere);
      //refresh ui
    end;
  end;
end;

procedure TfFrameTrucks.PMenu1Popup(Sender: TObject);
begin
  N2.Enabled := BtnEdit.Enabled;
end;

//Desc: 车辆签到
procedure TfFrameTrucks.N2Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := 'Update %s Set T_LastTime=getDate() Where R_ID=%s';
    nStr := Format(nStr, [sTable_Truck, SQLQuery.FieldByName('R_ID').AsString]);

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
    ShowMsg(MLang('签到成功'), MLang(sHint));
  end;
end;

//Desc: 查询
procedure TfFrameTrucks.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    if EditName.Text = '' then Exit;

    FWhere := Format('T_Truck Like ''%%%s%%''', [EditName.Text]);
    InitFormData(FWhere);
  end;
end;

//办理电子标签
procedure TfFrameTrucks.N4Click(Sender: TObject);
var nStr, nRFIDCard, nFlag: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('T_Truck').AsString;
    nRFIDCard := SQLQuery.FieldByName('T_Card').AsString;
    nFlag := SQLQuery.FieldByName('T_CardUse').AsString;
    
    if SetTruckRFIDCard(nStr, nRFIDCard, nFlag, nRFIDCard) and
       SaveTruckRFIDCard(nStr, nRFIDCard, nFlag) then
    begin
      InitFormData(FWhere);
      ShowMsg(MLang('办理电子标签成功'),MLang(sHint));
    end;
  end;
end;


//启用电子标签
procedure TfFrameTrucks.N5Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('T_Truck').AsString;
    if not SaveTruckRFIDCard(nStr, '', sFlag_Yes) then exit;

    InitFormData(FWhere);
    ShowMsg(MLang('启用电子标签成功'), MLang(sHint));
  end;
end;

//Desc: 停用电子签
procedure TfFrameTrucks.N7Click(Sender: TObject);
var nStr: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('T_Truck').AsString;
    if not SaveTruckRFIDCard(nStr, '', sFlag_No) then exit;

    InitFormData(FWhere);
    ShowMsg(MLang('停用电子标签成功'), MLang(sHint));
  end;
end;

procedure TfFrameTrucks.VIP1Click(Sender: TObject);
var nStr: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := 'Update %s Set T_VIPTruck=''%s'' Where R_ID=%s';
    nStr := Format(nStr, [sTable_Truck, sFlag_TypeVIP,
      SQLQuery.FieldByName('R_ID').AsString]);
    //xxxxxx

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
    ShowMsg(MLang('设置车辆VIP成功'), MLang(sHint));
  end;
end;

procedure TfFrameTrucks.VIP2Click(Sender: TObject);
var nStr: string;
begin
  inherited;
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := 'Update %s Set T_VIPTruck=''%s'' Where R_ID=%s';
    nStr := Format(nStr, [sTable_Truck, sFlag_TypeCommon,
      SQLQuery.FieldByName('R_ID').AsString]);
    //xxxxxx

    FDM.ExecuteSQL(nStr);
    InitFormData(FWhere);
    ShowMsg( MLang('关闭车辆VIP成功'), MLang(sHint));
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTrucks, TfFrameTrucks.FrameID);
end.

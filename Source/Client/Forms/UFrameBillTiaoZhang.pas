{*******************************************************************************
  ����: dmzn@163.com 2009-6-22
  ����: ��������ʴ���
*******************************************************************************}
unit UFrameBillTiaoZhang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, UBusinessPacker, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxGraphics, cxCheckBox, IdHTTP, NativeXml, IdURI,USysBusiness;

type
  TfFrameBillTiaoZhang= class(TfFrameNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N2: TMenuItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N1: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //ʱ������
    FFields: string;
    //�ֶ�
    FJBWhere: string;
    //��������
    nListA: TStrings;
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*} 
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormDateFilter,
  UFormBillModify, UFormWait, UBusinessWorker, UBusinessConst, USysDB,
  USysConst,UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFrameBillTiaoZhang.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

//------------------------------------------------------------------------------
class function TfFrameBillTiaoZhang.FrameID: integer;
begin
  Result := cFI_FrameBillTiaoZ;
end;

procedure TfFrameBillTiaoZhang.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameBillTiaoZhang.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: ���ݲ�ѯSQL
function TfFrameBillTiaoZhang.InitFormDataSQL(const nWhere: string): string;
begin
 EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select (Case When L_Action=''$PO'' Then ' +
            'L_Result Else '''' End) As L_Result,* From $Bill ';
  //xxxxx

  if FJBWhere = '' then
  begin
    if nWhere = '' then
         Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')' +
                   ' And (L_Action=''$PK'' OR L_Action=''$PO'' )'
    else Result := Result + 'Where (' + nWhere + ')';
  end else
  begin
    Result := Result + 'Where (' + FJBWhere + ')';
  end;

  Result := MacroValue(Result, [MI('$Bill', sTable_Bill),
            MI('$PO', sFlag_BillTiao), MI('$PK', sFlag_BillPost),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: ִ�в�ѯ
procedure TfFrameBillTiaoZhang.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    FWhere := 'L_ID like ''%' + EditLID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := '(L_CusID like ''%%%s%%'' Or L_CusName like ''%%%s%%'') And ' +
              '(L_Date>=''$ST'' and L_Date <''$End'')';
    FWhere := Format(FWhere, [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := '(L_Truck like ''%%%s%%'') And ' +
              '(L_Date>=''$ST'' and L_Date <''$End'')';
    FWhere := Format(FWhere, [EditTruck.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: ����ɸѡ
procedure TfFrameBillTiaoZhang.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: ����
procedure TfFrameBillTiaoZhang.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
    nLang,nHint : string;
begin
   if cxView1.DataController.GetSelectedCount > 0 then
   begin

      if SQLQuery.FieldByName('L_TiaoZBill').AsString = '' then
      begin
       nListA.Free;
       nListA := TStringList.Create;

        with nListA do
        begin
          Values['��������']   :=   SQLQuery.FieldByName('L_ID').AsString;
          Values['������']     :=   SQLQuery.FieldByName('L_Value').AsString;
          Values['�������']   :=   SQLQuery.FieldByName('L_ZhiKa').AsString;
          Values['�ͻ����']   :=   SQLQuery.FieldByName('L_CUSID').AsString;
          Values['�ͻ�����']   :=   SQLQuery.FieldByName('L_CusName').AsString;
          Values['Ʒ�ֱ��']   :=   SQLQuery.FieldByName('L_StockNo').AsString;
          Values['Ʒ������']   :=   SQLQuery.FieldByName('L_StockName').AsString;
          Values['���ί�е�'] :=   SQLQuery.FieldByName('L_CRM').AsString;
        end;

        nP.FCommand := cCmd_AddData;
        nP.FParamA  := PackerEncodeStr(nListA.Text);                           //�������ţ��ɣ�
        CreateBaseFormItem(cFI_FormBillTiaoz, '', @nP);
        if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
           InitFormData(FWhere);
      end else
      begin
        nLang :=  MLang('�ý������ѵ��ʲ������ٴε��ʣ�');
        nHint :=  MLang(sHint);
        ShowMsg(nLang, nHint);
      end;
   end;
end;

//Desc: ��ӡ�����
procedure TfFrameBillTiaoZhang.N1Click(Sender: TObject);
var nStr,nTemp: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('L_ID').AsString;
    nTemp := SQLQuery.FieldByName('L_StockNo').AsString;
    PrintBillReport(nStr,nTemp, False);
  end;
end;

//Desc: ���˴���
procedure TfFrameBillTiaoZhang.N4Click(Sender: TObject);
var nP: TFormCommandParam;
    nLang,nHint :string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
   begin

      if SQLQuery.FieldByName('L_TiaoZBill').AsString = '' then
      begin
       nListA.Free;
       nListA := TStringList.Create;

        with nListA do
        begin
          Values['��������']   :=   SQLQuery.FieldByName('L_ID').AsString;
          Values['������']     :=   SQLQuery.FieldByName('L_Value').AsString;
          Values['�������']   :=   SQLQuery.FieldByName('L_ZhiKa').AsString;
          Values['�ͻ����']   :=   SQLQuery.FieldByName('L_CUSID').AsString;
          Values['�ͻ�����']   :=   SQLQuery.FieldByName('L_CusName').AsString;
          Values['Ʒ�ֱ��']   :=   SQLQuery.FieldByName('L_StockNo').AsString;
          Values['Ʒ������']   :=   SQLQuery.FieldByName('L_StockName').AsString;
          Values['���ί�е�'] :=   SQLQuery.FieldByName('L_CRM').AsString;
        end;

        nP.FCommand := cCmd_AddData;
        nP.FParamA  := PackerEncodeStr(nListA.Text);                           //�������ţ��ɣ�
        CreateBaseFormItem(cFI_FormBillTiaoz, '', @nP);
        if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
           InitFormData(FWhere);
      end else
      begin
        nLang :=  MLang('�ý������ѵ��ʲ������ٴε��ʣ�');
        nHint :=  MLang(sHint);
        ShowMsg(nLang, nHint);
      end;
   end;

 end;

procedure TfFrameBillTiaoZhang.N5Click(Sender: TObject);
var nStr: string;
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  begin
    nStr := 'L_Date>=''%s'' and L_Date<''%s''';
    nStr := Format(nStr, [DateTime2Str(FTimeS), DateTime2Str(FTimeE)]);
    Initformdata(nStr);
  end;
end;



initialization
  gControlManager.RegCtrl(TfFrameBillTiaoZhang, TfFrameBillTiaoZhang.FrameID);
end.

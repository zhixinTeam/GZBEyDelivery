{*******************************************************************************
  ����: dmzn@163.com 2009-6-22
  ����: �����ȷ��
*******************************************************************************}
unit UFrameBillPost;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameBillPost = class(TfFrameNormal)
    EditCus: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditCard: TcxButtonEdit;
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
    N1: TMenuItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    N2: TMenuItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N2Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //ʱ������
    FFields: string;
    //�ֶ�
    FListA,FListB: TStrings;
    //�ַ��б�
    FJBWhere: string;
    //��������
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*��ѯSQL*}
    function GetVal(const nRow: Integer; const nField: string): string;
    //��ȡָ������
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormDateFilter, UFormInputbox,
  UBusinessWorker, UBusinessConst, UBusinessPacker, USysBusiness, USysDB,
  USysConst, UFormWait,UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFrameBillPost.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

//------------------------------------------------------------------------------
class function TfFrameBillPost.FrameID: integer;
begin
  Result := cFI_FrameBillPost;
end;

procedure TfFrameBillPost.OnCreateFrame;
var nStr: string;
begin
  inherited;
  FListA := TStringList.Create;
  FListB := TStringList.Create;

  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);

  nStr :='Update %s set L_PostDay =convert(char(10),getdate(),120) where L_Action <> ''%s''' ;
  nStr := Format(nStr, [sTable_Bill, sFlag_BillPost]);
  FDM.ExecuteSQL(nStr);
end;

procedure TfFrameBillPost.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  FreeAndNil(FListA);
  FreeAndNil(FListB);
  inherited;
end;

//Desc: ���ݲ�ѯSQL
function TfFrameBillPost.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select (Case When L_Action=''$PO'' Then ' +
            'L_Result Else '''' End) As L_Result,* From $Bill ';
  //xxxxx

  if FJBWhere = '' then
  begin
    if nWhere = '' then
         Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')' +
                   ' And (L_Action=''$PO'' Or L_Action=''$PK'')'
    else Result := Result + 'Where (' + nWhere + ')';
  end else
  begin
    Result := Result + 'Where (' + FJBWhere + ')';
  end;

  Result := MacroValue(Result, [MI('$Bill', sTable_Bill),
            MI('$PO', sFlag_BillPost), MI('$PK', sFlag_BillPick),//MI('$PZ', sFlag_BillTiao),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: ִ�в�ѯ
procedure TfFrameBillPost.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    FWhere := '(L_Action=''%s'' Or L_Status=''%s'') And L_ID like ''%%%s%%'' ';
    FWhere := Format(FWhere, [sFlag_BillPost, sFlag_BillPick, EditLID.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := '(L_Action=''%s'' Or L_Status=''%s'') And ' +
              ' L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [sFlag_BillPost, sFlag_BillPick,
              EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := '(L_Action=''%s'' Or L_Status=''%s'') And L_Card=''%s''';
    FWhere := Format(FWhere, [sFlag_BillPost, sFlag_BillPick, EditCard.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: ��δ����
procedure TfFrameBillPost.N1Click(Sender: TObject);
begin
  FWhere := 'L_Status=''%s'' And L_Action<>''%s'' ';
  FWhere := Format(FWhere, [sFlag_BillPick, sFlag_BillPost]);
  InitFormData(FWhere);
end;

//Desc: �����δ�ɹ�
procedure TfFrameBillPost.N2Click(Sender: TObject);
begin
  FWhere := 'L_Action=''%s'' And L_Result<>''%s'' ';
  FWhere := Format(FWhere, [sFlag_BillPost, sFlag_Yes]);
  InitFormData(FWhere);
end;

//Desc: �޸Ĺ�����
procedure TfFrameBillPost.N4Click(Sender: TObject);
var nStr,nVal,nEvent: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫ�޸ĵļ�¼', sHint); Exit;
  end;

  nVal := SQLQuery.FieldByName('L_PostDay').AsString;
  while True do
  try
    nVal := StringReplace(nVal, '-', '.', [rfReplaceAll]);
    nStr := '����д��ȷ����,��ʽ: 2010.01.01';
    if not ShowInputBox(nStr, '������', nVal, 10) then Exit;

    nVal := StringReplace(nVal, '.', '-', [rfReplaceAll]);
    nStr := SQLQuery.FieldByName('L_PostDay').AsString;
    
    if Date2Str(StrToDate(nVal)) = nStr then
         ShowMsg('��ȷ������Ч', sHint)
    else Break;
  except
    ShowMsg('���ڸ�ʽ��Ч', sHint);
  end;

  nVal := Date2Str(StrToDate(nVal));
  nStr := 'Update %s Set L_PostDay=''%s'' Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nVal, SQLQuery.FieldByName('L_ID').AsString]);

  FDM.ExecuteSQL(nStr);

  //�����޸Ĺ�������־
  nStr   := SQLQuery.FieldByName('L_ID').AsString;
  nEvent := '������[%s]ȷ������ԭ��[%s]�޸�Ϊ[%s]';
  nEvent := Format(nEvent, [SQLQuery.FieldByName('L_ID').AsString,
                            SQLQuery.FieldByName('L_PostDay').AsString,
                            nVal]);
  FDM.WriteSysLog(sTable_ExtInfo, nStr, nEvent);

  InitFormData(FWhere);
end;

//Desc: ����ɸѡ
procedure TfFrameBillPost.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: ��ȡnRow��nField�ֶε�����
function TfFrameBillPost.GetVal(const nRow: Integer;
 const nField: string): string;
var nVal: Variant;
begin
  nVal := cxView1.DataController.GetValue(
            cxView1.Controller.SelectedRows[nRow].RecordIndex,
            cxView1.GetColumnByFieldName(nField).Index);
  //xxxxx

  if VarIsNull(nVal) then
       Result := ''
  else Result := nVal;
end;

//Desc: ִ�й���
procedure TfFrameBillPost.BtnEditClick(Sender: TObject);
var nStr,nLang,nHint: string;
    nIdx,nLen: Integer;
    nIn: TWorkerPostBillIn;
    nOut: TWorkerPostBillOut;
    nWorker: TBusinessWorkerBase;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    nLang := MLang('��ѡ��Ҫȷ�ϵļ�¼');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;
  
  if cxView1.DataController.GetSelectedCount > 1 then
  begin
    nLang := MLang('��һ�β�Ҫѡ�񳬹�1����¼');
    nHint := MLang(sHint);
    ShowMsg( nLang, nHint); Exit;
  end;


  nStr := 'ȷ��Ҫ��ѡ�е�%d�Ž�����ִ��ȷ�ϲ�����?';
  nLang := MLang(nStr);
  nHint := MLang(sAsk);
  nStr := Format(nLang, [cxView1.DataController.GetSelectedCount]);
  if not QueryDlg(nStr, nHint) then Exit;

  nWorker := nil;

  try
    nLen := cxView1.DataController.GetSelectedCount - 1;
    FListA.Clear;

    for nIdx:=0 to nLen do
    begin
    
      FListB.Values['DELIVERYORDERNO'] := GetVal(nIdx, 'L_ID');
      FListA.Add(PackerEncodeStr(FListB.Text));

      with nIn do
      begin

        nIn.FData  := PackerEncodeStr(FListA.Text);
        if nLen < 1 then
        begin
          nStr := SQLQuery.FieldByName('L_ID').AsString;
          nStr := sFlag_ForceDone + sFlag_BillPost + nStr;
        end else nStr := IntToStr(GetTickCount);

        FBase.FMsgNO := nStr;

      end;

      nLang := MLang('����ȷ��');
      ShowWaitForm(ParentForm, nLang);
      nWorker := gBusinessWorkerManager.LockWorker(sCLI_PostSaleBill);

      if nWorker.WorkActive(@nIn, @nOut) then
    end;
      InitFormData(FWhere);
    //xxxxx
  finally
    CloseWaitForm;
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameBillPost, TfFrameBillPost.FrameID);
end.

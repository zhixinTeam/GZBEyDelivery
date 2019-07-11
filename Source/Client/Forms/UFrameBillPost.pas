{*******************************************************************************
  作者: dmzn@163.com 2009-6-22
  描述: 提货单确认
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
    //时间区间
    FFields: string;
    //字段
    FListA,FListB: TStrings;
    //字符列表
    FJBWhere: string;
    //交班条件
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
    function GetVal(const nRow: Integer; const nField: string): string;
    //获取指定内容
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

//Desc: 数据查询SQL
function TfFrameBillPost.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

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

//Desc: 执行查询
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

//Desc: 查未过账
procedure TfFrameBillPost.N1Click(Sender: TObject);
begin
  FWhere := 'L_Status=''%s'' And L_Action<>''%s'' ';
  FWhere := Format(FWhere, [sFlag_BillPick, sFlag_BillPost]);
  InitFormData(FWhere);
end;

//Desc: 查过账未成功
procedure TfFrameBillPost.N2Click(Sender: TObject);
begin
  FWhere := 'L_Action=''%s'' And L_Result<>''%s'' ';
  FWhere := Format(FWhere, [sFlag_BillPost, sFlag_Yes]);
  InitFormData(FWhere);
end;

//Desc: 修改过账日
procedure TfFrameBillPost.N4Click(Sender: TObject);
var nStr,nVal,nEvent: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要修改的记录', sHint); Exit;
  end;

  nVal := SQLQuery.FieldByName('L_PostDay').AsString;
  while True do
  try
    nVal := StringReplace(nVal, '-', '.', [rfReplaceAll]);
    nStr := '请填写新确认日,格式: 2010.01.01';
    if not ShowInputBox(nStr, '过账日', nVal, 10) then Exit;

    nVal := StringReplace(nVal, '.', '-', [rfReplaceAll]);
    nStr := SQLQuery.FieldByName('L_PostDay').AsString;
    
    if Date2Str(StrToDate(nVal)) = nStr then
         ShowMsg('新确认日无效', sHint)
    else Break;
  except
    ShowMsg('日期格式无效', sHint);
  end;

  nVal := Date2Str(StrToDate(nVal));
  nStr := 'Update %s Set L_PostDay=''%s'' Where L_ID=''%s''';
  nStr := Format(nStr, [sTable_Bill, nVal, SQLQuery.FieldByName('L_ID').AsString]);

  FDM.ExecuteSQL(nStr);

  //增加修改过账日日志
  nStr   := SQLQuery.FieldByName('L_ID').AsString;
  nEvent := '交货单[%s]确认日由原来[%s]修改为[%s]';
  nEvent := Format(nEvent, [SQLQuery.FieldByName('L_ID').AsString,
                            SQLQuery.FieldByName('L_PostDay').AsString,
                            nVal]);
  FDM.WriteSysLog(sTable_ExtInfo, nStr, nEvent);

  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFrameBillPost.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: 获取nRow行nField字段的内容
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

//Desc: 执行过账
procedure TfFrameBillPost.BtnEditClick(Sender: TObject);
var nStr,nLang,nHint: string;
    nIdx,nLen: Integer;
    nIn: TWorkerPostBillIn;
    nOut: TWorkerPostBillOut;
    nWorker: TBusinessWorkerBase;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    nLang := MLang('请选择要确认的记录');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;
  
  if cxView1.DataController.GetSelectedCount > 1 then
  begin
    nLang := MLang('请一次不要选择超过1条记录');
    nHint := MLang(sHint);
    ShowMsg( nLang, nHint); Exit;
  end;


  nStr := '确定要对选中的%d张交货单执行确认操作吗?';
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

      nLang := MLang('正在确认');
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

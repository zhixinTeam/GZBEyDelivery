{*******************************************************************************
  作者: dmzn@163.com 2009-6-22
  描述: 提货单拣配
*******************************************************************************}
unit UFrameBillPick;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, UBusinessPacker, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxGraphics;

type
  TfFrameBillPick = class(TfFrameNormal)
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
    N3: TMenuItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N4: TMenuItem;
    EditTruck: TcxButtonEdit;
    dxLayout1Item10: TdxLayoutItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N3Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    FFields: string;
    //字段
    FJBWhere: string;
    //交班条件
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    {*查询SQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UDataModule, UFormDateFilter, UFormBillPick,
  UBusinessWorker, UBusinessConst, UFormWait, USysBusiness, USysFun, USysDB,
  USysConst,UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFrameBillPick.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

//------------------------------------------------------------------------------
class function TfFrameBillPick.FrameID: integer;
begin
  Result := cFI_FrameBillPick;
end;

procedure TfFrameBillPick.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  FJBWhere := '';
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameBillPick.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameBillPick.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select (Case When ' +
            ' L_Action=''$PK'' Or L_Action=''$PT'' Then L_Result Else '''' ' +
            'End) As L_Result,L_Status,b.* From $Bill b ';
  //xxxxx

  if FJBWhere = '' then
  begin
    if nWhere = '' then
         Result := Result + ' Where L_Action<>''$PT''  AND L_Action<>''$PM''  And ' +
                   '(L_Date>=''$ST'' and L_Date <''$End'')'
    else Result := Result + ' Where L_Action<>''$PT'' AND L_Action<>''$PM'' And (' + nWhere + ')';
  end else
  begin
    Result := Result + ' Where (' + FJBWhere + ')';
  end;

  Result := MacroValue(Result, [MI('$Bill', sTable_Bill),
            MI('$PK', sFlag_BillPick), MI('$PT', sFlag_BillPost), MI('$PM', sFlag_BillTiao),
            MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 执行查询
procedure TfFrameBillPick.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditLID then
  begin
    EditLID.Text := Trim(EditLID.Text);
    if EditLID.Text = '' then Exit;

    FWhere := 'L_ID like ''%' + EditLID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditTruck then
  begin
    EditTruck.Text := Trim(EditTruck.Text);
    if EditTruck.Text = '' then Exit;

    FWhere := 'L_Truck like ''%' + EditTruck.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditCus then
  begin
    EditCus.Text := Trim(EditCus.Text);
    if EditCus.Text = '' then Exit;

    FWhere := 'L_CusID like ''%%%s%%'' Or L_CusName like ''%%%s%%''';
    FWhere := Format(FWhere, [EditCus.Text, EditCus.Text]);
    InitFormData(FWhere);
  end else

  if Sender = EditCard then
  begin
    EditCard.Text := Trim(EditCard.Text);
    if EditCard.Text = '' then Exit;

    FWhere := Format('L_Card=''%s''', [EditCard.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 查未拣配
procedure TfFrameBillPick.N1Click(Sender: TObject);
begin
  FWhere := 'L_Action<>''%s''';
  FWhere := Format(FWhere, [sFlag_BillPick]);
  InitFormData(FWhere);
end;

//Desc: 查拣配未成功
procedure TfFrameBillPick.N3Click(Sender: TObject);
begin
  FWhere := 'L_Action=''%s'' And L_Result<>''%s'' ';
  FWhere := Format(FWhere, [sFlag_BillPick, sFlag_Yes]);
  InitFormData(FWhere);
end;

//Desc: 拣配记录的时间段查询
procedure TfFrameBillPick.N4Click(Sender: TObject);
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  try
    FJBWhere := 'L_PickDate>=''%s'' And L_PickDate<''%s''';
    FJBWhere := Format(FJBWhere, [DateTime2Str(FTimeS), DateTime2Str(FTimeE),
                sFlag_Yes]);
    InitFormData;
  finally
    FJBWhere := '';
  end;
end;

//Desc: 日期筛选
procedure TfFrameBillPick.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: 执行拣配
procedure TfFrameBillPick.BtnEditClick(Sender: TObject);
var nIn: TWorkerPickBillIn;
    nOut: TBWDataBase;
    nWorker: TBusinessWorkerBase;
    nStr,nLang,nHint: string;
begin
  nWorker := nil;
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    nLang := MLang('请选择需要拣配的单据');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  nStr := '交货单[  %s  ]当前票重值为[  %s  ]' +
          #13#10#13#10 +
          '***包装业务将以当前票重值拣配***' +
          #13#10#13#10 +
          '***散装业务将以输入净重值拣配***' +
          #13#10#13#10 +
          '继续手工拣配请点"是",退出请点"否".';
  nLang := MLang(nStr);
  nStr := Format(nLang, [SQLQuery.FieldByName('L_ID').AsString,
                        SQLQuery.FieldByName('L_Value').AsString]);
  if not QueryDlg(nStr,MLang(sAsk)) then Exit;

  try
    with nIn do
    begin
      FAMOUNT          := SQLQuery.FieldByName('L_Value').AsString;
      FDELIVERYORDERNO := SQLQuery.FieldByName('L_ID').AsString;
      FType            := SQLQuery.FieldByName('L_Type').AsString;

      FPValue := '0';
      FMValue := '0';

      FBase.FMsgNO := sFlag_ForceDone + sFlag_BillPick + nIn.FDELIVERYORDERNO;
      //msg no
    end;

    if not ShowPickBillForm(@nIn) then Exit;
    //change param
    nLang  := MLang('正在拣配');
    ShowWaitForm(ParentForm, nLang);
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_PickSaleBill);
    if not nWorker.WorkActive(@nIn, @nOut) then Exit;

    InitFormData(FWhere);
    nLang  := MLang('发货单拣配成功');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint);
  finally
    CloseWaitForm;
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameBillPick, TfFrameBillPick.FrameID);
end.

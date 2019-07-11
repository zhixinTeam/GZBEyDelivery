{*******************************************************************************
  作者: dmzn@163.com 2009-6-22
  描述: 开提货单
*******************************************************************************}
unit UFrameBill;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UFrameNormal, UBusinessPacker, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, cxContainer, Menus, dxLayoutControl,
  cxTextEdit, cxMaskEdit, cxButtonEdit, ADODB, cxLabel, UBitmapPanel,
  cxSplitter, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxGraphics, cxCheckBox, IdHTTP, NativeXml, IdURI;

type
  TfFrameBill = class(TfFrameNormal)
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
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    EditLID: TcxButtonEdit;
    dxLayout1Item8: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    N4: TMenuItem;
    N5: TMenuItem;
    CheckBox1: TcxCheckBox;
    dxLayout1Item10: TdxLayoutItem;
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    FTimeS,FTimeE: TDate;
    //时间区间
    FFields: string;
    //字段
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
  ULibFun, UMgrControl, UDataModule, UFormBase, UFormDateFilter,
  UFormBillModify, UFormWait, UBusinessWorker, UBusinessConst, USysDB,
  USysConst,USysBusiness,UMgrLang;

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFrameBill.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

//------------------------------------------------------------------------------
class function TfFrameBill.FrameID: integer;
begin
  Result := cFI_FrameViewBill;
end;

procedure TfFrameBill.OnCreateFrame;
begin
  inherited;
  FTimeS := Str2DateTime(Date2Str(Now) + ' 00:00:00');
  FTimeE := Str2DateTime(Date2Str(Now) + ' 00:00:00');

  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameBill.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//Desc: 数据查询SQL
function TfFrameBill.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $Bill a Left Join S_OrderXS b on a.L_ID=b.BILLID ';
  //提货单

  if nWhere = '' then
       Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')'
  else Result := Result + 'Where (' + nWhere + ')';

  if CheckBox1.Checked then
       Result := MacroValue(Result, [MI('$Bill', sTable_BillBak)])
  else Result := MacroValue(Result, [MI('$Bill', sTable_Bill)]);

  Result := MacroValue(Result, [MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: 执行查询
procedure TfFrameBill.EditIDPropertiesButtonClick(Sender: TObject;
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

    FWhere := '(L_CusPY like ''%%%s%%'' Or L_CusName like ''%%%s%%'') And ' +
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

//Desc: 未开始提货的提货单
procedure TfFrameBill.N3Click(Sender: TObject);
begin
  FWhere := 'L_OutFact Is Null And L_Value > 0';
  InitFormData(FWhere);
end;

//Desc: 日期筛选
procedure TfFrameBill.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: 开提货单
procedure TfFrameBill.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormNewBill, '', @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    InitFormData('');
  //xxxxx
end;

//Desc: 修改
procedure TfFrameBill.BtnEditClick(Sender: TObject);
var nStr,nEvent,nTruck,nLang,nHint: string;
    nFamout :Double;
    nBool: Boolean;
    nIn: TWorkerModfiyBillIn;
    nOut: TBWDataBase;
    nWorker: TBusinessWorkerBase;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    nLang := MLang('请选择要修改的记录');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  if SQLQuery.FieldByName('L_DELMAN').AsString <> '' then
  begin
    nLang := MLang('已删除记录不允许操作');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  if SQLQuery.FieldByName('L_CRM').AsString <> '' then
  begin
    nLang := MLang('电子提货单禁止修改');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint);
    Exit;
  end;

  nStr := 'Select L_Status From %s Where L_ID=''%s'' ';
  nStr := Format(nStr, [sTable_Bill, SQLQuery.FieldByName('L_ID').AsString]);
  with FDM.QueryTemp(nStr) do
  if (Fields[0].AsString = sFlag_TruckFH)    or                               //放灰车辆
     (Fields[0].AsString = sFlag_TruckZT)    or                               //栈台车辆
     (Fields[0].AsString = sFlag_TruckBFM)    or                               //磅房毛重车辆
     (Fields[0].AsString = sFlag_TruckOut)                                    // 出厂车辆
  then
  begin
    nLang := MLang('该交货单提货中,禁止修改');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint);
    Exit;
  end;
  //校验交货单 是否满足 修改 要求

  nBool := False;
  nWorker := nil;

  InitFormData(FWhere);
  
  try
    with nIn do
    begin
      FDELIVERYORDERNO := SQLQuery.FieldByName('L_ID').AsString;                //交货单号
      FAMOUNT          := SQLQuery.FieldByName('L_Value').AsString;             //交货数量
      FDELIVERYNUMBER  := SQLQuery.FieldByName('L_Truck').AsString;             //车牌号

      nTruck           := SQLQuery.FieldByName('L_ID').AsString;
      nFamout          := StrToFloat(SQLQuery.FieldByName('L_Value').AsString);
      //临时变量

      FBase.FMsgNO := sFlag_ForceDone + sFlag_BillEdit + FDELIVERYORDERNO;
      //msg no
    end;

    if not ShowModifyBillForm(@nIn, nBool) then Exit;
    ShowWaitForm(ParentForm,MLang('正在提交'));

    if nTruck <> nIn.FDELIVERYORDERNO then
    begin
      nStr := '注意:修改车牌号将修改交货单[ %s ]对应的称重及装运记录'+ #13#10#13#10 +
              '是否要继续修改?继续请点"是",退出请点"否".' ;
      nStr := MLang(nStr);
      nStr := Format(nStr, [nIn.FDELIVERYORDERNO]);
      if not QueryDlg(nStr, sAsk) then Exit;

      nWorker := gBusinessWorkerManager.LockWorker(sCLI_ModifySaleBill);
      if not nWorker.WorkActive(@nIn, @nOut) then Exit;

      nStr := 'Update %s Set P_Truck=''%s'',P_LimValue=''%s'' Where P_Bill=''%s''';
      nStr := Format(nStr, [sTable_PoundLog, nIn.FDELIVERYNUMBER,nIn.FAMOUNT, nIn.FDELIVERYORDERNO]);
      FDM.ExecuteSQL(nStr);
      //修改PoundLog对应的车牌号

      if nFamout <> StrToFloat(nIn.FAMOUNT) then
      begin
        nEvent:= '交货单[ %s ]数量由[ %s ]修改为[ %s ].';
        nEvent := MLang(nEvent);
        nEvent := Format(nEvent, [nIn.FDELIVERYORDERNO,nFamout,nIn.FAMOUNT]);
        FDM.WriteSysLog(sFlag_TruckQueue, nIn.FDELIVERYORDERNO, nEvent);
      end;
      //xxxx

      if nTruck <> nIn.FDELIVERYNUMBER then
      begin
        nEvent:= '交货单[ %s ]车号由[ %s ]修改为[ %s ].';
        nEvent := MLang(nEvent);
        nEvent := Format(nEvent, [nIn.FDELIVERYORDERNO,nTruck,nIn.FDELIVERYNUMBER]);
        FDM.WriteSysLog(sFlag_TruckQueue, nIn.FDELIVERYNUMBER, nEvent);
      end;
      //xxxxxx
    end else
    begin
      nWorker := gBusinessWorkerManager.LockWorker(sCLI_ModifySaleBill);
      if not nWorker.WorkActive(@nIn, @nOut) then Exit;
    end;

    InitFormData(FWhere);
    nLang := MLang('交货单修改成功');
    nHint := MLang(sHint);
    ShowMsg( nLang, nHint);
  finally
    CloseWaitForm;
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Desc: 删除
procedure TfFrameBill.BtnDelClick(Sender: TObject);
var nStr,nEvent,nLang,nHint: string;
    nIn: TWorkerDeleteBillIn;
    nOut: TWorkerDeleteBillIn;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;

  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    nLang := MLang('请选择要删除的记录');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  if SQLQuery.FieldByName('L_DELMAN').AsString <> '' then
  begin
      nLang := MLang('已删除记录不允许操作');
      nHint := MLang(sHint);
      ShowMsg(nLang, nHint); Exit;
  end;

  if SQLQuery.FieldByName('L_TiaoZBill').AsString <> '' then
  begin
      nLang := MLang('已调账交货单不允许删除');
      nHint := MLang(sHint);
      ShowMsg(nLang, nHint); Exit;
  end;

  try
    nIn.FDELIVERYORDERNO := SQLQuery.FieldByName('L_ID').AsString;
    nIn.FBase.FMsgNO := sFlag_FixedNo + sFlag_BillDel + nIn.FDELIVERYORDERNO;

    nStr := '确定要删除编号为[ %s ]的交货单吗?';
    nStr := MLang(nStr);
    nStr := Format(nStr, [nIn.FDELIVERYORDERNO]);
    if not QueryDlg(nStr, MLang(sAsk)) then Exit;

    nLang := MLang('正在删除');
    ShowWaitForm(ParentForm, nLang);
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_DeleteSaleBill);
    if not nWorker.WorkActive(@nIn, @nOut) then Exit;

    nEvent:= '提货单[ %s ]被用户[ %s ]删除.';
    nEvent := Format(nEvent, [nIn.FDELIVERYORDERNO,gSysParam.FUserID]);
    FDM.WriteSysLog(sFlag_TruckQueue, nIn.FDELIVERYORDERNO, nEvent);
    //增加删除日志

    InitFormData(FWhere);
    nLang := MLang('交货单删除成功');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint);
  finally
    CloseWaitForm;
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Desc: 打印提货单
procedure TfFrameBill.N1Click(Sender: TObject);
var nBill,nStock: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nBill := SQLQuery.FieldByName('L_ID').AsString;
    nStock := '';//SQLQuery.FieldByName('L_StockNo').AsString;
    PrintBillReport(nBill,nStock,  True);
  end;
end;

//Desc: 设置提货卡
procedure TfFrameBill.N4Click(Sender: TObject);
var nL,nT: string;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nL := SQLQuery.FieldByName('L_ID').AsString;
    nT := SQLQuery.FieldByName('L_Truck').AsString;
    if SetBillCard(nL, nT, False) then InitFormData(FWhere);
  end;
end;

procedure TfFrameBill.N5Click(Sender: TObject);
var nStr: string;
begin
  if ShowDateFilterForm(FTimeS, FTimeE, True) then
  begin
    nStr := 'L_Date>=''%s'' and L_Date<''%s''';
    nStr := Format(nStr, [DateTime2Str(FTimeS), DateTime2Str(FTimeE)]);
    Initformdata(nStr);
  end;
end;

procedure TfFrameBill.CheckBox1Click(Sender: TObject);
begin
  BtnRefresh.Click;
end;

initialization
  gControlManager.RegCtrl(TfFrameBill, TfFrameBill.FrameID);
end.

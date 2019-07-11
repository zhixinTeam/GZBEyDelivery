{*******************************************************************************
  ����: dmzn@163.com 2009-6-22
  ����: �������
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
    //ʱ������
    FFields: string;
    //�ֶ�
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

//Desc: ���ݲ�ѯSQL
function TfFrameBill.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $Bill a Left Join S_OrderXS b on a.L_ID=b.BILLID ';
  //�����

  if nWhere = '' then
       Result := Result + 'Where (L_Date>=''$ST'' and L_Date <''$End'')'
  else Result := Result + 'Where (' + nWhere + ')';

  if CheckBox1.Checked then
       Result := MacroValue(Result, [MI('$Bill', sTable_BillBak)])
  else Result := MacroValue(Result, [MI('$Bill', sTable_Bill)]);

  Result := MacroValue(Result, [MI('$ST', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxx
end;

//Desc: ִ�в�ѯ
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

//Desc: δ��ʼ����������
procedure TfFrameBill.N3Click(Sender: TObject);
begin
  FWhere := 'L_OutFact Is Null And L_Value > 0';
  InitFormData(FWhere);
end;

//Desc: ����ɸѡ
procedure TfFrameBill.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData('');
end;

//------------------------------------------------------------------------------
//Desc: �������
procedure TfFrameBill.BtnAddClick(Sender: TObject);
var nP: TFormCommandParam;
begin
  CreateBaseFormItem(cFI_FormNewBill, '', @nP);
  if (nP.FCommand = cCmd_ModalResult) and (nP.FParamA = mrOK) then
    InitFormData('');
  //xxxxx
end;

//Desc: �޸�
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
    nLang := MLang('��ѡ��Ҫ�޸ĵļ�¼');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  if SQLQuery.FieldByName('L_DELMAN').AsString <> '' then
  begin
    nLang := MLang('��ɾ����¼���������');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  if SQLQuery.FieldByName('L_CRM').AsString <> '' then
  begin
    nLang := MLang('�����������ֹ�޸�');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint);
    Exit;
  end;

  nStr := 'Select L_Status From %s Where L_ID=''%s'' ';
  nStr := Format(nStr, [sTable_Bill, SQLQuery.FieldByName('L_ID').AsString]);
  with FDM.QueryTemp(nStr) do
  if (Fields[0].AsString = sFlag_TruckFH)    or                               //�Żҳ���
     (Fields[0].AsString = sFlag_TruckZT)    or                               //ջ̨����
     (Fields[0].AsString = sFlag_TruckBFM)    or                               //����ë�س���
     (Fields[0].AsString = sFlag_TruckOut)                                    // ��������
  then
  begin
    nLang := MLang('�ý����������,��ֹ�޸�');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint);
    Exit;
  end;
  //У�齻���� �Ƿ����� �޸� Ҫ��

  nBool := False;
  nWorker := nil;

  InitFormData(FWhere);
  
  try
    with nIn do
    begin
      FDELIVERYORDERNO := SQLQuery.FieldByName('L_ID').AsString;                //��������
      FAMOUNT          := SQLQuery.FieldByName('L_Value').AsString;             //��������
      FDELIVERYNUMBER  := SQLQuery.FieldByName('L_Truck').AsString;             //���ƺ�

      nTruck           := SQLQuery.FieldByName('L_ID').AsString;
      nFamout          := StrToFloat(SQLQuery.FieldByName('L_Value').AsString);
      //��ʱ����

      FBase.FMsgNO := sFlag_ForceDone + sFlag_BillEdit + FDELIVERYORDERNO;
      //msg no
    end;

    if not ShowModifyBillForm(@nIn, nBool) then Exit;
    ShowWaitForm(ParentForm,MLang('�����ύ'));

    if nTruck <> nIn.FDELIVERYORDERNO then
    begin
      nStr := 'ע��:�޸ĳ��ƺŽ��޸Ľ�����[ %s ]��Ӧ�ĳ��ؼ�װ�˼�¼'+ #13#10#13#10 +
              '�Ƿ�Ҫ�����޸�?�������"��",�˳����"��".' ;
      nStr := MLang(nStr);
      nStr := Format(nStr, [nIn.FDELIVERYORDERNO]);
      if not QueryDlg(nStr, sAsk) then Exit;

      nWorker := gBusinessWorkerManager.LockWorker(sCLI_ModifySaleBill);
      if not nWorker.WorkActive(@nIn, @nOut) then Exit;

      nStr := 'Update %s Set P_Truck=''%s'',P_LimValue=''%s'' Where P_Bill=''%s''';
      nStr := Format(nStr, [sTable_PoundLog, nIn.FDELIVERYNUMBER,nIn.FAMOUNT, nIn.FDELIVERYORDERNO]);
      FDM.ExecuteSQL(nStr);
      //�޸�PoundLog��Ӧ�ĳ��ƺ�

      if nFamout <> StrToFloat(nIn.FAMOUNT) then
      begin
        nEvent:= '������[ %s ]������[ %s ]�޸�Ϊ[ %s ].';
        nEvent := MLang(nEvent);
        nEvent := Format(nEvent, [nIn.FDELIVERYORDERNO,nFamout,nIn.FAMOUNT]);
        FDM.WriteSysLog(sFlag_TruckQueue, nIn.FDELIVERYORDERNO, nEvent);
      end;
      //xxxx

      if nTruck <> nIn.FDELIVERYNUMBER then
      begin
        nEvent:= '������[ %s ]������[ %s ]�޸�Ϊ[ %s ].';
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
    nLang := MLang('�������޸ĳɹ�');
    nHint := MLang(sHint);
    ShowMsg( nLang, nHint);
  finally
    CloseWaitForm;
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Desc: ɾ��
procedure TfFrameBill.BtnDelClick(Sender: TObject);
var nStr,nEvent,nLang,nHint: string;
    nIn: TWorkerDeleteBillIn;
    nOut: TWorkerDeleteBillIn;
    nWorker: TBusinessWorkerBase;
begin
  nWorker := nil;

  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    nLang := MLang('��ѡ��Ҫɾ���ļ�¼');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint); Exit;
  end;

  if SQLQuery.FieldByName('L_DELMAN').AsString <> '' then
  begin
      nLang := MLang('��ɾ����¼���������');
      nHint := MLang(sHint);
      ShowMsg(nLang, nHint); Exit;
  end;

  if SQLQuery.FieldByName('L_TiaoZBill').AsString <> '' then
  begin
      nLang := MLang('�ѵ��˽�����������ɾ��');
      nHint := MLang(sHint);
      ShowMsg(nLang, nHint); Exit;
  end;

  try
    nIn.FDELIVERYORDERNO := SQLQuery.FieldByName('L_ID').AsString;
    nIn.FBase.FMsgNO := sFlag_FixedNo + sFlag_BillDel + nIn.FDELIVERYORDERNO;

    nStr := 'ȷ��Ҫɾ�����Ϊ[ %s ]�Ľ�������?';
    nStr := MLang(nStr);
    nStr := Format(nStr, [nIn.FDELIVERYORDERNO]);
    if not QueryDlg(nStr, MLang(sAsk)) then Exit;

    nLang := MLang('����ɾ��');
    ShowWaitForm(ParentForm, nLang);
    nWorker := gBusinessWorkerManager.LockWorker(sCLI_DeleteSaleBill);
    if not nWorker.WorkActive(@nIn, @nOut) then Exit;

    nEvent:= '�����[ %s ]���û�[ %s ]ɾ��.';
    nEvent := Format(nEvent, [nIn.FDELIVERYORDERNO,gSysParam.FUserID]);
    FDM.WriteSysLog(sFlag_TruckQueue, nIn.FDELIVERYORDERNO, nEvent);
    //����ɾ����־

    InitFormData(FWhere);
    nLang := MLang('������ɾ���ɹ�');
    nHint := MLang(sHint);
    ShowMsg(nLang, nHint);
  finally
    CloseWaitForm;
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

//Desc: ��ӡ�����
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

//Desc: ���������
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

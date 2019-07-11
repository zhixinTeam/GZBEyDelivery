unit UFrameQuerySaplog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IniFiles, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxMaskEdit, cxButtonEdit, cxTextEdit, Menus,
  UBitmapPanel, cxSplitter, cxLookAndFeels, cxLookAndFeelPainters,
  cxDropDownEdit;

type
  TfFrameQuerySapLog = class(TfFrameNormal)
    EditSerild: TcxButtonEdit;
    dxlytmLayout1Item1: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxlytmLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxlytmLayout1Item3: TdxLayoutItem;
    EditStatus: TcxComboBox;
    dxLayout1Item1: TdxLayoutItem;
    procedure EditDatePropertiesButtonClick(Sender: TObject;
    AButtonIndex: Integer);
    procedure EditSerildPropertiesButtonClick(Sender: TObject;
    AButtonIndex: Integer);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
 protected
    FStart,FEnd: TDate;
    //ʱ������
    FFilteDate: Boolean;
    //ɸѡ����
    FFields: string;
    //�����ֶ�
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
    procedure AfterInitFormData; override;
        procedure FormClose(Sender: TObject; var Action: TCloseAction);
    {*��ѯSQL*}
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;
implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UFormDateFilter, USysConst, USysDB, USysBusiness,
  UBusinessConst,USysLoger,UBusinessWorker, UBusinessPacker,UFormWait,
  UDataModule,UAdjustForm;
  
class function TfFrameQuerySapLog.FrameID: integer;
begin
  Result := cFI_FrameQSapLog;
end;

procedure TfFrameQuerySapLog.OnCreateFrame;
begin
  inherited;
  FFilteDate := True;

  AdjustCtrlData(EditStatus);

  EditStatus.ItemIndex := 0;
  InitDateRange(Name, FStart, FEnd);

end;
procedure TfFrameQuerySapLog.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

//------------------------------------------------------------------------------
function TfFrameQuerySapLog.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s �� %s', [Date2Str(FStart), Date2Str(FEnd)]);

  Result := 'Select * From $Status' ;
  //xxxxx

  if FFilteDate then
    Result := Result + ' Where ((S_DATE>=''$S'' and S_DATE <''$End'')) and S_Status = ''$zt'' ';
  //xxxxx

  if nWhere <> '' then
    if FFilteDate then
         Result := Result + ' And (' + nWhere + ')'
    else Result := Result + ' Where (' + nWhere + ')';
  //xxxxx

  Result := MacroValue(Result, [MI('$Status', sTable_SerialStatus),
            MI('$S', Date2Str(FStart)),MI('$End', Date2Str(FEnd + 1)),
            MI('$zt',GetCtrlData(EditStatus) )]);
  //xxxxx
end;

procedure TfFrameQuerySapLog.AfterInitFormData;
begin
  FFilteDate := True;
  inherited;
end;

//Desc: ����ɸѡ
procedure TfFrameQuerySapLog.EditDatePropertiesButtonClick(Sender: TObject ;
          AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;


//Desc: ִ�в�ѯ
procedure TfFrameQuerySapLog.EditSerildPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditSerild then
  begin
    EditSerild.Text := Trim(EditSerild.Text);
    if EditSerild.Text = '' then Exit;

    FWhere := 'S_SerailID like ''%%%s%%'' ';
    FWhere := Format(FWhere, [EditSerild.Text]);
    InitFormData(FWhere);
  end
end;

procedure TfFrameQuerySapLog.BtnEditClick(Sender: TObject);
var nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
  //  FIn: TWorkerCreateBillIn;
  //  FOut: TWorkerCreateBillOut;
    nIn: TWorkerDeleteBillIn;
    nOut: TBWDataBase;
    nStr: string;
begin
  nWorker := nil;
//
//  try
//    if cxView1.DataController.GetSelectedCount < 1 then
//    begin
//      ShowMsg('��ѡ��Ҫͬ���ļ�¼', sHint); Exit;
//    end;
//
//    if SQLQuery.FieldByName('S_QBill').AsString  <> '' then
//    begin
//        ShowMsg('��������ͬ��', sHint); Exit;
//    end;
//
//    nStr := SQLQuery.FieldByName('S_SerailID').AsString;
//    with FIn do
//    begin
//     FIn.FBase.FMsgNO :=  sFlag_ManualNo + nStr;
//     FIn.FBase.FKey   :=  '3';
//    end;
//
//    ShowWaitForm(ParentForm, '����ͬ��������');
//    //nWorker := gBusinessWorkerManager.LockWorker(sCLI_QueryCSaleBill);
////    if not nWorker.WorkActive(@FIn, @FOut) then
////    begin
////      gBusinessWorkerManager.RelaseWorker(nWorker);
////      Exit;
////    end;
//
//    nStr := 'Update %s set  S_Status = ''U''  Where S_SerailID=''%s''';
//    nStr := Format(nStr, [sTable_SerialStatus,SQLQuery.FieldByName('S_SerailID').AsString]);
//    FDM.ExecuteSQL(nStr);
//
//    InitFormData(FWhere);
//    ShowMsg('������ͬ���ɹ�', sHint);
//  finally
//    CloseWaitForm;
//    gBusinessWorkerManager.RelaseWorker(nWorker);
//  end;
end;

procedure TfFrameQuerySapLog.BtnDelClick(Sender: TObject);
var nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
    nIn: TWorkerDeleteBillIn;
    nOut: TBWDataBase;
   // nStr,nEvent: string;
begin
  nWorker := nil;

//  try
//    if cxView1.DataController.GetSelectedCount < 1 then
//    begin
//      ShowMsg('��ѡ��Ҫɾ���ļ�¼', sHint); Exit;
//    end;
//
//    nIn.FVBELN := SQLQuery.FieldByName('S_QBill').AsString;
//    nIn.FBase.FMsgNO := sFlag_ManualNo + sFlag_BillDel + nIn.FVBELN;
//
//    nStr := 'ȷ��Ҫɾ�����Ϊ[ %s ]�Ľ�������?';
//    nStr := Format(nStr, [nIn.FVBELN]);
//    if not QueryDlg(nStr, sAsk) then Exit;
//
//    ShowWaitForm(ParentForm, '����ɾ��');
//    nWorker := gBusinessWorkerManager.LockWorker(sCLI_QueryDSaleBill);
//    if not nWorker.WorkActive(@nIn, @nOut) then
//    begin
//      gBusinessWorkerManager.RelaseWorker(nWorker);
//      Exit;
//    end;
//
//    //����ɾ����������¼
//    nStr   := nIn.FVBELN;
//    nEvent := '������[%s]ͬ����ɾ��';
//    nEvent := Format(nEvent, [nIn.FVBELN]);
//    FDM.WriteSysLog(sTable_ExtInfo, nStr, nEvent);
//
//    InitFormData(FWhere);
//    ShowMsg('������ɾ���ɹ�', sHint);
//  finally
//    CloseWaitForm;
//    gBusinessWorkerManager.RelaseWorker(nWorker);
//  end;

end;

procedure TfFrameQuerySapLog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   ReleaseCtrlData(EditStatus);
end;


initialization
  gControlManager.RegCtrl(TfFrameQuerySapLog, TfFrameQuerySapLog.FrameID);
end.



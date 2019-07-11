{*******************************************************************************
  作者: dmzn@163.com 2009-6-12
  描述: 调账处理
*******************************************************************************}
unit UFormBillTiaoZhang;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormBase, cxGraphics, dxLayoutControl, StdCtrls,
  cxMaskEdit, cxDropDownEdit, cxMCListBox, cxMemo, cxContainer, cxEdit,
  cxTextEdit, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxSkinsCore, dxSkinsDefaultPainters, UBusinessConst, ComCtrls, cxListView,
  ImgList, cxListBox;

type
  TTfFormBillTiaoZhang = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditName: TcxTextEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    BtnOK: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    BtnExit: TButton;
    dxLayoutControl1Item11: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    EditID: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Group3: TdxLayoutGroup;
    EditCusCode: TcxTextEdit;
    dxLayoutControl1Item8: TdxLayoutItem;
    EditIDOrder: TcxTextEdit;
    dxLayoutControl1Item4: TdxLayoutItem;
    EditINum: TcxTextEdit;
    dxLayoutControl1Item5: TdxLayoutItem;
    EditOrder: TcxTextEdit;
    dxLayoutControl1Item6: TdxLayoutItem;
    EditCusName: TcxTextEdit;
    dxLayoutControl1Item7: TdxLayoutItem;
    EditProduCode: TcxTextEdit;
    dxLayoutControl1Item9: TdxLayoutItem;
    EditProduName: TcxTextEdit;
    dxLayoutControl1Item12: TdxLayoutItem;
    EditCrm: TcxTextEdit;
    dxLayoutControl1Item13: TdxLayoutItem;
    dxLayoutControl1Group4: TdxLayoutGroup;
    dxLayoutControl1Group2: TdxLayoutGroup;
    cxListView1: TcxListView;
    dxLayoutControl1Item199: TdxLayoutItem;
    ImageList1: TImageList;
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditIDKeyPress(Sender: TObject; var Key: Char);
    procedure EditNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    NDELIVERYNO: string;      //交货单号
    NDELIVERLISTNO:STRING;    //电子提货委托单
    FNum:string;
    FTZNum:string;
    Fin    : TWorkerDiaozhangBillIn;
    FOut   : TWorkerDiaozhangBillIn;
    nIn    : TWorkerROrderForCusin;
    nOut   : TWorkerROrderForCusOut;
    nListA,nListB : TStrings;
    //记录号
   procedure InitFormData(const nOut: PWorkerROrderForCusOut);
    //载入数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
   IniFiles,ULibFun, UMgrControl, UFormWait,UBusinessWorker, UBusinessPacker,
  UMgrLookupAdapter, USysBusiness, USysConst,USysDB,UAdjustForm,USysGrid,UMgrLang;

var
  gForm: TTfFormBillTiaoZhang = nil;
  //全局使用

function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TTfFormBillTiaoZhang.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

class function TTfFormBillTiaoZhang.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
     nIni: TIniFile;
     i :Integer;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TTfFormBillTiaoZhang.Create(Application) do
    begin

      Caption := MLang('调帐处理');

      FNum   := GetSerialNo(sFlag_BusGroup,sFlag_BillNo,False);
      FTZNum := GetSerialNo(sFlag_BusGroup,sFlag_TZBillNo,False); //红字交货单号

      nListA.Free;
      nListA := TStringList.Create;

      nListA.Delimiter := ',' ;
      nListA.DelimitedText :=  PackerDecodeStr(nP.FParamA);

       EditIDOrder.Text   := nListA.Values['交货单号'];
       EditINum.Text      := nListA.Values['交货量'];
       EditOrder.Text     := nListA.Values['订单编号'];
       EditCusCode.Text   := nListA.Values['客户编号'];
       EditCusName.Text   := nListA.Values['客户名称'];
       EditProduCode.Text := nListA.Values['品种编号'];
       EditProduName.Text := nListA.Values['品种名称'];
       EditCrm.Text       := nListA.Values['提货委托单'];

      NDELIVERYNO    :=   nListA.Values['交货单号'];         //交货单号
      NDELIVERLISTNO :=   nListA.Values['提货委托单'];        //电子提货委托单

      cxListView1.GridLines := True;

      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
  end;
end;

class function TTfFormBillTiaoZhang.FormID: integer;
begin
  Result := cFI_FormBillTiaoz;
end;

procedure TTfFormBillTiaoZhang.BtnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TTfFormBillTiaoZhang.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 调账
procedure TTfFormBillTiaoZhang.BtnOKClick(Sender: TObject);
var nStr,nLang,nHint: string;
    nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
begin
   if  cxListView1.SelCount  <= 0 then
   begin
       nLang :=  MLang('请选择需要的订单');
       nHint :=  MLang(sHint);
       exit;
   end;

   nWorker := nil;
   nPacker := nil;

   nStr := '交货单[%s]需调入到订单[%s]' +
            #13#10#13#10 +
           '确认请点"是",退出请点"否".';
   nLang :=  MLang(nStr);
   nStr := Format(nLang, [NDELIVERYNO,cxListView1.Selected.Caption]);
   if not QueryDlg(nStr,MLang(sAsk)) then Exit;

    nLang :=  MLang('系统正在进行调账');
    MLang('正在读取客户订单信息');
    ShowWaitForm(Self, nLang);
      try
        with Fin do
        begin
          FODELIVERYNO        := NDELIVERYNO;                                   //交货单号(旧)
          FDELIVERLISTNO      := NDELIVERLISTNO;                                //电子提货委托单号
          FORDERNO            := cxListView1.Selected.Caption;                  //订单号(新)
          FDELIVERYNO         := FNum;                                          //交货单号(新)
          FTZDELIVERYNO       := FTZNum;                                        //交货单号(红字交货单号)
          FPRODUCTCODE        := cxListView1.Selected.SubItems.Strings[2];      //产品编号
          FPRODUCTNAME        := cxListView1.Selected.SubItems.Strings[3];      //产品名称
          FCUSTOMCODE         := cxListView1.Selected.SubItems.Strings[4];      //客户编号
          FCUSTOMNAME         := cxListView1.Selected.SubItems.Strings[5];      //客户名称

          FBase.FMSGNO        := sFlag_ForceDone + sFlag_BillTiao + NDELIVERYNO;
          FBase.FKey          := FNum + ';' + FTZNum;

          nPacker := gBusinessPackerManager.LockPacker(sSAP_TiaoZSaleBill);
          nWorker := gBusinessWorkerManager.LockWorker(sCLI_TiaoZSaleBill);

          if not nWorker.WorkActive(@Fin,@FOut) then Exit;

          ShowMsg(MLang('调账成功'), MLang(sHint));
          ModalResult := mrOk;
        end;

       finally

       if ModalResult <> mrOk then
        BtnOK.Enabled := True;
        CloseWaitForm;

        gBusinessPackerManager.RelasePacker(nPacker);
        gBusinessWorkerManager.RelaseWorker(nWorker);
      end;
end;

procedure TTfFormBillTiaoZhang.EditIDKeyPress(Sender: TObject;
  var Key: Char);
var nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
    nStr,nLang :string;
begin
   if Key = #13  then
   begin
      nWorker := nil;
      nLang :=  MLang('正在读取客户订单信息');
      ShowWaitForm(Self, nLang);
      try
        with nIn do
        begin
          FCUSTOMCODE   := Trim(EditID.Text);
          FCUSTOMNAME   := Trim(EditName.Text);
          FBase.FMSGNO := sFlag_NotMatter;

          gBusinessPackerManager.RelasePacker(nPacker);
          nPacker := gBusinessPackerManager.LockPacker(sSAP_TiaoZROrder);
          nWorker := gBusinessWorkerManager.LockWorker(sCLI_ROrderForCus);
          if not nWorker.WorkActive(@nIn,@nOut) then Exit;

           CloseWaitForm;
           Application.ProcessMessages;
           InitFormData(@nOut);
          //load list
        end;

       finally
        gBusinessPackerManager.RelasePacker(nPacker);
        gBusinessWorkerManager.RelaseWorker(nWorker);
      end;
   end;

end;

 //Desc: 载入客户编号读取订单返回信息
procedure TTfFormBillTiaoZhang.EditNameKeyPress(Sender: TObject;
  var Key: Char);
var nPacker: TBusinessPackerBase;
    nWorker: TBusinessWorkerBase;
    nStr,nLang :string;
begin
   if Key = #13  then
   begin

      nWorker := nil;
      nLang :=  MLang('正在读取客户订单信息');
      ShowWaitForm(Self, nLang);

      try

        with nIn do
        begin
          FCUSTOMCODE   := Trim(EditID.Text);
          FCUSTOMNAME   := Trim(EditName.Text);
          FBase.FMSGNO := sFlag_NotMatter;

          gBusinessPackerManager.RelasePacker(nPacker);
          nPacker := gBusinessPackerManager.LockPacker(sSAP_TiaoZROrder);
          nWorker := gBusinessWorkerManager.LockWorker(sCLI_ROrderForCus);
          if not nWorker.WorkActive(@nIn,@nOut) then Exit;

          CloseWaitForm;
          Application.ProcessMessages;
          InitFormData(@nOut);
          //load list
        end;

       finally
         CloseWaitForm;
        gBusinessPackerManager.RelasePacker(nPacker);
        gBusinessWorkerManager.RelaseWorker(nWorker);
      end;
   end;
 end;

 //Desc: 载入客户编号读取订单返回信息
procedure TTfFormBillTiaoZhang.InitFormData(const nOut: PWorkerROrderForCusOut);
var  nPacker: TBusinessPackerBase;
     nstr: string;
     nIdx: Integer;
     FList: TStrings;
     nItem: TListItem;
begin

    nPacker := gBusinessPackerManager.LockPacker(sSAP_TiaoZROrder);
    FList := TStringList.Create;

    with nPacker do
    begin
      StrBuilder.Text := PackerDecodeStr(nOut.FData);

      cxListView1.Clear;
      for nIdx:=0 to StrBuilder.Count - 1 do
      begin
        FList.Text := PackerDecodeStr(StrBuilder[nIdx]);
         nItem := cxListView1.Items.Add;
         nItem.Caption :=  FList.Values['orderCode'];
         nItem.SubItems.Add( FList.Values['amount']);
         nItem.SubItems.Add( FList.Values['surplusAmount']);
         nItem.SubItems.Add( FList.Values['productCode']);
         nItem.SubItems.Add( FList.Values['productName']);
         nItem.SubItems.Add( FList.Values['cusCode']);
         nItem.SubItems.Add( FList.Values['cusName']);
      end;
    end;
    FList.Free;
    gBusinessPackerManager.RelasePacker(nPacker);
end;

procedure TTfFormBillTiaoZhang.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
   nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self,nIni);
    SavecxListViewConfig(Name, cxListView1, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TTfFormBillTiaoZhang.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  inherited;
   
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
        gMultiLangManager.SectionID := 'TTfFormBillTiaoZhang';
    gMultiLangManager.TranslateAllCtrl(Self);
    LoadFormConfig(Self, nIni);
    LoadcxListViewConfig(Name, cxListView1, nIni);
  finally
    nIni.Free;
  end;
end;

initialization
  gControlManager.RegCtrl(TTfFormBillTiaoZhang, TTfFormBillTiaoZhang.FormID);
end.

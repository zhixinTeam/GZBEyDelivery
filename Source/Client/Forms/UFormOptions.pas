{*******************************************************************************
  作者: dmzn@163.com 2012-3-31
  描述: 系统设置
*******************************************************************************}
unit UFormOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPC, dxLayoutControl, StdCtrls, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCheckBox, cxMCListBox,
  Menus, cxButtons;

type
  TfFormOptions = class(TfFormNormal)
    wPage: TcxPageControl;
    dxLayout1Item3: TdxLayoutItem;
    Sheet1: TcxTabSheet;
    Sheet2: TcxTabSheet;
    Sheet3: TcxTabSheet;
    EditFactID: TcxTextEdit;
    Label1: TLabel;
    Label2: TLabel;
    CheckViaCard: TcxCheckBox;
    CheckPoundDai: TcxCheckBox;
    ListStockPrint: TcxMCListBox;
    Label6: TLabel;
    EditStockId: TcxTextEdit;
    EditStockName: TcxTextEdit;
    BtnAdd: TcxButton;
    BtnDel: TcxButton;
    cxTabSheet1: TcxTabSheet;
    ListStockNF: TcxMCListBox;
    Label8: TLabel;
    EditStockId2: TcxTextEdit;
    BtnDel2: TcxButton;
    BtnAdd2: TcxButton;
    EditStockName2: TcxTextEdit;
    Label9: TLabel;
    cxTabSheet2: TcxTabSheet;
    ListStockLine: TcxMCListBox;
    EditStockId3: TcxTextEdit;
    Label10: TLabel;
    Label11: TLabel;
    EditStockName3: TcxTextEdit;
    BtnDel3: TcxButton;
    BtnAdd3: TcxButton;
    Label14: TLabel;
    EditDaiWuChaZ: TcxTextEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    EditDaiWuChaF: TcxTextEdit;
    Label19: TLabel;
    Label30: TLabel;
    EditSanWuChaZ: TcxTextEdit;
    lbl2: TLabel;
    Label31: TLabel;
    EditSanWuChaF: TcxTextEdit;
    lbl4: TLabel;
    cxTabSheet3: TcxTabSheet;
    ListStockBreed: TcxMCListBox;
    lbl5: TLabel;
    EditStockId4: TcxTextEdit;
    BtnDel4: TcxButton;
    lbl6: TLabel;
    EditStockName4: TcxTextEdit;
    BtnAdd4: TcxButton;
    CheckFSanZStop: TcxCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    EditStockType3: TcxTextEdit;
    procedure wPageChange(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditFactIDPropertiesChange(Sender: TObject);
    procedure CheckViaCardClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDel2Click(Sender: TObject);
    procedure BtnAdd2Click(Sender: TObject);
    procedure BtnAdd3Click(Sender: TObject);
    procedure BtnDel3Click(Sender: TObject);
    procedure BtnAdd4Click(Sender: TObject);
    procedure BtnDel4Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData;
    procedure LoadBaseParam;
    procedure SaveBaseParam;
    //基本参数
    procedure LoadPoundData;
    procedure SavePoundData;
    procedure ShowStytlePoundDataEn;
    //磅站参数
    procedure LoadPrintStock;
    procedure SavePrintStock;
    procedure LoadPrintStockList;
    procedure ShowStytlePrintStockEn;
    //打印品种
    procedure LoadNFStock;
    procedure SaveNFStock;
    procedure LoadNFStockList;
    procedure ShowStytleNFStockListEn;
    //无需发货
    procedure LoadLineStock;
    procedure SaveLineStock;
    procedure LoadLineStockList;
    procedure ShowStytleLineStockListEn;
    //通道品种
    procedure LoadLineBreed;
    procedure SaveLineBreed;
    procedure LoadLineBreedList;
    procedure ShowStytleLineBreedListEn;
    //水泥品种类型
  public
    { Public declarations }
    class function FormID: integer; override;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    //base
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UMgrControl, UDataModule, UFormCtrl, USysDB, USysConst, UMgrLang;

type
  TSysParam = record
    FLoaded:   Boolean;
    FSaved:    Boolean;
    FPoundDai: string;
    FViaCard:  string;
    FSanStop:  string;
  end;

  TPoundParam = record
    FLoaded: Boolean;
    FSaved: Boolean;
    FFactID: string;
    FPoundID: string;
    FPoundDaiWuChaZ: string;                               //包装正误差 20130708
    FPoundDaiWuChaF: string;                               //包装负误差 20130708
    FPoundSanWuChaZ: string;                               //散装正误差 20130708
    FPoundSanWuChaF: string;                               //散装负误差 20130708
  end;

  TStockItem = record
    FID: string;
    FName: string;
    FTYPE: string;
    FEnabled: Boolean;
  end;

  TPrintStock = record
    FLoaded: Boolean;
    FSaved: Boolean;
    FItems: array of TStockItem;
  end;

  TNoFangHuiStock = record
    FLoaded: Boolean;
    FSaved: Boolean;
    FItems: array of TStockItem;
  end;

  TLineStock = record
    FLoaded: Boolean;
    FSaved: Boolean;
    FItems: array of TStockItem;
  end;

   TLineBreed = record
    FLoaded: Boolean;
    FSaved: Boolean;
    FItems: array of TStockItem;
  end;
var
  gSysParam: TSysParam;
  //系统参数
  gPoundParam: TPoundParam;
  //磅站参数
  gPrintStock: TPrintStock;
  //需打印品种
  gNFStock: TNoFangHuiStock;
  //无需放灰品种
  gLineStock: TLineStock;
  //发货通道品种
  gLineBreed: TLineBreed;
  //水泥类型维护


function MLang(const nStr: string): string;
begin
  gMultiLangManager.SectionID := TfFormOptions.ClassName;
  Result := gMultiLangManager.GetTextByText(nStr);
end;

class function TfFormOptions.FormID: integer;
begin
  Result := cFI_FormOptions;
end;

class function TfFormOptions.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormOptions.Create(Application) do
  begin
    Caption := MLang('参数设置');
    ShowStytlePoundDataEn;
    ShowStytlePrintStockEn;
    ShowStytleNFStockListEn;
    ShowStytleLineStockListEn;
    ShowStytleLineBreedListEn;

    InitFormData;
    ShowModal;
    Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormOptions.InitFormData;
begin
  gSysParam.FLoaded := False;
  gPoundParam.FLoaded := False;
  gPrintStock.FLoaded := False;
  gNFStock.FLoaded := False;
  gLineStock.FLoaded := False;
  gLineBreed.FLoaded := False;
  wPage.ActivePage := Sheet1;
  LoadBaseParam;
end;

procedure TfFormOptions.LoadBaseParam;
var nStr: string;
begin
  with gSysParam do
  begin
    FLoaded := True;
    FSaved := True;
  end;

  nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s'' or D_Name = ''%s'' ';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam,sFlag_PoundWuCha]);

  with FDM.QueryTemp(nStr,FALSE) do
  if RecordCount > 0 then
  begin
   First;

    while not Eof do
    begin
      if Fields[1].AsString = sFlag_ViaBillCard then
        gSysParam.FViaCard := Fields[0].AsString
      else
      if Fields[1].AsString = sFlag_PoundIfDai then
        gSysParam.FPoundDai := Fields[0].AsString
        else
      if Fields[1].AsString = sFlag_PoundSanStopZ then
        gSysParam.FSanStop := Fields[0].AsString;
      Next;
    end;
  end;

  with gSysParam do
  begin
    CheckViaCard.Checked   := FViaCard  = sFlag_Yes;
    CheckPoundDai.Checked  := FPoundDai = sFlag_Yes;
    CheckFSanZStop.Checked := FSanStop  = sFlag_Yes;
  end;
end;

procedure TfFormOptions.SaveBaseParam;
var nStr: string;
begin
  with gSysParam do
  begin
    nStr := 'Update %s Set D_Value=''%s'' Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, FViaCard, sFlag_SysParam,
            sFlag_ViaBillCard]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set D_Value=''%s'' Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, FPoundDai, sFlag_SysParam,
            sFlag_PoundIfDai]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Update %s Set D_Value=''%s'' Where D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, FSanStop, sFlag_PoundWuCha,
            sFlag_PoundSanStopZ]);
    FDM.ExecuteSQL(nStr);

    FSaved := True;
  end;
end;

procedure TfFormOptions.LoadPoundData;
var nStr: string;
begin
  with gPoundParam do
  begin
    FLoaded := True;
    FSaved := True;
  end;

  nStr := 'Select D_Value From %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_SysParam, sFlag_FactID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    gPoundParam.FFactID := Fields[0].AsString;
  end;
                                                                //工厂编号

  nStr := 'Select D_Value from %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundWuCha, sFlag_PDaiWuChaZ]);

  with FDM.QueryTemp(nStr, False) do
  if RecordCount > 0 then
  begin
    gPoundParam.FPoundDaiWuChaZ := Fields[0].AsString;
  end;                                                    //袋装正误差

  nStr := 'Select D_Value from %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundWuCha, sFlag_PDaiWuChaF]);

  with FDM.QueryTemp(nStr, False) do
  if RecordCount > 0 then
  begin
    gPoundParam.FPoundDaiWuChaF := Fields[0].AsString;
  end;                                                    //散装负误差

  nStr := 'Select D_Value from %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundWuCha, sFlag_PSanWuChaZ]);

  with FDM.QueryTemp(nStr, False) do
  if RecordCount > 0 then
  begin
    gPoundParam.FPoundSanWuChaZ := Fields[0].AsString;
  end;                                                    //散装正误差

  nStr := 'Select D_Value from %s Where D_Name=''%s'' And D_Memo=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundWuCha, sFlag_PSanWuChaF]);

  with FDM.QueryTemp(nStr, False) do
  if RecordCount > 0 then
  begin
    gPoundParam.FPoundSanWuChaF := Fields[0].AsString;
  end;
                                                       //散装负误差
  with gPoundParam do
  begin
    EditFactID.Text := FFactID;
    EditDaiWuChaZ.Text := FPoundDaiWuChaZ;
    EditDaiWuChaF.Text := FPoundDaiWuChaF;
    EditSanWuChaZ.Text := FPoundSanWuChaZ;
    EditSanWuChaF.Text := FPoundSanWuChaF;
  end;
end;

procedure TfFormOptions.SavePoundData;
var nStr: string;
begin
  with gPoundParam do
  begin
    if FSaved then Exit;
    nStr := 'Update %s Set D_Value=''%s'' Where ' +
            'D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, FFactID,
            sFlag_SysParam, sFlag_FactID]);
    FDM.ExecuteSQL(nStr, False);

    nStr := 'Update %s Set D_Value=''%s'' Where ' +
            'D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, FPoundDaiWuChaZ,
            sFlag_PoundWuCha, sFlag_PDaiWuChaZ]);
    FDM.ExecuteSQL(nStr, False);                         // 袋装正误差

    nStr := 'Update %s Set D_Value=''%s'' Where ' +
            'D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, FPoundDaiWuChaF,
            sFlag_PoundWuCha, sFlag_PDaiWuChaF]);
    FDM.ExecuteSQL(nStr, False);                         // 袋装负误差

        nStr := 'Update %s Set D_Value=''%s'' Where ' +
            'D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, FPoundSanWuChaZ,
            sFlag_PoundWuCha, sFlag_PSanWuChaZ]);
    FDM.ExecuteSQL(nStr, False);                         // 散装正误差

    nStr := 'Update %s Set D_Value=''%s'' Where ' +
            'D_Name=''%s'' And D_Memo=''%s''';
    nStr := Format(nStr, [sTable_SysDict, FPoundSanWuChaF,
            sFlag_PoundWuCha, sFlag_PSanWuChaF]);
    FDM.ExecuteSQL(nStr, False);                         // 散装负误差


    FSaved := True;
  end;
end;

procedure TfFormOptions.ShowStytlePoundDataEn;
var  i,nCount,nW,nR: Integer;
begin
  if CompareText('en', gMultiLangManager.LangID) = 0 then
  begin

  //只处理英文布局
  nW := 0;
  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 10) and (Components[i] is TLabel) then
      nW := TLabel(Components[i]).Width ;
  //第一列标签最大宽度

  nR := Label1.Left + nW;
  //第一列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 10 then
    TLabel(Components[i]).Left := nR -  TLabel(Components[i]).Width;
  //调整第一列标签左边界

  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 20 then
   TcxTextEdit(Components[i]).Left := nR + 3;
  //调整第二列文本框左边界

  nR := nR + 3 + EditFactID.Width;
  //第二列右边界
  nW := 0;

  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 30) and (TLabel(Components[i]).Width > nW) then
    nW :=TLabel(Components[i]).Width;
  //第三列标签最大宽度

  nR := nR + nW;
  //第三列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 30 then
   TLabel(Components[i]).Left := nR - TLabel(Components[i]).Width;
  //调整第三列标签左边界
  end;
end;

//----------------------------------------------------------------------------

procedure TfFormOptions.LoadPrintStock;
var nStr: string;
    nIdx: Integer;
begin
  with gPrintStock do
  begin
    FLoaded := True;
    FSaved := True;
    SetLength(FItems, 0);

    nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_PrintBill]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then Exit;
      SetLength(FItems, RecordCount);

      nIdx := 0;
      First;

      while not Eof do
      begin
        with FItems[nIdx] do
        begin
          FID := Fields[0].AsString;
          FName := Fields[1].AsString;
          FEnabled := True;
        end;

        Inc(nIdx);
        Next;
      end;

      LoadPrintStockList;
    end;
  end;
end;

procedure TfFormOptions.LoadPrintStockList;
var nIdx: Integer;
begin
  with gPrintStock do
  begin
    ListStockPrint.Clear;
    for nIdx:=Low(FItems) to High(FItems) do
     with FItems[nIdx] do
      if FEnabled then
       ListStockPrint.Items.AddObject(FID + ListStockPrint.Delimiter + FName, Pointer(nIdx));
    //items
  end;
end;

procedure TfFormOptions.SavePrintStock;
var nStr: string;
    nIdx: Integer;
begin
  with gPrintStock do
  begin
    nStr := 'Delete From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_PrintBill]);
    FDM.ExecuteSQL(nStr);

    for nIdx:=Low(FItems) to High(FItems) do
    with FItems[nIdx] do
    begin
      if not FEnabled then Continue;
      nStr := MakeSQLByStr([SF('D_Name', sFlag_PrintBill),
              SF('D_Desc', '需打印单品种'),
              SF('D_Value', FID), SF('D_Memo', FName)
              ], sTable_SysDict, '', True);
      FDM.ExecuteSQL(nStr);
    end;

    FSaved := True;
  end;
end;

procedure TfFormOptions.ShowStytlePrintStockEn;
var  i,nCount,nW,nR: Integer;
begin
  if CompareText('en', gMultiLangManager.LangID) = 0 then
  begin

  //只处理英文布局
  nW := 0;
  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 40) and (Components[i] is TLabel) then
      nW := TLabel(Components[i]).Width ;
  //第一列标签最大宽度

  nR := Label1.Left + nW;
  //第一列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 40 then
    TLabel(Components[i]).Left := nR -  TLabel(Components[i]).Width;
  //调整第一列标签左边界

  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 50 then
   TcxTextEdit(Components[i]).Left := nR + 3;
  //调整第二列文本框左边界

  nR := nR +  EditStockId.Width;
  //第二列右边界
  nW := 0;

  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 60) and (TcxButton(Components[i]).Width > nW) then
    nW :=TcxButton(Components[i]).Width;
  //第三列标签最大宽度

  nR := nR + nW;
  //第三列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 60 then
   TcxButton(Components[i]).Left := nR - TcxButton(Components[i]).Width;
  //调整第三列标签左边界
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormOptions.LoadNFStock;
var nStr: string;
    nIdx: Integer;
begin
  with gNFStock do
  begin
    FLoaded := True;
    FSaved := True;
    SetLength(FItems, 0);

    nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then Exit;
      SetLength(FItems, RecordCount);

      nIdx := 0;
      First;

      while not Eof do
      begin
        with FItems[nIdx] do
        begin
          FID := Fields[0].AsString;
          FName := Fields[1].AsString;
          FEnabled := True;
        end;

        Inc(nIdx);
        Next;
      end;

      LoadNFStockList;
    end;
  end;
end;

procedure TfFormOptions.SaveNFStock;
var nStr: string;
    nIdx: Integer;
begin
  with gNFStock do
  begin
    nStr := 'Delete From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_NFStock]);
    FDM.ExecuteSQL(nStr);

    for nIdx:=Low(FItems) to High(FItems) do
    with FItems[nIdx] do
    begin
      if not FEnabled then Continue;
      nStr := MakeSQLByStr([SF('D_Name', sFlag_NFStock),
              SF('D_Desc', '无需发货品种'),
              SF('D_Value', FID), SF('D_Memo', FName)
              ], sTable_SysDict, '', True);
      FDM.ExecuteSQL(nStr);
    end;

    FSaved := True;
  end;
end;

procedure TfFormOptions.LoadNFStockList;
var nIdx: Integer;
begin
  with gNFStock do
  begin
    ListStockNF.Clear;
    for nIdx:=Low(FItems) to High(FItems) do
     with FItems[nIdx] do
      if FEnabled then
       ListStockNF.Items.AddObject(FID + ListStockNF.Delimiter + FName, Pointer(nIdx));
    //items
  end;
end;

procedure TfFormOptions.ShowStytleNFStockListEn;
var  i,nCount,nW,nR: Integer;
begin
  if CompareText('en', gMultiLangManager.LangID) = 0 then
  begin

  //只处理英文布局
  nW := 0;
  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 40) and (Components[i] is TLabel) then
      nW := TLabel(Components[i]).Width ;
  //第一列标签最大宽度

  nR := Label1.Left + nW;
  //第一列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 40 then
    TLabel(Components[i]).Left := nR -  TLabel(Components[i]).Width;
  //调整第一列标签左边界

  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 50 then
   TcxTextEdit(Components[i]).Left := nR + 3;
  //调整第二列文本框左边界

  nR := nR + 3 + EditStockId2.Width;
  //第二列右边界
  nW := 0;

  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 60) and (TcxButton(Components[i]).Width > nW) then
    nW :=TcxButton(Components[i]).Width;
  //第三列标签最大宽度

  nR := nR + nW;
  //第三列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 60 then
   TcxButton(Components[i]).Left := nR - TcxButton(Components[i]).Width;
  //调整第三列标签左边界
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormOptions.LoadLineStock;
var nStr: string;
    nIdx: Integer;
begin
  with gLineStock do
  begin
    FLoaded := True;
    FSaved := True;
    SetLength(FItems, 0);

    nStr := 'Select D_Value,D_Memo ,D_ParamB From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_LineStock]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then Exit;
      SetLength(FItems, RecordCount);

      nIdx := 0;
      First;

      while not Eof do
      begin
        with FItems[nIdx] do
        begin
          FID := Fields[0].AsString;
          FName := Fields[1].AsString;
          FTYPE := Fields[2].AsString;
          FEnabled := True;
        end;

        Inc(nIdx);
        Next;
      end;

      LoadLineStockList;
    end;
  end;
end;

procedure TfFormOptions.LoadLineStockList;
var nIdx: Integer;
begin
  with gLineStock do
  begin
    ListStockLine.Clear;
    for nIdx:=Low(FItems) to High(FItems) do
     with FItems[nIdx] do
      if FEnabled then
       ListStockLine.Items.AddObject(FID + ListStockLine.Delimiter + FName + ListStockLine.Delimiter + FTYPE , Pointer(nIdx));
    //items
  end;
end;

procedure TfFormOptions.SaveLineStock;
var nStr: string;
    nIdx: Integer;
begin
  with gLineStock do
  begin
    nStr := 'Delete From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_LineStock]);
    FDM.ExecuteSQL(nStr);

    for nIdx:=Low(FItems) to High(FItems) do
    with FItems[nIdx] do
    begin
      if not FEnabled then Continue;
      nStr := MakeSQLByStr([SF('D_Name', sFlag_LineStock),
              SF('D_Desc', '发货通道品种'),
              SF('D_Value', FID), SF('D_Memo', FName),
              SF('D_ParamB',FTYPE)
              ], sTable_SysDict, '', True);
      FDM.ExecuteSQL(nStr);
    end;

    FSaved := True;
  end;
end;

procedure TfFormOptions.ShowStytleLineStockListEn;
var  i,nCount,nW,nR: Integer;
begin
  if CompareText('en', gMultiLangManager.LangID) = 0 then
  begin

  //只处理英文布局
  nW := 0;
  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 40) and (Components[i] is TLabel) then
      nW := TLabel(Components[i]).Width ;
  //第一列标签最大宽度

  nR := Label1.Left + nW;
  //第一列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 40 then
    TLabel(Components[i]).Left := nR -  TLabel(Components[i]).Width;
  //调整第一列标签左边界

  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 50 then
   TcxTextEdit(Components[i]).Left := nR + 3;
  //调整第二列文本框左边界

  nR := nR + 3 + EditStockId3.Width;
  //第二列右边界
  nW := 0;

  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 60) and (TcxButton(Components[i]).Width > nW) then
    nW :=TcxButton(Components[i]).Width;
  //第三列标签最大宽度

  nR := nR + nW;
  //第三列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 60 then
   TcxButton(Components[i]).Left := nR - TcxButton(Components[i]).Width;
  //调整第三列标签左边界
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormOptions.LoadLineBreed;
var nStr: string;
    nIdx: Integer;
begin
  with gLineBreed do
  begin
    FLoaded := True;
    FSaved := True;
    SetLength(FItems, 0);

    nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_LineBreed]);

    with FDM.QueryTemp(nStr) do
    begin
      if RecordCount < 1 then Exit;
      SetLength(FItems, RecordCount);

      nIdx := 0;
      First;

      while not Eof do
      begin
        with FItems[nIdx] do
        begin
          FID := Fields[0].AsString;
          FName := Fields[1].AsString;
          FEnabled := True;
        end;

        Inc(nIdx);
        Next;
      end;

      LoadLineBreedList;
    end;
  end;
end;

procedure TfFormOptions.LoadLineBreedList;
var nIdx: Integer;
begin
  with gLineBreed do
  begin
    ListStockBreed.Clear;
    for nIdx:=Low(FItems) to High(FItems) do
     with FItems[nIdx] do
      if FEnabled then
       ListStockBreed.Items.AddObject(FID + ListStockBreed.Delimiter + FName, Pointer(nIdx));
    //items
  end;
end;

procedure TfFormOptions.SaveLineBreed;
var nStr: string;
    nIdx: Integer;
begin
  with gLineBreed do
  begin
    nStr := 'Delete From %s Where D_Name=''%s''';
    nStr := Format(nStr, [sTable_SysDict, sFlag_LineBreed]);
    FDM.ExecuteSQL(nStr);

    for nIdx:=Low(FItems) to High(FItems) do
    with FItems[nIdx] do
    begin
      if not FEnabled then Continue;
      nStr := MakeSQLByStr([SF('D_Name', sFlag_LineBreed),
              SF('D_Desc', '水泥类型'),
              SF('D_Value', FID), SF('D_Memo', FName)
              ], sTable_SysDict, '', True);
      FDM.ExecuteSQL(nStr);
    end;

    FSaved := True;
  end;
end;

procedure TfFormOptions.ShowStytleLineBreedListEn;
var  i,nCount,nW,nR: Integer;
begin
  if CompareText('en', gMultiLangManager.LangID) = 0 then
  begin

  //只处理英文布局
  nW := 0;
  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 40) and (Components[i] is TLabel) then
      nW := TLabel(Components[i]).Width ;
  //第一列标签最大宽度

  nR := Label1.Left + nW;
  //第一列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 40 then
    TLabel(Components[i]).Left := nR -  TLabel(Components[i]).Width;
  //调整第一列标签左边界

  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 50 then
   TcxTextEdit(Components[i]).Left := nR + 3;
  //调整第二列文本框左边界

  nR := nR + 3 + EditStockId4.Width;
  //第二列右边界
  nW := 0;

  for i:=0 to ComponentCount  - 1 do
   if (Components[i].Tag = 60) and (TcxButton(Components[i]).Width > nW) then
    nW :=TcxButton(Components[i]).Width;
  //第三列标签最大宽度

  nR := nR + nW;
  //第三列标签右边界
  for i:=0 to ComponentCount  - 1 do
   if Components[i].Tag = 60 then
   TcxButton(Components[i]).Left := nR - TcxButton(Components[i]).Width;
  //调整第三列标签左边界
  end;
end;
//------------------------------------------------------------------------------
procedure TfFormOptions.wPageChange(Sender: TObject);
begin
  case wPage.ActivePageIndex of
   0: if not gSysParam.FLoaded then LoadBaseParam;
   1: if not gPoundParam.FLoaded then LoadPoundData;
   2: if not gPrintStock.FLoaded then LoadPrintStock;
   3: if not gNFStock.FLoaded then LoadNFStock;
   4: if not gLineStock.FLoaded then LoadLineStock;
   5: if not gLineBreed.FLoaded then LoadLineBreed;
  end;
end;

procedure TfFormOptions.CheckViaCardClick(Sender: TObject);
begin
  with gSysParam do
  begin
    if Sender = CheckViaCard then
    begin
      if CheckViaCard.Checked then
           FViaCard := sFlag_Yes
      else FViaCard := sFlag_No;
    end else

    if Sender = CheckPoundDai then
    begin
      if CheckPoundDai.Checked then
           FPoundDai := sFlag_Yes
      else FPoundDai := sFlag_No;
    end else

    if Sender = CheckFSanZStop then
    begin
      if CheckFSanZStop.Checked then
           FSanStop := sFlag_Yes
      else FSanStop := sFlag_No;
    end;

    FSaved := False;
  end;
end;

procedure TfFormOptions.EditFactIDPropertiesChange(Sender: TObject);
begin
  with gPoundParam do
  begin
    if Sender = EditFactID then FFactID := Trim(EditFactID.Text);
    if Sender = EditDaiWuChaZ then FPoundDaiWuChaZ := Trim(EditDaiWuChaZ.Text);
    if Sender = EditDaiWuChaF then FPoundDaiWuChaF := Trim(EditDaiWuChaF.Text);
    if Sender = EditSanWuChaZ then FPoundSanWuChaZ := Trim(EditSanWuChaZ.Text);
    if Sender = EditSanWuChaF then FPoundSanWuChaF := Trim(EditSanWuChaF.Text);
    FSaved := False;
  end;
end;

procedure TfFormOptions.BtnAddClick(Sender: TObject);
var nIdx: Integer;
    nLang,nHint: string;
begin
  EditStockId.Text := Trim(EditStockId.Text);
  EditStockName.Text := Trim(EditStockName.Text);

  with gPrintStock do
  begin
    for nIdx:=Low(FItems) to High(FItems) do
    if (CompareText(FItems[nIdx].FID, EditStockId.Text) = 0) and
       (FItems[nIdx].FEnabled) then
    begin
      EditStockId.SetFocus;
      nLang := MLang('编号已存在');
      nHint := MLang(sHint);
      ShowMsg(nLang, nHint); Exit;
    end;

    nIdx := Length(FItems);
    SetLength(FItems, nIdx + 1);

    with FItems[nIdx] do
    begin
      FID := EditStockId.Text;
      FName := EditStockName.Text;
      FEnabled := True;
    end;

    FSaved := False;
    LoadPrintStockList;
  end;
end;

procedure TfFormOptions.BtnDelClick(Sender: TObject);
var nIdx: Integer;
begin
  if ListStockPrint.ItemIndex > -1 then
  with gPrintStock do
  begin
    nIdx := Integer(ListStockPrint.Items.Objects[ListStockPrint.ItemIndex]);
    FItems[nIdx].FEnabled := False;

    FSaved := False;
    LoadPrintStockList;
  end;
end;

procedure TfFormOptions.BtnDel2Click(Sender: TObject);
var nIdx: Integer;
begin
  if ListStockNF.ItemIndex > -1 then
  with gNFStock do
  begin
    nIdx := Integer(ListStockNF.Items.Objects[ListStockNF.ItemIndex]);
    FItems[nIdx].FEnabled := False;

    FSaved := False;
    LoadNFStockList;
  end;
end;

procedure TfFormOptions.BtnDel4Click(Sender: TObject);
var nIdx: Integer;
begin
  if ListStockBreed.ItemIndex > -1 then
  with gLineBreed do
  begin
    nIdx := Integer(ListStockBreed.Items.Objects[ListStockBreed.ItemIndex]);
    FItems[nIdx].FEnabled := False;

    FSaved := False;
    LoadLineBreedList;
  end;
end;

procedure TfFormOptions.BtnAdd2Click(Sender: TObject);
var nIdx: Integer;
    nLang,nHint: string;
begin
  EditStockId2.Text := Trim(EditStockId2.Text);
  EditStockName2.Text := Trim(EditStockName2.Text);

  with gNFStock do
  begin
    for nIdx:=Low(FItems) to High(FItems) do
    if (CompareText(FItems[nIdx].FID, EditStockId2.Text) = 0) and
       (FItems[nIdx].FEnabled) then
    begin
      EditStockId2.SetFocus;
      nLang := MLang('编号已存在');
      nHint := MLang(sHint);
      ShowMsg(nLang, nHint); Exit;
    end;

    nIdx := Length(FItems);
    SetLength(FItems, nIdx + 1);

    with FItems[nIdx] do
    begin
      FID := EditStockId2.Text;
      FName := EditStockName2.Text;
      FEnabled := True;
    end;

    FSaved := False;
    LoadNFStockList;
  end;
end;

procedure TfFormOptions.BtnDel3Click(Sender: TObject);
var nIdx: Integer;
begin
  if ListStockLine.ItemIndex > -1 then
  with gLineStock do
  begin
    nIdx := Integer(ListStockLine.Items.Objects[ListStockLine.ItemIndex]);
    FItems[nIdx].FEnabled := False;

    FSaved := False;
    LoadLineStockList;
  end;
end;

procedure TfFormOptions.BtnAdd3Click(Sender: TObject);
var nIdx: Integer;
    nLang,nHint: string;
begin
  EditStockId3.Text := Trim(EditStockId3.Text);
  EditStockName3.Text := Trim(EditStockName3.Text);
  EditStockType3.Text := Trim(EditStockType3.Text);

  with gLineStock do
  begin
    for nIdx:=Low(FItems) to High(FItems) do
    if (CompareText(FItems[nIdx].FID, EditStockId3.Text) = 0) and
       (FItems[nIdx].FEnabled) then
    begin
      EditStockId3.SetFocus;
      nLang := MLang('编号已存在');
      nHint := MLang(sHint);
      ShowMsg(nLang, nHint); Exit;
    end;

    nIdx := Length(FItems);
    SetLength(FItems, nIdx + 1);

    with FItems[nIdx] do
    begin
      FID := EditStockId3.Text;
      FName := EditStockName3.Text;
      FTYPE := EditStockType3.Text;
      FEnabled := True;
    end;

    FSaved := False;
    LoadLineStockList;
  end;
end;

procedure TfFormOptions.BtnAdd4Click(Sender: TObject);
var nIdx: Integer;
    nLang,nHint: string;
begin
  EditStockId4.Text := Trim(EditStockId4.Text);
  EditStockName4.Text := Trim(EditStockName4.Text);
  
  with gLineBreed do
  begin
    for nIdx:=Low(FItems) to High(FItems) do
    if (CompareText(FItems[nIdx].FID, EditStockId4.Text) = 0) and
       (FItems[nIdx].FEnabled) then
    begin
      EditStockId4.SetFocus;
      nLang := MLang('编号已存在');
      nHint := MLang(sHint);
      ShowMsg(nLang, nHint); Exit;
    end;

    nIdx := Length(FItems);
    SetLength(FItems, nIdx + 1);

    with FItems[nIdx] do
    begin
      FID := EditStockId4.Text;
      FName := EditStockName4.Text;
      FEnabled := True;
    end;

    FSaved := False;
    LoadLineBreedList;
  end;
end;

//Desc: 保存数据
procedure TfFormOptions.BtnOKClick(Sender: TObject);
var nLang,nHint:string;
begin
  with gSysParam do
    if FLoaded and (not FSaved) then SaveBaseParam;
  //xxxxx

  with gPoundParam do
    if FLoaded and (not FSaved) then SavePoundData;
  //xxxxx

  with gPrintStock do
    if FLoaded and (not FSaved) then SavePrintStock;
  //xxxxx

  with gNFStock do
    if FLoaded and (not FSaved) then SaveNFStock;
  //xxxxx

  with gLineStock do
    if FLoaded and (not FSaved) then SaveLineStock;
  //xxxxx

   with gLineBreed do
    if FLoaded and (not FSaved) then SaveLineBreed;
  //xxxxx

  ModalResult := mrOk;
  nLang := MLang('保存完毕');
  nHint := MLang(sHint);
  ShowMsg(nLang, nHint);
end;

initialization
  gControlManager.RegCtrl(TfFormOptions, TfFormOptions.FormID);
end.

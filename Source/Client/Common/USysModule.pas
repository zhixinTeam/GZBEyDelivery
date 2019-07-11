{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 单元模块

  备注: 由于模块有自注册能力,只要Uses一下即可.
*******************************************************************************}
unit USysModule;

{$I Link.Inc}
interface

uses
  UFrameLog, UFrameSysLog, UFormIncInfo, UFormBackupSQL, UFormRestoreSQL,
  UClientWorker,UMITPacker,
  {Form Module}
  UFormPassword, UFormAuthorize, UFormOptions,UFormPMaterails,UFormPProvider,
  UFormBillNew, UFormBillXS,UFormCard, UFormTruckIn,UFormZTMode,UFormBillTiaoZhang,
  UFormTruckOut,UFormZTLine,UFormGetTruck,UFormBillModify,UFormBillPick,
  UFormLadingDai,UFormLadingSan,UFormTruck,UFormRFIDCard,
  {Frame Module}
  UFramePProvider,UFrameAuthorize,UFramePMaterails,UFrameZTDispatch,UFrameBill,
  UFrameBillTiaoZhang,UFrameQueryDiapatch,UFrameQuerySaleDetail,
  UFrameBillPost,UFrameBillPick,UFrameBillCard,UFramePoundManual,
  UFramePoundQuery,UFrameTruckQuery,UFrameQuerySaplog,UFramePoundManualItem,
  UFrameTrucks;


procedure InitSystemObject;
procedure RunSystemObject;
procedure FreeSystemObject;

implementation

uses
  SysUtils, UMgrLang, UMgrChannel, UChannelChooser, UDataModule, USysLoger,
  USysConst, USysMAC, USysDB;

//Desc: 初始化系统对象
procedure InitSystemObject;
var nStr: string;
begin
  if not Assigned(gSysLoger) then
    gSysLoger := TSysLoger.Create(gPath + sLogDir);
  //system loger

  gChannelManager := TChannelManager.Create;
  gChannelManager.ChannelMax := 20;
  gChannelChoolser := TChannelChoolser.Create('');
  gChannelChoolser.AutoUpdateLocal := False;
  //channel

  gMultiLangManager := TMultiLangManager.Create;
  nStr := gPath + 'Lang.xml';

  if FileExists(nStr) then
  with gMultiLangManager do
  begin
    LoadLangFile(nStr);
    NowLang := 'cn';

    RegItem('TcxMCListBox', 'HeaderSections.Text');
    RegItem('TcxGridLevel','Caption');
    RegItem('TcxListView','Columns.Caption');
    //注册待翻译的控件
  end;

  {$IFDEF DEBUG}
  gMultiLangManager.AutoNewNode := True;
  {$ELSE}
  gMultiLangManager.AutoNewNode := False;
  //正式发布时关闭节点扫描
  {$ENDIF}
end;

//Desc: 运行系统对象
procedure RunSystemObject;
var nStr: string;
begin
  with gSysParam do
  begin
    FLocalMAC   := MakeActionID_MAC;
    GetLocalIPConfig(FLocalName, FLocalIP);
  end;

  nStr := 'Select W_Factory,W_Serial From %s ' +
          'Where W_MAC=''%s'' And W_Valid=''%s''';
  nStr := Format(nStr, [sTable_WorkePC, gSysParam.FLocalMAC, sFlag_Yes]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    gSysParam.FFactNum := Fields[0].AsString;
    gSysParam.FSerialID := Fields[1].AsString;
  end;

  //----------------------------------------------------------------------------
  with gSysParam do
  begin
    FPoundDaiZ := 0;
    FPoundDaiF := 0;
    FPoundSanZ := 0;
    FPoundSanF := 0;
    FSanZStop := False;
    FDaiWCStop := False;
    FDaiPercent := False;
  end;

  nStr := 'Select D_Value,D_Memo From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_PoundWuCha]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := Fields[1].AsString;
      if nStr = sFlag_PDaiWuChaZ then
        gSysParam.FPoundDaiZ := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PDaiWuChaF then
        gSysParam.FPoundDaiF := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PDaiPercent then
        gSysParam.FDaiPercent := Fields[0].AsString = sFlag_Yes;
      //xxxxx

      if nStr = sFlag_PDaiWuChaStop then
        gSysParam.FDaiWCStop := Fields[0].AsString = sFlag_Yes;
      //xxxxx

      if nStr = sFlag_PSanWuChaZ then
        gSysParam.FPoundSanZ := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PSanWuChaF then
        gSysParam.FPoundSanF := Fields[0].AsFloat;
      //xxxxx

      if nStr = sFlag_PSanZhengStop then
        gSysParam.FSanZStop := Fields[0].AsString = sFlag_Yes;
      Next;
    end;

    with gSysParam do
    begin
      FPoundDaiZ_1 := FPoundDaiZ;
      FPoundDaiF_1 := FPoundDaiF;
      //backup wucha value
    end;
  end;

  //----------------------------------------------------------------------------
  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_MITSrvURL]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      gChannelChoolser.AddChannelURL(Fields[0].AsString);
      Next;
    end;

    {$IFNDEF DEBUG}
    gChannelChoolser.StartRefresh;
    {$ENDIF}//update channel
  end;
  
  nStr := 'Select D_Value From %s Where D_Name=''%s''';
  nStr := Format(nStr, [sTable_SysDict, sFlag_HardSrvURL]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    gSysParam.FHardMonURL := Fields[0].AsString;
  end;
end;

//Desc: 释放系统对象
procedure FreeSystemObject;
begin
  FreeAndNil(gSysLoger);
end;

end.

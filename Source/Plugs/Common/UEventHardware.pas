{*******************************************************************************
  作者: dmzn@163.com 2013-11-23
  描述: 模块工作对象,用于响应框架事件
*******************************************************************************}
unit UEventHardware;

{$I Link.Inc}
interface

uses
  Windows, Classes, UMgrPlug, UBusinessConst, ULibFun, UMITConst, UPlugConst;

type
  THardwareWorker = class(TPlugEventWorker)
  public
    class function ModuleInfo: TPlugModuleInfo; override;
    procedure RunSystemObject(const nParam: PPlugRunParameter); override;
    procedure InitSystemObject; override;
    //主程序启动时初始化
    procedure BeforeStartServer; override;
    //服务启动之前调用
    procedure AfterStopServer; override;
    //服务关闭之后调用
    {$IFDEF DEBUG}
    procedure GetExtendMenu(const nList: TList); override;
    {$ENDIF}
  end;

var
  gPlugRunParam: TPlugRunParameter;
  //运行参数

implementation

uses
  SysUtils, USysLoger, UHardBusiness, UMgrTruckProbe, UMgrParam,
  UMgrQueue, UMgrLEDCard, UMgrHardHelper, UMgrRemotePrint, U02NReader,
  UMgrERelay, UMultiJS, UMgrRemoteVoice, UMgrCodePrinter, UMgrLEDDisp,
  UMgrRFID102, UMgrVoiceNet;

class function THardwareWorker.ModuleInfo: TPlugModuleInfo;
begin
  Result := inherited ModuleInfo;
  with Result do
  begin
    FModuleID := sPlug_ModuleHD;
    FModuleName := '硬件守护';
    FModuleVersion := '2014-09-30';
    FModuleDesc := '提供水泥一卡通发货的硬件处理对象';
    FModuleBuildTime:= Str2DateTime('2014-09-30 15:01:01');
  end;
end;

procedure THardwareWorker.RunSystemObject(const nParam: PPlugRunParameter);
var nStr,nCfg: string;
begin
  gPlugRunParam := nParam^;
  nCfg := gPlugRunParam.FAppPath + 'Hardware\';

  try
    nStr := 'LED';
    gCardManager.TempDir := nCfg + 'Temp\';
    gCardManager.FileName := nCfg + 'LED.xml';

    nStr := '远距读头';
    gHardwareHelper.LoadConfig(nCfg + '900MK.xml');

    nStr := '近距读头';
    g02NReader.LoadConfig(nCfg + 'Readers.xml');

    nStr := '计数器';
    gMultiJSManager.LoadFile(nCfg + 'JSQ.xml');

    nStr := '继电器';
    gERelayManager.LoadConfig(nCfg + 'ERelay.xml');

    nStr := '远程打印';
    gRemotePrinter.LoadConfig(nCfg + 'Printer.xml');

    nStr := '语音服务';
    gVoiceHelper.LoadConfig(nCfg + 'Voice.xml');

    nStr := '网络语音服务';
    gNetVoiceHelper := TNetVoiceManager.Create;
    gNetVoiceHelper.LoadConfig(nCfg + 'NetVoice.xml');

    nStr := '喷码机';
    gCodePrinterManager.LoadConfig(nCfg + 'CodePrinter.xml');

    nStr := '小屏显示';
    gDisplayManager.LoadConfig(nCfg + 'LEDDisp.xml');

    nStr := '华益RFID102';
    gHYReaderManager := THYReaderManager.Create;
    gHYReaderManager.LoadConfig(nCfg + 'RFID102.xml');

    nStr := '车辆检测器';
    gProberManager := TProberManager.Create;
    gProberManager.LoadConfig(nCfg + 'TruckProber.xml');
  except
    on E:Exception do
    begin
      nStr := Format('加载[ %s ]配置文件失败: %s', [nStr, E.Message]);
      gSysLoger.AddLog(nStr);
    end;
  end;
end;

{$IFDEF DEBUG}
procedure THardwareWorker.GetExtendMenu(const nList: TList);
var nItem: PPlugMenuItem;
begin
  New(nItem);
  nList.Add(nItem);
  nItem.FName := 'Menu_Param_2';

  nItem.FModule := ModuleInfo.FModuleID;
  nItem.FCaption := '硬件测试';
  nItem.FFormID := cFI_FormTest2;
  nItem.FDefault := False;
end;
{$ENDIF}

procedure THardwareWorker.InitSystemObject;
begin
  gHardwareHelper := THardwareHelper.Create;
  //远距读头

  gHardShareData := WhenBusinessMITSharedDataIn;
  //hard monitor share
end;

procedure THardwareWorker.BeforeStartServer;
begin
  gTruckQueueManager.StartQueue(gParamManager.ActiveParam.FDB.FID);
  //truck queue

  gHardwareHelper.OnProce := WhenReaderCardArrived;
  gHardwareHelper.StartRead;
  //long reader

  gHYReaderManager.OnCardProc := WhenHYReaderCardArrived;
  gHYReaderManager.StartReader;
  //rfid-102

  g02NReader.OnCardIn := WhenReaderCardIn;
  g02NReader.OnCardOut := WhenReaderCardOut;
  g02NReader.StartReader;
  //near reader

  gMultiJSManager.SaveDataProc := WhenSaveJS;
  gMultiJSManager.StartJS;
  //counter
  gERelayManager.ControlStart;
  //erelay

  gRemotePrinter.StartPrinter;
  //printer
  
  gNetVoiceHelper.StartVoice;
  gVoiceHelper.StartVoice;
  //voice

  gCardManager.StartSender;
  //led display
  gDisplayManager.StartDisplay;
  //small led
  gProberManager.StartProber;
  //truck&led light
end;

procedure THardwareWorker.AfterStopServer;
begin
  gNetVoiceHelper.StartVoice;
  gVoiceHelper.StopVoice;
  //voice
  
  gRemotePrinter.StopPrinter;
  //printer

  gERelayManager.ControlStop;
  //erelay
  gMultiJSManager.StopJS;
  //counter

  g02NReader.StopReader;
  g02NReader.OnCardIn := nil;
  g02NReader.OnCardOut := nil;

  gHardwareHelper.StopRead;
  gHardwareHelper.OnProce := nil;
  //reader

  gHYReaderManager.StopReader;
  gHYReaderManager.OnCardProc := nil;
  //rfid-102

  gDisplayManager.StopDisplay;
  //small led
  gCardManager.StopSender;
  //led
  gProberManager.StopProber;
  //truck&led light

  gTruckQueueManager.StopQueue;
  //queue
end;

end.

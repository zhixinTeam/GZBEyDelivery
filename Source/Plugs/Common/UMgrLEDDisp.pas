{*******************************************************************************
  ����: dmzn@163.com 2013-07-20
  ����: LEDС����ʾ
*******************************************************************************}
unit UMgrLEDDisp;

{$I Link.Inc}
interface

uses
  Windows, Classes, SysUtils, SyncObjs, NativeXml, USysLoger, UWaitItem,
  ULibFun, IdTCPConnection, IdTCPClient, IdGlobal;

const
  cDisp_KeepLong   = 15 * 1000;     //���ݱ���ʱ��                  

type
  PDispCard = ^TDispCard;
  TDispCard = record
    FID: string;
    FName: string;

    FHost: string;
    FPort: Integer;
    FAddr: Integer;
    FLastUpdate: Int64;
  end;

  PDispContent = ^TDispContent;
  TDispContent = record
    FID: string;
    FText: string;
  end;

type
  TDisplayManager = class;
  TDisplayControler = class(TThread)
  private
    FOwner: TDisplayManager;
    //ӵ����
    FBuffer: TList;
    //��ʾ����
    FClient: TIdTCPClient;
    //������·
    FWaiter: TWaitObject;
    //�ȴ�����
  protected
    procedure DoExuecte(const nCard: PDispCard);
    procedure Execute; override;
    //ִ���߳�
    procedure AddContent(const nContent: PDispContent);
    //�������
  public
    constructor Create(AOwner: TDisplayManager);
    destructor Destroy; override;
    //�����ͷ�
    procedure WakupMe;
    //�����߳�
    procedure StopMe;
    //ֹͣ�߳�
  end;

  TDisplayManager = class(TObject)
  private
    FControler: TDisplayControler;
    //��ʾ����
    FCards: array of TDispCard;
    //�豸�б�
    FEnabled: Boolean;
    FDefault: string;
    //Ĭ������
    FBuffData: TList;
    //���ݻ���
    FSyncLock: TCriticalSection;
    //ͬ����
  protected
    procedure ClearBuffer(const nList: TList; const nFree: Boolean = False);
    //������Դ
  public
    constructor Create;
    destructor Destroy; override;
    //�����ͷ�
    procedure LoadConfig(const nFile: string);
    //��ȡ����
    procedure StartDisplay;
    procedure StopDisplay;
    //��ͣ��ʾ
    procedure Display(const nID,nText: string);
    //��ʾ����
  end;

var
  gDisplayManager: TDisplayManager = nil;
  //ȫ��ʹ��

implementation

procedure WriteLog(const nEvent: string);
begin
  gSysLoger.AddLog(TDisplayManager, 'LED��ʾ����', nEvent);
end;

constructor TDisplayManager.Create;
begin
  FBuffData := TList.Create;
  FSyncLock := TCriticalSection.Create;
end;

destructor TDisplayManager.Destroy;
begin
  StopDisplay;
  ClearBuffer(FBuffData, True);

  FSyncLock.Free;
  inherited;
end;

procedure TDisplayManager.ClearBuffer(const nList: TList; const nFree: Boolean);
var nIdx: Integer;
begin
  for nIdx := nList.Count - 1 downto 0 do
  begin
    Dispose(PDispContent(nList[nIdx]));
    nList.Delete(nIdx);
  end;

  if nFree then
    nList.Free;
  //xxxxx
end;

procedure TDisplayManager.StartDisplay;
begin
  if FEnabled and (Length(FCards) > 0) then
  begin
    if not Assigned(FControler) then
      FControler := TDisplayControler.Create(Self);
    FControler.WakupMe;
  end;
end;

procedure TDisplayManager.StopDisplay;
begin
  if Assigned(FControler) then
    FControler.StopMe;
  FControler := nil;
end;

//Date: 2013-07-20
//Parm: ��ʶ;����
//Desc: ��nID������ʾnText
procedure TDisplayManager.Display(const nID,nText: string);
var nItem: PDispContent;
begin
  if not Assigned(FControler) then Exit;
  //no controler

  FSyncLock.Enter;
  try
    New(nItem);
    FBuffData.Add(nItem);

    nItem.FID := nID;
    nItem.FText := nText;
    FControler.WakupMe;
  finally
    FSyncLock.Leave;
  end;   
end;

//Desc: ����nFile�����ļ�
procedure TDisplayManager.LoadConfig(const nFile: string);
var nIdx,nInt: Integer;
    nXML: TNativeXml;
    nNode,nTmp: TXmlNode;
begin
  nXML := TNativeXml.Create;
  try
    nInt := 0;
    SetLength(FCards, 0);
    nXML.LoadFromFile(nFile);

    nNode := nXML.Root.NodeByName('config');
    FEnabled := nNode.NodeByName('enable').ValueAsString = '1';
    FDefault := nNode.NodeByName('default').ValueAsString;

    for nIdx:=nXML.Root.NodeCount - 1 downto 0 do
    begin
      nNode := nXML.Root.Nodes[nIdx];
      if CompareText(nNode.Name, 'card') <> 0 then Continue;

      nTmp := nNode.FindNode('enable');
      if (not Assigned(nTmp)) or (nTmp.ValueAsString <> '1') then Continue;
      //not valid card

      SetLength(FCards, nInt + 1);
      with FCards[nInt],nNode do
      begin
        FID := AttributeByName['ID'];
        FName := AttributeByName['Name'];

        FHost := NodeByName('ip').ValueAsString;
        FPort := NodeByName('port').ValueAsInteger;
        FAddr := NodeByName('addr').ValueAsInteger;

        FLastUpdate := 0;
        Inc(nInt);
      end;
    end;
  finally
    nXML.Free;
  end;
end;

//------------------------------------------------------------------------------
constructor TDisplayControler.Create(AOwner: TDisplayManager);
begin
  inherited Create(False);
  FreeOnTerminate := False;
  FOwner := AOwner;

  FBuffer := TList.Create;
  FWaiter := TWaitObject.Create;
  FWaiter.Interval := 2000;

  FClient := TIdTCPClient.Create;
  FClient.ReadTimeout := 5 * 1000;
  FClient.ConnectTimeout := 5 * 1000;
end;

destructor TDisplayControler.Destroy;
begin
  FClient.Disconnect;
  FClient.Free;

  FOwner.ClearBuffer(FBuffer, True);
  FWaiter.Free;
  inherited;
end;

procedure TDisplayControler.StopMe;
begin
  Terminate;
  FWaiter.Wakeup;

  WaitFor;
  Free;
end;

procedure TDisplayControler.WakupMe;
begin
  FWaiter.Wakeup;
end;

//Desc: ���������,���������
procedure TDisplayControler.AddContent(const nContent: PDispContent);
var nIdx: Integer;
    nItem: PDispContent;
begin
  for nIdx:=FBuffer.Count - 1 downto 0 do
  begin
    nItem := FBuffer[nIdx];
    if nItem.FID = nContent.FID then
    begin
      Dispose(nItem);
      FBuffer.Delete(nIdx);
    end;
  end;

  FBuffer.Add(nContent);
  //�����ʾ����

  for nIdx:=Low(FOwner.FCards) to High(FOwner.FCards) do
   if CompareText(FOwner.FCards[nIdx].FID, nContent.FID) = 0 then
    FOwner.FCards[nIdx].FLastUpdate := GetTickCount;
  //update status
end;

procedure TDisplayControler.Execute;
var nStr: string;
    nIdx: Integer;
    nContent: PDispContent;
begin
  while not Terminated do
  try
    FWaiter.EnterWait;
    if Terminated then Exit;

    FOwner.FSyncLock.Enter;
    try
      for nIdx:=0 to FOwner.FBuffData.Count - 1 do
        AddContent(FOwner.FBuffData[nIdx]);
      FOwner.FBuffData.Clear;
    finally
      FOwner.FSyncLock.Leave;
    end;

    for nIdx:=Low(FOwner.FCards) to High(FOwner.FCards) do
    if GetTickCount - FOwner.FCards[nIdx].FLastUpdate >= cDisp_KeepLong then
    begin
      nStr := StringReplace(FOwner.FDefault, 'dt', Date2Str(Now),
              [rfReplaceAll, rfIgnoreCase]);
      //date item

      nStr := StringReplace(nStr, 'wk', Date2Week(),
              [rfReplaceAll, rfIgnoreCase]);
      //week item

      New(nContent);
      FBuffer.Add(nContent);

      nContent.FID := FOwner.FCards[nIdx].FID;
      nContent.FText := nStr;
      //default content
    end;

    if FBuffer.Count > 0 then
    try
      for nIdx:=Low(FOwner.FCards) to High(FOwner.FCards) do
        DoExuecte(@FOwner.FCards[nIdx]);
      //send contents
    finally
      FOwner.ClearBuffer(FBuffer);
    end;
  except
    on E:Exception do
    begin
      WriteLog(E.Message);
    end;
  end;
end;

//Date: 2013-07-20
//Parm: �ַ�
//Desc: ��ȡnTxt������
function ConvertStr(const nTxt: WideString; var nBuf: TIdBytes): Integer;
var nStr: string;
    nIdx: Integer;
begin
  Result := 0;
  nStr := nTxt;
  SetLength(nBuf, Length(nStr));

  for nIdx:=1 to Length(nTxt) do
  begin
    nStr := nTxt[nIdx];
    nBuf[Result] := Ord(nStr[1]);
    Inc(Result);

    if Length(nStr) = 2 then
    begin
      nBuf[Result] := Ord(nStr[2]);
      Inc(Result);
    end;
  end;
end;

//Desc: ��ʾ����
procedure TDisplayControler.DoExuecte(const nCard: PDispCard);
var nIdx: Integer;
    nBuf: TIdBytes;
    nContent: PDispContent;
begin
  if not Terminated then
  try
    if FClient.Connected and ((FClient.Host <> nCard.FHost) or (
       FClient.Port <> nCard.FPort)) then
    begin
      FClient.Disconnect;
      if Assigned(FClient.IOHandler) then
        FClient.IOHandler.InputBuffer.Clear;
      //try to swtich connection
    end;

    if not FClient.Connected then
    begin
      FClient.Host := nCard.FHost;
      FClient.Port := nCard.FPort;
      FClient.Connect;
    end;

    for nIdx:=FBuffer.Count - 1 downto 0 do
    begin
      nContent := FBuffer[nIdx];
      if CompareText(nContent.FID, nCard.FID) <> 0 then Continue;

      ConvertStr(Char($40) + Char(nCard.FAddr) + nContent.FText + #13, nBuf);
      FClient.Socket.Write(nBuf);
      nCard.FLastUpdate := GetTickCount;
    end;
  except
    WriteLog(Format('��С��[ %s ]������ʾ����ʧ��.', [nCard.FName]));
    //loged

    FClient.Disconnect;
    if Assigned(FClient.IOHandler) then
      FClient.IOHandler.InputBuffer.Clear;
    //close connection
  end;
end;

initialization
  gDisplayManager := TDisplayManager.Create;
finalization
  FreeAndNil(gDisplayManager);
end.

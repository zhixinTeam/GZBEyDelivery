{*******************************************************************************
  ����: dmzn@163.com 2012-3-7
  ����: ϵͳҵ����ڶ���
*******************************************************************************}
unit SrvBusiness_Impl;

{$I Link.Inc}
interface

uses
  Windows, Classes, SysUtils, uROServer, MIT_Service_Intf;

type
  TSrvBusiness = class(TRORemotable, ISrvBusiness)
  private
    FEvent: string;
    FTaskID: Int64;
    procedure WriteLog(const nLog: string);
  protected
    function Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
  end;

implementation

uses
  UROModule, UBusinessWorker, UMgrLang, UTaskMonitor, UMemDataPool, USysLoger,
  UMITConst;

procedure NewLang(const nFlag: string; const nType: Word; var nData: Pointer);
var nP: PWorkerBusinessLang;
begin
  New(nP);
  nData := nP;
end;

procedure DisLang(const nFlag: string; const nType: Word; const nData: Pointer);
begin
  Dispose(PWorkerBusinessLang(nData));
end;

procedure TSrvBusiness.WriteLog(const nLog: string);
begin
  gSysLoger.AddLog(TSrvBusiness, 'ҵ��������', nLog);
end;

//Date: 2012-3-7
//Parm: ������;[in]����,[out]�������
//Desc: ִ����nDataΪ������nFunName����
function TSrvBusiness.Action(const nFunName: AnsiString;
 var nData: AnsiString): Boolean;
var nPos: Integer;
    nLang: PWorkerBusinessLang;
    nWorker: TBusinessWorkerBase;
begin
  nLang := nil;
  FTaskID := 0;
  nWorker := nil;
  try
    if InterlockedExchange(gRegistryMultiLangData, 1) = 0 then
      gMemDataManager.RegDataType('LangID', 'MultiLang', NewLang, DisLang, 5);
    //reg lang record

    nLang := gMemDataManager.LockData('LangID');
    nLang.FProcessID := GetCurrentThreadId;

    FEvent := '$LangID:=';
    nPos := Pos(FEvent, nData);

    if nPos > 0 then
         nLang.FLangID := Copy(nData, nPos+Length(FEvent), 2)
    else nLang.FLangID := '';

    nWorker := gBusinessWorkerManager.LockWorker(nFunName);
    try
      if nWorker.FunctionName = '' then
      begin
        nData := 'Զ�̵���ʧ��(Worker Is Null).';
        Result := False;
        Exit;
      end;
               
      FEvent := Format('TSrvBusiness.Action( %s )', [nFunName]);
      FTaskID := gTaskMonitor.AddTask(FEvent, 10 * 1000);
      //new task

      Result := nWorker.WorkActive(nData);
      //do action

      with ROModule.LockModuleStatus^ do
      try
        FNumBusiness := FNumBusiness + 1;
      finally
        ROModule.ReleaseStatusLock;
      end;
    except
      on E:Exception do
      begin
        Result := False;
        nData := E.Message;
        WriteLog('Function:[ ' + nFunName + ' ]' + E.Message);

        with ROModule.LockModuleStatus^ do
        try
          FNumActionError := FNumActionError + 1;
        finally
          ROModule.ReleaseStatusLock;
        end;
      end;
    end;

    if (not Result) and (Pos(#10#13, nData) < 1) then
    begin
      if nLang.FLangID <> '' then
        nData := gMultiLangManager.GetTextByText(nData, '', nLang.FLangID, False);
      //xxxxx

      FEvent := '��Դ: %s,%s' + #13#10 + '����: %s';
      if nLang.FLangID <> '' then
        FEvent := gMultiLangManager.GetTextByText(FEvent, '', nLang.FLangID);
      //xxxxx

      nData := Format(FEvent, [
               gMultiLangManager.GetTextByText(gSysParam.FAppFlag, '',nLang.FLangID),
               gSysParam.FLocalName, nWorker.FunctionName]) + #13#10#13#10 + nData;
      //xxxxx
    end;
  finally
    gTaskMonitor.DelTask(FTaskID);
    gMemDataManager.UnLockData(nLang);  
    gBusinessWorkerManager.RelaseWorker(nWorker);
  end;
end;

initialization

finalization

end.

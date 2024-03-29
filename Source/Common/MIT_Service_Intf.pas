unit MIT_Service_Intf;

{----------------------------------------------------------------------------}
{ This unit was automatically generated by the RemObjects SDK after reading  }
{ the RODL file associated with this project .                               }
{                                                                            }
{ Do not modify this unit manually, or your changes will be lost when this   }
{ unit is regenerated the next time you compile the project.                 }
{----------------------------------------------------------------------------}

{$I RemObjects.inc}
{$I LibFun.inc}

interface

uses
  {vcl:} Classes, TypInfo,
  {RemObjects:} uROXMLIntf, uROClasses, uROClient, uROTypes,
  {$IFDEF RO_v90}uROProxy, {$ENDIF}uROClientIntf;

const
  { Library ID }
  LibraryUID = '{9EFB4070-F3EF-4F02-ACF0-00A22B2A64AB}';
  TargetNamespace = '';

  { Service Interface ID's }
  ISrvConnection_IID : TGUID = '{3E08D66D-DFBE-485E-A65C-F5EC6DC9F7CF}';
  ISrvBusiness_IID : TGUID = '{6173318C-3ECB-4FA8-A32A-4FC64D22AFF5}';

  { Event ID's }

type
  { Forward declarations }
  ISrvConnection = interface;
  ISrvBusiness = interface;


  { ISrvConnection }

  { Description:
      连接服务,负责安全验证、心跳指令等 }
  ISrvConnection = interface
    ['{3E08D66D-DFBE-485E-A65C-F5EC6DC9F7CF}']
    function Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
  end;

  { CoSrvConnection }
  CoSrvConnection = class
    class function Create(const aMessage: IROMessage; aTransportChannel: IROTransportChannel): ISrvConnection;
  end;

  { TSrvConnection_Proxy }
  TSrvConnection_Proxy = class(TROProxy, ISrvConnection)
  protected
    function __GetInterfaceName:string; override;

    function Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
  end;

  { ISrvBusiness }

  { Description:
      处理系统业务 }
  ISrvBusiness = interface
    ['{6173318C-3ECB-4FA8-A32A-4FC64D22AFF5}']
    function Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
  end;

  { CoSrvBusiness }
  CoSrvBusiness = class
    class function Create(const aMessage: IROMessage; aTransportChannel: IROTransportChannel): ISrvBusiness;
  end;

  { TSrvBusiness_Proxy }
  TSrvBusiness_Proxy = class(TROProxy, ISrvBusiness)
  protected
    function __GetInterfaceName:string; override;

    function Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
  end;

implementation

uses
  {vcl:} SysUtils,
  {RemObjects:} uROEventRepository, uROSerializer, uRORes;

{ CoSrvConnection }

class function CoSrvConnection.Create(const aMessage: IROMessage; aTransportChannel: IROTransportChannel): ISrvConnection;
begin
  result := TSrvConnection_Proxy.Create(aMessage, aTransportChannel);
end;

{ TSrvConnection_Proxy }

function TSrvConnection_Proxy.__GetInterfaceName:string;
begin
  result := 'SrvConnection';
end;

function TSrvConnection_Proxy.Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
begin
  try
    __Message.InitializeRequestMessage(__TransportChannel, 'MIT_Service', __InterfaceName, 'Action');
    __Message.Write('nFunName', TypeInfo(AnsiString), nFunName, []);
    __Message.Write('nData', TypeInfo(AnsiString), nData, []);
    __Message.Finalize;

    __TransportChannel.Dispatch(__Message);

    __Message.Read('Result', TypeInfo(Boolean), result, []);
    __Message.Read('nData', TypeInfo(AnsiString), nData, []);
  finally
    __Message.UnsetAttributes(__TransportChannel);
    __Message.FreeStream;
  end
end;

{ CoSrvBusiness }

class function CoSrvBusiness.Create(const aMessage: IROMessage; aTransportChannel: IROTransportChannel): ISrvBusiness;
begin
  result := TSrvBusiness_Proxy.Create(aMessage, aTransportChannel);
end;

{ TSrvBusiness_Proxy }

function TSrvBusiness_Proxy.__GetInterfaceName:string;
begin
  result := 'SrvBusiness';
end;

function TSrvBusiness_Proxy.Action(const nFunName: AnsiString; var nData: AnsiString): Boolean;
begin
  try
    __Message.InitializeRequestMessage(__TransportChannel, 'MIT_Service', __InterfaceName, 'Action');
    __Message.Write('nFunName', TypeInfo(AnsiString), nFunName, []);
    __Message.Write('nData', TypeInfo(AnsiString), nData, []);
    __Message.Finalize;

    __TransportChannel.Dispatch(__Message);

    __Message.Read('Result', TypeInfo(Boolean), result, []);
    __Message.Read('nData', TypeInfo(AnsiString), nData, []);
  finally
    __Message.UnsetAttributes(__TransportChannel);
    __Message.FreeStream;
  end
end;

initialization
  RegisterProxyClass(ISrvConnection_IID, TSrvConnection_Proxy);
  RegisterProxyClass(ISrvBusiness_IID, TSrvBusiness_Proxy);


finalization
  UnregisterProxyClass(ISrvConnection_IID);
  UnregisterProxyClass(ISrvBusiness_IID);

end.

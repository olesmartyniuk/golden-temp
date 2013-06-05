unit uServerState;

interface

uses
  Classes,
  SysUtils,
  IdHTTPWebBrokerBridge,
  HTTPApp,
  uRemotable;

type
  TServerState = (STATE_STOPED, STATE_STARTED, STATE_SUSPENDED);

  IServerState = interface
    ['{F4DF90C2-8494-4632-9292-35209ECF8F6B}']
    function GetState: TServerState;
    procedure SetState(Value: TServerState);
    procedure CheckState;

    property State: TServerState read GetState write SetState;
  end;

  TServerStatusImpl = class(TInterfacedObject, IServerState)
    private
      FState: TServerState;
      FHTTPWebBroker: TIdHTTPWebBrokerBridge;
    protected
      function GetState: TServerState;
      procedure SetState(Value: TServerState);
      procedure CheckState;
    public
      constructor Create;
      destructor Destroy; override;
  end;

var
  Server: IServerState;

implementation

{ TServerImpl }

procedure TServerStatusImpl.CheckState;
begin
  if FState = STATE_SUSPENDED then
    raise EServerStoped.Create('Сервер призупинено.');
end;

constructor TServerStatusImpl.Create;
begin
  FHTTPWebBroker := TIdHTTPWebBrokerBridge.Create;
end;

destructor TServerStatusImpl.Destroy;
begin
  SetState(STATE_STOPED);
  FreeAndNil(FHTTPWebBroker);
  inherited;
end;

function TServerStatusImpl.GetState: TServerState;
begin
  Result := FState;
end;

procedure TServerStatusImpl.SetState(Value: TServerState);
begin
  if Value = FState then
    Exit;
  FState := Value;
  case FState of
    STATE_STARTED:
      begin
        if not FHTTPWebBroker.Active then
        begin
          FHTTPWebBroker.Bindings.Clear;
          FHTTPWebBroker.DefaultPort := 3030;
          FHTTPWebBroker.Active := True;
        end;
      end;
    STATE_STOPED:
      begin
        FHTTPWebBroker.Active := False;
        FHTTPWebBroker.Bindings.Clear;
      end;
    STATE_SUSPENDED:
      begin
        if not FHTTPWebBroker.Active then
        begin
          FHTTPWebBroker.Bindings.Clear;
          FHTTPWebBroker.DefaultPort := 3030;
          FHTTPWebBroker.Active := True;
        end;
      end;
  end;
end;

end.

unit uInterfaces;

interface

uses
  Classes,
  Controls,
  Forms,
  SysUtils;

type

  ISplash = interface
  ['{9ED05CEB-A250-4F74-BB82-E5B0AADA7DC1}']
    procedure ShowSplash(const Messsge: WideString);
    procedure HideSplash;
    procedure SetProgress(Value: word);
    function GetProgress: word;
    function GetShowProgress: boolean;
    procedure SetShowProgress(Value: boolean);
    function GetVisible: boolean;
    procedure SetVisible(Value: boolean);

    property ShowProgress: boolean read GetShowProgress write SetShowProgress;
    property Progress: word read GetProgress write SetProgress;
    property Visible: boolean read GetVisible write SetVisible;
  end;


  ISettings = interface
  ['{1A36C4C1-E2BC-4EDB-B609-885EA1C76077}']
    function GetSectionName: WideString;
    procedure SetSectionName(const Value: WideString);
    function GetStr(aParamName: WideString; const aDefault: WideString): WideString;
    function GetInt(aParamName: WideString; const aDefault: Integer): Integer;
    function GetBool(aParamName: WideString; const aDefault: Boolean): Boolean;
    procedure SetStr(aParamName: WideString; aValue: WideString);
    procedure SetInt(aParamName: WideString; aValue: Integer);
    procedure SetBool(aParamName: WideString; aValue: Boolean);

    property SectionName: WideString read GetSectionName write SetSectionName;
  end;

  TgtException = class(Exception)
  private
    fExceptionCode: integer;
    fExceptionClass: string;
  private
    function GetExceptionClass: string;
    function GetExceptionCode: integer;
    procedure SetExceptionClass(const Value: string);
    procedure SetExceptionCode(const Value: integer);
  public
    property ExceptionClass: string read GetExceptionClass write SetExceptionClass;
    property ExceptionCode: integer read GetExceptionCode write SetExceptionCode;
  end;

  function GetHumanExceptionText(E: Exception): WideString;


const
  param_parent_control = 'parent_control';
  param_host = 'host';
  param_login = 'login';
  param_password = 'password';
  param_test = 'test';


implementation

function GetHumanExceptionText(E: Exception): WideString;
var
  s: string;
  code: integer;
begin
  if E is TgtException then
    begin
    s := (E as TgtException).ExceptionClass;
    if s = 'EIdSocketError' then
      begin
      code := (E as TgtException).ExceptionCode;
      case code of
        10004: Result := 'Interrupted system call.';
        10009: Result := 'Bad file number.';
        10013: Result := 'Permission denied.';
        10014: Result := 'Bad address.';
        10022: Result := 'Invalid argument.';
        10024: Result := 'Too many open files.';
        10035: Result := 'Operation would block.';
        10036: Result := 'Operation now in progress. This error is ' +
                         'returned if any Windows Sockets API ' +
                         'function is called while a blocking ' +
                         'function is in progress. ';
        10037: Result := 'Operation already in progress.';
        10038: Result := 'Socket operation on nonsocket.';
        10039: Result := 'Destination address required.';
        10040: Result := 'Message too long.';
        10041: Result := 'Protocol wrong type for socket.';
        10042: Result := 'Protocol not available.';
        10043: Result := 'Protocol not supported.';
        10044: Result := 'Socket type not supported.';
        10045: Result := 'Operation not supported on socket.';
        10046: Result := 'Protocol family not supported.';
        10047: Result := 'Address family not supported by protocol family.';
        10048: Result := 'Address already in use.';
        10049: Result := 'Cannot assign requested address.';
        10050: Result := 'Network is down. This error may be ' +
                         'reported at any time if the Windows ' +
                         'Sockets implementation detects an ' +
                         'underlying failure.';
        10051: Result := 'Network is unreachable.';
        10052: Result := 'Network dropped connection on reset.';
        10053: Result := 'Software caused connection abort.';
        10054: Result := 'Connection reset by peer.';
        10055: Result := 'No buffer space available.';
        10056: Result := 'Socket is already connected.';
        10057: Result := 'Socket is not connected.';
        10058: Result := 'Cannot send after socket shutdown.';
        10059: Result := 'Too many references: cannot splice.';
        10060: Result := 'Connection timed out.';
        10061: Result := 'Connection refused.';
        10062: Result := 'Too many levels of symbolic links.';
        10063: Result := 'File name too long.';
        10064: Result := 'Host is down.';
        10065: Result := 'No route to host.';
        10091: Result := 'Returned by WSAStartup(), indicating that the network subsystem is unusable.';
        10092: Result := 'Returned by WSAStartup(), indicating that the Windows Sockets DLL cannot support this application.';
        10093: Result := 'Winsock not initialized. This message is ' +
                         'returned by any function except ' +
                         'WSAStartup(), indicating that a ' +
                         'successful WSAStartup() has not yet been ' +
                         'performed.';
        10101: Result := 'Disconnect.';
        11001: Result := 'Host not found. This message indicates ' +
                         'that the key (name, address, and so on) ' +
                         'was not found.';
        11002: Result := 'Nonauthoritative host not found. This ' +
                         'error may suggest that the name service ' +
                         'itself is not functioning.';
        11003: Result := 'Nonrecoverable error. This error may ' +
                         'suggest that the name service itself is ' +
                         'not functioning.';
        11004: Result := 'Valid name, no data record of requested ' +
                         'type. This error indicates that the key ' +
                         '(name, address, and so on) was not found. ';
      end
      end
      else
        Result := E.Message;
    end;
end;

{ TgtException }

function TgtException.GetExceptionClass: string;
begin
  Result := fExceptionClass;
end;

function TgtException.GetExceptionCode: integer;
begin
  Result := fExceptionCode;
end;

procedure TgtException.SetExceptionClass(const Value: string);
begin
  fExceptionClass := Value;
end;

procedure TgtException.SetExceptionCode(const Value: integer);
begin
  fExceptionCode := Value;
end;


end.

unit uMainForm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.AppEvnts,
  Vcl.StdCtrls,
  IdHTTPWebBrokerBridge,
  Web.HTTPApp;

type
  TMainForm = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    private
      FServer: TIdHTTPWebBrokerBridge;
      procedure StartServer;
      { Private declarations }
    public
      { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Winapi.ShellApi,
  uServerState;

procedure TMainForm.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0, nil, PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TMainForm.ButtonStartClick(Sender: TObject);
begin
  Server := TServerStatusImpl.Create;
  Server.State := STATE_STARTED;
end;

procedure TMainForm.ButtonStopClick(Sender: TObject);
begin
  Server := nil;
end;

procedure TMainForm.StartServer;
begin

end;

end.

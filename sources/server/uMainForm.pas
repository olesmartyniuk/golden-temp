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
  Vcl.StdCtrls;

type
  TMainForm = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    ApplicationEvents: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    private
    public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Winapi.ShellApi,
  uServerState;

procedure TMainForm.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  if Server.State = STATE_STOPED then
  begin
    ButtonStart.Enabled := True;
    ButtonStop.Enabled := False;
    ButtonOpenBrowser.Enabled := False;
  end else
  begin
    ButtonStart.Enabled := False;
    ButtonStop.Enabled := True;
    ButtonOpenBrowser.Enabled := True;
  end;
end;

procedure TMainForm.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  LURL := Format('http://localhost:3030/', []);
  ShellExecute(0, nil, PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TMainForm.ButtonStartClick(Sender: TObject);
begin
  Server.State := STATE_STARTED;
end;

procedure TMainForm.ButtonStopClick(Sender: TObject);
begin
  Server.State := STATE_STOPED;
end;

end.

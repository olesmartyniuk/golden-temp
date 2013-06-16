program server;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uMainForm in 'uMainForm.pas' {MainForm},
  uWebModule in 'uWebModule.pas' {ServerWebModule: TWebModule},
  uRemotableImpl in 'uRemotableImpl.pas',
  uRemotable in '..\common\uRemotable.pas',
  uDatabase in 'uDatabase.pas',
  uConfig in '..\common\uConfig.pas',
  uServerState in 'uServerState.pas',
  uDebug in '..\common\uDebug.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

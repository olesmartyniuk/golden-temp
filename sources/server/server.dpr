program server;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  uMainForm in 'uMainForm.pas' {MainForm},
  uWebModule in 'uWebModule.pas' {ServerWebModule: TWebModule},
  uRemotableImpl in 'uRemotableImpl.pas',
  uDatabase in 'uDatabase.pas',
  uServerState in 'uServerState.pas',
  uConfig in '..\common\uConfig.pas',
  uDebug in '..\common\uDebug.pas',
  uFactories in '..\common\uFactories.pas',
  uInterfaces in '..\common\uInterfaces.pas',
  uQuizeImpl in '..\common\uQuizeImpl.pas',
  uRemotable in '..\common\uRemotable.pas',
  uStreamImpl in '..\common\uStreamImpl.pas',
  uUtils in '..\common\uUtils.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

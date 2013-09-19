program editor;



{$R 'animation.res' '..\..\resources\animation\animation.rc'}

uses
  Forms,
  uMainForm in 'uMainForm.pas' {MainForm: TTntForm},
  uSettingsForm in 'uSettingsForm.pas' {FormSettings: TTntForm},
  uTeacherPlugins in 'uTeacherPlugins.pas',
  uVariantsFrame in 'uVariantsFrame.pas' {VariantsFrame: TTntFrame},
  uTexts in 'uTexts.pas',
  uConfig in '..\common\uConfig.pas',
  uDebug in '..\common\uDebug.pas',
  uFactories in '..\common\uFactories.pas',
  uInterfaces in '..\common\uInterfaces.pas',
  uRemotable in '..\common\uRemotable.pas',
  uUtils in '..\common\uUtils.pas',
  uQuizeImpl in '..\common\uQuizeImpl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.HelpFile := 'GoldenTemp.chm';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

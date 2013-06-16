program administrator;

{$R 'animation.res' '..\..\resources\animation\animation.rc'}

uses
  Forms,
  Windows,
  SysUtils,
  uDebug,
  uMainUnit in 'uMainUnit.pas' {AdministratorMainForm},
  uGroupForm in 'uGroupForm.pas' {GroupForm},
  uStudentsListForm in 'uStudentsListForm.pas' {StudentListForm},
  uStudentForm in 'uStudentForm.pas' {StudentForm},
  uTeacherForm in 'uTeacherForm.pas' {TeacherForm},
  uTexts in 'uTexts.pas',
  uStudentsAddGroupForm in 'uStudentsAddGroupForm.pas' {FormAddStudent: TTntForm},
  uAccountForm in 'uAccountForm.pas' {AccountForm},
  uChangePasswordForm in 'uChangePasswordForm.pas' {PasswordForm},
  uInterfaces in '..\common\uInterfaces.pas',
  uFactories in '..\common\uFactories.pas',
  uSplashFrom in '..\implement\gui\splash\uSplashFrom.pas' {FormSplash};

{$R *.res}

var
  window: THandle;

begin
  window := FindWindow(nil, 'Golden Temp Administrator');
  if window <> 0 then
  begin
    if IsIconic(window) then
      ShowWindow(window, SW_SHOWNORMAL)
    else
      SetForegroundWindow(window);
    Exit;
  end;

  Application.Initialize;
  Application.Title := 'Golden Temp Administrator';
  Application.HelpFile := 'GoldenTemp.chm';
  Application.CreateForm(TAdministratorMainForm, AdministratorMainForm);
  Application.Run;
end.

unit uTeacherForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Buttons,
  ImgList,
  uRemotable;

type

  TLoginState = (lsNo, lsNoChecked, lsOK, lsFail);

  TTeacherForm = class(TForm)
    PanelMain: TPanel;
    LabeledEditLogin: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEditPassword: TEdit;
    LabeledEditName: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    LabeledEditSurname: TEdit;
    Label6: TLabel;
    LabeledEditCathedra: TEdit;
    Label7: TLabel;
    ComboBoxPosition: TComboBox;
    PanelBottom: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    LabelError: TLabel;
    procedure FormShow(Sender: TObject);
    procedure LabeledEditLoginChange(Sender: TObject);
    procedure LabeledEditSurnameChange(Sender: TObject);
    procedure LabeledEditLoginKeyPress(Sender: TObject; var Key: Char);
    procedure BitBtnOkClick(Sender: TObject);
    procedure LabeledEditPasswordChange(Sender: TObject);
    private
      FLoginsChangManualy: Boolean; // логін змінювався вручну, а не транслітерувався з імені
    private
      procedure CheckValues;
      function IsDataChanged: Boolean;
    public
      Teacher: TTeacher;
  end;

implementation

uses
  uInterfaces,
  uFactories,
  uUtils,
  uTexts,
  uMainUnit;

{$R *.dfm}
{ TStudentForm }

procedure TTeacherForm.CheckValues;
var
  ok: boolean;
  message: string;
begin
  ok := True;
  if LabeledEditLogin.Text = '' then
  begin
    message := cEmptyLogin;
    ok := False;
  end;
  if ok and (LabeledEditPassword.Text = '') then
  begin
    message := cEmptyPassword;
    ok := False;
  end;
  if ok and not IsShortText(LabeledEditLogin.Text) then
  begin
    message := cLongLogin;
    ok := False;
  end;
  if ok and not IsShortText(LabeledEditPassword.Text) then
  begin
    message := cLongPassword;
    ok := False;
  end;
  if ok and not IsShortText(LabeledEditName.Text) then
  begin
    message := cLongName;
    ok := False;
  end;
  if ok and not IsShortText(LabeledEditSurname.Text) then
  begin
    message := cLongSurname;
    ok := False;
  end;
  if ok and not IsShortText(LabeledEditCathedra.Text) then
  begin
    message := cLongCathedra;
    ok := False;
  end;

  BitBtnOk.Enabled := ok;
  if not ok then
    LabelError.Caption := message
  else
    LabelError.Caption := '';
end;

function TTeacherForm.IsDataChanged: Boolean;
begin
  if Teacher.Id <> 0 then
    Result := (Teacher.Login <> LabeledEditLogin.Text) or (Teacher.Name <> LabeledEditName.Text) or (Teacher.Surname <> LabeledEditSurname.Text) or
      (Teacher.Password <> LabeledEditPassword.Text) or (Teacher.Pulpit <> LabeledEditCathedra.Text) or (Teacher.Job <> ComboBoxPosition.Text)
  else
    Result := ('' <> LabeledEditLogin.Text) or ('' <> LabeledEditName.Text) or ('' <> LabeledEditSurname.Text) or ('' <> LabeledEditPassword.Text) or
      ('' <> LabeledEditCathedra.Text) or ('' <> ComboBoxPosition.Text);
end;

procedure TTeacherForm.LabeledEditLoginChange(Sender: TObject);
begin
  CheckValues;
end;

procedure TTeacherForm.LabeledEditLoginKeyPress(Sender: TObject; var Key: Char);
begin
  FLoginsChangManualy := Trim(LabeledEditLogin.Text) <> '';
end;

procedure TTeacherForm.LabeledEditPasswordChange(Sender: TObject);
begin
  CheckValues;
end;

procedure TTeacherForm.LabeledEditSurnameChange(Sender: TObject);
begin
  if not FLoginsChangManualy then
  begin
    LabeledEditLogin.Text := TranslitKir2Lat(LabeledEditSurname.Text);
    if LabeledEditName.Text <> '' then
      LabeledEditLogin.Text := LabeledEditLogin.Text + '_' + TranslitKir2Lat(LabeledEditName.Text);
  end;
end;

procedure TTeacherForm.FormShow(Sender: TObject);
begin
  LabeledEditLogin.Text := Teacher.Login;
  LabeledEditPassword.Text := Teacher.Password;
  LabeledEditName.Text := Teacher.Name;
  LabeledEditSurname.Text := Teacher.Surname;
  LabeledEditCathedra.Text := Teacher.Pulpit;
  if Teacher.Job = '' then
    ComboBoxPosition.ItemIndex := 0
  else
    ComboBoxPosition.ItemIndex := ComboBoxPosition.Items.IndexOf(Teacher.Job);
  CheckValues;
end;

procedure TTeacherForm.BitBtnOkClick(Sender: TObject);
var
  splash: ISplash;
  teach: TTeacher;
  server: IAdministrator;
begin
  if not IsDataChanged then
  begin
    ModalResult := mrCancel;
    Exit;
  end;

  teach := TTeacher.Create;
  teach.CopyFrom(Teacher);
  teach.Login := LabeledEditLogin.Text;
  teach.Password := LabeledEditPassword.Text;
  teach.Name := LabeledEditName.Text;
  teach.Surname := LabeledEditSurname.Text;
  teach.Pulpit := LabeledEditCathedra.Text;
  if ComboBoxPosition.ItemIndex = 0 then
    teach.Job := ''
  else
    teach.Job := ComboBoxPosition.Text;
  try
    splash := Dialog.NewSplash(Self);
    try
      server := Remotable.NewAdministrator();
      if teach.Id = 0 then
      begin
        splash.ShowSplash(cAddTeacher);
        teach.Id := server.TeacherAdd(Remotable.Account, teach);
      end
      else
      begin
        splash.ShowSplash(cEditTeacher);
        server.TeacherEdit(Remotable.Account, teach);
      end;
    finally
      splash.HideSplash;
    end;
    Teacher.CopyFrom(teach);
    teach.Free;
  except
    on E: ERemotableError do
    begin
      ModalResult := mrNone;
      Dialog.ShowWarningMessage(E.Message, Self);
      Exit;
    end;
  end;
  ModalResult := mrOk;
end;

end.

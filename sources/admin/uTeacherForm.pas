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
    ImageList: TImageList;
    ButtonCheckLogin: TImage;
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
    procedure ButtonCheckLoginClick(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure LabeledEditPasswordChange(Sender: TObject);
    private
      fLoginsChangManualy: Boolean;
    private
      procedure SetLoginState(aState: TLoginState);
      procedure CheckValues;
      procedure SetPicture(aButton: TImage; aPictureNumber: Integer);
      function CheckLogin(aLogin: WideString): Boolean;
      function IsDataChanged: Boolean;
    public
      Host: string;
      Account: TAccount;
      TeacherSurname, TeacherName, TeacherLogin, TeacherPassword, TeacherCathedra, TeacherPosition: WideString;
      NewTeacherSurname, NewTeacherName, NewTeacherLogin, NewTeacherPassword, NewTeacherCathedra, NewTeacherPosition: WideString;
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

function TTeacherForm.CheckLogin(aLogin: WideString): Boolean;
var
  splash: ISplash;
  teachers: TTeachers;
begin
  splash := Dialog.NewSplash(Self);
  splash.ShowSplash(cCheckLoginUnical);
  try
    teachers := Remotable.Administrator.TeacherGet(Account, aLogin);
    Result := Length(teachers) = 0;
  finally
    splash.HideSplash;
  end;
end;

procedure TTeacherForm.CheckValues;
var
  ok: boolean;
  message: WideString;
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
  if TeacherLogin <> '' then
    Result := (TeacherLogin <> LabeledEditLogin.Text) or (TeacherName <> LabeledEditName.Text) or (TeacherSurname <> LabeledEditSurname.Text) or
      (TeacherPassword <> LabeledEditPassword.Text) or (TeacherCathedra <> LabeledEditCathedra.Text) or (TeacherPosition <> ComboBoxPosition.Text)
  else
    Result := ('' <> LabeledEditLogin.Text) or ('' <> LabeledEditName.Text) or ('' <> LabeledEditSurname.Text) or ('' <> LabeledEditPassword.Text) or
      ('' <> LabeledEditCathedra.Text) or ('' <> ComboBoxPosition.Text);
end;

procedure TTeacherForm.LabeledEditLoginChange(Sender: TObject);
begin
  if Trim(LabeledEditLogin.Text) <> '' then
    SetLoginState(lsNoChecked)
  else
    SetLoginState(lsNo);
  CheckValues;
end;

procedure TTeacherForm.LabeledEditLoginKeyPress(Sender: TObject; var Key: Char);
begin
  fLoginsChangManualy := Trim(LabeledEditLogin.Text) <> '';
end;

procedure TTeacherForm.LabeledEditPasswordChange(Sender: TObject);
begin
  CheckValues;
end;

procedure TTeacherForm.LabeledEditSurnameChange(Sender: TObject);
begin
  if not fLoginsChangManualy then
  begin
    LabeledEditLogin.Text := TranslitKir2Lat(LabeledEditSurname.Text);
    if LabeledEditName.Text <> '' then
      LabeledEditLogin.Text := LabeledEditLogin.Text + '_' + TranslitKir2Lat(LabeledEditName.Text);
  end;
end;

procedure TTeacherForm.SetLoginState(aState: TLoginState);
begin
  case aState of
    lsNo:
      begin
        SetPicture(ButtonCheckLogin, 0);
        ButtonCheckLogin.Hint := '';
        ButtonCheckLogin.Enabled := False;
      end;
    lsNoChecked:
      begin
        SetPicture(ButtonCheckLogin, 1);
        ButtonCheckLogin.Hint := cCheckLoginAvailable;
        ButtonCheckLogin.Enabled := True;
      end;
    lsOK:
      begin
        SetPicture(ButtonCheckLogin, 2);
        ButtonCheckLogin.Hint := cLoginUnical;
        ButtonCheckLogin.Enabled := False;
      end;
    lsFail:
      begin
        SetPicture(ButtonCheckLogin, 3);
        ButtonCheckLogin.Hint := cTeacherAlreadyExists;
        ButtonCheckLogin.Enabled := False;
      end;
  end;
end;

procedure TTeacherForm.SetPicture(aButton: TImage; aPictureNumber: Integer);
var
  btm: TBitmap;
begin
  btm := TBitmap.Create;
  try
    ImageList.GetBitmap(aPictureNumber, btm);
    btm.TransparentColor := clWhite;
    aButton.Picture.Bitmap := btm;
    aButton.Transparent := True;
  finally
    btm.Free;
  end;
end;

procedure TTeacherForm.FormShow(Sender: TObject);
begin
  LabeledEditLogin.Text := TeacherLogin;
  if TeacherLogin <> '' then
  begin
    SetLoginState(lsOK);
    fLoginsChangManualy := True;
  end
  else
  begin
    SetLoginState(lsNo);
    fLoginsChangManualy := False;
  end;
  LabeledEditPassword.Text := TeacherPassword;
  LabeledEditName.Text := TeacherName;
  LabeledEditSurname.Text := TeacherSurname;
  LabeledEditCathedra.Text := TeacherCathedra;
  if TeacherPosition = '' then
    ComboBoxPosition.ItemIndex := 0
  else
    ComboBoxPosition.ItemIndex := ComboBoxPosition.Items.IndexOf(TeacherPosition);
  CheckValues;
end;

procedure TTeacherForm.BitBtnOkClick(Sender: TObject);
var
  splash: ISplash;
  teacher: TTeacher;
begin
  if not IsDataChanged then
  begin
    ModalResult := mrCancel;
    Exit;
  end;
  splash := Dialog.NewSplash(Self);
  try
    teacher := TTeacher.Create;
    teacher.Login := LabeledEditLogin.Text;
    teacher.Password := LabeledEditPassword.Text;
    teacher.name := LabeledEditName.Text;
    teacher.Surname := LabeledEditSurname.Text;
    teacher.Pulpit := LabeledEditCathedra.Text;
    if ComboBoxPosition.ItemIndex <> 0 then
      teacher.Job := ComboBoxPosition.Text;
    try
    if TeacherLogin = '' then
    begin
      splash.ShowSplash(cAddTeacher);
      Remotable.Administrator.TeacherAdd(Account, teacher);
    end
    else
    begin
      splash.ShowSplash(cEditTeacher);
      Remotable.Administrator.TeacherEdit(Account, teacher);
    end;
    except
      on E: ERemotableError do
      begin
        ModalResult := mrCancel;
        ShowWarningMessage(E.Message);
        Exit;
      end;
    end;
    NewTeacherLogin := LabeledEditLogin.Text;
    NewTeacherPassword := LabeledEditPassword.Text;
    NewTeacherName := LabeledEditName.Text;
    NewTeacherSurname := LabeledEditSurname.Text;
    NewTeacherCathedra := LabeledEditCathedra.Text;
    NewTeacherPosition := ComboBoxPosition.Text;
  finally
    splash.HideSplash;
  end;
  ModalResult := mrOk;
end;

procedure TTeacherForm.ButtonCheckLoginClick(Sender: TObject);
begin
  if CheckLogin(LabeledEditLogin.Text) then
    SetLoginState(lsOK)
  else
    SetLoginState(lsFail);
end;

end.

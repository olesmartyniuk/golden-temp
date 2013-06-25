unit uStudentForm;

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
  Generics.Collections,
  uRemotable;

type

  TLoginState = (lsNo, lsNoChecked, lsOK, lsFail);

  TStudentForm = class(TForm)
    PanelMain: TPanel;
    LabeledEditLogin: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    LabeledEditPassword: TEdit;
    LabeledEditName: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    LabeledEditSurname: TEdit;
    ComboBoxGroups: TComboBox;
    Label5: TLabel;
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
      FLoginChangeManualy: Boolean;
    private
      procedure CheckValues;
      function IsDataChanged: Boolean;
    public
      Student: TStudent;
      Groups: TList<TGroup>;
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

procedure TStudentForm.CheckValues;
var
  ok: boolean;
  error: string;
begin
  ok := True;

  if LabeledEditLogin.Text = '' then
  begin
    error := cEmptyLogin;
    ok := False;
  end;

  if ok and (LabeledEditPassword.Text = '') then
  begin
    error := cEmptyPassword;
    ok := False;
  end;

  if ok and not IsShortText(LabeledEditLogin.Text) then
  begin
    error := cLongLogin;
    ok := False;
  end;

  if ok and not IsShortText(LabeledEditLogin.Text) then
  begin
    error := cLongPassword;
    ok := False;
  end;

  if ok and not IsShortText(LabeledEditName.Text) then
  begin
    error := cLongName;
    ok := False;
  end;

  if ok and not IsShortText(LabeledEditName.Text) then
  begin
    error := cLongSurname;
    ok := False;
  end;

  BitBtnOk.Enabled := ok;
  if not ok then
    LabelError.Caption := error
  else
    LabelError.Caption := '';
end;

function TStudentForm.IsDataChanged: Boolean;
begin
  if Student.Id > 0 then
    Result := (Student.Login <> LabeledEditLogin.Text) or (Student.Name <> LabeledEditName.Text) or (Student.Surname <> LabeledEditSurname.Text) or
      (Student.Password <> LabeledEditPassword.Text) or (Student.GroupId <> Integer(ComboBoxGroups.Items.Objects[ComboBoxGroups.ItemIndex]))
  else
    Result := ('' <> LabeledEditLogin.Text) or ('' <> LabeledEditName.Text) or ('' <> LabeledEditSurname.Text) or ('' <> LabeledEditPassword.Text) or
      ((Integer(ComboBoxGroups.Items.Objects[ComboBoxGroups.ItemIndex])) <> 0);
end;

procedure TStudentForm.LabeledEditLoginChange(Sender: TObject);
begin
  CheckValues;
end;

procedure TStudentForm.LabeledEditLoginKeyPress(Sender: TObject; var Key: Char);
begin
  FLoginChangeManualy := Trim(LabeledEditLogin.Text) <> '';
end;

procedure TStudentForm.LabeledEditPasswordChange(Sender: TObject);
begin
  CheckValues;
end;

procedure TStudentForm.LabeledEditSurnameChange(Sender: TObject);
begin
  if not FLoginChangeManualy then
  begin
    LabeledEditLogin.Text := TranslitKir2Lat(LabeledEditSurname.Text);
    if LabeledEditName.Text <> '' then
      LabeledEditLogin.Text := LabeledEditLogin.Text + '_' + TranslitKir2Lat(LabeledEditName.Text);
  end;
end;

procedure TStudentForm.FormShow(Sender: TObject);
var
  i: Integer;
  name: string;
begin
  LabeledEditLogin.Text := Student.Login;
  if Student.Login <> '' then
  begin
    FLoginChangeManualy := True;
  end
  else
  begin
    FLoginChangeManualy := False;
  end;
  LabeledEditPassword.Text := Student.Password;
  LabeledEditName.Text := Student.Name;
  LabeledEditSurname.Text := Student.Surname;

  name := '';
  for i := 0 to Groups.Count - 1 do
  begin
    ComboBoxGroups.Items.AddObject(Groups.Items[i].Name, Pointer(Groups.Items[i].Id));
    if Groups.Items[i].Id = Student.GroupId then
      name := Groups.Items[i].Name;
  end;
  ComboBoxGroups.Items.InsertObject(0, cNoGroups, nil);

  if name = '' then
    ComboBoxGroups.ItemIndex := 0
  else
    ComboBoxGroups.ItemIndex := ComboBoxGroups.Items.IndexOf(name);

  if Groups.Count = 0 then
    ComboBoxGroups.Enabled := False;
  CheckValues;
end;

procedure TStudentForm.BitBtnOkClick(Sender: TObject);
var
  splash: ISplash;
  stud: TStudent;
  server: IAdministrator;
begin
  if not IsDataChanged then
  begin
    ModalResult := mrCancel;
    Exit;
  end;

  try
    stud := TStudent.Create;
    stud.CopyFrom(Student);
    stud.Login := LabeledEditLogin.Text;;
    stud.Password := LabeledEditPassword.Text;
    stud.Name := LabeledEditName.Text;
    stud.Surname := LabeledEditSurname.Text;
    stud.GroupId := Integer(ComboBoxGroups.Items.Objects[ComboBoxGroups.ItemIndex]);

    splash := Dialog.NewSplash(Self);
    splash.ShowSplash(cAddStudent);
    try
      server := Remotable.NewAdministrator();
      if stud.Id = 0 then
        stud.Id := server.StudentAdd(Remotable.Account, stud)
      else
        server.StudentEdit(Remotable.Account, stud);
      Student.CopyFrom(stud);
      stud.Free;
    finally
      splash.HideSplash;
    end;
  except
    on E: ERemotableError do
    begin
      Dialog.ShowWarningMessage(E.Message, Self);
      ModalResult := mrNone;
      Exit;
    end
  end;
  ModalResult := mrOk;
end;

end.

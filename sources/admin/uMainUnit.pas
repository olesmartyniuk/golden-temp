unit uMainUnit;

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
  ComCtrls,
  ImgList,
  Buttons,
  StdCtrls,
  ExtCtrls,
  ActnList,
  Menus,
  AppEvnts,
  uInterfaces,
  XPMan,
  ToolWin,
  SOAPHttpClient,
  Generics.Collections,
  uRemotable;

type

  TServerState = (ssNone, ssStarted, ssStoped);

  TAdministratorMainForm = class(TForm)
    PageControl: TPageControl;
    TabSheetGroups: TTabSheet;
    TabSheetStudents: TTabSheet;
    ListViewGroups: TListView;
    TabSheeTeachers: TTabSheet;
    ListViewStudents: TListView;
    ImageList: TImageList;
    PopupMenuTeacher: TPopupMenu;
    AddTeacherMenu: TMenuItem;
    DelTeacherMenu: TMenuItem;
    EditTeacherMenu: TMenuItem;
    PopupMenuStudents: TPopupMenu;
    StudentEnterGroup: TMenuItem;
    StudentLeaveGroup: TMenuItem;
    ListViewTeachers: TListView;
    ApplicationEvents: TApplicationEvents;
    ActionList: TActionList;
    ActionHelp: TAction;
    ActionStudentEdit: TAction;
    ActionTeacherEdit: TAction;
    ActionGroupEdit: TAction;
    ToolBarTeacher: TToolBar;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolBarGroup: TToolBar;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolBarStudent: TToolBar;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    MainMenu: TMainMenu;
    MenuLogin: TMenuItem;
    MenuHelp: TMenuItem;
    ActionStudentAdd: TAction;
    ActionStudentDel: TAction;
    ActionStudentExport: TAction;
    ActionGroupAdd: TAction;
    ActionTeacherAdd: TAction;
    ActionTeacherDel: TAction;
    ActionTeacherExport: TAction;
    ActionGroupDel: TAction;
    ActionGroupExport: TAction;
    PanelStudents: TPanel;
    ListViewStudentsByGroups: TListView;
    Splitter: TSplitter;
    HelpActionMenuItem: TMenuItem;
    MenuLogout: TMenuItem;
    MenuActions: TMenuItem;
    StatusBar: TPanel;
    LabelStatus: TLabel;
    ImageServerStatus: TImage;
    LabelServerStatus: TLabel;
    N3: TMenuItem;
    PopupMenuGroups: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PanelStudentInGroup: TPanel;
    ActionStudentAddToGroup: TAction;
    ActionStudentDelFromGroup: TAction;
    PopupMenuStudentsInGroup: TPopupMenu;
    ToolBarStudentInGroup: TToolBar;
    ToolButtonStudentAddToGroup: TToolButton;
    ToolButtonStudentDeleteFromGroup: TToolButton;
    N4: TMenuItem;
    N5: TMenuItem;
    ActionAbout: TAction;
    N6: TMenuItem;
    MenuItemAddTeacher: TMenuItem;
    MenuItemAddStudent: TMenuItem;
    MenuItemAddGroup: TMenuItem;
    ActionChangePassword: TAction;
    ChangePassword1: TMenuItem;
    TimerLogin: TTimer;
    ActionLogin: TAction;
    ActionLogout: TAction;
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionHelpExecute(Sender: TObject);
    procedure ActionTeacherEditExecute(Sender: TObject);
    procedure ActionGroupEditExecute(Sender: TObject);
    procedure ActionStudentEditExecute(Sender: TObject);
    procedure ActionStudentAddExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionStudentDelExecute(Sender: TObject);
    procedure ActionGroupAddExecute(Sender: TObject);
    procedure ActionTeacherAddExecute(Sender: TObject);
    procedure ActionTeacherDelExecute(Sender: TObject);
    procedure ActionGroupDelExecute(Sender: TObject);
    procedure ListViewGroupsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ActionStudentAddToGroupExecute(Sender: TObject);
    procedure ActionStudentDelFromGroupExecute(Sender: TObject);
    procedure ListViewStudentsByGroupsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListViewTeachersSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure PageControlChange(Sender: TObject);
    procedure ListViewStudentsDblClick(Sender: TObject);
    procedure ListViewTeachersDblClick(Sender: TObject);
    procedure ListViewGroupsDblClick(Sender: TObject);
    procedure ActionAboutExecute(Sender: TObject);
    procedure ActionChangePasswordExecute(Sender: TObject);
    procedure ListViewTeachersKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewStudentsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewGroupsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewStudentsByGroupsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActionStudentExportExecute(Sender: TObject);
    procedure ActionTeacherExportExecute(Sender: TObject);
    procedure ActionGroupExportExecute(Sender: TObject);
    procedure ListViewTeachersColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewTeachersCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure ListViewStudentsColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewStudentsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure ListViewGroupsColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewGroupsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure ListViewStudentsByGroupsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure FormShow(Sender: TObject);
    procedure TimerLoginTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActionLoginExecute(Sender: TObject);
    procedure ActionLogoutExecute(Sender: TObject);
    private
      FAccount: TAccount;
      FSplash: ISplash;
      FStudents: TList<TStudent>;
      FGroups: TList<TGroup>;
      FTeachers: TList<TTeacher>;
      FSettings: ISettings;
      FGuiBlocked: Boolean;
      FLogined: Boolean;
    private
      procedure ChangeState;
      procedure ShowSplash(const aMessage: WideString);
      procedure HideSplash;
      function Splash: ISplash;
      function GetSelectedStudent: TStudent;
      function GetSelectedGroup: TGroup;
      function GetSelectedTeacher: TTeacher;

      function DelGroup(aName: WideString): Boolean;
      function DelStudent(aLogin: WideString): Boolean;
      function DelTeacher(aLogin: WideString): Boolean;

      procedure GetAll;
      procedure GetGroupsList;
      procedure GetStudentsList;
      procedure GetTeachersList;
      procedure PrintStudents;
      procedure PrintStudentOfGroup(aGroup: WideString);
      procedure PrintGroups;
      procedure PrintTeachers;
      procedure PrintOnImage(aNumber: Integer);

      function Login: Boolean;
    public
      function Account: TAccount;
  end;

var
  AdministratorMainForm: TAdministratorMainForm;

implementation

uses
  uDebug,
  uGroupForm,
  uStudentsListForm,
  uStudentForm,
  uTeacherForm,
  uStudentsAddGroupForm,
  uChangePasswordForm,
  uUtils,
  uFactories,
  uTexts,
  // uExport,
  // uDialogs,
  uSplashImpl,
  uAccountForm;

const
  cMessWaitForAnswer = 'Очікування відповіді від %s...';
  cMessServerStoped = 'Cервер недоступний. Перевірте чи немає помилок в host.';
  cErrNoAuthorize = 'Не вдалося пройти автентифікацію. Перевірте ваш логін і пароль';
  cErrServerStoped = 'Не вдалося з''єднатись із сервером. Сервер призупинено адміністратором';
  cErrunknownError = 'Не вдалося з''єднатись із сервером. На сервері відбулась невідома помилка';
  cMessPasswordChange = 'Зміна паролю...';

{$R *.dfm}

procedure TAdministratorMainForm.ActionGroupAddExecute(Sender: TObject);
var
  form: TGroupForm;
  group: TGroup;
begin
  form := TGroupForm.Create(Self);
  try
    form.Host := Remotable.Host;
    form.Account := Account;
    form.Group := TGroup.Create;
    if form.ShowModal = mrOk then
    begin
      FGroups.Add(group);
      PrintGroups;
    end;
  finally
    form.Free;
  end;
end;

procedure TAdministratorMainForm.ActionGroupDelExecute(Sender: TObject);
var
  group: TGroup;
  i: Integer;
begin
  group := GetSelectedGroup;
  if not Assigned(group) then
    Exit;
  if QueryYesNo(WideFormat(cGroupDeleteConfirm, [group.Name])) = IDYES then
    if DelGroup(group.Name) then
    begin
      for i := 0 to FStudents.Count - 1 do
        if SameText(group.Name, (FStudents.Items[i] as TStudent).Group.Name) then
          (FStudents.Items[i] as TStudent).Group.Name := '';
      FGroups.Delete(FGroups.IndexOf(group));
      PrintGroups;
      PrintStudents;
    end;
end;

procedure TAdministratorMainForm.ActionGroupEditExecute(Sender: TObject);
var
  form: TGroupForm;
  group: TGroup;
  oldName: WideString;
  i: Integer;
begin
  group := GetSelectedGroup;
  if not Assigned(group) then
    Exit;
  form := TGroupForm.Create(Self);
  try
    form.Host := Remotable.Host;
    form.Account := Account;
    form.Group := group;
    oldName := group.Name;
    if form.ShowModal = mrOk then
    begin
      for i := 0 to fStudents.Count - 1 do
        if SameText(fStudents.Items[i].Group.Name, oldName) then
          fStudents.Items[i].Group.Name := group.Name;
      PrintStudents;
      PrintGroups;
    end;
  finally
    form.Free;
  end;
end;

procedure TAdministratorMainForm.ActionGroupExportExecute(Sender: TObject);
begin
  // ExportToExcel(WideFormat(cGroupsExportCaption, [fHost, DateToStr(Now)]), ListViewGroups);
end;

procedure TAdministratorMainForm.ActionStudentEditExecute(Sender: TObject);
var
  form: TStudentForm;
  student: TStudent;
  i: Integer;
begin
  student := GetSelectedStudent;
  if not Assigned(student) then
    Exit;
  form := TStudentForm.Create(Self);
  try
    form.Host := Remotable.Host;
    form.Login := Account.Login;
    form.Password := Account.Password;
    form.Student := student;
    for i := 0 to fGroups.Count - 1 do
      form.Groups.Add(fGroups.Items[i].Name);
    if form.ShowModal = mrOk then
      PrintStudents;
  finally
    form.Free;
  end;
end;

procedure TAdministratorMainForm.ActionStudentExportExecute(Sender: TObject);
begin
  // ExportToExcel(WideFormat(cStudentsExportCaption, [fHost, DateToStr(Now)]), ListViewStudents);
end;

procedure TAdministratorMainForm.ActionTeacherAddExecute(Sender: TObject);
var
  form: TTeacherForm;
  teacher: TTeacher;
begin
  form := TTeacherForm.Create(Self);
  try
    form.Host := Remotable.Host;
    form.Account := Account;
    if form.ShowModal = mrOk then
    begin
      teacher := TTeacher.Create;
      teacher.Login := form.NewTeacherLogin;
      teacher.Password := form.NewTeacherPassword;
      teacher.Name := form.NewTeacherName;
      teacher.Surname := form.NewTeacherSurname;
      teacher.Pulpit := form.NewTeacherCathedra;
      teacher.Job := form.NewTeacherPosition;
      fTeachers.Add(teacher);
      PrintTeachers;
    end;
  finally
    form.Free;
  end;
end;

procedure TAdministratorMainForm.ActionTeacherDelExecute(Sender: TObject);
var
  teacher: TTeacher;
begin
  teacher := GetSelectedTeacher;
  if not Assigned(teacher) then
    Exit;
  if QueryYesNo(WideFormat(cTeacherDeleteConfirm, [teacher.Surname])) = IDYES then
    if DelTeacher(teacher.Login) then
    begin
      FTeachers.Delete(FTeachers.IndexOf(teacher));
      PrintTeachers;
    end;
end;

procedure TAdministratorMainForm.ActionTeacherEditExecute(Sender: TObject);
var
  form: TTeacherForm;
  teacher: TTeacher;
begin
  teacher := GetSelectedTeacher;
  if not Assigned(teacher) then
    Exit;
  form := TTeacherForm.Create(Self);
  try
    form.Host := Remotable.Host;
    form.Account := Account;
    form.TeacherLogin := teacher.Login;
    form.TeacherPassword := teacher.Password;
    form.TeacherName := teacher.Name;
    form.TeacherSurname := teacher.Surname;
    form.TeacherCathedra := teacher.Pulpit;
    form.TeacherPosition := teacher.Job;
    if form.ShowModal = mrOk then
    begin
      teacher.Login := form.NewTeacherLogin;
      teacher.Password := form.NewTeacherPassword;
      teacher.Name := form.NewTeacherName;
      teacher.Surname := form.NewTeacherSurname;
      teacher.Pulpit := form.NewTeacherCathedra;
      teacher.Job := form.NewTeacherPosition;
      PrintTeachers;
    end;
  finally
    form.Free;
  end;
end;

procedure TAdministratorMainForm.ActionTeacherExportExecute(Sender: TObject);
begin
  // ExportToExcel(WideFormat(cTeachersExportCaption, [fHost, DateToStr(Now)]), ListViewTeachers);
end;

procedure TAdministratorMainForm.TimerLoginTimer(Sender: TObject);
begin
  TimerLogin.Enabled := False;
  ActionLogin.Execute;
end;

procedure TAdministratorMainForm.ActionStudentAddExecute(Sender: TObject);
var
  form: TStudentForm;
  i: Integer;
  student: TStudent;
begin
  form := TStudentForm.Create(Self);
  try
    form.Host := Remotable.Host;
    form.Login := Account.Login;
    form.Password := Account.Password;
    student := TStudent.Create;
    for i := 0 to fGroups.Count - 1 do
      form.Groups.Add(fGroups.Items[i].Name);
    form.Student := student;
    if form.ShowModal = mrOk then
    begin
      FStudents.Add(student);
      PrintStudents;
    end;
  finally
    form.Free;
  end;
end;

procedure TAdministratorMainForm.ActionStudentAddToGroupExecute(Sender: TObject);
var
  form: TFormAddStudent;
  group: TGroup;
  studentCount: Integer;
begin
  group := GetSelectedGroup;
  if not Assigned(group) then
    Exit;
  form := TFormAddStudent.Create(Self);
  form.Host := Remotable.Host;
  form.Login := Account.Login;
  form.Password := Account.Password;
  form.Group := group.Name;
  form.Groups := FGroups;
  form.StudentsList := fStudents;
  studentCount := fStudents.Count;
  if (form.ShowModal = mrOK) or (studentCount < fStudents.Count) then
  begin
    PrintStudents;
    PrintStudentOfGroup(group.Name);
  end;
  form.StudentsList := nil;
  form.Free;
end;

function TAdministratorMainForm.Account: TAccount;
begin
  if not Assigned(FAccount) then
    raise Exception.Create('Необхідно виконати вхід на сервер.');
  Result := FAccount;
end;

procedure TAdministratorMainForm.ActionLoginExecute(Sender: TObject);
begin
  if Login then
  begin
    FLogined := True;
    GetAll;
    PageControl.TabIndex := FSettings.GetInt('active_tab', 0);
  end;
end;

procedure TAdministratorMainForm.ActionLogoutExecute(Sender: TObject);
begin
  FLogined := False;
  ChangeState;
end;

procedure TAdministratorMainForm.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  SaveException(E);
  if E.ClassName = 'EDOMParseError' then
    ShowErrorMessage('Не вдалося встановити зв''язок з сервером.', Self)
  else
    ShowErrorMessage(E.Message, Self);
end;

procedure TAdministratorMainForm.ShowSplash(const aMessage: WideString);
begin
  fGuiBlocked := True;
  ChangeState;
  PageControl.Enabled := False;
  Splash.ShowSplash(aMessage);
end;

procedure TAdministratorMainForm.ActionChangePasswordExecute(Sender: TObject);
var
  form: TPasswordForm;
  newPassword, oldPassword: WideString;
begin
  form := TPasswordForm.Create(Self);
  if form.ShowModal = mrCancel then
    Exit;
  oldPassword := form.LabeledEditOld.Text;
  newPassword := form.LabeledEditNew.Text;
  form.Free;

  ShowSplash(cPasswordChange);
  try
    Remotable.Administrator.PasswordEdit(Account, newPassword);
  finally
    HideSplash;
  end;
  Account.Password := newPassword;
  ShowInfoMessage(cPasswordChangeConfirm, Self);
end;

procedure TAdministratorMainForm.ChangeState;
var
  access: Boolean;
begin
  access := not FGuiBlocked;
  case PageControl.TabIndex of
    0:
      LabelStatus.Caption := Format(cAllCount, [FTeachers.Count]);
    1:
      LabelStatus.Caption := Format(cAllCount, [FStudents.Count]);
    2:
      LabelStatus.Caption := Format(cAllCount, [FGroups.Count]);
  end;

  ActionStudentEdit.Enabled := Assigned(ListViewStudents.Selected) and not FGuiBlocked;
  ActionStudentDel.Enabled := Assigned(ListViewStudents.Selected) and not FGuiBlocked;
  ActionStudentExport.Enabled := (ListViewStudents.Items.Count > 0) and not FGuiBlocked;
  ActionStudentAdd.Enabled := access;

  ActionTeacherEdit.Enabled := Assigned(ListViewTeachers.Selected) and not FGuiBlocked;
  ActionTeacherDel.Enabled := Assigned(ListViewTeachers.Selected) and not FGuiBlocked;
  ActionTeacherExport.Enabled := (ListViewTeachers.Items.Count > 0) and not FGuiBlocked;
  ActionTeacherAdd.Enabled := access;

  ActionGroupEdit.Enabled := Assigned(ListViewGroups.Selected) and not FGuiBlocked;
  ActionGroupDel.Enabled := Assigned(ListViewGroups.Selected) and not FGuiBlocked;
  ActionGroupExport.Enabled := (ListViewGroups.Items.Count > 0) and not FGuiBlocked;
  ActionGroupAdd.Enabled := access;

  ActionStudentAddToGroup.Enabled := Assigned(ListViewGroups.Selected) and not FGuiBlocked;
  ActionStudentDelFromGroup.Enabled := Assigned(ListViewStudentsByGroups.Selected) and not FGuiBlocked;

  ActionLogin.Enabled := not FGuiBlocked;
  ActionLogout.Enabled := not FGuiBlocked;

  ActionHelp.Enabled := not FGuiBlocked;
  ActionAbout.Enabled := not FGuiBlocked;

  PageControl.Visible := FLogined;
  StatusBar.Visible := FLogined;
  MenuLogin.Visible := not FLogined;
  MenuLogout.Visible := FLogined;
end;

function TAdministratorMainForm.DelGroup(aName: WideString): Boolean;
begin
  Result := False;
  try
    ShowSplash(cDeletingGroup);
    Remotable.Administrator.GroupDel(Account, AName);
    Result := True;
  finally
    HideSplash;
  end;
end;

function TAdministratorMainForm.DelStudent(aLogin: WideString): Boolean;
begin
  Result := False;
  try
    ShowSplash(cDeletingStudent);
    Remotable.Administrator.StudentDel(Account, ALogin);
    Result := True;
  finally
    HideSplash;
  end;
end;

function TAdministratorMainForm.DelTeacher(aLogin: WideString): Boolean;
begin
  Result := False;
  try
    ShowSplash(cDeletingTeacher);
    Remotable.Administrator.TeacherDel(Account, ALogin);
    Result := True;
  finally
    HideSplash;
  end;
end;

procedure TAdministratorMainForm.FormCreate(Sender: TObject);
var
  left, top, width, height: Integer;
begin
  FStudents := TList<TStudent>.Create;
  FGroups := TList<TGroup>.Create;
  FTeachers := TList<TTeacher>.Create;
  FSettings := Core.NewSettings('administrator');
  Remotable.Host := FSettings.GetStr('host', 'localhost');
  left := FSettings.GetInt('wnd_left', - 1);
  if left <> - 1 then
    Self.Left := left;
  top := FSettings.GetInt('wnd_top', - 1);
  if top <> - 1 then
    Self.Top := top;
  width := FSettings.GetInt('wnd_width', - 1);
  if width <> - 1 then
    Self.Width := width;
  height := FSettings.GetInt('wnd_height', - 1);
  if height <> - 1 then
    Self.Height := height;
end;

procedure TAdministratorMainForm.GetAll;
begin
  ShowSplash(cGetTeachersList);
  try
    GetTeachersList;
    ShowSplash(cGetstudentsList);
    GetStudentsList;
    ShowSplash(cGetGroupsList);
    GetGroupsList;
  finally
    HideSplash;
  end;
  ChangeState;
end;

procedure TAdministratorMainForm.GetGroupsList;
var
  group: TGroup;
  groupArr: TGroups;
  i: Integer;
begin
  groupArr := Remotable.Administrator.GroupGet(Account);
  FGroups.Clear;
  for i := low(groupArr) to high(groupArr) do
    FGroups.Add(groupArr[i]);
  PrintGroups;
end;

function TAdministratorMainForm.GetSelectedGroup: TGroup;
begin
  Result := nil;
  if not Assigned(ListViewGroups.Selected) then
    Exit;
  Result := FGroups.Items[Integer(ListViewGroups.Selected.Data)];
end;

function TAdministratorMainForm.GetSelectedStudent: TStudent;
begin
  Result := nil;
  if not Assigned(ListViewStudents.Selected) then
    Exit;
  Result := FStudents.Items[Integer(ListViewStudents.Selected.Data)];
end;

function TAdministratorMainForm.GetSelectedTeacher: TTeacher;
begin
  Result := nil;
  if not Assigned(ListViewTeachers.Selected) then
    Exit;
  Result := FTeachers.Items[Integer(ListViewTeachers.Selected.Data)];
end;

procedure TAdministratorMainForm.GetStudentsList;
var
  students: TStudents;
  i: Integer;
  adm: IAdministrator;
  acc: TAccount;
begin
  // отримання списку студентів
  adm := Remotable.Administrator;
  acc := Account;
  students := adm.StudentGet(acc);
  FStudents.Clear;
  for i := low(students) to high(students) do
    FStudents.Add(students[i]);
  PrintStudents;
end;

procedure TAdministratorMainForm.GetTeachersList;
var
  teachers: TTeachers;
  i: Integer;
begin
  // отримання списку викладчів
  teachers := Remotable.Administrator.TeacherGet(Account);
  FTeachers.Clear;
  for i := low(teachers) to high(teachers) do
    FTeachers.Add(teachers[i]);
  PrintTeachers;
end;

procedure TAdministratorMainForm.ActionAboutExecute(Sender: TObject);
begin
  // ShowAboutDialog(cProgramName, cProgramdescription);
end;

procedure TAdministratorMainForm.ActionHelpExecute(Sender: TObject);
begin
  { case PageControl.ActivePageIndex of
    0:
    ShowHelp(3020);
    1:
    ShowHelp(3030);
    2:
    ShowHelp(3040);
    end;
  }
end;

procedure TAdministratorMainForm.HideSplash;
begin
  Splash.HideSplash;
  fGuiBlocked := False;
  PageControl.Enabled := True;
  ChangeState;
end;

procedure TAdministratorMainForm.ListViewGroupsColumnClick(Sender: TObject; Column: TListColumn);
begin
  if ListViewGroups.Tag = Column.Index + 1 then
    ListViewGroups.Tag := - ListViewGroups.Tag
  else
    ListViewGroups.Tag := Column.Index + 1;
  ListViewGroups.CustomSort(nil, Column.Index);
end;

procedure TAdministratorMainForm.ListViewGroupsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  group1, group2: TGroup;
begin
  if not (Assigned(Item1) and Assigned(Item2)) then
  begin
    Compare := 0;
    Exit;
  end;
  group1 := FGroups[Integer(Item1.Data)];
  group2 := FGroups[Integer(Item2.Data)];
  case Data of
    0:
      Compare := WideCompareText(group1.Name, group2.Name);
    1:
      Compare := WideCompareText(group1.Description, group2.Description);
  end;
  if ListViewGroups.Tag < 0 then
    Compare := - Compare;
end;

procedure TAdministratorMainForm.ListViewGroupsDblClick(Sender: TObject);
begin
  ActionGroupEdit.Execute;
end;

procedure TAdministratorMainForm.ListViewGroupsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    13:
      ActionGroupEdit.Execute;
    45:
      ActionGroupAdd.Execute;
    46:
      ActionGroupDel.Execute;
  end;
end;

procedure TAdministratorMainForm.ListViewGroupsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
var
  group: TGroup;
begin
  ChangeState;
  group := GetSelectedGroup;
  if not Assigned(group) then
    Exit;
  PrintStudentOfGroup(group.Name);
end;

procedure TAdministratorMainForm.ListViewStudentsByGroupsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  student1, student2: TStudent;
begin
  if not (Assigned(Item1) and Assigned(Item2)) then
  begin
    Compare := 0;
    Exit;
  end;
  student1 := FStudents.Items[Integer(Item1.Data)];
  student2 := FStudents.Items[Integer(Item2.Data)];
  Compare := WideCompareText(student1.Surname + ' ' + student1.Name, student2.Surname + ' ' + student2.Name);
end;

procedure TAdministratorMainForm.ListViewStudentsByGroupsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    45:
      ActionStudentAddToGroup.Execute;
    46:
      ActionStudentDelFromGroup.Execute;
  end;
end;

procedure TAdministratorMainForm.ListViewStudentsByGroupsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  ChangeState;
end;

procedure TAdministratorMainForm.ListViewStudentsColumnClick(Sender: TObject; Column: TListColumn);
begin
  if ListViewStudents.Tag = Column.Index + 1 then
    ListViewStudents.Tag := - ListViewStudents.Tag
  else
    ListViewStudents.Tag := Column.Index + 1;
  ListViewStudents.CustomSort(nil, Column.Index);
end;

procedure TAdministratorMainForm.ListViewStudentsCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  student1, student2: TStudent;
begin
  if not (Assigned(Item1) and Assigned(Item2)) then
  begin
    Compare := 0;
    Exit;
  end;
  student1 := FStudents.Items[Integer(Item1.Data)];
  student2 := FStudents.Items[Integer(Item2.Data)];
  case Data of
    0:
      Compare := WideCompareText(student1.Surname, student2.Surname);
    1:
      Compare := WideCompareText(student1.Name, student2.Name);
    2:
      Compare := WideCompareText(student1.Login, student2.Login);
    3:
      Compare := WideCompareText(student1.Group.Name, student2.Group.Name);
  end;
  if ListViewStudents.Tag < 0 then
    Compare := - Compare;
end;

procedure TAdministratorMainForm.ListViewStudentsDblClick(Sender: TObject);
begin
  ActionStudentEdit.Execute;
end;

procedure TAdministratorMainForm.ListViewStudentsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    13:
      ActionStudentEdit.Execute;
    45:
      ActionStudentAdd.Execute;
    46:
      ActionStudentDel.Execute;
  end;
end;

procedure TAdministratorMainForm.ListViewTeachersColumnClick(Sender: TObject; Column: TListColumn);
begin
  if ListViewTeachers.Tag = Column.Index + 1 then
    ListViewTeachers.Tag := - ListViewTeachers.Tag
  else
    ListViewTeachers.Tag := Column.Index + 1;
  ListViewTeachers.CustomSort(nil, Column.Index);
end;

procedure TAdministratorMainForm.ListViewTeachersCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
var
  teacher1, teacher2: TTeacher;
begin
  if not (Assigned(Item1) and Assigned(Item2)) then
  begin
    Compare := 0;
    Exit;
  end;
  teacher1 := FTeachers.Items[Integer(Item1.Data)];
  teacher2 := FTeachers.Items[Integer(Item2.Data)];
  case Data of
    0:
      Compare := WideCompareText(teacher1.Surname, teacher2.Surname);
    1:
      Compare := WideCompareText(teacher1.Name, teacher2.Name);
    2:
      Compare := WideCompareText(teacher1.Login, teacher2.Login);
    3:
      Compare := WideCompareText(teacher1.Pulpit, teacher2.Pulpit);
    4:
      Compare := WideCompareText(teacher1.Job, teacher2.Job);
  end;
  if ListViewTeachers.Tag < 0 then
    Compare := - Compare;
end;

procedure TAdministratorMainForm.ListViewTeachersDblClick(Sender: TObject);
begin
  ActionTeacherEdit.Execute;
end;

procedure TAdministratorMainForm.ListViewTeachersKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    13:
      ActionTeacherEdit.Execute;
    45:
      ActionTeacherAdd.Execute;
    46:
      ActionTeacherDel.Execute;
  end;
end;

procedure TAdministratorMainForm.ListViewTeachersSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  ChangeState;
end;

function TAdministratorMainForm.Login: Boolean;
var
  splash: ISplash;
  form: TAccountForm;
begin
  Result := False;
  FreeAndNil(FAccount);

  FAccount := TAccount.Create;
  FAccount.Login := 'admin';
  FAccount.Password := FSettings.GetStr('password', '');

  form := TAccountForm.Create(Self);
  try
    form.HelpContext := 3010;
    form.EditHost.Text := Remotable.Host;
    form.Account := FAccount;
    form.EditLogin.Enabled := False;
    form.CheckBoxSavePassword.Checked := FSettings.GetBool('savepassword', False);
    if form.ShowModal <> mrOk then
      Exit;
    Remotable.Host := form.EditHost.Text;
    FAccount.Login := form.EditLogin.Text;
    FAccount.Password := form.EditPassword.Text;

    FSettings.SetBool('savepassword', form.CheckBoxSavePassword.Checked);
    FSettings.SetStr('host', Remotable.Host);
    FSettings.SetStr('login', FAccount.Login);
    if FSettings.GetBool('savepassword', False) then
      FSettings.SetStr('password', FAccount.Password)
    else
      FSettings.SetStr('password', '');

    splash := Dialog.NewSplash(Self);
    splash.ShowSplash(Format(cMessWaitForAnswer, [Remotable.Host]));
    try
      try
        Remotable.Administrator.TeacherGet(FAccount);
        Result := True;
      finally
        splash.HideSplash;
      end;
    except
      on E: ERemotableError do
        ShowWarningMessage(E.Message, Self);
    end;
  finally
    form.Free;
  end;
end;

procedure TAdministratorMainForm.PageControlChange(Sender: TObject);
begin
  ChangeState;
end;

procedure TAdministratorMainForm.PrintGroups;
var
  group: TGroup;
  i: Integer;
begin
  ListViewGroups.Clear;
  for i := 0 to FGroups.Count - 1 do
  begin
    group := FGroups.Items[i];
    with ListViewGroups.Items.Add do
    begin
      ImageIndex := 4;
      Data := Pointer(i);
      Caption := group.Name;
      SubItems.Add(group.Description);
    end;
  end;
  ListViewStudentsByGroups.Clear;
  ListViewGroups.CustomSort(nil, 0);
end;

procedure TAdministratorMainForm.PrintOnImage(aNumber: Integer);
var
  btm: TBitmap;
begin
  btm := TBitmap.Create;
  try
    ImageList.GetBitmap(aNumber, btm);
    btm.TransparentColor := clWhite;
    ImageServerStatus.Picture.Bitmap := btm;
    ImageServerStatus.Transparent := True;
  finally
    btm.Free;
  end;
end;

procedure TAdministratorMainForm.PrintStudentOfGroup(aGroup: WideString);
var
  student: TStudent;
  i: Integer;
begin
  ListViewStudentsByGroups.Clear;
  for i := 0 to FStudents.Count - 1 do
  begin
    student := FStudents.Items[i];
    if not WideSameText(student.Group.Name, aGroup) then
      Continue;
    with ListViewStudentsByGroups.Items.Add do
    begin
      ImageIndex := 2;
      Data := Pointer(i);
      Caption := student.Surname + ' ' + student.Name;
    end;
  end;
  ListViewStudentsByGroups.CustomSort(nil, 0);
end;

procedure TAdministratorMainForm.PrintStudents;
var
  student: TStudent;
  i: Integer;
begin
  ListViewStudents.Clear;
  for i := 0 to FStudents.Count - 1 do
  begin
    student := FStudents.Items[i];
    with ListViewStudents.Items.Add do
    begin
      ImageIndex := 2;
      Data := Pointer(i);
      Caption := student.Surname;
      SubItems.Add(student.Name);
      SubItems.Add(student.Login);
      SubItems.Add(student.Group.Name);
    end;
  end;
  ListViewStudents.CustomSort(nil, 0);
end;

procedure TAdministratorMainForm.PrintTeachers;
var
  teacher: TTeacher;
  i: Integer;
begin
  ListViewTeachers.Clear;
  for i := 0 to FTeachers.Count - 1 do
  begin
    teacher := FTeachers.Items[i];
    with ListViewTeachers.Items.Add do
    begin
      ImageIndex := 3;
      Data := Pointer(i);
      Caption := teacher.Surname;
      SubItems.Add(teacher.Name);
      SubItems.Add(teacher.Login);
      SubItems.Add(teacher.Pulpit);
      SubItems.Add(teacher.Job);
    end;
  end;
  ListViewTeachers.CustomSort(nil, 0);
end;

function TAdministratorMainForm.Splash: ISplash;
begin
  if not Assigned(fSplash) then
  begin
    fSplash := Dialog.NewSplash(Self);
    fSplash.ShowProgress := False;
  end;
  Result := fSplash;
end;

procedure TAdministratorMainForm.ActionStudentDelExecute(Sender: TObject);
var
  student: TStudent;
begin
  student := GetSelectedStudent;
  if Assigned(student) then
    if QueryYesNo(WideFormat(cStudentDeleteConfirm, [student.Surname])) = IDYES then
      if DelStudent(student.Login) then
      begin
        FStudents.Delete(FStudents.IndexOf(student));
        PrintStudents;
      end;
end;

procedure TAdministratorMainForm.ActionStudentDelFromGroupExecute(Sender: TObject);
var
  student: TStudent;
  group: TGroup;
begin
  group := GetSelectedGroup;
  if Assigned(group) then
    student := GetSelectedStudent
  else
    Exit;
  ShowSplash(cDeletingStudFromGroup);
  try
    student.Group.Name := '';
    Remotable.Administrator.StudentEdit(Account, student);
    PrintStudents;
    PrintStudentOfGroup(group.Name);
  finally
    HideSplash;
  end;
end;

procedure TAdministratorMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FSettings.SetInt('active_tab', PageControl.TabIndex);
  FSettings.SetInt('wnd_left', Self.Left);
  FSettings.SetInt('wnd_top', Self.Top);
  FSettings.SetInt('wnd_width', Self.Width);
  FSettings.SetInt('wnd_height', Self.Height);
end;

procedure TAdministratorMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not fGuiBlocked;
end;

procedure TAdministratorMainForm.FormDestroy(Sender: TObject);
begin
  FStudents.Clear;
  FGroups.Clear;
  FTeachers.Clear;
  FreeAndNil(FAccount);
  FStudents := nil;
  FGroups := nil;
  FTeachers := nil;
  FSettings := nil;
end;

procedure TAdministratorMainForm.FormShow(Sender: TObject);
begin
  TimerLogin.Enabled := True;
end;

end.

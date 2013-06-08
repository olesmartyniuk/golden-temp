unit uRemotableImpl;

interface

uses
  Soap.InvokeRegistry,
  System.Types,
  Soap.XSBuiltIns,
  uRemotable;

type

  TServerImpl = class(TInvokableClass, IAdministrator)
    private
      function AuthorizeAdmin(Account: TAccount): TTeacher;
      function AuthorizeTeacher(Account: TAccount): TTeacher;
      procedure CheckNoEmpty(const Value: string);
    public
      function GroupAdd(Account: TAccount; Group: TGroup): Integer; stdcall;
      procedure GroupEdit(Account: TAccount; Group: TGroup); stdcall;
      procedure GroupDel(Account: TAccount; const Name: string); stdcall;
      function GroupGet(Account: TAccount): TGroups; stdcall;

      function TeacherAdd(Account: TAccount; Teacher: TTeacher): Integer; stdcall;
      procedure TeacherEdit(Account: TAccount; Teacher: TTeacher); stdcall;
      procedure TeacherDel(Account: TAccount; TeacherLogin: string); stdcall;
      function TeacherGet(Account: TAccount; const Pulpit: string = ''; const Job: string = ''): TTeachers;

      function StudenAdd(Account: TAccount; Student: TStudent): Integer; stdcall;
      procedure StudentEdit(Account: TAccount; Student: TStudent);
      procedure StudentDel(Account: TAccount; StudentLogin: string); stdcall;
      function StudentGet(Account: TAccount; const Group: string = ''): TStudents; stdcall;
  end;

implementation

uses
  SysUtils,
  uDatabase,
  uServerState;

{ TServerImpl }

function TServerImpl.AuthorizeAdmin(Account: TAccount): TTeacher;
begin
  if not Assigned(Account) then
    raise ENoAuthorize.Create('Не вказані логін та пароль, авторизація неможлива.');

  Result := AuthorizeTeacher(Account);
  if not SameText(Account.Login, 'admin') then
    raise ENoAuthorize.Create('Для виконання команди необхідні права адміністратора.');
end;

function TServerImpl.AuthorizeTeacher(Account: TAccount): TTeacher;
begin
  Result := uDatabase.TeacherGet(Account.Login);
  if not Assigned(Result) then
    raise ENoAuthorize.Create(Format('Викладач %s не існує на сервері.', [Account.Login]));

  if Account.Password <> Result.Password then
    raise ENoAuthorize.Create(Format('Неправильний пароль для викладача %s', [Account.Login]));
end;

procedure TServerImpl.CheckNoEmpty(const Value: string);
begin
  if Trim(Value) = '' then
    raise EWrongValue.Create('Значення не може бути порожнім.');
end;

function TServerImpl.GroupAdd(Account: TAccount; Group: TGroup): Integer;
var
  grp: TGroup;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  CheckNoEmpty(Group.Name);
  grp := uDatabase.GroupGet(Group.Name);
  try
    if not Assigned(grp) then
      uDatabase.GroupAdd(Group)
    else
      raise EAlreadyExists.Create(Format('Група з іменем "%s" вже існує.', [Group.Name]));
  finally
    FreeAndNil(grp);
  end;
end;

procedure TServerImpl.GroupDel(Account: TAccount; const Name: string);
var
  grp: TGroup;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  CheckNoEmpty(Name);
  grp := uDatabase.GroupGet(Name);
  if Assigned(grp) then
    uDatabase.GroupDel(Name)
  else
    raise ENotExists.Create(Format('Група з іменем "%s" не існує.', [Name]));
end;


procedure TServerImpl.GroupEdit(Account: TAccount; Group: TGroup);
var
  grp: TGroup;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  CheckNoEmpty(Group.Name);
  grp := uDatabase.GroupGet(Group.Id);
  if not Assigned(grp) then
    raise ENotExists.Create(Format('Група з Id "%d" не існує.', [Group.Id]));

  grp := uDatabase.GroupGet(Group.Name);
  if Assigned(grp) and (grp.Id <> Group.Id)then
    raise EAlreadyExists.Create(Format('Група з іменем "%s" вже існує.', [Group.Name]));
  uDatabase.GroupChange(Group.Id, Group);
end;


function TServerImpl.GroupGet(Account: TAccount): TGroups;
begin
  Server.CheckState;
  AuthorizeTeacher(Account);
  Result := uDatabase.GroupGetMany();
end;

function TServerImpl.StudenAdd(Account: TAccount; Student: TStudent): Integer;
var
  stud: TStudent;
  group: TGroup;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  CheckNoEmpty(Student.Login);
  CheckNoEmpty(Student.Password);
  stud := uDatabase.StudentGet(Student.Login);
  if Assigned(stud) then
    raise EAlreadyExists.Create(Format('Студент з логіном "%s" вже існує.', [Student.Login]));
  if Student.Group.Name <> '' then
  begin
    group := uDatabase.GroupGet(Student.Group.Name);
    if not Assigned(group) then
      raise ENotExists.Create(Format('Група з іменем "%s" не існує.', [Student.Group.Name]));
  end;
  uDatabase.StudentAdd(Student);
end;


procedure TServerImpl.StudentDel(Account: TAccount; StudentLogin: string);
var
  stud: TStudent;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  stud := uDatabase.StudentGet(StudentLogin);
  if not Assigned(stud) then
    raise ENotExists.Create(Format('Студент з логіном "%s" не існує.', [StudentLogin]));
  uDatabase.StudentDel(StudentLogin);
end;

procedure TServerImpl.StudentEdit(Account: TAccount; Student: TStudent);
var
  stud: TStudent;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  CheckNoEmpty(Student.Login);
  CheckNoEmpty(Student.Password);
  stud := uDatabase.StudentGet(Student.Id);
  if not Assigned(stud) then
    raise ENotExists.Create(Format('Студент з Id "%d" не існує.', [Student.Id]));
  if not SameText(Student.Login, stud.Login) then
  begin
    stud := uDatabase.StudentGet(Student.Login);
    if Assigned(stud) then
      raise EAlreadyExists.Create(Format('Студент з логіном "%s" вже існує.', [Student.Login]));
  end;
  uDatabase.StudentEdit(Student);
end;

function TServerImpl.StudentGet(Account: TAccount; const Group: string): TStudents;
begin
  Server.CheckState;
  AuthorizeTeacher(Account);
  if Group = '' then
    Result := uDatabase.StudentGetMany()
  else
    Result := uDatabase.StudentGetMany('%', '%', '%', Group);
end;

function TServerImpl.TeacherAdd(Account: TAccount; Teacher: TTeacher): Integer;
var
  teach: TTeacher;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  CheckNoEmpty(Teacher.Login);
  CheckNoEmpty(Teacher.Password);
  teach := uDatabase.TeacherGet(Teacher.Login);
  if not Assigned(teach) then
    uDatabase.TeacherAdd(Teacher)
  else
    raise EAlreadyExists.Create(Format('Викладач з логіном "%s" вже існує.', [Teacher.Login]));
end;


procedure TServerImpl.TeacherDel(Account: TAccount; TeacherLogin: string);
var
  teach: TTeacher;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  teach := uDatabase.TeacherGet(TeacherLogin);
  if not Assigned(teach) then
    raise EAlreadyExists.Create(Format('Викладач з логіном "%s" не існує.', [TeacherLogin]));
  uDatabase.TeacherDel(TeacherLogin);
end;


procedure TServerImpl.TeacherEdit(Account: TAccount; Teacher: TTeacher);
var
  teach: TTeacher;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  CheckNoEmpty(Teacher.Login);
  CheckNoEmpty(Teacher.Password);
  teach := uDatabase.TeacherGet(Teacher.Id);
  if not Assigned(teach) then
    raise EAlreadyExists.Create(Format('Викладач з Id "%d" не існує.', [Teacher.Id]));
  if not SameText(teach.Login, Teacher.Login) then
  begin
    teach := uDatabase.TeacherGet(Teacher.Login);
    if Assigned(teach) then
      raise EAlreadyExists.Create(Format('Викладач з логіном "%s" вже існує.', [Teacher.Login]));
  end;
  if Teacher.Login = 'admin' then
    raise ENoAuthorize.Create('Не можна модифікувати дані адміністратора системи.');
  uDatabase.TeacherEdit(Teacher);
end;


function TServerImpl.TeacherGet(Account: TAccount; const Pulpit, Job: string): TTeachers;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  if Pulpit = '' then
    Result := uDatabase.TeacherGetMany()
  else
    Result := uDatabase.TeacherGetMany('%', '%', '%', Pulpit);
end;

initialization

{ Invokable classes must be registered }
InvRegistry.RegisterInvokableClass(TServerImpl);

end.

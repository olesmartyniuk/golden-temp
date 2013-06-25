unit uRemotableImpl;

interface

uses
  Soap.InvokeRegistry,
  System.Types,
  Soap.XSBuiltIns,
  uRemotable,
  uDatabase;

type

  TServerImpl = class(TInvokableClass, IAdministrator)
    private
      function AuthorizeAdmin(const Database: TDatabaseConnect; Account: TAccount): TTeacher;
      function AuthorizeTeacher(const Database: TDatabaseConnect; Account: TAccount): TTeacher;
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

      function StudentAdd(Account: TAccount; Student: TStudent): Integer; stdcall;
      procedure StudentEdit(Account: TAccount; Student: TStudent);
      procedure StudentDel(Account: TAccount; StudentLogin: string); stdcall;
      function StudentGet(Account: TAccount; const Group: string = ''): TStudents; stdcall;

      procedure PasswordEdit(Account: TAccount; const PasswordNew: string);
  end;

implementation

uses
  SysUtils,
  uServerState;

{ TServerImpl }

function TServerImpl.AuthorizeAdmin(const Database: TDatabaseConnect; Account: TAccount): TTeacher;
begin
  if not Assigned(Account) or (Account.Login = '') then
    raise ENoAuthorize.Create('Не вказані логін та пароль, аутентифікація неможлива.');

  Result := AuthorizeTeacher(Database, Account);
  if not SameText(Account.Login, 'admin') then
    raise ENoAuthorize.Create('Для виконання команди необхідні права адміністратора.');
end;

function TServerImpl.AuthorizeTeacher(const Database: TDatabaseConnect; Account: TAccount): TTeacher;
begin
  Result := uDatabase.TeacherGet(Database, Account.Login);
  if not Assigned(Result) then
    raise ENoAuthorize.Create(Format('Користувач не зареєстрований на сервері.', []));

  if Account.Password <> Result.Password then
    raise ENoAuthorize.Create(Format('Некоректний пароль.', []));
end;

procedure TServerImpl.CheckNoEmpty(const Value: string);
begin
  if Trim(Value) = '' then
    raise EWrongValue.Create('Значення не може бути порожнім.');
end;

function TServerImpl.GroupAdd(Account: TAccount; Group: TGroup): Integer;
var
  grp: TGroup;
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    CheckNoEmpty(Group.Name);
    grp := uDatabase.GroupGet(db, Group.Name);
    try
      if not Assigned(grp) then
      begin
        uDatabase.GroupAdd(db, Group);
        Result := Group.Id;
      end
      else
        raise EAlreadyExists.Create(Format('Група з іменем "%s" вже існує.', [Group.Name]));
    finally
      FreeAndNil(grp);
    end;
  finally
    DatabaseClose(db);
  end;
end;

procedure TServerImpl.GroupDel(Account: TAccount; const Name: string);
var
  grp: TGroup;
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    CheckNoEmpty(name);
    grp := uDatabase.GroupGet(db, name);
    if Assigned(grp) then
      uDatabase.GroupDel(db, name)
    else
      raise ENotExists.Create(Format('Група з іменем "%s" не існує.', [name]));
  finally
    DatabaseClose(db);
  end;
end;

procedure TServerImpl.GroupEdit(Account: TAccount; Group: TGroup);
var
  grp: TGroup;
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    CheckNoEmpty(Group.Name);
    grp := uDatabase.GroupGet(db, Group.Id);
    if not Assigned(grp) then
      raise ENotExists.Create(Format('Група з Id "%d" не існує.', [Group.Id]));

    grp := uDatabase.GroupGet(db, Group.Name);
    if Assigned(grp) and (grp.Id <> Group.Id) then
      raise EAlreadyExists.Create(Format('Група з іменем "%s" вже існує.', [Group.Name]));
    uDatabase.GroupEdit(db, Group.Id, Group);
  finally
    DatabaseClose(db);
  end;
end;

function TServerImpl.GroupGet(Account: TAccount): TGroups;
var
  db: TDatabaseConnect;
begin
  db := DatabaseOpen;
  try
    Server.CheckState;
    AuthorizeTeacher(db, Account);
    Result := uDatabase.GroupGetMany(db);
  finally
    DatabaseClose(db);
  end;
end;

procedure TServerImpl.PasswordEdit(Account: TAccount; const PasswordNew: string);
begin
  // TODO
end;

function TServerImpl.StudentAdd(Account: TAccount; Student: TStudent): Integer;
var
  stud: TStudent;
  group: TGroup;
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    CheckNoEmpty(Student.Login);
    CheckNoEmpty(Student.Password);

    stud := uDatabase.StudentGet(db, Student.Login);
    if Assigned(stud) then
      raise EAlreadyExists.Create(Format('Студент з логіном "%s" вже існує.', [Student.Login]));
    if Student.GroupId > 0 then
    begin
      group := uDatabase.GroupGet(db, Student.GroupId);
      if not Assigned(group) then
        raise ENotExists.Create(Format('Група з ID "%d" не існує.', [Student.GroupId]));
    end;
    uDatabase.StudentAdd(db, Student);
    Result := Student.Id;
  finally
    DatabaseClose(db);
  end;
end;

procedure TServerImpl.StudentDel(Account: TAccount; StudentLogin: string);
var
  stud: TStudent;
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    stud := uDatabase.StudentGet(db, StudentLogin);
    if not Assigned(stud) then
      raise ENotExists.Create(Format('Студент з логіном "%s" не існує.', [StudentLogin]));
    uDatabase.StudentDel(db, StudentLogin);
  finally
    DatabaseClose(db);
  end;
end;

procedure TServerImpl.StudentEdit(Account: TAccount; Student: TStudent);
var
  stud: TStudent;
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    CheckNoEmpty(Student.Login);
    CheckNoEmpty(Student.Password);
    stud := uDatabase.StudentGet(db, Student.Id);
    if not Assigned(stud) then
      raise ENotExists.Create(Format('Студент з Id "%d" не існує.', [Student.Id]));
    if not SameText(Student.Login, stud.Login) then
    begin
      stud := uDatabase.StudentGet(db, Student.Login);
      if Assigned(stud) then
        raise EAlreadyExists.Create(Format('Студент з логіном "%s" вже існує.', [Student.Login]));
    end;
    uDatabase.StudentEdit(db, Student);
  finally
    DatabaseClose(db);
  end;
end;

function TServerImpl.StudentGet(Account: TAccount; const Group: string): TStudents;
var
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeTeacher(db, Account);
    if Group = '' then
      Result := uDatabase.StudentGetMany(db)
    else
      Result := uDatabase.StudentGetMany(db, '%', '%', '%', Group);
  finally
    DatabaseClose(db);
  end;
end;

function TServerImpl.TeacherAdd(Account: TAccount; Teacher: TTeacher): Integer;
var
  teach: TTeacher;
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    CheckNoEmpty(Teacher.Login);
    CheckNoEmpty(Teacher.Password);
    teach := uDatabase.TeacherGet(db, Teacher.Login);
    if not Assigned(teach) then
    begin
      uDatabase.TeacherAdd(db, Teacher);
      Result := Teacher.Id;
    end
    else
      raise EAlreadyExists.Create(Format('Викладач з логіном "%s" вже існує.', [Teacher.Login]));
  finally
    DatabaseClose(db);
  end;
end;

procedure TServerImpl.TeacherDel(Account: TAccount; TeacherLogin: string);
var
  teach: TTeacher;
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    teach := uDatabase.TeacherGet(db, TeacherLogin);
    if not Assigned(teach) then
      raise EAlreadyExists.Create(Format('Викладач з логіном "%s" не існує.', [TeacherLogin]));
    uDatabase.TeacherDel(db, TeacherLogin);
  finally
    DatabaseClose(db);
  end;
end;

procedure TServerImpl.TeacherEdit(Account: TAccount; Teacher: TTeacher);
var
  teach: TTeacher;
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    CheckNoEmpty(Teacher.Login);
    CheckNoEmpty(Teacher.Password);
    teach := uDatabase.TeacherGet(db, Teacher.Id);
    if not Assigned(teach) then
      raise EAlreadyExists.Create(Format('Викладач з Id "%d" не існує.', [Teacher.Id]));
    if not SameText(teach.Login, Teacher.Login) then
    begin
      teach := uDatabase.TeacherGet(db, Teacher.Login);
      if Assigned(teach) then
        raise EAlreadyExists.Create(Format('Викладач з логіном "%s" вже існує.', [Teacher.Login]));
    end;
    if Teacher.Login = 'admin' then
      raise ENoAuthorize.Create('Не можна модифікувати дані адміністратора системи.');
    uDatabase.TeacherEdit(db, Teacher);
  finally
    DatabaseClose(db);
  end;
end;

function TServerImpl.TeacherGet(Account: TAccount; const Pulpit, Job: string): TTeachers;
var
  db: TDatabaseConnect;
begin
  Server.CheckState;

  db := DatabaseOpen;
  try
    AuthorizeAdmin(db, Account);
    if Pulpit = '' then
      Result := uDatabase.TeacherGetMany(db)
    else
      Result := uDatabase.TeacherGetMany(db, '%', '%', '%', Pulpit);
  finally
    DatabaseClose(db);
  end;
end;

initialization

{ Invokable classes must be registered }
InvRegistry.RegisterInvokableClass(TServerImpl);

end.

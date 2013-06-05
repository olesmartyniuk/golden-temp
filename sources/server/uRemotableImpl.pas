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
      procedure TeacherDel(Account: TAccount; TeacherLogin: TTeacher); stdcall;
      function TeacherGet(Account: TAccount; const Pulpit: string = ''; const Job: string = ''): TTeachers;

      function StudenAdd(Account: TAccount; Student: TStudent): Integer; stdcall;
      procedure StudentEdit(Account: TAccount; Student: TStudent);
      procedure StudentDel(Account: TAccount; StudentId: Integer); stdcall;
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
begin

end;

procedure TServerImpl.StudentDel(Account: TAccount; StudentId: Integer);
begin

end;

procedure TServerImpl.StudentEdit(Account: TAccount; Student: TStudent);
begin

end;

function TServerImpl.StudentGet(Account: TAccount; const Group: string): TStudents;
begin

end;

function TServerImpl.TeacherAdd(Account: TAccount; Teacher: TTeacher): Integer;
begin

end;

procedure TServerImpl.TeacherDel(Account: TAccount; TeacherLogin: TTeacher);
begin

end;

procedure TServerImpl.TeacherEdit(Account: TAccount; Teacher: TTeacher);
begin

end;

function TServerImpl.TeacherGet(Account: TAccount; const Pulpit, Job: string): TTeachers;
begin

end;

initialization

{ Invokable classes must be registered }
InvRegistry.RegisterInvokableClass(TServerImpl);

end.

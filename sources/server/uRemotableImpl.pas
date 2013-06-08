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
    raise ENoAuthorize.Create('�� ������ ���� �� ������, ����������� ���������.');

  Result := AuthorizeTeacher(Account);
  if not SameText(Account.Login, 'admin') then
    raise ENoAuthorize.Create('��� ��������� ������� �������� ����� ������������.');
end;

function TServerImpl.AuthorizeTeacher(Account: TAccount): TTeacher;
begin
  Result := uDatabase.TeacherGet(Account.Login);
  if not Assigned(Result) then
    raise ENoAuthorize.Create(Format('�������� %s �� ���� �� ������.', [Account.Login]));

  if Account.Password <> Result.Password then
    raise ENoAuthorize.Create(Format('������������ ������ ��� ��������� %s', [Account.Login]));
end;

procedure TServerImpl.CheckNoEmpty(const Value: string);
begin
  if Trim(Value) = '' then
    raise EWrongValue.Create('�������� �� ���� ���� �������.');
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
      raise EAlreadyExists.Create(Format('����� � ������ "%s" ��� ����.', [Group.Name]));
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
    raise ENotExists.Create(Format('����� � ������ "%s" �� ����.', [Name]));
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
    raise ENotExists.Create(Format('����� � Id "%d" �� ����.', [Group.Id]));

  grp := uDatabase.GroupGet(Group.Name);
  if Assigned(grp) and (grp.Id <> Group.Id)then
    raise EAlreadyExists.Create(Format('����� � ������ "%s" ��� ����.', [Group.Name]));
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
    raise EAlreadyExists.Create(Format('������� � ������ "%s" ��� ����.', [Student.Login]));
  if Student.Group.Name <> '' then
  begin
    group := uDatabase.GroupGet(Student.Group.Name);
    if not Assigned(group) then
      raise ENotExists.Create(Format('����� � ������ "%s" �� ����.', [Student.Group.Name]));
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
    raise ENotExists.Create(Format('������� � ������ "%s" �� ����.', [StudentLogin]));
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
    raise ENotExists.Create(Format('������� � Id "%d" �� ����.', [Student.Id]));
  if not SameText(Student.Login, stud.Login) then
  begin
    stud := uDatabase.StudentGet(Student.Login);
    if Assigned(stud) then
      raise EAlreadyExists.Create(Format('������� � ������ "%s" ��� ����.', [Student.Login]));
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
    raise EAlreadyExists.Create(Format('�������� � ������ "%s" ��� ����.', [Teacher.Login]));
end;


procedure TServerImpl.TeacherDel(Account: TAccount; TeacherLogin: string);
var
  teach: TTeacher;
begin
  Server.CheckState;
  AuthorizeAdmin(Account);
  teach := uDatabase.TeacherGet(TeacherLogin);
  if not Assigned(teach) then
    raise EAlreadyExists.Create(Format('�������� � ������ "%s" �� ����.', [TeacherLogin]));
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
    raise EAlreadyExists.Create(Format('�������� � Id "%d" �� ����.', [Teacher.Id]));
  if not SameText(teach.Login, Teacher.Login) then
  begin
    teach := uDatabase.TeacherGet(Teacher.Login);
    if Assigned(teach) then
      raise EAlreadyExists.Create(Format('�������� � ������ "%s" ��� ����.', [Teacher.Login]));
  end;
  if Teacher.Login = 'admin' then
    raise ENoAuthorize.Create('�� ����� ������������ ��� ������������ �������.');
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

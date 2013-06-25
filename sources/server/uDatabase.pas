unit uDatabase;

interface

uses
  Classes,
  Windows,
  SysUtils,
  Dialogs,
  FIBDatabase,
  pFIBDatabase,
  FIBQuery,
  pFIBQuery,
  uRemotable;

type
  TDatabaseConnect = TpFibDataBase;
  TDatabaseQuery = TpFibQuery;

function DatabaseOpen: TDatabaseConnect;
procedure DatabaseClose(ADatabase: TDatabaseConnect);
function QueryOpen(ADatabase: TDatabaseConnect): TDatabaseQuery;
procedure QueryClose(AQuery: TDatabaseQuery);

procedure GroupAdd(const Database: TDatabaseConnect; const Group: TGroup);
procedure GroupDel(const Database: TDatabaseConnect; const GroupName: string);
function GroupGet(const Database: TDatabaseConnect; const GroupName: string): TGroup; overload;
function GroupGet(const Database: TDatabaseConnect; const GroupId: Integer): TGroup; overload;
function GroupGetMany(const Database: TDatabaseConnect; const GroupName: string = '%'): TGroups;
procedure GroupEdit(const Database: TDatabaseConnect; const GroupId: Integer; Group: TGroup);

procedure StudentAdd(const Database: TDatabaseConnect; const Student: TStudent);
function StudentGet(const Database: TDatabaseConnect; const StudentLogin: string): TStudent; overload;
function StudentGet(const Database: TDatabaseConnect; const StudentId: Integer): TStudent; overload;
function StudentGetMany(const Database: TDatabaseConnect; const StudentLogin: string = '%'; const StudentName: string = '%'; const StudentSurname: string = '%'; StudentGroup: string = '%')
  : TStudents;
procedure StudentEdit(const Database: TDatabaseConnect; const Student: TStudent);
procedure StudentDel(const Database: TDatabaseConnect; const StudentLogin: string); overload;
procedure StudentDel(const Database: TDatabaseConnect; const StudentId: Integer); overload;

function TeacherGet(const Database: TDatabaseConnect; const TeacherLogin: string): TTeacher; overload;
function TeacherGet(const Database: TDatabaseConnect; const TeacherId: Integer): TTeacher; overload;
function TeacherGetMany(const Database: TDatabaseConnect; const TeacherLogin: string = '%'; const TeacherName: string = '%'; const TeacherSurname: string = '%'; const Pulpit: string = '%')
  : TTeachers;
procedure TeacherAdd(const Database: TDatabaseConnect; const Teacher: TTeacher);
procedure TeacherDel(const Database: TDatabaseConnect; const TeacherLogin: string);
procedure TeacherEdit(const Database: TDatabaseConnect; const Teacher: TTeacher);

procedure ChangeTeacherPassword(const Database: TDatabaseConnect; Account: TAccount; const NewPassword: string);
procedure ChangeStudentPassword(const Database: TDatabaseConnect; const Login, NewPassword: string);

function AdminPasswordPresent: Boolean;
procedure SetAdminPassword(const Database: TDatabaseConnect; const Password: string);

implementation

uses
  uConfig,
  Math;

function DatabaseOpen: TDatabaseConnect;
var
  db: TpFibDatabase;
begin
  db := TpFibDataBase.Create(nil);
  db.DatabaseName := GetDatabasePath;
  db.ConnectParams.UserName := 'SYSDBA';
  db.ConnectParams.Password := 'masterkey';
  db.LibraryName := 'fbclient.dll';
  db.Open;
  Result := db as TDatabaseConnect;
end;

procedure DatabaseClose(ADatabase: TDatabaseConnect);
var
  db: TpFibDatabase;
begin
  db := ADatabase as TpFibDatabase;
  db.Close;
  db.Free;
end;

function QueryOpen(ADatabase: TDatabaseConnect): TDatabaseQuery;
begin
  Result := TDatabaseQuery.Create(nil);
  Result.Transaction := TpFibTransaction.Create(nil);
  Result.Transaction.DefaultDatabase := ADatabase as TpFibDatabase;
  Result.Database := ADatabase as TpFibDatabase;
  Result.Transaction.StartTransaction;
end;

procedure QueryClose(AQuery: TDatabaseQuery);
begin
  AQuery.Transaction.Commit;
  AQuery.Transaction.Free;
  FreeAndNil(AQuery);
end;

procedure GroupAdd(const Database: TDatabaseConnect; const Group: TGroup);
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.Text := 'insert into GROUPS (NAME, DESCRIPTION) values (:NAME, :DESCRIPTION) returning ID';
    query.ParamByName('NAME').AsString := Group.Name;
    query.ParamByName('DESCRIPTION').AsString := Group.Description;
    query.ExecQuery;
    Group.Id := query.FldByName['ID'].AsInteger;
  finally
    QueryClose(query);
  end;
end;

procedure GroupDel(const Database: TDatabaseConnect; const GroupName: string);
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('delete from GROUPS where NAME=:NAME');
    query.ParamByName('NAME').AsString := GroupName;
    query.ExecQuery;
  finally
    QueryClose(query);
  end;
end;

function GroupGet(const Database: TDatabaseConnect; const GroupName: string): TGroup;
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('select * from GROUPS where NAME=:NAME');
    query.ParamByName('NAME').AsString := GroupName;
    query.ExecQuery;
    if not query.Eof then
    begin
      Result := TGroup.Create;
      Result.Id := query.FldByName['ID'].AsInteger;
      Result.Name := query.FldByName['NAME'].AsString;
      Result.Description := query.FldByName['DESCRIPTION'].AsString;
    end
    else
      Result := nil;
  finally
    QueryClose(query);
  end;
end;

function GroupGet(const Database: TDatabaseConnect; const GroupId: Integer): TGroup;
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('select * from GROUPS where ID=:ID');
    query.ParamByName('ID').AsInteger := GroupId;
    query.ExecQuery;
    if not query.Eof then
    begin
      Result := TGroup.Create;
      Result.Id := query.FldByName['ID'].AsInteger;
      Result.Name := query.FldByName['NAME'].AsString;
      Result.Description := query.FldByName['DESCRIPTION'].AsString;
    end
    else
      Result := nil;
  finally
    QueryClose(query);
  end;
end;

function GroupGetMany(const Database: TDatabaseConnect; const GroupName: string): TGroups;
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    SetLength(Result, 0);
    query.SQL.SetText('select * from GROUPS where NAME like :NAME');
    query.ParamByName('NAME').AsString := GroupName;
    query.ExecQuery;
    while not query.Eof do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[high(Result)] := TGroup.Create;
      Result[high(Result)].Id := query.FldByName['ID'].AsInteger;
      Result[high(Result)].Name := query.FldByName['NAME'].AsString;
      Result[high(Result)].Description := query.FldByName['DESCRIPTION'].AsString;
      query.Next;
    end;
  finally
    QueryClose(query);
  end;
end;

procedure GroupEdit(const Database: TDatabaseConnect; const GroupId: Integer; Group: TGroup);
var
  query: TDatabaseQuery;
  name: string;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('update GROUPS set NAME=:NAME, DESCRIPTION=:DESCRIPTION where ID=:ID');
    query.ParamByName('ID').AsInteger := GroupId;
    query.ParamByName('NAME').AsString := Group.Name;
    query.ParamByName('DESCRIPTION').AsString := Group.Description;
    query.ExecQuery;
  finally
    QueryClose(query);
  end;
end;

procedure StudentAdd(const Database: TDatabaseConnect; const Student: TStudent);
var
  query: TDatabaseQuery;
  Transaction: TpFibTransaction;
  group: TGroup;
begin
  query := QueryOpen(Database);
  try
    if Student.GroupId > 0 then
      group := GroupGet(Database, Student.GroupId)
    else
      group := nil;

    query.SQL.Text := 'insert into STUDENTS (LOGIN, PASSW, NAME, SURNAME, ID_GROUP) values (:LOGIN, :PASSW, :NAME, :SURNAME, :GROUPID) returning ID';
    query.ParamByName('LOGIN').AsString := Student.Login;
    query.ParamByName('PASSW').AsString := Student.Password;
    query.ParamByName('NAME').AsString := Student.Name;
    query.ParamByName('SURNAME').AsString := Student.Surname;
    if Assigned(group) then
      query.ParamByName('GROUPID').AsInteger := group.Id
    else
      query.ParamByName('GROUPID').IsNull := True;
    query.ExecQuery;
    Student.Id := query.FldByName['ID'].AsInteger;

    FreeAndNil(group);
  finally
    QueryClose(query);
  end;
end;

function StudentGet(const Database: TDatabaseConnect; const StudentLogin: string): TStudent;
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.Text := 'select * from STUDENTS where STUDENTS.LOGIN=:LOGIN';
    query.ParamByName('LOGIN').AsString := StudentLogin;
    query.ExecQuery;
    if not query.Eof then
    begin
      Result := TStudent.Create;
      Result.Id := query.FldByName['ID'].AsInteger;
      Result.Login := query.FldByName['LOGIN'].AsString;
      Result.Password := query.FldByName['PASSW'].AsString;
      Result.Name := query.FldByName['NAME'].AsString;
      Result.SurName := query.FldByName['SURNAME'].AsString;
    end
    else
      Result := nil;
  finally
    QueryClose(query);
  end;
end;

function StudentGet(const Database: TDatabaseConnect;const StudentId: Integer): TStudent;
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.Text := 'select * from STUDENTS where ID=:ID';
    query.ParamByName('ID').AsInteger := StudentId;
    query.ExecQuery;
    if not query.Eof then
    begin
      Result := TStudent.Create;
      Result.Id := query.FldByName['ID'].AsInteger;
      Result.Login := query.FldByName['LOGIN'].AsString;
      Result.Password := query.FldByName['PASSW'].AsString;
      Result.Name := query.FldByName['NAME'].AsString;
      Result.SurName := query.FldByName['SURNAME'].AsString;
    end
    else
      Result := nil;
  finally
    QueryClose(query);
  end;
end;

function StudentGetMany(const Database: TDatabaseConnect; const StudentLogin: string = '%'; const StudentName: string = '%'; const StudentSurname: string = '%'; StudentGroup: string = '%')
  : TStudents;
var
  query: TDatabaseQuery;
begin
  SetLength(Result, 0);
  query := QueryOpen(Database);
  try
    if Trim(StudentLogin) <> '' then
    begin
      if StudentGroup = '%' then
      begin
        query.SQL.Text := 'select STUDENTS.*, GROUPS.NAME as GROUPNAME from STUDENTS left join GROUPS on STUDENTS.ID_GROUP=GROUPS.ID ' +
          'where STUDENTS.LOGIN like :LOGIN and STUDENTS.NAME like :NAME and STUDENTS.SURNAME like :SURNAME';
        query.ParamByName('LOGIN').AsString := StudentLogin;
        query.ParamByName('NAME').AsString := StudentName;
        query.ParamByName('SURNAME').AsString := StudentSurname;
      end
      else
      begin
        query.SQL.Text := 'select STUDENTS.* from STUDENTS left join GROUPS on STUDENTS.ID_GROUP=GROUPS.ID ' +
          'where STUDENTS.LOGIN like :LOGIN and STUDENTS.NAME like :NAME and STUDENTS.SURNAME like :SURNAME and GROUPS.NAME like :GROUP';
        query.ParamByName('LOGIN').AsString := StudentLogin;
        query.ParamByName('NAME').AsString := StudentName;
        query.ParamByName('SURNAME').AsString := StudentSurname;
        query.ParamByName('GROUP').AsString := StudentGroup;
      end;
      query.ExecQuery;
      while not query.Eof do
      begin
        SetLength(Result, Length(Result) + 1);
        Result[high(Result)] := TStudent.Create;
        Result[high(Result)].Id := query.FldByName['ID'].AsInteger;
        Result[high(Result)].Login := query.FldByName['LOGIN'].AsString;
        Result[high(Result)].Password := query.FldByName['PASSW'].AsString;
        Result[high(Result)].Name := query.FldByName['NAME'].AsString;
        Result[high(Result)].Surname := query.FldByName['SURNAME'].AsString;
        Result[high(Result)].GroupId := query.FldByName['ID_GROUP'].AsInteger;
        query.Next;
      end;
    end;
  finally
    QueryClose(query);
  end;
end;

procedure StudentDel(const Database: TDatabaseConnect; const StudentLogin: string);
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('delete from STUDENTS where LOGIN=:LOGIN');
    query.ParamByName('LOGIN').AsString := StudentLogin;
    query.ExecQuery;
  finally
    QueryClose(query);
  end;
end;

procedure StudentDel(const Database: TDatabaseConnect; const StudentId: Integer);
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('delete from STUDENTS where ID=:ID');
    query.ParamByName('ID').AsInteger := StudentId;
    query.ExecQuery;
  finally
    QueryClose(query);
  end;
end;

procedure StudentEdit(const Database: TDatabaseConnect; const Student: TStudent);
var
  query: TDatabaseQuery;
  Transaction: TpFibTransaction;
  group: TGroup;
begin
  query := QueryOpen(Database);
  try
    if Student.GroupId > 0 then
      group := GroupGet(Database, Student.GroupId)
    else
      group := nil;

    query.SQL.SetText('update STUDENTS set LOGIN=:LOGIN, PASSW=:PASSW, NAME=:NAME, SURNAME=:SURNAME, ID_GROUP=:GROUPID where ID=:ID');
    query.ParamByName('ID').AsInteger := Student.Id;
    query.ParamByName('LOGIN').AsString := Student.Login;
    query.ParamByName('PASSW').AsString := Student.Password;
    query.ParamByName('NAME').AsString := Student.Name;
    query.ParamByName('SURNAME').AsString := Student.Surname;

    if Assigned(group) then
      query.ParamByName('GROUPID').AsInteger := group.Id
    else
      query.ParamByName('GROUPID').IsNull := True;
    query.ExecQuery;

    FreeAndNil(group);
  finally
    QueryClose(query);
  end;
end;

function TeacherGet(const Database: TDatabaseConnect; const TeacherLogin: string): TTeacher;
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('select * from TEACHERS where LOGIN=:LOGIN');
    query.ParamByName('LOGIN').AsString := TeacherLogin;
    query.ExecQuery;

    if not query.Eof then
    begin
      Result := TTeacher.Create;
      Result.Id := query.FldByName['ID'].AsInteger;
      Result.Login := query.FldByName['LOGIN'].AsString;
      Result.Password := query.FldByName['PASSW'].AsString;
      Result.Name := query.FldByName['NAME'].AsString;
      Result.SurName := query.FldByName['SURNAME'].AsString;
      Result.Pulpit := query.FldByName['PULPIT'].AsString;
      Result.Job := query.FldByName['JOB'].AsString;
    end
    else
      Result := nil;
  finally
    QueryClose(query);
  end;
end;

function TeacherGet(const Database: TDatabaseConnect; const TeacherId: Integer): TTeacher;
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('select * from TEACHERS where ID=:ID');
    query.ParamByName('ID').AsInteger := TeacherId;
    query.ExecQuery;

    if not query.Eof then
    begin
      Result := TTeacher.Create;
      Result.Id := query.FldByName['ID'].AsInteger;
      Result.Login := query.FldByName['LOGIN'].AsString;
      Result.Password := query.FldByName['PASSW'].AsString;
      Result.Name := query.FldByName['NAME'].AsString;
      Result.SurName := query.FldByName['SURNAME'].AsString;
      Result.Pulpit := query.FldByName['PULPIT'].AsString;
      Result.Job := query.FldByName['JOB'].AsString;
    end
    else
      Result := nil;
  finally
    QueryClose(query);
  end;
end;

function TeacherGetMany(const Database: TDatabaseConnect; const TeacherLogin: string = '%'; const TeacherName: string = '%'; const TeacherSurname: string = '%'; const Pulpit: string = '%')
  : TTeachers;
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    SetLength(Result, 0);
    query.SQL.SetText('select * from TEACHERS where LOGIN like :LOGIN and NAME like :NAME and SURNAME like :SURNAME and PULPIT like :PULPIT');
    query.ParamByName('LOGIN').AsString := TeacherLogin;
    query.ParamByName('NAME').AsString := TeacherName;
    query.ParamByName('SURNAME').AsString := TeacherSurname;
    query.ParamByName('PULPIT').AsString := Pulpit;
    query.ExecQuery;
    while not query.Eof do
    begin
      if query.FldByName['LOGIN'].AsString <> 'admin' then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[high(Result)] := TTeacher.Create;
        Result[high(Result)].Id := query.FldByName['ID'].AsInteger;
        Result[high(Result)].Login := query.FldByName['LOGIN'].AsString;
        Result[high(Result)].Password := query.FldByName['PASSW'].AsString;
        Result[high(Result)].Name := query.FldByName['NAME'].AsString;
        Result[high(Result)].Surname := query.FldByName['SURNAME'].AsString;
        Result[high(Result)].Pulpit := query.FldByName['PULPIT'].AsString;
        Result[high(Result)].Job := query.FldByName['JOB'].AsString;
      end;
      query.Next;
    end;
  finally
    QueryClose(query);
  end;
end;

procedure TeacherAdd(const Database: TDatabaseConnect; const Teacher: TTeacher);
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('insert into TEACHERS (LOGIN, PASSW, NAME, SURNAME, PULPIT, JOB) ' +
      'values (:LOGIN, :PASSW, :NAME, :SURNAME, :PULPIT, :JOB) returning ID');
    query.ParamByName('LOGIN').AsString := Teacher.Login;
    query.ParamByName('PASSW').AsString := Teacher.Password;
    query.ParamByName('NAME').AsString := Teacher.Name;
    query.ParamByName('SURNAME').AsString := Teacher.Surname;
    query.ParamByName('PULPIT').AsString := Teacher.Pulpit;
    query.ParamByName('JOB').AsString := Teacher.Job;
    query.ExecQuery;
    Teacher.Id := query.FldByName['ID'].AsInteger;
  finally
    QueryClose(query);
  end;
end;

procedure TeacherDel(const Database: TDatabaseConnect; const TeacherLogin: string);
var
  query: TDatabaseQuery;
begin
  if TeacherLogin = 'admin' then
    raise ENoAuthorize.Create('Не можна видалити адміністратора.');
  query := QueryOpen(Database);
  try
    query.SQL.SetText('delete from TEACHERS where LOGIN=:LOGIN');
    query.ParamByName('LOGIN').AsString := TeacherLogin;
    query.ExecQuery;
  finally
    QueryClose(query);
  end;
end;

procedure TeacherEdit(const Database: TDatabaseConnect; const Teacher: TTeacher);
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('update TEACHERS set LOGIN=:LOGIN, PASSW=:PASSW, NAME=:NAME, SURNAME=:SURNAME, PULPIT=:PULPIT, JOB=:JOB where ID=:ID');
    query.ParamByName('ID').AsInteger := Teacher.Id;
    query.ParamByName('LOGIN').AsString := Teacher.Login;
    query.ParamByName('PASSW').AsString := Teacher.Password;
    query.ParamByName('NAME').AsString := Teacher.Name;
    query.ParamByName('SURNAME').AsString := Teacher.Surname;
    query.ParamByName('PULPIT').AsString := Teacher.Pulpit;
    query.ParamByName('JOB').AsString := Teacher.Job;
    query.ExecQuery;
  finally
    QueryClose(query);
  end;
end;

procedure ChangeTeacherPassword(const Database: TDatabaseConnect; Account: TAccount; const NewPassword: string);
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('update TEACHERS set PASSW=:PASSW where LOGIN=:LOGIN');
    query.ParamByName('PASSW').AsString := NewPassword;
    query.ParamByName('LOGIN').AsString := Account.Login;
    query.ExecQuery;
  finally
    QueryClose(query);
  end;
end;

procedure ChangeStudentPassword(const Database: TDatabaseConnect; const Login, NewPassword: string);
var
  query: TDatabaseQuery;
  TeacherIs: boolean;
  TeacherId: integer;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('update STUDENTS set PASSW=:PASSW where ID=:STUDID');
    query.ParamByName('PASSW').AsString := NewPassword;
    query.ParamByName('STUDID').AsInteger := TeacherId;
    query.ExecQuery;
  finally
    QueryClose(query);
  end;
end;

function AdminPasswordPresent: Boolean;
var
  query: TDatabaseQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  query := QueryOpen(Database);
  try
    Transaction.StartTransaction;
    query.SQL.SetText('select * from TEACHERS where LOGIN=:LOGIN');
    query.ParamByName('LOGIN').AsString := 'admin';
    query.ExecQuery;
    if query.Eof then
    begin
      Transaction.Rollback;
      raise ENoAuthorize.Create(Format('Викладач %s не існує в базі ', ['admin']));
    end
    else
      Result := not query.FldByName['PASSW'].IsNull;
    Transaction.Commit;
  finally
    QueryClose(query);
  end;
end;

procedure SetAdminPassword(const Database: TDatabaseConnect; const Password: string);
var
  query: TDatabaseQuery;
begin
  query := QueryOpen(Database);
  try
    query.SQL.SetText('update TEACHERS set PASSW=:PASSWORD where LOGIN=:LOGIN');
    query.ParamByName('LOGIN').AsString := 'admin';
    query.ParamByName('PASSWORD').AsString := Password;
    query.ExecQuery;
  finally
    QueryClose(query);
  end;
end;

end.

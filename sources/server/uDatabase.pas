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

procedure DbConfigure(var DataBase: TpFibDatabase);
procedure ReqConfigure(var Database: TpFibDataBase; var Transaction: TpFibTransaction; var Query: TpFibQuery);
procedure ReqClear(var Database: TpFibDataBase; var Transaction: TpFibTransaction; var Query: TpFibQuery);

function GroupAdd(const Group: TGroup): Integer;
procedure GroupDel(const GroupName: string);
function GroupGet(const GroupName: string): TGroup; overload;
function GroupGet(const GroupId: Integer): TGroup; overload;
function GroupGetMany(const GroupName: string = '%'): TGroups;
procedure GroupChange(const GroupId: Integer; Group: TGroup);

procedure StudentAdd(const Student: TStudent);
function StudentGet(const StudentLogin: string): TStudent; overload;
function StudentGet(const StudentId: Integer): TStudent; overload;
function StudentGetMany(const StudentLogin: string = '%'; const StudentName: string = '%'; const StudentSurname: string = '%'; StudentGroup: string = '%')
  : TStudents;
procedure StudentEdit(Student: TStudent);
procedure StudentDel(const StudentLogin: string); overload;
procedure StudentDel(const StudentId: Integer); overload;

function TeacherGet(const TeacherLogin: string): TTeacher; overload;
function TeacherGet(const TeacherId: Integer): TTeacher; overload;
function TeacherGetMany(const TeacherLogin: string = '%'; const TeacherName: string = '%'; const TeacherSurname: string = '%'; const Pulpit: string = '%')
  : TTeachers;
function TeacherAdd(const Teacher: TTeacher): Integer;
procedure TeacherDel(const TeacherLogin: string);
procedure TeacherEdit(Teacher: TTeacher);

function GetTeacherId(TeacherLogin: string): integer;
function GetGroupId(const GroupName: string): integer;
function GetTestId(const TeacherLogin, TestName: string): integer;
function GetStudentId(const StudentLogin: string): integer;

procedure ChangeTeacherPassword(Account: TAccount; const NewPassword: string);
procedure ChangeStudentPassword(Login, NewPassword: string);

function AdminPasswordPresent: Boolean;
procedure SetAdminPassword(const Password: string);

implementation

uses
  uConfig,
  Math;

procedure DbConfigure(var DataBase: TpFibDatabase);
begin
  DataBase.DatabaseName := GetDatabasePath;
  DataBase.ConnectParams.UserName := 'SYSDBA';
  DataBase.ConnectParams.Password := 'masterkey';
  DataBase.LibraryName := 'fbclient.dll';
end;

procedure ReqConfigure(var Database: TpFibDataBase; var Transaction: TpFibTransaction; var Query: TpFibQuery);
begin
  Database := TpFibDataBase.Create(nil);
  DBConfigure(Database);
  Transaction := TpFibTransaction.Create(nil);
  Query := TpFibQuery.Create(nil);
  Transaction.DefaultDatabase := Database;
  Query.Database := Database;
  Query.Transaction := Transaction;
  Database.Open;
end;

procedure ReqClear(var Database: TpFibDataBase; var Transaction: TpFibTransaction; var Query: TpFibQuery);
begin
  Database.Close;
  Transaction.Free;
  Query.Free;
  Database.Free;
end;

function GroupAdd(const Group: TGroup): Integer;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.Text := 'insert into GROUPS (NAME, DESCRIPTION) values (:NAME, :DESCRIPTION) returning ID';
    Query.ParamByName('NAME').AsString := Group.Name;
    Query.ParamByName('DESCRIPTION').AsString := Group.Description;
    Query.ExecQuery;
    Result := Query.FldByName['ID'].AsInteger;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure GroupDel(const GroupName: string);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('delete from GROUPS where NAME=:NAME');
    Query.ParamByName('NAME').AsString := GroupName;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function GroupGet(const GroupName: string): TGroup;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from GROUPS where NAME=:NAME');
    Query.ParamByName('NAME').AsString := GroupName;
    Query.ExecQuery;
    if not Query.Eof then
    begin
      Result := TGroup.Create;
      Result.Name := Query.FldByName['NAME'].AsString;
      Result.Description := Query.FldByName['DESCRIPTION'].AsString;
    end
    else
      Result := nil;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function GroupGet(const GroupId: Integer): TGroup;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from GROUPS where ID=:ID');
    Query.ParamByName('ID').AsInteger := GroupId;
    Query.ExecQuery;
    if not Query.Eof then
    begin
      Result := TGroup.Create;
      Result.Name := Query.FldByName['NAME'].AsString;
      Result.Description := Query.FldByName['DESCRIPTION'].AsString;
    end
    else
      Result := nil;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function GroupGetMany(const GroupName: string): TGroups;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    SetLength(Result, 0);
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from GROUPS where NAME like :NAME');
    Query.ParamByName('NAME').AsString := GroupName;
    Query.ExecQuery;
    while not Query.Eof do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[high(Result)] := TGroup.Create;
      Result[high(Result)].Name := Query.FldByName['NAME'].AsString;
      Result[high(Result)].Description := Query.FldByName['DESCRIPTION'].AsString;
      Query.Next;
    end;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure GroupChange(const GroupId: Integer; Group: TGroup);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
  name: string;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('update GROUPS set NAME=:NAME, DESCRIPTION=:DESCRIPTION where ID=:ID');
    Query.ParamByName('NAME').AsString := Group.Name;
    Query.ParamByName('DESCRIPTION').AsString := Group.Description;
    Query.ParamByName('ID').AsInteger := GroupId;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure StudentAdd(const Student: TStudent);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
  groupId: Integer;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    groupId := - 1;
    if Student.Group.Name <> '' then
    begin
      Transaction.StartTransaction;
      Query.SQL.Text := 'select ID from GROUPS where NAME=:NAME';
      Query.ParamByName('NAME').AsString := Student.Group.Name;
      Query.ExecQuery;
      if not Query.Eof then
        groupId := Query.FldByName['ID'].AsInteger;
      Transaction.Commit;
    end;

    Transaction.StartTransaction;
    Query.SQL.Text := 'insert into STUDENTS (LOGIN, PASSW, NAME, SURNAME, ID_GROUP) values (:LOGIN, :PASSW, :NAME, :SURNAME, :GROUPID) returning ID';
    if groupId >= 0 then
      Query.ParamByName('GROUPID').AsInteger := groupId
    else
      Query.ParamByName('GROUPID').IsNull := True;
    Query.ParamByName('LOGIN').AsString := Student.Login;
    Query.ParamByName('PASSW').AsString := Student.Password;
    Query.ParamByName('NAME').AsString := Student.Name;
    Query.ParamByName('SURNAME').AsString := Student.Surname;
    Query.ExecQuery;
    Student.Id := Query.FldByName['ID'].AsInteger;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function StudentGet(const StudentLogin: string): TStudent;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.Text := 'select * from STUDENTS where STUDENTS.LOGIN=:LOGIN';
    Query.ParamByName('LOGIN').AsString := StudentLogin;
    Query.ExecQuery;
    if not Query.Eof then
    begin
      Result := TStudent.Create;
      Result.Id := Query.FldByName['ID'].AsInteger;
      Result.Login := Query.FldByName['LOGIN'].AsString;
      Result.Password := Query.FldByName['PASSW'].AsString;
      Result.Name := Query.FldByName['NAME'].AsString;
      Result.SurName := Query.FldByName['SURNAME'].AsString;
    end
    else
      Result := nil;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function StudentGet(const StudentId: Integer): TStudent;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.Text := 'select * from STUDENTS where ID=:ID';
    Query.ParamByName('ID').AsInteger := StudentId;
    Query.ExecQuery;
    if not Query.Eof then
    begin
      Result := TStudent.Create;
      Result.Id := Query.FldByName['ID'].AsInteger;
      Result.Login := Query.FldByName['LOGIN'].AsString;
      Result.Password := Query.FldByName['PASSW'].AsString;
      Result.Name := Query.FldByName['NAME'].AsString;
      Result.SurName := Query.FldByName['SURNAME'].AsString;
    end
    else
      Result := nil;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function StudentGetMany(const StudentLogin: string = '%'; const StudentName: string = '%'; const StudentSurname: string = '%'; StudentGroup: string = '%')
  : TStudents;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
  Info: string;
  GroupId: integer;
begin
  SetLength(Result, 0);
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    if Trim(StudentLogin) <> '' then
    begin
      if StudentGroup = '%' then
      begin
        Query.SQL.Text := 'select STUDENTS.*, GROUPS.NAME as GROUPNAME from STUDENTS left join GROUPS on STUDENTS.ID_GROUP=GROUPS.ID ' +
          'where STUDENTS.LOGIN like :LOGIN and STUDENTS.NAME like :NAME and STUDENTS.SURNAME like :SURNAME';
        Query.ParamByName('LOGIN').AsString := StudentLogin;
        Query.ParamByName('NAME').AsString := StudentName;
        Query.ParamByName('SURNAME').AsString := StudentSurname;
      end
      else
      begin
        Query.SQL.Text := 'select STUDENTS.*, GROUPS.NAME as GROUPNAME from STUDENTS left join GROUPS on STUDENTS.ID_GROUP=GROUPS.ID ' +
          'where STUDENTS.LOGIN like :LOGIN and STUDENTS.NAME like :NAME and STUDENTS.SURNAME like :SURNAME and GROUPS.NAME like :GROUP';
        Query.ParamByName('LOGIN').AsString := StudentLogin;
        Query.ParamByName('NAME').AsString := StudentName;
        Query.ParamByName('SURNAME').AsString := StudentSurname;
        Query.ParamByName('GROUP').AsString := StudentGroup;
      end;
      Query.ExecQuery;
      while not Query.Eof do
      begin
        SetLength(Result, Length(Result) + 1);
        Result[high(Result)] := TStudent.Create;
        Result[high(Result)].Id := Query.FldByName['ID'].AsInteger;
        Result[high(Result)].Login := Query.FldByName['LOGIN'].AsString;
        Result[high(Result)].Password := Query.FldByName['PASSW'].AsString;
        Result[high(Result)].name := Query.FldByName['NAME'].AsString;
        Result[high(Result)].Surname := Query.FldByName['SURNAME'].AsString;
        Result[high(Result)].Group.Name := Query.FldByName['GROUPNAME'].AsString;
        Query.Next;
      end;
    end;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure StudentDel(const StudentLogin: string);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('delete from STUDENTS where LOGIN=:LOGIN');
    Query.ParamByName('LOGIN').AsString := StudentLogin;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure StudentDel(const StudentId: Integer);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('delete from STUDENTS where ID=:ID');
    Query.ParamByName('ID').AsInteger := StudentId;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;


procedure StudentEdit(Student: TStudent);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('update STUDENTS set LOGIN=:LOGIN, PASSW=:PASSW, NAME=:NAME, SURNAME=:SURNAME, ID_GROUP=:GROUPID where ID=:ID');
    Query.ParamByName('LOGIN').AsString := Student.Login;
    Query.ParamByName('PASSW').AsString := Student.Password;
    Query.ParamByName('NAME').AsString := Student.Name;
    Query.ParamByName('SURNAME').AsString := Student.Surname;
    if Student.Group.Id >= 0 then
      Query.ParamByName('GROUPID').AsInteger := Student.Group.Id
    else
      Query.ParamByName('GROUPID').IsNull := True;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function TeacherGet(const TeacherLogin: string): TTeacher;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
  Info: string;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from TEACHERS where LOGIN=:LOGIN');
    Query.ParamByName('LOGIN').AsString := TeacherLogin;
    Query.ExecQuery;

    if not Query.Eof then
    begin
      Result := TTeacher.Create;
      Result.Id := Query.FldByName['ID'].AsInteger;
      Result.Login := Query.FldByName['LOGIN'].AsString;
      Result.Password := Query.FldByName['PASSW'].AsString;
      Result.Name := Query.FldByName['NAME'].AsString;
      Result.SurName := Query.FldByName['SURNAME'].AsString;
      Result.Pulpit := Query.FldByName['PULPIT'].AsString;
      Result.Job := Query.FldByName['JOB'].AsString;
    end
    else
      Result := nil;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function TeacherGet(const TeacherId: Integer): TTeacher;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
  Info: string;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from TEACHERS where ID=:ID');
    Query.ParamByName('ID').AsInteger := TeacherId;
    Query.ExecQuery;

    if not Query.Eof then
    begin
      Result := TTeacher.Create;
      Result.Id := Query.FldByName['ID'].AsInteger;
      Result.Login := Query.FldByName['LOGIN'].AsString;
      Result.Password := Query.FldByName['PASSW'].AsString;
      Result.Name := Query.FldByName['NAME'].AsString;
      Result.SurName := Query.FldByName['SURNAME'].AsString;
      Result.Pulpit := Query.FldByName['PULPIT'].AsString;
      Result.Job := Query.FldByName['JOB'].AsString;
    end
    else
      Result := nil;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;


function TeacherGetMany(const TeacherLogin: string = '%'; const TeacherName: string = '%'; const TeacherSurname: string = '%'; const Pulpit: string = '%')
  : TTeachers;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
  Info: string;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    SetLength(Result, 0);
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from TEACHERS where LOGIN like :LOGIN and NAME like :NAME and SURNAME like :SURNAME and PULPIT like :PULPIT');
    Query.ParamByName('LOGIN').AsString := TeacherLogin;
    Query.ParamByName('NAME').AsString := TeacherName;
    Query.ParamByName('SURNAME').AsString := TeacherSurname;
    Query.ParamByName('PULPIT').AsString := Pulpit;
    Query.ExecQuery;
    while not Query.Eof do
    begin
      if Query.FldByName['LOGIN'].AsString <> 'admin' then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[high(Result)] := TTeacher.Create;
        Result[high(Result)].Login := Query.FldByName['LOGIN'].AsString;
        Result[high(Result)].Password := Query.FldByName['PASSW'].AsString;
        Result[high(Result)].Name := Query.FldByName['NAME'].AsString;
        Result[high(Result)].Surname := Query.FldByName['SURNAME'].AsString;
        Result[high(Result)].Pulpit := Query.FldByName['PULPIT'].AsString;
        Result[high(Result)].Job := Query.FldByName['JOB'].AsString;
      end;
      Query.Next;
    end;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function TeacherAdd(const Teacher: TTeacher): integer;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('insert into TEACHERS (LOGIN, PASSW, NAME, SURNAME, PULPIT, JOB) ' +
      'values (:LOGIN, :PASSW, :NAME, :SURNAME, :PULPIT, :JOB) returning ID');
    Query.ParamByName('LOGIN').AsString := Teacher.Login;
    Query.ParamByName('PASSW').AsString := Teacher.Password;
    Query.ParamByName('NAME').AsString := Teacher.Name;
    Query.ParamByName('SURNAME').AsString := Teacher.Surname;
    Query.ParamByName('PULPIT').AsString := Teacher.Pulpit;
    Query.ParamByName('JOB').AsString := Teacher.Job;
    Query.ExecQuery;
    Result := Query.FldByName['ID'].AsInteger;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure TeacherDel(const TeacherLogin: string);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  if TeacherLogin = 'admin' then
    raise ENoAuthorize.Create('Не можна видалити адміністратора.');
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('delete from TEACHERS where LOGIN=:LOGIN');
    Query.ParamByName('LOGIN').AsString := TeacherLogin;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure TeacherEdit(Teacher: TTeacher);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('update TEACHERS set LOGIN=:LOGIN, PASSW=:PASSW, NAME=:NAME, SURNAME=:SURNAME, PULPIT=:PULPIT, JOB=:JOB where ID=:ID');
    Query.ParamByName('ID').AsInteger := Teacher.Id;
    Query.ParamByName('LOGIN').AsString := Teacher.Login;
    Query.ParamByName('PASSW').AsString := Teacher.Password;
    Query.ParamByName('NAME').AsString := Teacher.Name;
    Query.ParamByName('SURNAME').AsString := Teacher.Surname;
    Query.ParamByName('PULPIT').AsString := Teacher.Pulpit;
    Query.ParamByName('JOB').AsString := Teacher.Job;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function GetTeacherId(TeacherLogin: string): integer;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from TEACHERS where LOGIN=:LOGIN');
    Query.ParamByName('LOGIN').AsString := TeacherLogin;
    Query.ExecQuery;
    if Query.Eof then
      Result := - 1
    else
      Result := Query.FldByName['ID'].AsInteger;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function GetGroupId(const GroupName: string): integer;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from GROUPS where NAME=:NAME');
    Query.ParamByName('NAME').AsString := GroupName;
    Query.ExecQuery;
    if Query.Eof then
      Result := - 1
    else
      Result := Query.FldByName['ID'].AsInteger;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function GetTestId(const TeacherLogin, TestName: string): integer;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from TESTS, TEACHERS where TESTS.NAME=:NAME and TESTS.ID_TEACHER=TEACHERS.ID and TEACHERS.LOGIN=:LOGIN');
    Query.ParamByName('NAME').AsString := TestName;
    Query.ParamByName('LOGIN').AsString := TeacherLogin;
    Query.ExecQuery;
    if Query.Eof then
      Result := - 1
    else
      Result := Query.FldByName['ID'].AsInteger;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function GetStudentId(const StudentLogin: string): integer;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from STUDENTS where LOGIN=:LOGIN');
    Query.ParamByName('LOGIN').AsString := StudentLogin;
    Query.ExecQuery;
    if Query.Eof then
      Result := - 1
    else
      Result := Query.FldByName['ID'].AsInteger;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure ChangeTeacherPassword(Account: TAccount; const NewPassword: string);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('update TEACHERS set PASSW=:PASSW where LOGIN=:LOGIN');
    Query.ParamByName('PASSW').AsString := NewPassword;
    Query.ParamByName('LOGIN').AsString := Account.Login;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure ChangeStudentPassword(Login, NewPassword: string);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
  TeacherIs: boolean;
  TeacherId: integer;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from STUDENTS where LOGIN=:LOGIN');
    Query.ParamByName('LOGIN').AsString := Login;
    Query.ExecQuery;
    TeacherIs := not Query.Eof;
    TeacherId := Query.FldByName['ID'].AsInteger;
    Transaction.Commit;

    if not TeacherIs then
      raise ENotExists.Create('Студент з логіном ' + Login + ' не існує в базі');

    Transaction.StartTransaction;
    Query.SQL.SetText('update STUDENTS set PASSW=:PASSW where ID=:STUDID');
    Query.ParamByName('PASSW').AsString := NewPassword;
    Query.ParamByName('STUDID').AsInteger := TeacherId;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

function AdminPasswordPresent: Boolean;
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('select * from TEACHERS where LOGIN=:LOGIN');
    Query.ParamByName('LOGIN').AsString := 'admin';
    Query.ExecQuery;
    if Query.Eof then
    begin
      Transaction.Rollback;
      raise ENoAuthorize.Create(Format('Викладач %s не існує в базі ', ['admin']));
    end
    else
      Result := not Query.FldByName['PASSW'].IsNull;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

procedure SetAdminPassword(const Password: string);
var
  Query: TpFibQuery;
  Transaction: TpFibTransaction;
  Database: TpFibDataBase;
begin
  ReqConfigure(Database, Transaction, Query);
  try
    Transaction.StartTransaction;
    Query.SQL.SetText('update TEACHERS set PASSW=:PASSWORD where LOGIN=:LOGIN');
    Query.ParamByName('LOGIN').AsString := 'admin';
    Query.ParamByName('PASSWORD').AsString := Password;
    Query.ExecQuery;
    Transaction.Commit;
  finally
    ReqClear(Database, Transaction, Query);
  end;
end;

end.

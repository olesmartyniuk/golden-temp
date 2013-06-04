{ Invokable implementation File for TGoldenTemp which implements IGoldenTemp }

unit uRemotableImpl;

interface

uses
  Soap.InvokeRegistry,
  System.Types,
  Soap.XSBuiltIns,
  uRemotable;

type

  { TGoldenTemp }
  TServerImpl = class(TInvokableClass, IAdministrator)
    public
      procedure GroupEdit(Account: TAccount; Group: TGroup); stdcall;
      procedure GroupCreate(Account: TAccount; Name: string; Student: TStudent); stdcall;
      procedure GroupDel(Account: TAccount; Name: string); stdcall;
      procedure TeacherEdit(Account: TAccount; Teacher: TTeacher); stdcall;
      procedure StudentEdit(Account: TAccount; Student: TStudent);
      function StudentGet(Account: TAccount; StudentLogin: string): TStudentArray; stdcall;
      procedure TeacherDel(Account: TAccount; TeacherLogin: TTeacher); stdcall;
      procedure StudentDel(Account: TAccount; StudentLogin: TStudent); stdcall;
      procedure StudenAdd(Account: TAccount; Student: TStudent); stdcall;
      procedure TeacherAdd(Account: TAccount; Teacher: TTeacher); stdcall;
  end;

implementation

{ TServerImpl }

procedure TServerImpl.GroupCreate(Account: TAccount; Name: string; Student: TStudent);
begin

end;

procedure TServerImpl.GroupDel(Account: TAccount; Name: string);
begin

end;

procedure TServerImpl.GroupEdit(Account: TAccount; Group: TGroup);
begin

end;

procedure TServerImpl.StudenAdd(Account: TAccount; Student: TStudent);
begin

end;

procedure TServerImpl.StudentDel(Account: TAccount; StudentLogin: TStudent);
begin

end;

procedure TServerImpl.StudentEdit(Account: TAccount; Student: TStudent);
begin

end;

function TServerImpl.StudentGet(Account: TAccount; StudentLogin: string): TStudentArray;
begin

end;

procedure TServerImpl.TeacherAdd(Account: TAccount; Teacher: TTeacher);
begin

end;

procedure TServerImpl.TeacherDel(Account: TAccount; TeacherLogin: TTeacher);
begin

end;

procedure TServerImpl.TeacherEdit(Account: TAccount; Teacher: TTeacher);
begin

end;

initialization

{ Invokable classes must be registered }
InvRegistry.RegisterInvokableClass(TServerImpl);

end.

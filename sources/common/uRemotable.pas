{ Invokable interface IGoldenTemp }

unit uRemotable;

interface

uses
  Soap.InvokeRegistry,
  System.Types,
  Soap.XSBuiltIns;

type
  TGroup = class(TRemotable)
    strict private
      ID: Integer;
      Name: string;
  end;

  TAccount = class(TRemotable)
    strict private
      Login: string;
      Password: string;
  end;

  TTest = class(TRemotable)
    strict private
      ID: Integer;
      Name: string;
      MIX_Questions: Integer;
      MIX_Variant: Integer;
      Time_limit: Integer;
      Accessibility: string;
      Can_close: Integer;
      Greeting: string;
      Congratulations: string;
      Scale: string;
  end;

  TAnswer = class(TRemotable)
    strict private
      ID: Integer;
      Text: string;
      Correct: Boolean;
      Time_ON: Integer;
  end;

  TAnswers = array of TAnswer;

  TQuestion = class(TRemotable)
    strict private
      ID: Integer;
      Name: string;
      Number: Integer;
      Weight: Integer;
      Question_type: Integer;
      Topic: string;
      Content: Boolean;
      Answers: TAnswers;
  end;

  TSession = class(TRemotable)
    strict private
      ID: Integer;
      ID_Test: Integer;
      ID_Student: Integer;
      Active: Boolean;
      Life_time: Integer;
      Closed: Integer;
      Start_time: Integer;
      Finish_time: Integer;
  end;

  TAdmin = class(TRemotable)
    strict private
      ID: Integer;
      Login: string;
      Password: string;
      Name: string;
      Surname: string;
  end;

  TTeacher = class(TRemotable)
    strict private
      ID: Integer;
      Login: string;
      Password: string;
      Name: string;
      Surname: string;
      Pulpit: string;
      Job: string;
  end;

  TStudent = class(TRemotable)
    strict private
      ID: Integer;
      Login: string;
      Password: string;
      Name: string;
      Surname: string;
      Group: string;
  end;

  TStudentArray = array of TStudent;
  TTests = array of TTest;
  TSessions = array of TSession;

  { Invokable interfaces must derive from IInvokable }

  IAdministrator = interface(IInvokable)
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
    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
  end;

  ITeacher = interface
    function ResultsGet(Account: TAccount; StudentLogin: string; GroupName: string; TestName: string; StartDateFrom: TDateTime; StartDateTo: TDateTime)
      : TSessions; stdcall;
    procedure TestEdit(Account: TAccount; TestName: string; Test: TTest); stdcall;
    procedure TestUnblock(Account: TAccount; Name: string); stdcall;
    procedure TestBlock(Account: TAccount; Name: string); stdcall;
    function ToSeeResultsOfTesting(Account: TAccount; StudentLog: string; Answer: TAnswer): TAnswers; stdcall;
    procedure ToRemoveResultsOfTesting(Account: TAccount; Answer: TAnswer); stdcall;
    procedure UploadTest(Account: TAccount; Test: TSoapAttachment); stdcall;
    function DownloadTest(Account: TAccount; TestName: string): TSoapAttachment; stdcall;
  end;

  IStudent = interface
    function TestGetInfo(Account: TAccount; Accessibility: TTest): TTests; stdcall;
    function Sessions_list(Account: TAccount): TSessions; stdcall;
    function TestsGetAvailable(Account: TAccount): TTests; stdcall;
    function TestStart(Account: TAccount; ID: TTest): TSession; stdcall;
    function TestGetNextQuestion(Account: TAccount; Session: TSession; ID: TTest): TQuestion; stdcall;
    procedure SendAnswer(Account: TAccount; Session: TSession; ID_q: TQuestion; TextAnswer: string); stdcall;
  end;

implementation

initialization

{ Invokable interfaces must be registered }
InvRegistry.RegisterInterface(TypeInfo(IAdministrator));

end.

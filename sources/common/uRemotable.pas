{ Invokable interface IGoldenTemp }

unit uRemotable;

interface

uses Soap.InvokeRegistry, System.Types, Soap.XSBuiltIns;

type
    TGroup = class(TRemotable)
  strict private
    ID: Integer;
    Name: String;
  end;
  TAccount = class(TRemotable)
  strict private
    Login: String;
    Password: String;
  end;

  TTest = class(TRemotable)
  strict private
    ID: Integer;
    Name: String;
    MIX_Questions: Integer;
    MIX_Variant: Integer;
    Time_limit: Integer;
    Accessibility: String;
    Can_close: Integer;
    Greeting: String;
    Congratulations: String;
    Scale: String;
  end;

  TAnswer = class(TRemotable)
  strict private
    ID: Integer;
    Text: String;
    Correct: Boolean;
    Time_ON: Integer;
  end;

    TAnswers = array of TAnswer;

  TQuestion = class(TRemotable)
  strict private
    ID: Integer;
    Name: String;
    Number: Integer;
    Weight: Integer;
    Question_type: Integer;
    Topic: String;
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
    Login: String;
    Password: String;
    Name: String;
    Surname: String;
  end;

  TTeacher = class(TRemotable)
  strict private
    ID: Integer;
    Login: String;
    Password: String;
    Name: String;
    Surname: String;
    Pulpit: String;
    Job: String;
  end;

  TStudent = class(TRemotable)
  strict private
    ID: Integer;
    Login: String;
    Password: String;
    Name: String;
    Surname: String;
    Group: String;
  end;

  TStudentArray = array of TStudent;
  TTests = array of TTest;
  TSessions = array of TSession;

  { Invokable interfaces must derive from IInvokable }

  IAdministrator = interface(IInvokable)
 procedure GroupEdit(Account: TAccount; Group: TGroup);stdcall;
    procedure GroupCreate(Account: TAccount; Name: String; Student: TStudent);stdcall;
    procedure GroupDel(Account: TAccount; Name: String);stdcall;
    procedure TeacherEdit(Account: TAccount; Teacher: TTeacher);stdcall;
    procedure StudentEdit(Account: TAccount; Student: TStudent);
    function StudentGet(Account: TAccount; StudentLogin: String): TStudentArray;stdcall;
    procedure TeacherDel(Account: TAccount; TeacherLogin: TTeacher);stdcall;
    procedure StudentDel(Account: TAccount; StudentLogin: TStudent);stdcall;
    procedure StudenAdd(Account: TAccount; Student: TStudent);stdcall;
    procedure TeacherAdd(Account: TAccount; Teacher: TTeacher);stdcall;
    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
  end;

  ITeacher = interface
    function ResultsGet(Account: TAccount; StudentLogin: String;
      GroupName: String; TestName: String; StartDateFrom: TDateTime;
      StartDateTo: TDateTime): TSessions;stdcall;
    procedure TestEdit(Account: TAccount; TestName: String; Test: TTest);stdcall;
    procedure TestUnblock(Account: TAccount; Name: String);stdcall;
    procedure TestBlock(Account: TAccount; Name: String);stdcall;
    function ToSeeResultsOfTesting(Account: TAccount; StudentLog: String; Answer: TAnswer): TAnswers;stdcall;
    procedure ToRemoveResultsOfTesting(Account: TAccount; Answer: TAnswer);stdcall;
    procedure UploadTest(Account: TAccount; Test: TSoapAttachment);stdcall;
    function DownloadTest(Account: TAccount; TestName: String): TSoapAttachment;stdcall;
  end;

  IStudent = interface
    function TestGetInfo(Account: TAccount; Accessibility: TTest): TTests;stdcall;
    function Sessions_list(Account: TAccount): TSessions;stdcall;
    function TestsGetAvailable(Account: TAccount): TTests;stdcall;
    function TestStart(Account: TAccount; ID: TTest): TSession; stdcall;
    function TestGetNextQuestion(Account: TAccount; Session: TSession; ID: TTest): TQuestion;stdcall;
    procedure SendAnswer(Account: TAccount; Session: TSession; ID_q: TQuestion; TextAnswer: String); stdcall;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IAdministrator));

end.

{ Invokable interface IGoldenTemp }

unit uRemotable;

interface

uses
  Soap.InvokeRegistry,
  System.Types,
  Soap.XSBuiltIns;

type
  TSession = class;
  TTest = class;
  TStudent = class;
  TQuestion = class;

  TAccount = class(TRemotable)
    public
      Id: Integer;
      Login: string;
      Password: string;
  end;

  TGroup = class(TRemotable)
    public
      Id: Integer;
      Name: string;
      Description: string;
  end;

  TGroups = array of TGroup;

  TTeacher = class(TRemotable)
    public
      Id: Integer;
      Login: string;
      Password: string;
      Name: string;
      Surname: string;
      Pulpit: string;
      Job: string;
  end;

  TTeachers = array of TTeacher;

  TStudent = class(TRemotable)
    public
      Id: Integer;
      Login: string;
      Password: string;
      Name: string;
      Surname: string;
      /// <clientQualifier>N</clientQualifier>
      /// <supplierQualifier>1</supplierQualifier>
      /// <directed>True</directed>
      /// <label>знаходиться</label>
      Group: TGroup;
  end;

  TStudents = array of TStudent;

  TTest = class(TRemotable)
    public
      Id: Integer;
      Name: string;
      MixQuestions: Boolean;
      MixVariant: Boolean;
      TimeLimit: Word;
      Accessibility: Boolean;
      CanClose: Boolean;
      Greeting: string;
      Congratulations: string;
      Scales: string;
      /// <link>association</link>
      /// <clientQualifier>1</clientQualifier>
      /// <supplierQualifier>N</supplierQualifier>
      /// <directed>True</directed>
      /// <label>включає</label>
      Question: TQuestion;
      /// <clientQualifier>M</clientQualifier>
      /// <supplierQualifier>N</supplierQualifier>
      /// <label>знаходиться</label>
      Group: TGroup;
      /// <supplierQualifier>1</supplierQualifier>
      /// <clientQualifier>N</clientQualifier>
      /// <label>створюється</label>
      Teacher: TTeacher;
  end;

  TTests = array of TTest;

  TVariant = class(TRemotable)
    public
      Id: Integer;
      Number: Word;
      Text: string;
      Correct: Boolean;
      /// <supplierQualifier>1</supplierQualifier>
      /// <clientQualifier>N</clientQualifier>
      /// <directed>True</directed>
      /// <label>належить</label>
      Question: TQuestion;
  end;

  TVariants = array of TVariant;

  TAnswer = class(TRemotable)
    public
      Id: Integer;
      TimeSpent: Integer;
      Text: string;
      Ball: Integer;
      /// <clientCardinality>N</clientCardinality>
      /// <supplierQualifier>1</supplierQualifier>
      /// <directed>True</directed>
      /// <label>належить</label>
      Session: TSession;
      /// <clientQualifier>N</clientQualifier>
      /// <supplierQualifier>1</supplierQualifier>
      /// <label>дається</label>
      /// <directed>True</directed>
      Question: TQuestion;
  end;

  TAnswers = array of TAnswer;

  TQuestion = class(TRemotable)
    public
      Id: Integer;
      Name: string;
      Number: Integer;
      Weight: Integer;
      QuestionType: Integer;
      Topic: string;
      Content: Boolean;
  end;

  TQuestions = array of TQuestion;

  TSession = class(TRemotable)
    public
      Id: Integer;
      Active: Boolean;
      LifeTime: Integer;
      Closed: Integer;
      StartTime: TDateTime;
      FinishTime: TDateTime;
      /// <link>association</link>
      /// <directed>True</directed>
      /// <label>включає</label>
      /// <clientQualifier>N</clientQualifier>
      /// <supplierQualifier>1</supplierQualifier>
      Test: TTest;
      /// <directed>True</directed>
      /// <supplierQualifier>1</supplierQualifier>
      /// <clientQualifier>N</clientQualifier>
      /// <label>створюється</label>
      Student: TStudent;
  end;

  TSessions = array of TSession;

  IAdministrator = interface(IInvokable)
  ['{EE2A67B5-48C1-4A35-80F3-E3D44594C357}']
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

  ITeacher = interface(IInvokable)
  ['{7FC9807B-03BC-4336-8D73-B3006D3AF73F}']
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

  IStudent = interface(IInvokable)
  ['{4E33B4A4-6105-4632-BF90-74BDFC211163}']
    function TestGetInfo(Account: TAccount; Accessibility: TTest): TTests; stdcall;
    function Sessions_list(Account: TAccount): TSessions; stdcall;
    function TestsGetAvailable(Account: TAccount): TTests; stdcall;
    function TestStart(Account: TAccount; ID: TTest): TSession; stdcall;
    function TestGetNextQuestion(Account: TAccount; Session: TSession; ID: TTest): TQuestion; stdcall;
    procedure SendAnswer(Account: TAccount; Session: TSession; ID_q: TQuestion; TextAnswer: string); stdcall;
  end;

  ERemotableError = class(ERemotableException)
    private
      FMessage: string;
    published
      property message: string read FMessage write FMessage;
  end;

  ENoAuthorize = class(ERemotableError); // даному акаунту доступ заборонено, або акаунт не існує
  EAlreadyExists = class(ERemotableError); // даний елемент вже існує
  ENotExists = class(ERemotableError); // даний елемент не існує
  EServerStoped = class(ERemotableError); // сервер зупинено
  EWrongValue = class(ERemotableError); // некоректне значення

implementation

initialization

{ Invokable interfaces must be registered }
InvRegistry.RegisterInterface(TypeInfo(IAdministrator));

RemClassRegistry.RegisterXSClass(TGroup);
RemClassRegistry.RegisterXSInfo(TypeInfo(TGroups));
RemClassRegistry.RegisterXSClass(TStudent);
RemClassRegistry.RegisterXSInfo(TypeInfo(TStudents));
RemClassRegistry.RegisterXSClass(TTeacher);
RemClassRegistry.RegisterXSInfo(TypeInfo(TTeachers));

InvRegistry.RegisterException(TypeInfo(IAdministrator), ERemotableError);
RemClassRegistry.RegisterXSClass(ERemotableError);
RemClassRegistry.RegisterXSClass(ENoAuthorize);
RemClassRegistry.RegisterXSClass(EAlreadyExists);
RemClassRegistry.RegisterXSClass(ENotExists);
RemClassRegistry.RegisterXSClass(EServerStoped);
RemClassRegistry.RegisterXSClass(EWrongValue);

end.

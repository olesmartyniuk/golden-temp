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
    private
      FId: Integer;
      FLogin: string;
      FPassword: string;
    published
      property Id: Integer read FId write FId;
      property Login: string read FLogin write FLogin;
      property Password: string read FPassword write FPassword;
  end;

  TGroup = class(TRemotable)
    private
      FName: string;
      FId: Integer;
      FDescription: string;
    published
      property Id: Integer read FId write FId;
      property Name: string read FName write FName;
      property Description: string read FDescription write FDescription;
    public
      procedure CopyFrom(const Group: TGroup);
  end;

  TGroups = array of TGroup;

  TTeacher = class(TRemotable)
    private
      FName: string;
      FJob: string;
      FSurname: string;
      FId: Integer;
      FPulpit: string;
      FPassword: string;
      FLogin: string;
    published
      property Id: Integer read FId write FId;
      property Login: string read FLogin write FLogin;
      property Password: string read FPassword write FPassword;
      property Name: string read FName write FName;
      property Surname: string read FSurname write FSurname;
      property Pulpit: string read FPulpit write FPulpit;
      property Job: string read FJob write FJob;
    public
      procedure CopyFrom(const Teacher: TTeacher);
  end;

  TTeachers = array of TTeacher;

  TStudent = class(TRemotable)
    private
      FName: string;
      FSurname: string;
      FId: Integer;
      FPassword: string;
      FLogin: string;
      FGroupId: Integer;
    published
      property Id: Integer read FId write FId;
      property Login: string read FLogin write FLogin;
      property Password: string read FPassword write FPassword;
      property Name: string read FName write FName;
      property Surname: string read FSurname write FSurname;
      /// <clientQualifier>N</clientQualifier>
      /// <supplierQualifier>1</supplierQualifier>
      /// <directed>True</directed>
      /// <label>�����������</label>
      property GroupId: Integer read FGroupId write FGroupId;
    public
      procedure CopyFrom(const Student: TStudent);
  end;

  TStudents = array of TStudent;

  TTest = class(TRemotable)
    private
      FId: Integer;
      FName: string;
      FMixQuestions: Boolean;
      FMixVariants: Boolean;
      FCongratulations: string;
      FCanClose: Boolean;
      FGreeting: string;
      FTeacherId: Integer;
      FScales: string;
      FAccessibility: Boolean;
      FTimeLimit: Word;
    published
      property Id: Integer read FId write FId;
      /// <supplierQualifier>1</supplierQualifier>
      /// <clientQualifier>N</clientQualifier>
      /// <label>�����������</label>
      property TeacherId: Integer read FTeacherId write FTeacherId;
      property Name: string read FName write FName;
      property MixQuestions: Boolean read FMixQuestions write FMixQuestions;
      property MixVariants: Boolean read FMixVariants write FMixVariants;
      property TimeLimit: Word read FTimeLimit write FTimeLimit;
      property Accessibility: Boolean read FAccessibility write FAccessibility;
      property CanClose: Boolean read FCanClose write FCanClose;
      property Greeting: string read FGreeting write FGreeting;
      property Congratulations: string read FCongratulations write FCongratulations;
      property Scales: string read FScales write FScales;
  end;

  TTests = array of TTest;

  TQuestion = class(TRemotable)
    private
      FId: Integer;
      FTestId: Integer;
      FName: string;
      FNumber: Integer;
      FWeight: Integer;
      FQuestionType: Integer;
      FTopic: string;
      FContent: Boolean;
    published
      property Id: Integer read FId write FId;
      property TestId: Integer read FTestId write FTestId;
      property Name: string read FName write FName;
      property Number: Integer read FNumber write FNumber;
      property Weight: Integer read FWeight write FWeight;
      property QuestionType: Integer read FQuestionType write FQuestionType;
      property Topic: string read FTopic write FTopic;
      property Content: Boolean read FContent write FContent;
  end;

  TQuestions = array of TQuestion;

  TVariant = class(TRemotable)
    private
      FCorrect: Boolean;
      FId: Integer;
      FQuestionId: Integer;
      FNumber: Word;
      FText: string;
    published
      property Id: Integer read FId write FId;
      property Number: Word read FNumber write FNumber;
      property Text: string read FText write FText;
      property Correct: Boolean read FCorrect write FCorrect;
      /// <supplierQualifier>1</supplierQualifier>
      /// <clientQualifier>N</clientQualifier>
      /// <directed>True</directed>
      /// <label>��������</label>
      property QuestionId: Integer read FQuestionId write FQuestionId;
  end;

  TVariants = array of TVariant;

  TAnswer = class(TRemotable)
    private
      FSessionId: Integer;
      FId: Integer;
      FTimeSpent: Integer;
      FQuestionId: Integer;
      FText: string;
      FBall: Integer;
    published
      property Id: Integer read FId write FId;
      /// <clientQualifier>N</clientQualifier>
      /// <supplierQualifier>1</supplierQualifier>
      /// <label>������</label>
      /// <directed>True</directed>
      ///
      property QuestionId: Integer read FQuestionId write FQuestionId;
      /// <clientCardinality>N</clientCardinality>
      /// <supplierQualifier>1</supplierQualifier>
      /// <directed>True</directed>
      /// <label>��������</label>
      property SessionId: Integer read FSessionId write FSessionId;
      property TimeSpent: Integer read FTimeSpent write FTimeSpent;
      property Text: string read FText write FText;
      property Ball: Integer read FBall write FBall;
  end;

  TAnswers = array of TAnswer;

  TSession = class(TRemotable)
    private
      FClosed: Integer;
      FStartTime: TDateTime;
      FTestId: Integer;
      FId: Integer;
      FLifeTime: Integer;
      FActive: Boolean;
      FStudentId: Integer;
      FFinishTime: TDateTime;
    published
      property Id: Integer read FId write FId;
      /// <link>association</link>
      /// <directed>True</directed>
      /// <label>������</label>
      /// <clientQualifier>N</clientQualifier>
      /// <supplierQualifier>1</supplierQualifier>
      property TestId: Integer read FTestId write FTestId;
      /// <directed>True</directed>
      /// <supplierQualifier>1</supplierQualifier>
      /// <clientQualifier>N</clientQualifier>
      /// <label>�����������</label>
      property StudentId: Integer read FStudentId write FStudentId;
      property Active: Boolean read FActive write FActive;
      property LifeTime: Integer read FLifeTime write FLifeTime;
      property Closed: Integer read FClosed write FClosed;
      property StartTime: TDateTime read FStartTime write FStartTime;
      property FinishTime: TDateTime read FFinishTime write FFinishTime;
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

    function StudentAdd(Account: TAccount; Student: TStudent): Integer; stdcall;
    procedure StudentEdit(Account: TAccount; Student: TStudent);
    procedure StudentDel(Account: TAccount; StudentLogin: string); stdcall;
    function StudentGet(Account: TAccount; const Group: string = ''): TStudents; stdcall;

    procedure PasswordEdit(Account: TAccount; const PasswordNew: string);
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

  ERemotableError = class(ERemotableException);
  ENoAuthorize = class(ERemotableError); // ������ ������� ������ ����������, ��� ������ �� ����
  EAlreadyExists = class(ERemotableError); // ����� ������� ��� ����
  ENotExists = class(ERemotableError); // ����� ������� �� ����
  EServerStoped = class(ERemotableError); // ������ ��������
  EWrongValue = class(ERemotableError); // ���������� ��������

implementation

{ TStudent }

procedure TStudent.CopyFrom(const Student: TStudent);
begin
  FId := Student.Id;
  FName := Student.name;
  FSurname := Student.Surname;
  FPassword := Student.Password;
  FLogin := Student.Login;
  FGroupId := Student.GroupId;
end;

{ TTeacher }

procedure TTeacher.CopyFrom(const Teacher: TTeacher);
begin
  FId := Teacher.Id;
  FName := Teacher.name;
  FSurname := Teacher.Surname;
  FPassword := Teacher.Password;
  FLogin := Teacher.Login;
  FJob := Teacher.Job;
  FPulpit := Teacher.Pulpit;
end;

{ TGroup }

procedure TGroup.CopyFrom(const Group: TGroup);
begin
  FId := Group.Id;
  FName := Group.name;
  FDescription := Group.Description;
end;

initialization

{ Invokable interfaces must be registered }
InvRegistry.RegisterInterface(TypeInfo(IAdministrator));

RemClassRegistry.RegisterXSClass(TAccount);
RemClassRegistry.RegisterXSInfo(TypeInfo(TAccount));
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

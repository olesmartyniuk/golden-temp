unit uInterfaces;

interface

uses
  Classes,
  Controls,
  Forms,
  SysUtils,
  Generics.Collections;

type

  CyrillicString = type AnsiString(1251);

  IStream = interface
    ['{91257BF6-4448-469B-8D37-9DC90D0FDE5A}']
    procedure LoadFromFile(const AFileName: string);
    procedure SaveToFile(const AFileName: string);
    procedure SaveToStream(const Stream: TStream);
    procedure LoadFromString(const AContent: UTF8String);
    procedure LoadFromBase64(const AContent: UTF8String);
    function ToString: UTF8String;
    function ToBase64: UTF8String;

    procedure CopyFrom(const AStream: IStream; ACount: Int64 = - 1); overload;
    procedure CopyFrom(const AStream: TStream; ACount: Int64 = - 1); overload;
    function ReadBuffer(var ABuffer; ACount: Longint): Longint;
    function WriteBuffer(const ABuffer; ACount: Longint): Longint;
    function GetSize: Int64;
    procedure SetSize(AValue: Int64);
    procedure Clear;

    function GetPosition: Int64;
    procedure SetPosition(Value: Int64);

    property Size: Int64 read GetSize write SetSize;
    property Position: Int64 read GetPosition write SetPosition;
  end;

  IList<T> = interface(IInterface)
    function GetEnumerator: TList<T>.TEnumerator;
    function Add(const Value: T): Integer;
    function Count: Integer;
    procedure Clear;
    procedure Delete(AIndex: Integer);
    procedure DeleteItem(AItem: T);
    procedure Insert(AIndex: Integer; const AValue: T);
    function GetItem(AIndex: Integer): T;
    function GetIndex(AValue: T): Integer;
    procedure SetItem(AIndex: Integer; const AValue: T);
    function Exchange(AIndex1, AIndex2: Integer): Boolean;

    property Item[Index: Integer]: T read GetItem write SetItem;
  end;

  ISplash = interface
    ['{9ED05CEB-A250-4F74-BB82-E5B0AADA7DC1}']
    procedure ShowSplash(const message: WideString);
    procedure HideSplash;
    function GetVisible: Boolean;
    procedure SetVisible(Value: Boolean);
    function GetOnCancel: TNotifyEvent;
    procedure SetOnCancel(Value: TNotifyEvent);
    function GetShowCancelButton: Boolean;
    procedure SetShowCancelButton(Value: Boolean);

    property ShowCancelButton: Boolean read GetShowCancelButton write SetShowCancelButton;
    property Visible: Boolean read GetVisible write SetVisible;
    property OnCancel: TNotifyEvent read GetOnCancel write SetOnCancel;
  end;

  ISettings = interface
    ['{1A36C4C1-E2BC-4EDB-B609-885EA1C76077}']
    function GetSectionName: string;
    procedure SetSectionName(const Value: string);
    function GetStr(aParamName: string; const Default: string): string;
    function GetInt(aParamName: string; const Default: Integer): Integer;
    function GetBool(aParamName: string; const Default: Boolean): Boolean;
    procedure SetStr(aParamName: string; Value: string);
    procedure SetInt(aParamName: string; Value: Integer);
    procedure SetBool(aParamName: string; Value: Boolean);

    property SectionName: string read GetSectionName write SetSectionName;
  end;

  IVariant = interface
    ['{E56FAE2D-146D-45B1-B4F9-627949BD7BC7}']
    function GetNumber: Word;
    procedure SetNumber(Value: Word);
    function GetText: string;
    procedure SetText(Value: string);
    function GetCorrect: Boolean;
    procedure SetCorrect(Value: Boolean);

    property Number: Word read GetNumber write SetNumber;
    property Text: string read GetText write SetText;
    property Correct: Boolean read GetCorrect write SetCorrect;

  end;

  TQuestionType = (qtSingleSelect, qtMultiSelect, qtTypeAnswer, qtClickPicture);

  IQuestion = interface
    ['{5DAC79FA-8E0E-4B7E-9355-D1336BDD61FE}']
    function GetNumber: word;
    function GetName: string;
    function GetWeight: Integer;
    function GetQuestionType: TQuestionType;
    function GetTopic: string;
    function GetContent: IStream;
    function GetVariants: IList<IVariant>;

    procedure SetNumber(Value: word);
    procedure SetName(Value: string);
    procedure SetWeight(Value: Integer);
    procedure SetQuestionType(Value: TQuestionType);
    procedure SetTopic(Value: string);

    property Name: string read GetName write SetName;
    property Number: word read GetNumber write SetNumber;
    property Weight: Integer read GetWeight write SetWeight;
    property QuestionType: TQuestionType read GetQuestionType write SetQuestionType;
    property Topic: string read GetTopic write SetTopic;
    property Content: IStream read GetContent;
    property Variants: IList<IVariant> read GetVariants;
  end;

  ITest = interface
    ['{CE2ECE5D-1365-4199-9EF9-7E83EF9F4410}']
    function GetName: string;
    procedure SetName(Value: string);
    function GetMixQuestions: boolean;
    procedure SetMixQuestions(Value: boolean);
    function GetMixVariants: boolean;
    procedure SetMixVariants(Value: boolean);
    function GetTimeLimit: longword;
    procedure SetTimeLimit(Value: longword);
    function GetCanClose: boolean;
    procedure SetCanClose(Value: boolean);
    function GetGreeting: string;
    procedure SetGreeting(Value: string);
    function GetCongratulations: string;
    procedure SetCongratulations(Value: string);
    function GetQuestions: IList<IQuestion>;

    property Name: string read GetName write SetName;
    property MixQuestions: boolean read GetMixQuestions write SetMixQuestions;
    property MixVariants: boolean read GetMixVariants write SetMixVariants;
    property TimeLimit: longword read GetTimeLimit write SetTimeLimit;
    property CanClose: boolean read GetCanClose write SetCanClose;
    property Greeting: string read GetGreeting write SetGreeting;
    property Congratulations: string read GetCongratulations write SetCongratulations;
    property Questions: IList<IQuestion> read GetQuestions;
  end;

  IPersistObject = interface
    ['{6E3B7A86-D9E0-4AFC-8C8C-39B001712ABA}']
    procedure LoadFromStream(const Stream: IStream);
    procedure LoadFromFile(const FileName: string);
    procedure SaveToStream(const Stream: IStream);
    procedure SaveToFile(const FileName: string);
  end;

const
  param_parent_control = 'parent_control';
  param_host = 'host';
  param_login = 'login';
  param_password = 'password';
  param_test = 'test';

implementation

end.

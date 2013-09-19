unit uQuizeImpl;

interface

uses
  uInterfaces,
  uFactories;

function NewQuestion(QuestionType: TQuestionType): IQuestion;
function NewVariant(Number: Word; const Text: string; Correct: Boolean = False): IVariant;
function NewTest: ITest;

function GetQuestionTypeStr(AType: TQuestionType): string;
function GetQuestionTypeEnum(AType: string): TQuestionType;

implementation

uses
  Classes,
  SysUtils,
  XMLIntf,
  XMLDoc,
  XMLDom,
  uSynapse;

type

  TVariantImpl = class(TInterfacedObject, IVariant)
    private
      FNumber: word;
      FText: string;
      FChecked: Boolean;
    protected
      function GetNumber: word;
      procedure SetNumber(Value: word);
      function GetText: string;
      procedure SetText(Value: string);
      function GetCorrect: Boolean;
      procedure SetCorrect(Value: Boolean);
  end;

  TQuestionImpl = class(TInterfacedObject, IQuestion)
    private
      FDataStream: TStream;
      FNumber: Word;
      FTopic: string;
      FName: string;
      FQuestionType: TQuestionType;
      FVariants: IList<IVariant>;
      FWeight: Integer;
      FContent: IStream;
    protected
      function GetNumber: word;
      procedure SetNumber(Value: word);
      function GetTopic: string;
      procedure SetTopic(Value: string);
      function GetName: string;
      procedure SetName(Value: string);
      function GetWeight: Integer;
      procedure SetWeight(Value: Integer);
      function GetQuestionType: TQuestionType;
      procedure SetQuestionType(Value: TQuestionType);
      function GetVariants: IList<IVariant>;
      function GetContent: IStream;
    public
      constructor Create;
      destructor Destroy; override;
  end;

  TTestImpl = class(TInterfacedObject, ITest, IPersistObject)
    private
      FName: string;
      FMixQuestions: boolean;
      FMixVariants: boolean;
      FTimeLimit: longword;
      FCanClose: boolean;
      FMaxBreaks: word;
      FMaxPassings: word;
      FGreeting: string;
      FCongratulations: string;
      FQuestions: IList<IQuestion>;
    protected
      function GetName: string;
      procedure SetName(Value: string);
      function GetAmountQuestions: word;
      function GetMixQuestions: boolean;
      procedure SetMixQuestions(Value: boolean);
      function GetMixVariants: boolean;
      procedure SetMixVariants(Value: boolean);
      function GetTimeLimit: longword;
      procedure SetTimeLimit(Value: longword);
      function GetCanClose: boolean;
      procedure SetCanClose(Value: boolean);
      function GetMaxBreaks: word;
      procedure SetMaxBreaks(Value: word);
      function GetMaxPassings: word;
      procedure SetMaxPassings(Value: word);
      function GetGreeting: string;
      procedure SetGreeting(Value: string);
      function GetCongratulations: string;
      procedure SetCongratulations(Value: string);
      function GetQuestions: IList<IQuestion>;
    protected
      procedure LoadFromStream(const Stream: IStream);
      procedure LoadFromFile(const FileName: string);
      procedure SaveToStream(const Stream: IStream);
      procedure SaveToFile(const FileName: string);
    public
      constructor Create;
      destructor Destroy; override;
  end;

  { TgtVariant }

function TVariantImpl.GetCorrect: Boolean;
begin
  Result := FChecked;
end;

function TVariantImpl.GetNumber: word;
begin
  Result := FNumber;
end;

function TVariantImpl.GetText: string;
begin
  Result := FText;
end;

procedure TVariantImpl.SetCorrect(Value: Boolean);
begin
  FChecked := Value;
end;

procedure TVariantImpl.SetNumber(Value: word);
begin
  FNumber := Value;
end;

procedure TVariantImpl.SetText(Value: string);
begin
  FText := Value;
end;

function NewVariant(Number: word; const Text: string; Correct: Boolean): IVariant;
begin
  Result := TVariantImpl.Create;
  Result.Number := Number;
  Result.Text := Text;
  Result.Correct := Correct;
end;

{ TQuestionImpl }

constructor TQuestionImpl.Create;
begin
  inherited Create;
  FContent := Core.NewStream;
  FVariants := Core.NewList<IVariant>;
end;

destructor TQuestionImpl.Destroy;
begin
  FDataStream.Free;
  FVariants := nil;
  inherited;
end;

function TQuestionImpl.GetTopic: string;
begin
  Result := FTopic;
end;

function TQuestionImpl.GetContent: IStream;
begin
  Result := FContent;
end;

function TQuestionImpl.GetName: string;
begin
  Result := FName;
end;

function TQuestionImpl.GetNumber: word;
begin
  Result := FNumber;
end;

function TQuestionImpl.GetQuestionType: TQuestionType;
begin
  Result := FQuestionType;
end;

function TQuestionImpl.GetVariants: IList<IVariant>;
begin
  Result := FVariants;
end;

function TQuestionImpl.GetWeight: Integer;
begin
  Result := FWeight;
end;

procedure TQuestionImpl.SetTopic(Value: string);
begin
  FTopic := Value;
end;

procedure TQuestionImpl.SetName(Value: string);
begin
  FName := Value;
end;

procedure TQuestionImpl.SetNumber(Value: word);
begin
  FNumber := Value;
end;

procedure TQuestionImpl.SetQuestionType(Value: TQuestionType);
begin
  FQuestionType := Value;
end;

procedure TQuestionImpl.SetWeight(Value: Integer);
begin
  FWeight := Value;
end;

function NewQuestion(QuestionType: TQuestionType): IQuestion;
begin
  Result := TQuestionImpl.Create;
  Result.QuestionType := QuestionType;
end;

function NewTest: ITest;
begin
  Result := TTestImpl.Create;
end;

{ TTestImpl }

constructor TTestImpl.Create;
begin
  inherited Create;
  FQuestions := Core.NewList<IQuestion>;
end;

destructor TTestImpl.Destroy;
begin
  FQuestions := nil;
  inherited;
end;

function TTestImpl.GetAmountQuestions: word;
begin
  if not Assigned(FQuestions) then
    Exit(0);
  Result := FQuestions.Count;
end;

function TTestImpl.GetCanClose: boolean;
begin
  Result := FCanClose;
end;

function TTestImpl.GetCongratulations: string;
begin
  Result := FCongratulations;
end;

function TTestImpl.GetGreeting: string;
begin
  Result := FGreeting;
end;

function TTestImpl.GetMaxBreaks: word;
begin
  Result := FMaxBreaks;
end;

function TTestImpl.GetMaxPassings: word;
begin
  Result := FMaxPassings;
end;

function TTestImpl.GetMixQuestions: boolean;
begin
  Result := FMixQuestions;
end;

function TTestImpl.GetMixVariants: boolean;
begin
  Result := FMixVariants;
end;

function TTestImpl.GetName: string;
begin
  Result := FName;
end;

function TTestImpl.GetQuestions: IList<IQuestion>;
begin
  Result := FQuestions;
end;

function TTestImpl.GetTimeLimit: longword;
begin
  Result := FTimeLimit;
end;

procedure TTestImpl.LoadFromFile(const FileName: string);
begin
  LoadFromStream(Core.NewStream(FileName));
end;

procedure TTestImpl.LoadFromStream(const Stream: IStream);
var
  doc: IXMLDocument;
  rootNode, questionsNode, questionNode, variantsNode, variantNode, node: IXmlNode;
  question: IQuestion;
  varian: IVariant;
  number, i, j: integer;
  questionType: string;
  buffer: AnsiString;
  text: string;
  checked: Boolean;
  str: TStream;
begin
  doc := NewXMLDocument();
  str := TMemoryStream.Create;
  Stream.SaveToStream(str);
  doc.LoadFromStream(str);
  str.Free;
  rootNode := doc.DocumentElement;

  // зчитати основні параметри тесту
  FTimeLimit := StrToIntDef(rootNode.Attributes['time_limit'], 600);
  FCanClose := StrToBool(rootNode.Attributes['can_close']);
  FMaxBreaks := StrToIntDef(rootNode.Attributes['max_breaks'], 2);
  FMaxPassings := StrToIntDef(rootNode.Attributes['max_passings'], 1);

  // зчитати назву, привітання, поздоровлення
  FName := DecodeBase64(rootNode.ChildValues['name']);
  FGreeting := DecodeBase64(rootNode.ChildValues['greeting']);
  FCongratulations := DecodeBase64(rootNode.ChildValues['congratulations']);

  // отримати ссилку на ноду питань і зчитати параметри питань
  questionsNode := rootNode.ChildNodes.FindNode('questions');
  FMixVariants := StrToBool(questionsNode.Attributes['mix_variants']);
  FMixQuestions := StrToBool(questionsNode.Attributes['mix_questions']);
  for i := 0 to questionsNode.ChildNodes.Count - 1 do
  begin
    questionNode := questionsNode.ChildNodes.Nodes[i];
    questionType := questionNode.Attributes['type'];
    number := StrToIntDef(questionNode.Attributes['number'], 0);

    // створити обєкт питання
    question := NewQuestion(GetQuestionTypeEnum(questionType));

    // зчитати вагу
    question.Weight := StrToIntDef(questionNode.Attributes['weight'], 0);

    // зчитати назву запитання
    question.Name := UTF8Decode(DecodeBase64(questionNode.ChildNodes.FindNode('name').NodeValue));
    question.Number := i + 1;

    // зчитати дані
    node := questionNode.ChildNodes.FindNode('data');
    Buffer := node.NodeValue;
    Buffer := DecodeBase64(Buffer);
    Str := TMemoryStream.Create;
    Str.Write(Pointer(Buffer)^, Length(Buffer));
    Question.Content.CopyFrom(Str);
    Str.Free;

    // отримати силку на ноду варіантів
    variantsNode := questionNode.ChildNodes.FindNode('variants');
    for j := 0 to variantsNode.ChildNodes.Count - 1 do
    begin
      variantNode := variantsNode.ChildNodes.Get(j);
      // зчитати параметри варіанту
      Number := StrToIntDef(variantNode.Attributes['number'], 0);
      Checked := StrToBoolDef(variantNode.Attributes['correct'], False);
      Text := UTF8Decode(DecodeBase64(variantNode.NodeValue));
      // створити варіант і додати до списку варіантів даного питання
      Varian := NewVariant(Number, Text, Checked);
      Question.Variants.Add(Varian);
    end;
    FQuestions.Add(Question);
  end;
end;

procedure TTestImpl.SaveToFile(const FileName: string);
var
  stream: IStream;
begin
  stream := Core.NewStream();
  SaveToStream(stream);
  stream.SaveToFile(FileName);
end;

procedure TTestImpl.SaveToStream(const Stream: IStream);
var
  xml: IXMLDocument;
  rootNode, node, questionsNode, questionNode, variantsNode, variantNode: IXMLNode;
  question: IQuestion;
  varnt: IVariant;
  buffer: AnsiString;
  bufferStream: TStream;
begin
  xml := NewXMLDocument;
  xml.Encoding := 'utf-8';
  xml.Options := [doNodeAutoIndent];

  rootNode := xml.AddChild('test');
  rootNode.attributes['time_limit'] := FTimeLimit;
  rootNode.attributes['can_close'] := BoolToStr(FCanClose);
  rootNode.attributes['max_breaks'] := FMaxBreaks;
  rootNode.attributes['max_passings'] := FMaxPassings;

  node := rootNode.AddChild('name');
  node.NodeValue := FName;
  node := rootNode.AddChild('greeting');
  node.NodeValue := EncodeBase64(FGreeting);
  node := rootNode.AddChild('congratulations');
  node.NodeValue := EncodeBase64(FCongratulations);

  questionsNode := rootNode.AddChild('questions');
  questionsNode.attributes['count'] := GetAmountQuestions;
  questionsNode.attributes['mix_questions'] := BoolToStr(FMixQuestions);
  questionsNode.attributes['mix_variants'] := BoolToStr(FMixVariants);

  // проходимо по списку питань і записуємо їх в XML
  for question in FQuestions do
  begin
    questionNode := questionsNode.AddChild('question');
    questionNode.Attributes['number'] := question.Number;
    questionNode.Attributes['type'] := GetQuestionTypeStr(question.QuestionType);
    questionNode.Attributes['weight'] := question.Weight;

    // записуємо назву запитання
    node := questionNode.AddChild('name');
    node.NodeValue := EncodeBase64(question.Name);

    // записуємо дані
    bufferStream := TMemoryStream.Create;
    question.Content.SaveToStream(bufferStream);
    SetLength(buffer, bufferStream.Size);
    bufferStream.Position := 0;
    bufferStream.Read(Pointer(buffer)^, bufferStream.Size);
    bufferStream.Free;

    node := questionNode.AddChild('data');
    node.NodeValue := EncodeBase64(buffer);

    // проходимо по списку варіантів і записуємо в XML
    variantsNode := questionNode.AddChild('variants');
    for varnt in question.Variants do
    begin
      variantNode := variantsNode.AddChild('variant');
      variantNode.Attributes['number'] := varnt.Number;
      variantNode.Attributes['correct'] := BoolToStr(varnt.Correct);
      variantNode.NodeValue := EncodeBase64(varnt.Text);
    end;
  end;
  bufferStream := TMemoryStream.Create;
  xml.XML.SaveToStream(bufferStream);
  Stream.CopyFrom(bufferStream);
  bufferStream.Free;
end;

procedure TTestImpl.SetCanClose(Value: boolean);
begin
  FCanClose := Value;
end;

procedure TTestImpl.SetCongratulations(Value: string);
begin
  FCongratulations := Value;
end;

procedure TTestImpl.SetGreeting(Value: string);
begin
  FGreeting := Value;
end;

procedure TTestImpl.SetMaxBreaks(Value: word);
begin
  FMaxBreaks := Value;
end;

procedure TTestImpl.SetMaxPassings(Value: word);
begin
  FMaxPassings := Value;
end;

procedure TTestImpl.SetMixQuestions(Value: boolean);
begin
  FMixQuestions := Value;
end;

procedure TTestImpl.SetMixVariants(Value: boolean);
begin
  FMixVariants := Value;
end;

procedure TTestImpl.SetName(Value: string);
begin
  FName := Value;
end;

procedure TTestImpl.SetTimeLimit(Value: longword);
begin
  FTimeLimit := Value;
end;

function GetQuestionTypeStr(AType: TQuestionType): string;
begin
  case AType of
    qtSingleSelect:
      Result := 'select_single';
    qtMultiSelect:
      Result := 'multi_single';
    qtTypeAnswer:
      Result := 'type_answer';
    qtClickPicture:
      Result := 'click_picture';
  end;
end;

function GetQuestionTypeEnum(AType: string): TQuestionType;
begin
  if AType = 'select_single' then
    Result := qtSingleSelect;
  if AType = 'multi_single' then
    Result := qtMultiSelect;
  if AType = 'type_answer' then
    Result := qtTypeAnswer;
  if AType = 'click_picture' then
    Result := qtClickPicture;
end;

end.

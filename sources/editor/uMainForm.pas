unit uMainForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  ToolWin,
  ActnList,
  OleCtnrs,
  uVariantsFrame,
  XPMan,
  ImgList,
  ShellApi,
  uSettingsForm,
  uInterfaces,
  uFactories,
  uHTMLEditFrame,
  Dialogs,
  AppEvnts,
  Menus,
  ComCtrls,
  StdCtrls,
  ExtCtrls;

type

  TMainForm = class(TForm)
    ActionList: TActionList;
    MainMenu: TMainMenu;
    TestMenu: TMenuItem;
    TestOpenItem: TMenuItem;
    TestSaveItem: TMenuItem;
    TstSaveAsItem: TMenuItem;
    TestNewItem: TMenuItem;
    RightPanel: TPanel;
    LeftPanel: TPanel;
    Splitter: TSplitter;
    ListBoxQuestions: TListBox;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    QuestionMenu: TMenuItem;
    QuestionNewItem: TMenuItem;
    QuestionDeleteItem: TMenuItem;
    PageControl: TPageControl;
    TabSheetQuestion: TTabSheet;
    TabSheetVariants: TTabSheet;
    PanelVariants: TPanel;
    SettingsMenu: TMenuItem;
    QuestionUpItem: TMenuItem;
    QuestionDownItem: TMenuItem;
    ImageList16: TImageList;
    PopupMenuQuestions: TPopupMenu;
    UpItem: TMenuItem;
    DownItem: TMenuItem;
    XPManifest: TXPManifest;
    StatusBar: TStatusBar;
    PanelQuestionData: TPanel;
    OpenSettingsAction: TAction;
    QuestionDownAction: TAction;
    QuestionUpAction: TAction;
    QuestionDeleteAction: TAction;
    QuestionNewAction: TAction;
    TestNewAction: TAction;
    TestSaveAsAction: TAction;
    TestSaveAction: TAction;
    TestOpenAction: TAction;
    ApplicationEvents: TApplicationEvents;
    ApplicationQuit: TAction;
    ApplicationQuitItem: TMenuItem;
    HelpMenu: TMenuItem;
    HelpContent: TAction;
    HelpAbout: TAction;
    HelpContentItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    PanelQuestionTop: TPanel;
    ImageList20: TImageList;
    ToolBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    LabelAddQuestionHint: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure TestOpenActionExecute(Sender: TObject);
    procedure ListBoxQuestionsClick(Sender: TObject);
    procedure TestSaveActionExecute(Sender: TObject);
    procedure TestNewActionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QuestionNewActionExecute(Sender: TObject);
    procedure TestSaveAsActionExecute(Sender: TObject);
    procedure QuestionDeleteActionExecute(Sender: TObject);
    procedure QuestionUpActionExecute(Sender: TObject);
    procedure QuestionDownActionExecute(Sender: TObject);
    procedure TestChanged(Sender: TObject);
    procedure OpenSettingsActionExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure ListBoxQuestionsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ApplicationQuitExecute(Sender: TObject);
    procedure HelpContentExecute(Sender: TObject);
    procedure HelpAboutExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    private
      FTestFileName: string; // файл відкритого тесту
      FTest: ITest; // тест
      FCurrentQuestion: Integer; // номер поточного питання, якщо немає такого -1
      FQuestionWasModified: Boolean; // поточне питання було змінене
      FTestWasModified: Boolean; // тест було змінено після відкриття
      FFrameVariants: TVariantsFrame;
      FSplash: ISplash;
      FSettings: ISettings;
      FFrameHTMLEditor: TFrameHTMLEdit;
      FOldIndexForHint: Longint;
    private
      procedure BlockGUI;
      procedure UnblockGUI;
      procedure SetCurrentQuestion(Value: Integer);
      function GetCurrentQuestion: Integer;
      procedure SuckleQuestion(Number: Integer);
      procedure FillQuestion(Number: Integer);
      procedure SetTestEnable(const Value: Boolean);
      procedure SetTestHasQuestions(const Value: Boolean);
      procedure OpenTest;
      function Splash: ISplash;
      function Settings: ISettings;
      procedure ShowSplash(const aMessage: string);
      procedure HideSplash;
      function TestRead: Boolean;
      // процедура зчитує параметри тесту в контроли: запитання, ...
      function TestSave: Boolean;
      function TestClear: Boolean;
      function GetTestFileName: string;
      procedure SetTestFileName(const Value: string);
      function GetTestModified: Boolean;
      procedure SetTestModified(const Value: Boolean);
      // процедура очищає всі контроли і тест
      function GetClippedText(const aText: string): string;
    private
      property CurrentQuestion: Integer read GetCurrentQuestion write SetCurrentQuestion;
      property TestEnable: Boolean write SetTestEnable;
      property TestHasQuestions: Boolean write SetTestHasQuestions;
      property TestFileName: string read GetTestFileName write SetTestFileName;
      property TestModified: Boolean read GetTestModified write SetTestModified;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses
  uUtils,
  uQuizeImpl,
  uCorePath,
  uDebug,
  uTexts;

procedure TMainForm.FormCreate(Sender: TObject);
var
  left, top, width, height: Integer;
begin
  left := Settings.GetInt('wnd_left', - 1);
  if left <> - 1 then
    Self.left := left;
  top := Settings.GetInt('wnd_top', - 1);
  if top <> - 1 then
    Self.top := top;
  width := Settings.GetInt('wnd_width', - 1);
  if width <> - 1 then
    Self.width := width;
  height := Settings.GetInt('wnd_height', - 1);
  if height <> - 1 then
    Self.height := height;
  fOldIndexForHint := - 1;
  fFrameVariants := TVariantsFrame.Create(PanelVariants);
  fFrameVariants.Parent := PanelVariants;

  fFrameHTMLEditor := TFrameHTMLEdit.Create(Self);
  fFrameHTMLEditor.Parent := PanelQuestionData;
  fFrameHTMLEditor.Align := alClient;
  fFrameHTMLEditor.DesignMode := True;

  fCurrentQuestion := - 1;
  fQuestionWasModified := False;
  TestClear;
  TestFileName := Trim(GetProgrammParams);
  if FileExists(TestFileName) then
    OpenTest
  else
    TestFileName := cNewTestName;
end;

procedure TMainForm.TestOpenActionExecute(Sender: TObject);
begin
  if not OpenDialog.Execute then
    Exit;
  TestClear;
  TestFileName := OpenDialog.FileName;
  OpenTest;
end;

function TMainForm.TestRead: Boolean;
var
  question: IQuestion;
begin
  CurrentQuestion := - 1;
  if not Assigned(fTest) then
    raise Exception.Create(cErrTestNotAssigned);
  ListBoxQuestions.Clear;
  for question in fTest.Questions do
  begin
    if question.Name = '' then
      question.Name := cNoQuestionName;
    ListBoxQuestions.AddItem(Question.Name, Pointer(Question));
  end;
  TestEnable := True;
  TestHasQuestions := FTest.Questions.Count > 0;
  StatusBar.Panels[0].Text := WideFormat(cAllQuestionsCount, [FTest.Questions.Count]);
end;

procedure TMainForm.ListBoxQuestionsClick(Sender: TObject);
begin
  // вибір запитаня
  CurrentQuestion := ListBoxQuestions.ItemIndex;
end;

procedure TMainForm.ListBoxQuestionsMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  idx: Longint;
begin
  // хінт для елементів, що не влазять по ширині
  with Sender as TListBox do
  begin
    idx := ItemAtPos(Point(X, Y), True);
    if (idx < 0) or (idx = fOldIndexForHint) then
      Exit;
    Application.ProcessMessages;
    Application.CancelHint;
    fOldIndexForHint := idx;
    Hint := '';
    if Canvas.TextWidth(Items[idx]) > width - 4 then
      Hint := Items[idx];
  end;
end;

procedure TMainForm.OpenTest;
begin
  ShowSplash(cTestLoading);
  try
    (fTest as IPersistObject).LoadFromFile(TestFileName);
    Application.ProcessMessages;
    TestRead;
    TestModified := False;
    CurrentQuestion := 0;
  finally
    HideSplash;
  end;
end;

procedure TMainForm.TestSaveActionExecute(Sender: TObject);
begin
  if TestFileName = '' then
  begin
    SaveDialog.FileName := fTest.Name + cTestFileNameExtension;
    if SaveDialog.Execute then
      TestFileName := SaveDialog.FileName
    else
      Exit;
  end;
  TestSave;
end;

procedure TMainForm.TestNewActionExecute(Sender: TObject);
var
  testName: string;
begin
  testName := cNewTestName;
  TestClear;
  while InputQuery(cNewTest, cInputTestName, testName) do
  begin
    if Trim(testName) <> '' then
    begin
      fTest.Name := Trim(testName);
      TestFileName := '';
      TestRead;
      Break;
    end;
  end;
end;

function TMainForm.GetClippedText(const aText: string): string;
begin
  Result := StringReplace(aText, #$D, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #$A, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, #$9, ' ', [rfReplaceAll]);
  if Result = '' then
    Result := cNoQuestionName;
end;

function TMainForm.GetCurrentQuestion: Integer;
begin
  Result := fCurrentQuestion;
end;

function TMainForm.GetTestFileName: string;
begin
  Result := Trim(fTestFileName);
end;

function TMainForm.GetTestModified: Boolean;
begin
  Result := fTestWasModified;
end;

procedure TMainForm.HelpAboutExecute(Sender: TObject);
begin
  // ShowAboutDialog(cProgramNameCaption, cProgramDescription);
end;

procedure TMainForm.HelpContentExecute(Sender: TObject);
begin
  if not Application.HelpContext(4010) then
    raise Exception.Create(WideFormat(cErrHelpCall, [Application.HelpFile, 0]));
end;

procedure TMainForm.HideSplash;
begin
  Splash.HideSplash;
  UnblockGUI;
end;

procedure TMainForm.SetCurrentQuestion(Value: Integer);
begin
  if Value = fCurrentQuestion then
    Exit;
  ShowSplash(cQuestionLoad);
  try
    if (fCurrentQuestion <> - 1) then
    begin
      Application.ProcessMessages;
      SuckleQuestion(fCurrentQuestion);
      Application.ProcessMessages;
    end;
    FillQuestion(Value);
    fCurrentQuestion := Value;
    ListBoxQuestions.ItemIndex := fCurrentQuestion;
    Application.ProcessMessages;
  finally
    HideSplash;
  end;
end;

procedure TMainForm.SuckleQuestion(Number: Integer);
var
  Question: IQuestion;
  Ms: TStream;
begin
  if (Number < 0) or (Number >= ListBoxQuestions.count) then
    Exit;
  Question := IQuestion(Pointer(ListBoxQuestions.Items.Objects[Number]));
  Ms := TMemoryStream.Create;
  try
    fFrameHTMLEditor.SaveToStream(Ms);
    Question.Content.CopyFrom(Ms);
  finally
    Ms.Free;
  end;
  if fFrameHTMLEditor.DocumentEdited then
    TestModified := True;
  Question.Name := GetClippedText(fFrameHTMLEditor.Text);
  ListBoxQuestions.Items.Strings[Number] := Question.Name;
  fFrameVariants.GetQuestion(Question);
  if fFrameVariants.Changed then
    TestModified := True;
end;

procedure TMainForm.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  ShowErrorMessage(WideFormat(cErrUnhandledException, [E.Message]), Self);
  // gtSaveException(E);
end;

procedure TMainForm.ApplicationQuitExecute(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.BlockGUI;
begin
  Enabled := False;
end;

procedure TMainForm.FillQuestion(Number: Integer);
var
  Question: IQuestion;
  Ms: TStream;
begin
  if Number = - 1 then
  begin
    fFrameVariants.SetQuestion(nil);
    fFrameHTMLEditor.HTML := '';
  end;
  if (Number < 0) or (Number >= ListBoxQuestions.count) then
    Exit;
  Question := IQuestion(Pointer(ListBoxQuestions.Items.Objects[Number]));
  Ms := TMemoryStream.Create;
  try
    Question.Content.SaveToStream(Ms);
    fFrameHTMLEditor.LoadFromStream(Ms);
  finally
    Ms.Free;
  end;
  ListBoxQuestions.Items.Strings[Number] := Question.Name;
  fFrameVariants.SetQuestion(Question);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Settings.SetInt('wnd_left', Self.left);
  Settings.SetInt('wnd_top', Self.top);
  Settings.SetInt('wnd_width', Self.width);
  Settings.SetInt('wnd_height', Self.height);
  FreeAndNil(fFrameHTMLEditor);
end;

procedure TMainForm.QuestionNewActionExecute(Sender: TObject);
var
  Question: IQuestion;
begin
  if not Assigned(fTest) then
    Exit;
  CurrentQuestion := - 1;
  Question := NewQuestion(qtSingleSelect);
  FTest.Questions.Add(Question);
  TestRead;
  CurrentQuestion := ListBoxQuestions.Count - 1;
  TestModified := True;
end;

// якщо тест очищено нормально (збережено) TRUE
// якщо натиснуто Cancel - FALSE
function TMainForm.TestClear: Boolean;
var
  i: Integer;
begin
  if TestModified and Assigned(fTest) then
  begin
    case QueryYesNoCancel(WideFormat(cTestWasModified, [fTest.Name]), Self) of
      IDYES:
        begin
          if TestFileName = '' then
            TestSaveAsAction.Execute
          else
            TestSaveAction.Execute;
        end;
      IDNO:
        ;
      IDCANCEL:
        begin
          Result := False;
          Exit;
        end;
    end;
  end;
  FTest := NewTest;
  for i := 0 to ListBoxQuestions.Count - 1 do
    ListBoxQuestions.Items.Objects[i] := nil;

  ListBoxQuestions.Clear;
  TestEnable := False;
  CurrentQuestion := - 1;
  TestModified := False;
  StatusBar.Panels[0].Text := '';
  Result := True;
end;

function TMainForm.TestSave: Boolean;
var
  Number: Integer;
begin
  Number := CurrentQuestion;
  CurrentQuestion := - 1;
  (fTest as IPersistObject).SaveToFile(TestFileName);
  TestModified := False;
  CurrentQuestion := Number;
  Result := True;
end;

procedure TMainForm.TestSaveAsActionExecute(Sender: TObject);
begin
  if TestFileName = '' then
    SaveDialog.FileName := fTest.Name + cTestFileNameExtension
  else
    SaveDialog.FileName := ExtractFileName(TestFileName);
  if not SaveDialog.Execute then
    Exit;
  TestFileName := SaveDialog.FileName;
  TestSaveAction.Execute;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FFrameVariants);
  FreeAndNil(FFrameHTMLEditor);
  FSettings := nil;
  FTest := nil;
  FSplash := nil;
end;

procedure TMainForm.UnblockGUI;
begin
  Enabled := True;
end;

procedure TMainForm.QuestionDeleteActionExecute(Sender: TObject);
var
  aQuestion: IQuestion;
  num: Integer;
begin
  if not Assigned(fTest) then
    Exit;
  if (CurrentQuestion > - 1) and (CurrentQuestion < ListBoxQuestions.count) then
  begin
    num := CurrentQuestion;
    aQuestion := IQuestion(Pointer(ListBoxQuestions.Items.Objects[num]));

    if QueryYesNo(WideFormat(cDeleteQuestionQuery, [aQuestion.Name]), Self) = IDNO then
      Exit;

    fTest.Questions.DeleteItem(aQuestion);
    TestRead;
    if num < fTest.Questions.count then
      CurrentQuestion := num
    else
      CurrentQuestion := num - 1;
  end;
  if fTest.Questions.count <= 0 then
    fFrameHTMLEditor.Text := '';
  TestModified := True;
end;

procedure TMainForm.SetTestEnable(const Value: Boolean);
begin
  SettingsMenu.Visible := Value;
  QuestionMenu.Visible := Value;
  Splitter.Align := alNone;
  LeftPanel.Visible := Value;
  Splitter.Visible := Value;
  Splitter.Align := alLeft;
  RightPanel.Visible := Value;
  PageControl.Visible := Value;
  TestSaveAction.Enabled := Value;
  TestSaveAsAction.Enabled := Value;
  QuestionNewAction.Enabled := Value;
  QuestionDeleteAction.Enabled := Value;
  QuestionUpAction.Enabled := Value;
  QuestionDownAction.Enabled := Value;
  OpenSettingsAction.Enabled := Value;
end;

procedure TMainForm.SetTestFileName(const Value: string);
begin
  fTestFileName := Value;
  Caption := WideFormat(cFormCaption, [fTestFileName]);
end;

procedure TMainForm.SetTestHasQuestions(const Value: Boolean);
begin
  ListBoxQuestions.Visible := Value;
  PageControl.Visible := Value;
  QuestionDeleteAction.Enabled := Value;
  QuestionUpAction.Enabled := Value;
  QuestionDownAction.Enabled := Value;
end;

procedure TMainForm.SetTestModified(const Value: Boolean);
begin
  fTestWasModified := Value;
  if not Value then
    fFrameVariants.Changed := False;
  if fTestWasModified then
    Caption := WideFormat(cFormCaption + '*', [fTestFileName])
  else
    Caption := WideFormat(cFormCaption, [fTestFileName]);
end;

function TMainForm.Settings: ISettings;
begin
  if not Assigned(fSettings) then
    fSettings := Core.NewSettings();
  Result := fSettings;
end;

procedure TMainForm.QuestionUpActionExecute(Sender: TObject);
var
  Number: Integer;
begin
  if not Assigned(fTest) then
    Exit;
  Number := ListBoxQuestions.ItemIndex;
  if Number <= 0 then
    Exit;
  SuckleQuestion(Number);
  fTest.Questions.Exchange(Number, Number - 1);
  TestRead;
  CurrentQuestion := Number - 1;
  TestModified := True;
end;

procedure TMainForm.QuestionDownActionExecute(Sender: TObject);
var
  Number: Integer;
begin
  if not Assigned(fTest) then
    Exit;
  Number := ListBoxQuestions.ItemIndex;
  if (Number >= ListBoxQuestions.count - 1) or (Number < 0) then
    Exit;
  SuckleQuestion(Number);
  fTest.Questions.Exchange(Number, Number + 1);
  TestRead;
  CurrentQuestion := Number + 1;
  TestModified := True;
end;

procedure TMainForm.TestChanged(Sender: TObject);
begin
  TestModified := True;
end;

procedure TMainForm.OpenSettingsActionExecute(Sender: TObject);
var
  Form: TFormSettings;
begin
  if not Assigned(fTest) then
    Exit;
  Form := TFormSettings.Create(Self, fTest);
  if Form.ShowModal = mrOk then
    TestModified := True;;
  Form.Free;
end;

procedure TMainForm.ShowSplash(const aMessage: string);
begin
  BlockGUI;
  Splash.ShowSplash(aMessage);
end;

function TMainForm.Splash: ISplash;
begin
  if not Assigned(fSplash) then
  begin
    fSplash := Dialog.NewSplash(Self);
  end;
  Result := fSplash;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  SuckleQuestion(fCurrentQuestion);
  if Assigned(fTest) then
    CanClose := TestClear;
end;

end.

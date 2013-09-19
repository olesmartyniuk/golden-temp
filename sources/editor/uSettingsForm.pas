unit uSettingsForm;

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
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Spin,
  ComCtrls,
  uInterfaces,
  uFactories;

type
  TFormSettings = class(TForm)
    PageControl: TPageControl;
    TabGeneral: TTabSheet;
    TabAdditional: TTabSheet;
    CheckBox4: TCheckBox;
    PanelBottom: TPanel;
    Label6: TLabel;
    MemoGreeting: TMemo;
    Label7: TLabel;
    MemoCongratulation: TMemo;
    Label5: TLabel;
    MemoDescription: TEdit;
    CheckBox2: TCheckBox;
    CheckBox1: TCheckBox;
    PanelTime: TPanel;
    CheckBox3: TCheckBox;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    SpinHours: TSpinEdit;
    SpinMinutes: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure ButtonOKClick(Sender: TObject);
    private
      FTest: ITest;
    private
      procedure ReadTest;
      procedure WriteTest;
      function GetTestTime: Integer;
      procedure SetTestTime(const Value: Integer);
      property TestTime: Integer read GetTestTime write SetTestTime;
    public
      constructor Create(AOwner: TComponent; Test: ITest);
      destructor Destroy; override;
  end;

implementation

uses
  uUtils,
  uTexts;

{$R *.dfm}
{ TFormSettings }

constructor TFormSettings.Create(AOwner: TComponent; Test: ITest);
begin
  inherited Create(AOwner);
  fTest := Test;
  ReadTest;
end;

destructor TFormSettings.Destroy;
begin
  fTest := nil;
  inherited;
end;

function TFormSettings.GetTestTime: Integer;
var
  hours, minutes: Integer;
begin
  try
    hours := SpinHours.Value * 3600;
  except
    hours := 0;
  end;
  try
    minutes := SpinMinutes.Value * 60;
  except
    minutes := 0;
  end;
  Result := hours + minutes;
end;

procedure TFormSettings.ReadTest;
begin
  MemoDescription.Text := fTest.Name;
  MemoGreeting.Text := fTest.Greeting;
  MemoCongratulation.Text := fTest.Congratulations;
  TestTime := fTest.TimeLimit;
  CheckBox1.Checked := fTest.MixQuestions;
  CheckBox2.Checked := fTest.MixVariants;
  CheckBox3.Checked := fTest.CanClose;
  CheckBox4.Checked := False;
end;

procedure TFormSettings.SetTestTime(const Value: Integer);
begin
  SpinHours.Value := Value div 3600;
  SpinMinutes.Value := (Value - SpinHours.Value * 3600) div 60;
end;

procedure TFormSettings.WriteTest;
begin
  fTest.Name := Trim(MemoDescription.Text);
  fTest.Greeting := MemoGreeting.Text;
  fTest.Congratulations := MemoCongratulation.Text;
  fTest.TimeLimit := TestTime;
  fTest.MixQuestions := CheckBox1.Checked;
  fTest.MixVariants := CheckBox2.Checked;
  fTest.CanClose := CheckBox1.Checked;
end;

procedure TFormSettings.ButtonOKClick(Sender: TObject);
begin
  if Trim(MemoDescription.Text) = '' then
  begin
    Dialog.ShowWarningMessage(cEmptyTestName);
    Exit;
  end;
  if not IsShortText(Trim(MemoDescription.Text)) then
  begin
    Dialog.ShowWarningMessage(cLongTestName);
    Exit;
  end;
  WriteTest;
  ModalResult := mrOK;
end;

end.

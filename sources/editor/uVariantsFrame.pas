unit uVariantsFrame;

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
  Grids,
  ExtCtrls,
  Buttons,
  Spin,
  Dialogs,
  StdCtrls,
  ToolWin,
  ComCtrls,
  ImgList,
  uInterfaces,
  Menus;

type
  TVariantsFrame = class(TFrame)
    ImageList: TImageList;
    PanelVariants: TPanel;
    PopupMenu: TPopupMenu;
    AddVariant: TMenuItem;
    DelVariant: TMenuItem;
    PanelVariantsComment: TPanel;
    LabelComment: TLabel;
    MemoComment: TEdit;
    PanelTop: TPanel;
    RadioGroupQuestionType: TRadioGroup;
    PanelBall: TPanel;
    SpeedButtonAdd: TSpeedButton;
    cbWeight: TComboBox;
    lbWeight: TLabel;
    LabelCommentHint: TLabel;
    procedure LabelCommentClick(Sender: TObject);
    procedure MemoCommentKeyPress(Sender: TObject; var Key: Char);
    procedure RadioGroupQuestionTypeClick(Sender: TObject);
    procedure SpeedButtonAddClick(Sender: TObject);
    procedure cbWeightChange(Sender: TObject);
    private
      FChanged: Boolean;
      FVariants: TList;
    private
      procedure NewVariant(const Text: string; QuestionType: TQuestionType; Correct: Boolean);
      procedure ClearVariants;
    private
      function GetChanged: boolean;
      procedure SetChanged(const Value: boolean);
      procedure PlaceAddButton;
      function GetQuestionType: TQuestionType;
      procedure SetQuestionType(const Value: TQuestionType);
      procedure OnMessage(var Msg: TMessage); message WM_USER;
    public
      property QuestionType: TQuestionType read GetQuestionType write SetQuestionType;
      procedure SetQuestion(const Value: IQuestion);
      procedure GetQuestion(Value: IQuestion);
      property Changed: boolean read GetChanged write SetChanged;
    public
      constructor Create(AOwner: TComponent);
      destructor Destroy; override;
  end;

  TVariantControl = class
    private
      FEdit: TEdit;
      FRadioButton: TRadioButton;
      FCheckBox: TCheckBox;
      FDelButton: TSpeedButton;
      FParentFrame: TVariantsFrame;
      FQuestionType: TQuestionType;
    private
      FTop: Integer;
      FLeft: Integer;
    private
      procedure OnClick(Sender: TObject);
      function GetText: WideString;
      procedure SetText(const Value: WideString);
      procedure SetQuestionType(const Value: TQuestionType);
      function GetChecked: Boolean;
      procedure SetChecked(const Value: Boolean);
      procedure SetLeft(const Value: Integer);
      procedure SetTop(const Value: Integer);
    public
      property Text: WideString read GetText write SetText;
      property QuestionType: TQuestionType read FQuestionType write SetQuestionType;
      property Checked: Boolean read GetChecked write SetChecked;
      property Left: Integer read FLeft write SetLeft;
      property Top: Integer read FTop write SetTop;
    public
      constructor Create(ParentFrame: TVariantsFrame);
      destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  uQuizeImpl,
  uTexts;

{ TVariantsFrame }

function TVariantsFrame.GetChanged: boolean;
begin
  Result := fChanged;
end;

procedure TVariantsFrame.GetQuestion(Value: IQuestion);
var
  Variant: IVariant;
  variantControl: TVariantControl;
  i: integer;
  Ball: integer;
  Text: WideString;
begin
  Value.Variants.Clear;
  if not PanelVariants.Visible then
    Exit;
  for i := 0 to FVariants.Count - 1 do
  begin
    variantControl := TObject(FVariants.Items[i]) as TVariantControl;
    Variant := uQuizeImpl.NewVariant(i + 1, variantControl.Text, variantControl.Checked);
    Value.Variants.Add(Variant);
  end;
  Value.QuestionType := TQuestionType(RadioGroupQuestionType.ItemIndex);
  Value.Weight := cbWeight.ItemIndex + 1;
end;

function TVariantsFrame.GetQuestionType: TQuestionType;
begin
  Result := TQuestionType(RadioGroupQuestionType.ItemIndex);
end;

procedure TVariantsFrame.SetChanged(const Value: boolean);
begin
  fChanged := Value;
end;

procedure TVariantsFrame.SetQuestion(const Value: IQuestion);
var
  i: integer;
  variant: IVariant;
begin
  if not Assigned(Value) then
  begin
    MemoComment.Text := '';
    RadioGroupQuestionType.ItemIndex := 0;
    Exit;
  end;

  ClearVariants;
  for variant in Value.Variants do
    NewVariant(variant.Text, Value.QuestionType, variant.Correct);
  PlaceAddButton;

  if Trim(Value.Topic) <> '' then
  begin
    MemoComment.Text := Value.Topic;
    MemoComment.Visible := True;
    LabelCommentHint.Visible := True;
    LabelComment.Caption := cCommentCaption;
    LabelComment.Font.Color := clWindowText;
    LabelComment.Font.Style := [];
    LabelComment.Cursor := crDefault;
  end
  else
  begin
    MemoComment.Visible := False;
    MemoComment.Clear;
    LabelCommentHint.Visible := False;
    LabelComment.Caption := cCommentAddCaption;
    LabelComment.Font.Color := clBlue;
    LabelComment.Font.Style := [fsUnderline];
    LabelComment.Cursor := crHandPoint;
  end;
  RadioGroupQuestionType.ItemIndex := integer(Value.QuestionType);
  cbWeight.ItemIndex := Value.Weight - 1;
  fChanged := False;
end;

procedure TVariantsFrame.SetQuestionType(const Value: TQuestionType);
begin
  RadioGroupQuestionType.ItemIndex := Integer(Value);
end;

procedure TVariantsFrame.SpeedButtonAddClick(Sender: TObject);
begin
  NewVariant('', QuestionType, False);
  PlaceAddButton;
end;

procedure TVariantsFrame.cbWeightChange(Sender: TObject);
begin
  fChanged := True;
end;

procedure TVariantsFrame.ClearVariants;
var
  i: Integer;
begin
  for i := 0 to FVariants.Count - 1 do
    (TObject(FVariants.Items[i]) as TVariantControl).Free;
  FVariants.Clear;
end;

constructor TVariantsFrame.Create(AOwner: TComponent);
begin
  inherited;
  FVariants := TList.Create;
end;

destructor TVariantsFrame.Destroy;
begin
  ClearVariants;
  FVariants.Free;
  inherited;
end;

procedure TVariantsFrame.LabelCommentClick(Sender: TObject);
begin
  if fsUnderline in (Sender as TLabel).Font.Style then
  begin
    MemoComment.Visible := True;
    LabelCommentHint.Visible := True;
    LabelComment.Caption := cCommentCaption;
    LabelComment.Font.Color := clWindowText;
    LabelComment.Font.Style := [];
    LabelComment.Cursor := crDefault;
  end;
end;

procedure TVariantsFrame.MemoCommentKeyPress(Sender: TObject; var Key: Char);
begin
  fChanged := True;
end;

procedure TVariantsFrame.NewVariant(const Text: string; QuestionType: TQuestionType; Correct: Boolean);
var
  variant: TVariantControl;
begin
  if FVariants.Count >= 6 then
    Exit;
  variant := TVariantControl.Create(Self);
  variant.QuestionType := QuestionType;
  variant.Text := Text;
  variant.Checked := Correct;
  FVariants.Add(variant);
end;

procedure TVariantsFrame.OnMessage(var Msg: TMessage);
var
  i: Integer;
  obj: Pointer;
begin
  obj := Pointer(Msg.WParam);
  FVariants.Remove(obj);
  TVariantControl(obj).Free;
  PlaceAddButton;
end;

procedure TVariantsFrame.PlaceAddButton;
var
  i: Integer;
  variant: TVariantControl;
begin
  PanelVariants.Visible := False;
  SpeedButtonAdd.Top := 0;
  for i := 0 to FVariants.Count - 1 do
  begin
    variant := TVariantControl(FVariants.Items[i]);
    variant.Left := 6;
    variant.Top := i * 30 + 10;
  end;
  if (FVariants.Count > 0) then
    SpeedButtonAdd.Top := (TObject(FVariants.Last) as TVariantControl).Top + 30;
  SpeedButtonAdd.Visible := (FVariants.Count < 6);
  PanelVariants.Visible := True;
end;

procedure TVariantsFrame.RadioGroupQuestionTypeClick(Sender: TObject);
var
  i: Integer;
begin
  fChanged := True;
  for i := 0 to FVariants.Count - 1 do
    (TObject(FVariants.Items[i]) as TVariantControl).QuestionType := TQuestionType(RadioGroupQuestionType.ItemIndex);
end;

{ TVariantControl }

constructor TVariantControl.Create(ParentFrame: TVariantsFrame);
begin
  FParentFrame := ParentFrame;
  FRadioButton := TRadioButton.Create(ParentFrame.PanelVariants);
  FRadioButton.Parent := ParentFrame.PanelVariants;
  FRadioButton.Width := 20;
  FRadioButton.Height := 20;
  FRadioButton.Visible := False;

  FCheckBox := TCheckBox.Create(ParentFrame.PanelVariants);
  FCheckBox.Parent := ParentFrame.PanelVariants;
  FCheckBox.Width := 20;
  FCheckBox.Height := 20;
  FCheckBox.Visible := False;

  FEdit := TEdit.Create(ParentFrame.PanelVariants);
  FEdit.Parent := ParentFrame.PanelVariants;
  FEdit.Width := ParentFrame.PanelVariants.Width - FRadioButton.Width - 50;
  FEdit.Height := 20;
  FEdit.OnKeyPress := ParentFrame.MemoCommentKeyPress;

  FDelButton := TSpeedButton.Create(ParentFrame.PanelVariants);
  FDelButton.Parent := ParentFrame.PanelVariants;
  FDelButton.Width := 20;
  FDelButton.Height := 20;
  FDelButton.Flat := True;
  FDelButton.OnClick := OnClick;
  FParentFrame.ImageList.GetBitmap(1, FDelButton.Glyph);
end;

destructor TVariantControl.Destroy;
begin
  FreeAndNil(FEdit);
  FreeAndNil(FRadioButton);
  FreeAndNil(FCheckBox);
  FreeAndNil(FDelButton);
  inherited;
end;

function TVariantControl.GetChecked: Boolean;
begin
  case FQuestionType of
    qtSingleSelect:
      Result := FRadioButton.Checked;
    qtMultiSelect:
      Result := FCheckBox.Checked;
    qtTypeAnswer:
      Result := True;
  end;
end;

function TVariantControl.GetText: WideString;
begin
  Result := FEdit.Text;
end;

procedure TVariantControl.OnClick(Sender: TObject);
begin
  PostMessage(FParentFrame.Handle, WM_USER, Integer(Pointer(Self)), 0);
end;

procedure TVariantControl.SetChecked(const Value: Boolean);
begin
  FRadioButton.Checked := Value;
  FCheckBox.Checked := Value;
end;

procedure TVariantControl.SetLeft(const Value: Integer);
begin
  FLeft := Value;
  FRadioButton.Left := FLeft;
  FCheckBox.Left := FLeft;
  FEdit.Left := FLeft + FRadioButton.Width + 6;
  FDelButton.Left := FLeft + FEdit.Width + FRadioButton.Width + 20;
end;

procedure TVariantControl.SetQuestionType(const Value: TQuestionType);
var
  bool: Boolean;
begin
  bool := Checked;
  FQuestionType := Value;
  Checked := bool;
  case FQuestionType of
    qtSingleSelect:
      begin
        FCheckBox.Visible := False;
        FRadioButton.Visible := True;
      end;
    qtMultiSelect:
      begin
        FCheckBox.Visible := True;
        FRadioButton.Visible := False;
      end;
    qtTypeAnswer:
      begin
        FCheckBox.Visible := False;
        FRadioButton.Visible := False;
      end;
  end;
end;

procedure TVariantControl.SetText(const Value: WideString);
begin
  FEdit.Text := Value;
end;

procedure TVariantControl.SetTop(const Value: Integer);
begin
  FTop := Value;
  FRadioButton.Top := FTop;
  FCheckBox.Top := FTop;
  FEdit.Top := FTop;
  FDelButton.Top := FTop;
end;

end.

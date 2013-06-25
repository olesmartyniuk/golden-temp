unit uSplashFrom;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Classes,
  uInterfaces,
  ComCtrls,
  ExtCtrls;

type

  TFormSplash = class(TForm, ISplash)
    Panel: TPanel;
    LabelMessage: TLabel;
    Animate: TAnimate;
    ProgressBar: TProgressBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    private
      fMainForm: TForm;
      fVisible: boolean;
      procedure ShowSplash; overload;
      function MainForm: TForm;
      procedure MainFormResize(Sender: TObject);
    public
      procedure SetProgress(Value: word);
      function GetProgress: word;
      function GetShowProgress: boolean;
      procedure SetShowProgress(Value: boolean);
      function GetVisible: boolean;
      procedure SetVisible(Value: boolean);

      procedure ShowSplash(const Message: string); overload;
      procedure HideSplash;
      constructor Create(aMainForm: TForm);
  end;

implementation

{$R *.dfm}

constructor TFormSplash.Create(aMainForm: TForm);
begin
  inherited Create(MainForm);
  Animate.ResHandle := GetModuleHandle('administrator.exe');
  Animate.ResName := 'universal';
  fMainForm := aMainForm;
end;

procedure TFormSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  MainForm.Cursor := crDefault;
end;

procedure TFormSplash.MainFormResize(Sender: TObject);
begin
  Left := (MainForm.Width div 2) - (Width div 2);
  Top := (MainForm.Height div 2) - (Height div 2);
end;

procedure TFormSplash.FormShow(Sender: TObject);
begin
  MainForm.Cursor := crHourGlass;
end;

function TFormSplash.GetProgress: word;
begin
  Result := ProgressBar.Position;
end;

function TFormSplash.GetShowProgress: boolean;
begin
  Result := ProgressBar.Visible;
end;

function TFormSplash.GetVisible: boolean;
begin
  Result := fVisible;
end;

procedure TFormSplash.HideSplash;
begin
  fVisible := False;
  Animate.Active := False;
  Close;
end;

function TFormSplash.MainForm: TForm;
begin
  Result := fMainForm;
end;

procedure TFormSplash.SetProgress(Value: word);
begin
  ProgressBar.Position := Value;
end;

procedure TFormSplash.SetShowProgress(Value: boolean);
begin
  ProgressBar.Visible := Value;
end;

procedure TFormSplash.SetVisible(Value: boolean);
begin
  if Value = fVisible then
    Exit;
  if Value then
    ShowSplash
  else
    HideSplash;
end;

procedure TFormSplash.ShowSplash;
begin
  Parent := MainForm;
  MainForm.OnResize := MainFormResize;
  Animate.Active := True;
  fVisible := True;
  MainFormResize(Self);
  Show;
end;

procedure TFormSplash.ShowSplash(const Message: string);
begin
  LabelMessage.Caption := message;
  ShowSplash;
end;

function NewSplash(MainForm: TForm): ISplash;
begin
  Result := TFormSplash.Create(MainForm);
end;

end.

unit uSplashForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Controls,
  Forms,
  StdCtrls,
  uInterfaces,
  Classes,
  ExtCtrls,
  ComCtrls;

type

  TFormSplash = class(TForm)
    Panel: TPanel;
    LabelMessage: TLabel;
    Animate: TAnimate;
    ButtonCancel: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonCancelClick(Sender: TObject);
    private
      FMainForm: TForm;
      FOnCancelEvent: TNotifyEvent;
    protected
      procedure CreateParams(var Params: TCreateParams); override;
    public
      constructor Create(const MainForm: TForm);
  end;

  TSplashImpl = class(TInterfacedObject, ISplash)
    private
      FSplashForm: TFormSplash;
      FMainForm: TForm;
      FVisible: boolean;
    private
      procedure ShowSplash; overload;
      procedure MainFormResize(Sender: TObject);
    protected
      procedure ShowSplash(const Message: WideString); overload;
      procedure HideSplash;
      function GetVisible: Boolean;
      procedure SetVisible(Value: Boolean);
      function GetOnCancel: TNotifyEvent;
      procedure SetOnCancel(Value: TNotifyEvent);
      function GetShowCancelButton: Boolean;
      procedure SetShowCancelButton(Value: Boolean);
    public
      constructor Create(aMainForm: TForm);
      destructor Destroy; override;
  end;

implementation

{$R *.dfm}

procedure TFormSplash.ButtonCancelClick(Sender: TObject);
begin
  if Assigned(FOnCancelEvent) then
    FOnCancelEvent(Sender);
end;

constructor TFormSplash.Create(const MainForm: TForm);
begin
  inherited Create(MainForm);
  FMainForm := MainForm;
  Animate.ResHandle := LoadLibrary('resources.dll');
  Animate.ResName := 'load_avi';
  if MainForm <> nil then
    Self.Font := MainForm.Font;
end;

procedure TFormSplash.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
    Style := Style {OR WS_POPUP} OR WS_DLGFRAME OR WS_THICKFRAME;
end;

procedure TFormSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FMainForm <> nil then
    FMainForm.Cursor := crDefault;
end;

{ TSplashImpl }

constructor TSplashImpl.Create(aMainForm: TForm);
begin
  if Assigned(aMainForm) then
    FMainForm := aMainForm
  else
    FMainForm := Application.MainForm;
  FSplashForm := TFormSplash.Create(FMainForm);
  if FMainForm <> nil then
  begin
    FSplashForm.Parent := FMainForm;
    FMainForm.OnResize := MainFormResize;
  end;
end;

destructor TSplashImpl.Destroy;
begin
  FMainForm.OnResize := nil;
  HideSplash;
  FreeAndNil(FSplashForm);
  inherited;
end;

function TSplashImpl.GetOnCancel: TNotifyEvent;
begin
  Result := FSplashForm.FOnCancelEvent;
end;

function TSplashImpl.GetShowCancelButton: Boolean;
begin
  Result := FSplashForm.ButtonCancel.Visible;
end;

function TSplashImpl.GetVisible: Boolean;
begin
  Result := FVisible;
end;

procedure TSplashImpl.HideSplash;
begin
  FVisible := False;
  if Assigned(FSplashForm.Animate) then
  begin
    FSplashForm.Animate.Active := False;
    FSplashForm.Hide;
  end;
end;

procedure TSplashImpl.MainFormResize(Sender: TObject);
begin
  if FMainForm <> nil then
  begin
    FSplashForm.Left := (FMainForm.Width div 2) - (FSplashForm.Width div 2);
    FSplashForm.Top := (FMainForm.Height div 2) - (FSplashForm.Height div 2);
  end;
end;

procedure TSplashImpl.SetOnCancel(Value: TNotifyEvent);
begin
  FSplashForm.FOnCancelEvent := Value;
end;

procedure TSplashImpl.SetShowCancelButton(Value: Boolean);
begin
  FSplashForm.ButtonCancel.Visible := Value;
end;

procedure TSplashImpl.SetVisible(Value: Boolean);
begin
  if Value = FVisible then
    Exit;
  if Value then
    ShowSplash
  else
    HideSplash;
end;

procedure TSplashImpl.ShowSplash;
begin
  FSplashForm.Animate.Active := True;
  FVisible := True;
  MainFormResize(Self);
  FSplashForm.Show;
end;

procedure TSplashImpl.ShowSplash(const Message: WideString);
begin
  FSplashForm.LabelMessage.Caption := Message;
  ShowSplash;
end;

end.

unit uFactories;

interface

uses
  SysUtils,
  Windows,
  Forms,
  SOAPHttpClient,
  uInterfaces,
  uRemotable;

type

  Core = class
    public
      class function NewSettings(const ASection: string = ''): ISettings;
  end;

  Remotable = class
    private
      class var FHost: string;
      class var FAccount: TAccount;
    private
      class function GetHost: string; static;
      class procedure SetHost(const Value: string); static;
      class function GetAccount: TAccount; static;
    public
      class function NewAdministrator(const Host: string = ''): IAdministrator;
      class property Account: TAccount read GetAccount;
      class property Host: string read GetHost write SetHost;
  end;

  Dialog = class
    public
      class function NewSplash(MainForm: TForm): ISplash;
      class procedure ShowWarningMessage(const AMessage: string; AForm: TForm = nil);
  end;

implementation

uses
  uSplashImpl,
  uSettingsImpl;

{ Dialog }

class function Dialog.NewSplash(MainForm: TForm): ISplash;
begin
  Result := TFormSplash.Create(MainForm);
end;

class procedure Dialog.ShowWarningMessage(const AMessage: string; AForm: TForm);
begin
  if not Assigned(AForm) then
    AForm := Application.MainForm;
  MessageBox(AForm.Handle, PChar(AMessage), 'Попередження', MB_OK or MB_ICONWARNING);
end;

{ Remotable }

class function Remotable.GetAccount: TAccount;
begin
  if not Assigned(FAccount) then
    FAccount := TAccount.Create;
  Result := FAccount;
end;

class function Remotable.GetHost: string;
begin
  Result := FHost;
end;

class function Remotable.NewAdministrator(const Host: string): IAdministrator;
var
  HTTPRIO: THTTPRIO;
  str: string;
begin
  str := Host;
  if str = '' then
    str := FHost;
  if str = '' then
    raise Exception.Create('Не вказано хост, до якого необхідно підключитись.');
  HTTPRIO := THTTPRIO.Create(nil);
  HTTPRIO.URL := Format('http://%s:%d/soap/IAdministrator', [str, 3030]);
  Result := HTTPRIO as IAdministrator;
end;

class procedure Remotable.SetHost(const Value: string);
begin
  if SameText(FHost, Value) then
    Exit;
  FHost := Value;
end;

{ Core }

class function Core.NewSettings(const ASection: string): ISettings;
begin
  Result := TSettingsImpl.Create;
  Result.SectionName := ASection;
end;

end.

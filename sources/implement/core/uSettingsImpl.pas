unit uSettingsImpl;

interface

uses
  SysUtils,
  IniFiles,
  uInterfaces,
  uConfig;

type

  TSettingsImpl = class(TInterfacedObject, ISettings)
  private
    fIniFile: TIniFile;
    fSectionName: string;
  protected
    function GetSectionName: string;
    procedure SetSectionName(const Value: string);
    function GetStr(aParamName: string; const aDefault: string): string;
    function GetInt(aParamName: string; const aDefault: Integer): Integer;
    function GetBool(aParamName: string; const aDefault: Boolean): Boolean;
    procedure SetStr(aParamName: string; aValue: string);
    procedure SetInt(aParamName: string; aValue: Integer);
    procedure SetBool(aParamName: string; aValue: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TgtSettingsSaver }

constructor TSettingsImpl.Create;
var
  path: string;
begin
  path := GetDirData + '\settings.ini';
  if not DirectoryExists(GetDirData) then
    ForceDirectories(GetDirData);
  fIniFile := TIniFile.Create(path);
end;

destructor TSettingsImpl.Destroy;
begin
  fIniFile.UpdateFile;
  fIniFile.Free;
  inherited;
end;

function TSettingsImpl.GetBool(aParamName: string; const aDefault: Boolean): Boolean;
begin
  Result := fIniFile.ReadBool(GetSectionName, aParamName, aDefault);
end;

function TSettingsImpl.GetInt(aParamName: string; const aDefault: Integer): Integer;
begin
  Result := fIniFile.ReadInteger(GetSectionName, aParamName, aDefault);
end;

function TSettingsImpl.GetSectionName: string;
begin
  if fSectionName = '' then
    fSectionName := ChangeFileExt(GetCurrentExecutableModuleName, '');
  Result := fSectionName;
end;

function TSettingsImpl.GetStr(aParamName: string; const aDefault: string): string;
begin
  Result := fIniFile.ReadString(GetSectionName, aParamName, aDefault);
end;

procedure TSettingsImpl.SetBool(aParamName: string; aValue: Boolean);
begin
  fIniFile.WriteBool(GetSectionName, aParamName, aValue);
  fIniFile.UpdateFile;
end;

procedure TSettingsImpl.SetInt(aParamName: string; aValue: Integer);
begin
  fIniFile.WriteInteger(GetSectionName, aParamName, aValue);
  fIniFile.UpdateFile;
end;

procedure TSettingsImpl.SetSectionName(const Value: string);
begin
  fSectionName := Value;
end;

procedure TSettingsImpl.SetStr(aParamName, aValue: string);
begin
  fIniFile.WriteString(GetSectionName, aParamName, aValue);
  fIniFile.UpdateFile;
end;

end.

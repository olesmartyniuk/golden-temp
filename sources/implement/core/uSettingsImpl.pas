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
    fSectionName: WideString;
  protected
    function GetSectionName: WideString;
    procedure SetSectionName(const Value: WideString);
    function GetStr(aParamName: WideString; const aDefault: WideString): WideString;
    function GetInt(aParamName: WideString; const aDefault: Integer): Integer;
    function GetBool(aParamName: WideString; const aDefault: Boolean): Boolean;
    procedure SetStr(aParamName: WideString; aValue: WideString);
    procedure SetInt(aParamName: WideString; aValue: Integer);
    procedure SetBool(aParamName: WideString; aValue: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TgtSettingsSaver }

constructor TSettingsImpl.Create;
var
  path: WideString;
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

function TSettingsImpl.GetBool(aParamName: WideString; const aDefault: Boolean): Boolean;
begin
  Result := fIniFile.ReadBool(GetSectionName, aParamName, aDefault);
end;

function TSettingsImpl.GetInt(aParamName: WideString; const aDefault: Integer): Integer;
begin
  Result := fIniFile.ReadInteger(GetSectionName, aParamName, aDefault);
end;

function TSettingsImpl.GetSectionName: WideString;
begin
  if fSectionName = '' then
    fSectionName := ChangeFileExt(GetCurrentExecutableModuleName, '');
  Result := fSectionName;
end;

function TSettingsImpl.GetStr(aParamName: WideString; const aDefault: WideString): WideString;
begin
  Result := fIniFile.ReadString(GetSectionName, aParamName, aDefault);
end;

procedure TSettingsImpl.SetBool(aParamName: WideString; aValue: Boolean);
begin
  fIniFile.WriteBool(GetSectionName, aParamName, aValue);
  fIniFile.UpdateFile;
end;

procedure TSettingsImpl.SetInt(aParamName: WideString; aValue: Integer);
begin
  fIniFile.WriteInteger(GetSectionName, aParamName, aValue);
  fIniFile.UpdateFile;
end;

procedure TSettingsImpl.SetSectionName(const Value: WideString);
begin
  fSectionName := Value;
end;

procedure TSettingsImpl.SetStr(aParamName, aValue: WideString);
begin
  fIniFile.WriteString(GetSectionName, aParamName, aValue);
  fIniFile.UpdateFile;
end;

end.

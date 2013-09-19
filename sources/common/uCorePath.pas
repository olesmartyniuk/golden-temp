unit uCorePath;

interface

uses
  Windows,
  SysUtils,
  SHFolder;

function GetModuleFileName: WideString;  
function GetDirCore: WideString;
function GetDirBin: WideString;
function GetDirDb: WideString;
function GetDirErrors: WideString;
function GetDirData: WideString;

function ExeParamPresent(const aParam: WideString): boolean;
function GetCurrentModulePath: WideString;
function GetCurrentExecutableModuleDir: WideString;
function GetCurrentExecutableModulePath: WideString;
function GetCurrentExecutableModuleName: WideString;
function GetProgrammParams: WideString;
function GetTempDirectory: WideString;

function GetLongPathNameW(lpszShortPath, lpszLongPath: PWideChar;
    cchBuffer: DWORD): DWORD; stdcall external kernel32;

function ShGetFolderPathW(hWndOwner: HWnd; csidl: Integer; hToken:
  THandle; dwReserved: DWord; lpszPath: PWideChar): HResult; stdcall external 'ShFolder.dll' name 'SHGetFolderPathW';

implementation

const
  cAppGroupName = 'Golden Temp';

function GetSpecialFolderPath(FolderID: Cardinal): string;
(*  CSIDL_PERSONAL, { My Documents }
 CSIDL_APPDATA, { Application Data, new for NT4 }
 CSIDL_LOCAL_APPDATA, { non roaming, user\Local Settings\Application Data }
 CSIDL_INTERNET_CACHE,
 CSIDL_COOKIES,
 CSIDL_HISTORY,
 CSIDL_COMMON_APPDATA, { All Users\Application Data }
 CSIDL_WINDOWS, { GetWindowsDirectory() }
 CSIDL_SYSTEM, { GetSystemDirectory() }
 CSIDL_PROGRAM_FILES, { C:\Program Files }
 CSIDL_MYPICTURES, { My Pictures, new for Win2K }
 CSIDL_PROGRAM_FILES_COMMON, { C:\Program Files\Common }
 CSIDL_COMMON_DOCUMENTS, { All Users\Documents }
 CSIDL_FLAG_CREATE, { new for Win2K, or this in to force creation of folder }
 CSIDL_COMMON_ADMINTOOLS, { All Users\Start Menu\Programs\Administrative Tools }
 CSIDL_ADMINTOOLS); { <user name>\Start Menu\Programs\Administrative Tools }
 *)
var
  s: PWideChar;
  T, F: Cardinal;
begin
 T := 0;
 F := 0;
 GetMem(S, MAX_PATH * SizeOf(WideChar));
 try
   SHGetFolderPathW(0, FolderID, T, F, s);
   Result := s;
 finally
   FreeMem(S, MAX_PATH * SizeOf(WideChar));
 end;
end;

function ExeParamPresent(const aParam: WideString): boolean;
begin
  Result := Pos(' ' + aParam, GetProgrammParams) <> 0;
end;

function GetProgrammParams: WideString;
var
  i: integer;
begin
  Result := '';
  for i := 1 to ParamCount do
    Result := Result + ' ' + ParamStr(i);
end;

function GetCurrentModulePath: WideString;
var
  mbi: MEMORY_BASIC_INFORMATION;
  pBuf: array[0 .. MAX_PATH * 2] of WideChar;
begin
  VirtualQuery(@GetCurrentModulePath, mbi, sizeof(mbi));
  GetModuleFileNameW(Cardinal(mbi.AllocationBase), pBuf, MAX_PATH * 2);
  result := pBuf;
end;

function GetCurrentExecutableModulePath: WideString;
begin
  Result := ParamStr(0);
end;

function GetCurrentExecutableModuleDir: WideString;
begin
  Result := ExtractFileDir(GetCurrentExecutableModulePath);
end;

function GetCurrentExecutableModuleName: WideString;
begin
  Result := ExtractFileName(ParamStr(0));
end;

function GetTempDirectory: WideString;
var
  ShortPath, LongPath: array[0..MAX_PATH - 1] of WideChar;
begin
   if GetTempPathW(MAX_PATH, @ShortPath[0]) > 0 then
    if GetLongPathNameW(ShortPath, @LongPath[0], MAX_PATH) > 0 then
      Result := WideString(LongPath);
end;

function GetModuleFileName: WideString;
begin
  Result := ParamStr(0);
end;

function GetDirCore: WideString;
begin
  Result := ExtractFileDir(ParamStr(0));
  Result := ExtractFileDir(Result);
end;

function GetDirBin: WideString;
begin
  Result := GetDirCore + '\bin';
  if not DirectoryExists(Result) then
    CreateDir(Result);
end;

function GetDirDb: WideString;
begin
  Result := GetDirCore + '\data';
  Exit;
  Result := GetSpecialFolderPath(CSIDL_COMMON_APPDATA) + '\' + cAppGroupName;
  if not DirectoryExists(Result) then
    CreateDir(Result);
end;

function GetDirErrors: WideString;
begin
  Result := GetDirData;
end;

function GetDirData: WideString;
begin
  Result := GetDirCore + '\data';
  Exit;
  Result := GetSpecialFolderPath(CSIDL_APPDATA) + '\' + cAppGroupName;
  if not DirectoryExists(Result) then
    CreateDir(Result);
end;

end.

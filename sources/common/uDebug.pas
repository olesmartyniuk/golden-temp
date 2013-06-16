unit uDebug;

{ TODO }

interface

uses
  Classes,
  SysUtils,
  Windows,
  JCLDebug,
  Forms,
  Tlhelp32,
  Registry,
  JclSysInfo,
  JCLHookExcept;

type
  TExceptionLogger = class
    private
      FFileName: string;
      FException: Exception;
    private
      function GetExceptionInfo: string;
      function GetProgrammInfo: string;
      function GetOsInfo: string;
      function GetHardwareInfo: string;
      function GetStackList: string;
      function GetModulesList: string;
    public
      procedure LogException(const E: Exception);
      constructor Create(const FileName: string);
  end;

function SaveException(E: Exception): boolean;
procedure ODS(const aMessage: WideString);
function ProcessesCount(const ModuleFielName: WideString): Integer;
function AppendFile(const AFilePath: string; const AMessage: string): Boolean;

implementation

uses
  SyncObjs,
  WinInet,
  Printers,
  uConfig;

var
  csLogger: TCriticalSection;

function GetLogFileName: WideString;
begin
  Result := GetDirData + '\' + ChangeFileExt(GetCurrentExecutableModuleName, '.errors');
end;

function SaveException(E: Exception): boolean;
var
  Logger: TExceptionLogger;
begin
  csLogger.Enter;
  try
    Logger := TExceptionLogger.Create(GetLogFileName);
    Logger.LogException(E);
    Logger.Free;
  finally
    csLogger.Leave;
  end;
end;

procedure ODS(const aMessage: WideString);
var
  mess: WideString;
  txt: text;
begin
  AppendFile(GetDirData + '\' + ChangeFileExt(GetCurrentExecutableModuleName, '.log'), aMessage);
end;

function ProcessesCount(const ModuleFielName: WideString): Integer;
var
  processes: TStringList;
  i: Integer;
begin
  Result := 0;
  processes := TStringList.Create;
  try
    RunningProcessesList(processes, True);
    for i := 0 to processes.Count - 1 do
    begin
      if SameText(processes.Strings[i], ModuleFielName) then
        Inc(Result);
    end;
  finally
    processes.Free;
  end;
end;

const
  RETRY_COUNT = 10;

  // відкрити файл для запису (робиться декілька спроб з паузою)
function OpenFileForWrite(const AFileName: string): Cardinal;
var
  i: Integer;
begin
  Result := CreateFile(PChar(AFileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if Result <> INVALID_HANDLE_VALUE then
    Exit;
  i := 0;
  repeat
    // спробуємо відкрити файл повторно
    Sleep(50);
    Result := CreateFile(PChar(AFileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    Inc(i);
  until (not i >= RETRY_COUNT) or (Result <> INVALID_HANDLE_VALUE);
end;

// дописати текст у файл
function AppendFile(const AFilePath: string; const AMessage: string): Boolean;
var
  handle: Cardinal;
  text: string;
  written: Cardinal;
begin
  handle := OpenFileForWrite(AFilePath);
  if handle = INVALID_HANDLE_VALUE then
    Exit;
  text := AMessage;
  SetFilePointer(handle, 0, nil, FILE_END);
  Result := WriteFile(handle, text[1], Length(text) * SizeOf(Char), written, nil);
  CloseHandle(handle);
end;

procedure OnAnyException(ExceptObj: TObject; ExceptAddr: Pointer; OSException: Boolean);
var
  Logger: TExceptionLogger;
begin
  if not (ExceptObj is Exception) then
    Exit;
  csLogger.Enter;
  try
    Logger := TExceptionLogger.Create(GetLogFileName);
    Logger.LogException(ExceptObj as Exception);
    Logger.Free;
  finally
    csLogger.Leave;
  end;
end;

constructor TExceptionLogger.Create(const FileName: string);
begin
  FFileName := FileName;
end;

procedure TExceptionLogger.LogException(const E: Exception);
begin
  try
    if not Assigned(E) then
      Exit;
    FException := E;
    with TStringList.Create do
    begin
      try
        Add('');
        Add(GetExceptionInfo);
        Add(GetProgrammInfo);
        Add(GetOsInfo);
        Add(GetHardwareInfo);
        Add(GetStackList);
        Add(GetModulesList);
        Add('============================================================================================================================');
        AppendFile(FFileName, Text);
      finally
        Free;
      end;
    end;
  except
  end;
end;

{ const
  INTERNET_CONNECTION_MODEM = 1;
  INTERNET_CONNECTION_LAN = 2;
  INTERNET_CONNECTION_PROXY = 3;
}

const
  TAB = #09;

function TExceptionLogger.GetOsInfo: string;
var
  os, ie, network, proxy, prn: string;
  reg: TRegistry;
  dwConnectionTypes: DWORD;
  proxyServer: string;
  proxyPort: Integer;
begin
  // OS="Windows 7 Professional SP1" IE="8.0.1953.2221" Network="enabled" Proxy="192.168.11.15:80" Printer="Canon 123 enabled"
  os := Format('%s %s %s', [GetWindowsVersionString, NtProductTypeString, GetWindowsServicePackVersionString]);
  reg := TRegistry.Create(KEY_READ);
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKey('Software\Microsoft\Internet Explorer', False);
    ie := reg.ReadString('Version');
  finally
    reg.Free;
  end;

  try
    dwConnectionTypes := INTERNET_CONNECTION_MODEM + INTERNET_CONNECTION_LAN + INTERNET_CONNECTION_PROXY;
    if InternetGetConnectedState(@dwConnectionTypes, 0) then
    begin
      if ((dwConnectionTypes and INTERNET_CONNECTION_MODEM) <> 0) then
        network := 'Modem'
      else if ((dwConnectionTypes and INTERNET_CONNECTION_LAN) <> 0) then
        network := 'LAN';
      if ((dwConnectionTypes and INTERNET_CONNECTION_PROXY) <> 0) then
        network := network + ' use proxy';
      if ((dwConnectionTypes and INTERNET_RAS_INSTALLED) <> 0) then
        network := network + ' RAS';
      if ((dwConnectionTypes and INTERNET_CONNECTION_OFFLINE) <> 0) then
        network := network + ' offline'
      else
        network := network + ' online';
      if ((dwConnectionTypes and INTERNET_CONNECTION_CONFIGURED) <> 0) then
        network := network + ' might not connected';
    end
    else
      network := 'No connection';
  except
    network := '[error]';
  end;

  try
    prn := '';
    if (Printer.PrinterIndex > 0) then
      prn := Printer.Printers[Printer.PrinterIndex]
    else
      prn := '';
  except
    prn := '[error]';
  end;

  Result := Format(TAB + 'OS="%s" IE="%s" Network="%s" Printer="%s"', [os, ie, network, prn]);
end;

function TExceptionLogger.GetProgrammInfo: string;
var
  name, version, revision, module, thread: string;
begin
  // Programm="Соната" Version="0.4.0.0 альфа" Revision="0" Module="d:\projects\sonata\project\product\bin\sonata.exe" ProcessID="2792" ThreadID="2284"
  // DataDirectory="c:\users\appData"
  // name := Core.Settings.ReadParam('software_name');
  // version := Core.Settings.ReadParam('software_version');
  // revision := Core.Settings.ReadParam(PARAM_SOFTWARE_REVISION);
  module := Application.Exename;
  if GetCurrentThreadId = MainThreadId then
    thread := 'main'
  else
    thread := IntToStr(GetCurrentThreadId);
  Result := Format(TAB + 'Module="%s" Thread="%s" DataDirectory="%s"', [module, thread, GetDirData]);
end;

function TExceptionLogger.GetStackList: string;
var
  List: TJclStackInfoList;
  Info: TJclLocationInfo;
  i: Integer;
  line: string;
begin
  {
    Stack
    Procedure="TXMLDocument.LoadData" Module="sonata.exe" Source="" Line="0"
    Procedure="TXMLDocument.SetActive" Module="sonata.exe" Source="" Line="0"
    Procedure="TXMLDocument.LoadFromStream" Module="sonata.exe" Source="" Line="0"/>
    Procedure="TDocumentBaseImpl.SetXml" Module="sonata.exe" Source="..\..\implement\document\uDocumentBaseImpl.pas" Line="672"
    ...
  }

  List := JclLastExceptStackList;
  if not Assigned(List) then
    Exit;
  with TStringList.Create do
    try
      Add(TAB + 'Stack');
      for i := 0 to List.Count - 1 do
      begin
        if GetLocationInfo(List.Items[i].CallerAddr, Info) then
        begin
          line := Format('Procedure="%s" Module="%s" Source="%s" Line="%d"', [Info.ProcedureName, ExtractFileName(Info.BinaryFileName), Info.SourceName,
            Info.LineNumber]);
          Add(TAB + TAB + line);
        end;
      end;
      Result := TrimRight(Text);
    finally
      Free;
    end;
end;

function TExceptionLogger.GetExceptionInfo: string;
begin
  // Exception Class="EDOMParseError" Message="В текстовом комментарии обнаружен недопустимый знак.&#xA;&#xA;Line: 1&#xA;IVK_SIGN" Date="22.01.2013 16:06:03"
  Result := Format('Exception Class="%s" Message="%s" Date="%s"', [FException.ClassName, FException.Message, FormatDateTime('dd.mm.yyyy hh:mm:ss', Now)]);
end;

function TExceptionLogger.GetHardwareInfo: string;
var
  cpuInfo: TCpuInfo;
  processor, display, memory: string;
  DC: HDC;
begin
  // Processor="Intel(R) Pentium(R) CPU G840 @ 2.80GHz" Display="1680x1050 32 bit" FreeMemory Phisical="1434 Mb" Virtual="1804 Mb"
  GetCpuInfo(cpuInfo);
  DC := GetDC(0);
  processor := Trim(CpuInfo.CpuName);
  display := Format('%dx%d %d bit', [GetDeviceCaps(DC, HORZRES), GetDeviceCaps(DC, VERTRES), GetDeviceCaps(DC, BITSPIXEL)]);
  memory := Format('Phisical="%d Mb Virtual="%d Mb"', [GetFreePhysicalMemory div 1048576, GetFreeVirtualMemory div 1048576]);
  Result := Format(TAB + 'Processor="%s" Display="%s" FreeMemory %s', [processor, display, memory]);
end;

function TExceptionLogger.GetModulesList: string;
var
  modules: TJclModuleInfoList;
  i: Integer;
  path: string;
  module: HMODULE;
begin
  {
    Modules
    Path="C:\Windows\System32\oledlg.dll" Version="6.1.7600.16385"
  }
  {
    modules := TJclModuleInfoList.Create(False, False);
    try
    with TStringList.Create do
    try
    for i := 0 to modules.Count - 1 do
    begin
    Module := ModuleFromAddr(modules.Items[i].StartAddr);
    path := GetModulePath(Module);
    Add(TAB + TAB + Format('Path="%s" Version="%s"', [path, GetFileVersion(path)]));
    end;
    Sort;
    Insert(0, TAB + 'Modules');
    Result := TrimRight(Text);
    finally
    Free;
    end;
    finally
    modules.Free;
    end;
  }
  Result := '';
end;

initialization

csLogger := TCriticalSection.Create;
JclAddExceptNotifier(OnAnyException);
JclStartExceptionTracking;

finalization

JclStopExceptionTracking;
FreeAndNil(csLogger);

end.

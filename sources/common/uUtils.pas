unit uUtils;

interface

uses
  uInterfaces,
  Windows,
  Forms,
  OleCtnrs,
  SysUtils,
  Classes,
  ComObj,
  ZLib,
  Graphics,
  Controls,
  Jpeg,
  Dialogs,
  Soap.EncdDecd,
  TlHelp32,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPServer;

const
  CRLF = #13#10;
  cShortTextMaxLength = 300;

function DateTimeToUnix(ConvDate: TDateTime): Longint;
function UnixToDateTime(USec: Longint): TDateTime;
function EncodeDateTime(aDateTime: TDateTime): WideString;
function DecodeDateTime(aUnixFormat: WideString): TDateTime;

procedure CompressStream(inpStream, outStream: TStream);
procedure DecompressStream(inpStream, outStream: TStream);
procedure PictureToStream(var Ole: TOleContainer; Stream: TStream; Quality: byte);

function SecToTime(Seconds: integer): TTime;

procedure ShowInfoMessage(const aMessage: WideString; aForm: TForm = nil);
procedure ShowErrorMessage(const aMessage: WideString; aForm: TForm = nil);
procedure ShowWarningMessage(const aMessage: WideString; aForm: TForm = nil);
function QueryYesNo(const aMessage: WideString; aForm: TForm = nil; const aCaption: WideString = 'Info'): integer;
function QueryYesNoCancel(const aMessage: WideString; aForm: TForm = nil; const aCaption: WideString = 'Info'): integer;

function TranslitKir2Lat(const aStr: WideString): WideString;
function IsShortText(const aText: WideString): Boolean;
function GetWinInetError(ErrorCode: Cardinal): string;

implementation

const
  // Sets UnixStartDate to TDateTime of 01/01/1970
  UnixStartDate: TDateTime = 25569.0;

function DateTimeToUnix(ConvDate: TDateTime): Longint;
begin
  if Trunc(ConvDate) = 0 then
    Result := Round(ConvDate * 86400)
  else
    Result := Round((ConvDate - UnixStartDate) * 86400);
end;

function UnixToDateTime(USec: Longint): TDateTime;
begin
  Result := (Usec / 86400) + UnixStartDate;
end;

function EncodeDateTime(aDateTime: TDateTime): WideString;
begin
  Result := IntToStr(DateTimeToUnix(aDateTime))
end;

function DecodeDateTime(aUnixFormat: WideString): TDateTime;
begin
  Result := UnixToDateTime(StrToIntDef(aUnixFormat, 0));
end;

procedure CompressStream(inpStream, outStream: TStream);
var
  InpBuf, OutBuf: Pointer;
  InpBytes, OutBytes: Integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  try
    GetMem(InpBuf, inpStream.Size);
    inpStream.Position := 0;
    InpBytes := inpStream.Read(InpBuf^, inpStream.Size);
    ZCompress(InpBuf, InpBytes, OutBuf, OutBytes);
    outStream.Write(OutBuf^, OutBytes);
  finally
    if InpBuf <> nil then
      FreeMem(InpBuf);
    if OutBuf <> nil then
      FreeMem(OutBuf);
  end;
end;

procedure DecompressStream(inpStream, outStream: TStream);
var
  InpBuf, OutBuf: Pointer; 
  OutBytes, sz: Integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  sz := inpStream.Size - inpStream.Position;
  if sz > 0 then
    try
      GetMem(InpBuf, sz);
      inpStream.Read(InpBuf^, sz);
      ZDecompress(InpBuf, sz, OutBuf, OutBytes);
      outStream.Write(OutBuf^, OutBytes);
    finally
      if InpBuf <> nil then
        FreeMem(InpBuf);
      if OutBuf <> nil then
        FreeMem(OutBuf);
    end;
  outStream.Position := 0;
end;

procedure PictureToStream(var Ole: TOleContainer; Stream: TStream; Quality: byte);
var
  Bitmap: TBitmap;
  Jpeg: TJpegImage;
begin
  Bitmap := TBitmap.Create;
  try
    Ole.Align := alCustom;
    Ole.SizeMode := smAutosize;
    Bitmap.Width := Ole.Width;
    Bitmap.Height :=Ole.Height;
    Ole.PaintTo(Bitmap.Canvas, 0, 0);
    Ole.Align := alClient;
    Ole.SizeMode := smScale;
    Jpeg := TJpegImage.Create;
    try
      Jpeg.Assign(Bitmap);
      Jpeg.CompressionQuality := Quality;
      Jpeg.ProgressiveEncoding := True;
      Jpeg.Compress;
      Stream.Size := 0;
      Jpeg.SaveToStream(Stream);
    finally
      Jpeg.Free;
    end;
  finally
    Bitmap.Free;
  end;
end;


function SecToTime(Seconds: integer): TTime;
var
  Hour, Min, Sec: integer;
begin
  try
    Result := 0;
    if Seconds < 0 then
      Exit;
    Hour := Seconds div 3600;
    Min := (Seconds - Hour * 3600) div 60;
    Sec := Seconds - Hour * 3600 - Min * 60;
    if Hour > 23 then
      Hour := 23;
    if Min > 59 then
      Min := 59;
    if Sec > 59 then
      Sec := 59;
    Result := EncodeTime(Hour, Min, Sec, 0);
  except
    Result := 0.0;
  end;
end;

procedure ShowInfoMessage(const aMessage: WideString; aForm: TForm = nil);
var
  handle: THandle;
begin
  if Assigned(aForm) then
    handle := aForm.Handle
  else
    handle := Application.MainFormHandle;
  MessageBoxW(handle, PWideChar(aMessage), 'Info', MB_OK or MB_ICONINFORMATION)
end;

procedure ShowErrorMessage(const aMessage: WideString; aForm: TForm = nil);
var
  handle: THandle;
begin
  if Assigned(aForm) then
    handle := aForm.Handle
  else
    handle := Application.MainFormHandle;
  MessageBoxW(handle, PWideChar(aMessage), 'Error', MB_OK or MB_ICONERROR)
end;

procedure ShowWarningMessage(const aMessage: WideString; aForm: TForm = nil);
var
  handle: THandle;
begin
  if Assigned(aForm) then
    handle := aForm.Handle
  else
    handle := Application.MainFormHandle;
  MessageBoxW(handle, PWideChar(aMessage), 'Warning', MB_OK or MB_ICONWARNING)
end;

function QueryYesNo(const aMessage: WideString; aForm: TForm = nil; const aCaption: WideString = 'Info'): integer;
var
  handle: THandle;
begin
  if Assigned(aForm) then
    handle := aForm.Handle
  else
    handle := Application.MainFormHandle;
  Result := MessageBoxW(handle, PWideChar(aMessage), PWideChar(aCaption), MB_YESNO or MB_ICONQUESTION)
  // IDYES, IDNO
end;

function QueryYesNoCancel(const aMessage: WideString; aForm: TForm = nil; const aCaption: WideString = 'Info'): integer;
var
  handle: THandle;
begin
  if Assigned(aForm) then
    handle := aForm.Handle
  else
    handle := Application.MainFormHandle;
  Result := MessageBoxW(handle, PWideChar(aMessage), PWideChar(aCaption), MB_YESNOCANCEL or MB_ICONQUESTION)
  // IDYES, IDNO, IDCANCEL
end;

function TranslitKir2Lat(const aStr: WideString): WideString;
const
  RArrayL = 'абвгдеєёжзиіїйклмнопрстуфхцчшщьыъэюя';
  colChar = 36;
  arr: array[1..ColChar] of WideString =
    ('a','b','v','g','d','e','e','yo','zh','z','i','i','i','y',
     'k','l','m','n','o','p','r','s','t','u','f',
     'kh','ts','ch','sh','shch','','y','','e','yu','ya');
var
  i: Integer;
  len: Integer;
  p: Integer;
  str: WideString;
begin
  Result := '';
  str := WideLowerCase(aStr);
  len := Length(str);
  for i := 1 to len do
  begin
    p := pos(str[i], RArrayL);
    if (p <> 0) then
      Result := Result + arr[p]
    //если не русская буква, то берем исходную
    else
      Result := Result + str[i];
  end;
end;

function IsShortText(const aText: WideString): Boolean;
begin
  Result := Length(UTF8Encode(aText)) < cShortTextMaxLength;
end;

function GetWinInetError(ErrorCode: Cardinal): string;
const
  winetdll = 'wininet.dll';
var
  Len: Integer;
  Buffer: PChar;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_IGNORE_INSERTS or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, Pointer(GetModuleHandle(winetdll)), ErrorCode, 0, @Buffer, SizeOf(Buffer), nil);
  try
    while (Len > 0) and {$IFDEF UNICODE}(CharInSet(Buffer[Len - 1], [#0 .. #32, '.'])) {$ELSE}(Buffer[Len - 1] in [#0 .. #32, '.']) {$ENDIF} do
      Dec(Len);
    SetString(Result, Buffer, Len);
  finally
    LocalFree(HLOCAL(Buffer));
  end;
end;

end.

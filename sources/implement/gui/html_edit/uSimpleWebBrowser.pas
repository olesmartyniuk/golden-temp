unit uSimpleWebBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IeConst, ActiveX, MSHTML, MSHTML_TLB, SHDocVw, SHDocVw_TLB, CDO_TLB, ADODB_TLB, uSynapse, uUtils, uCorePath;

type
  TCommandId = TOleEnum;
  TCommandFlag = TOleEnum;

   TDocHostUIInfo = record
    cbSize: ULONG;          // size of structure in bytes
    dwFlags: DWORD;         // flags that specify UI capabilities
    dwDoubleClick: DWORD;   // specified response to double click
    pchHostCss: PWChar;     // pointer to CSS rules
    pchHostNS: PWChar;      // pointer to namespace list for custom tags
  end;

  IDocHostUIHandler = interface(IUnknown) ['{bd3f23c0-d43e-11cf-893b-00aa00bdce1a}']
   function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch): HRESULT; stdcall;
    function GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
    function ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
    function OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT; stdcall;
    function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT; stdcall;
    function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD): HRESULT; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
    function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT; stdcall;
  end;

  TFocusedNotifyEvent = procedure(Sender: TObject; aFocused: boolean) of object;

  TSimpleWebBrowser = class(TWebBrowser, IDocHostUIHandler, IOleControlSite)
  private
    fFonts: TStringList;
    fOnChange: TNotifyEvent;
    fOnFocused: TFocusedNotifyEvent;
    fNoChangeEvent: boolean;
    fInFocus: boolean;
    fDocumentEdited: Boolean;
  private
    function GetOnChange: TNotifyEvent;
    procedure SetOnChange(const Value: TNotifyEvent);
    function GetHTML: AnsiString;
    function GetText: WideString;
    procedure SetHTML(const Value: AnsiString);
    procedure SetText(const Value: WideString);
    function GetDesignMode: boolean;
    procedure SetDesignMode(const Value: boolean);
    function GetOnFocused: TFocusedNotifyEvent;
    procedure SetOnOnFocused(const Value: TFocusedNotifyEvent);
    function GetInFocus: boolean;
    procedure OnBeforeNavigateEvent(ASender: TObject; const pDisp: IDispatch;
                                                           const URL: OleVariant;
                                                           const Flags: OleVariant;
                                                           const TargetFrameName: OleVariant;
                                                           const PostData: OleVariant;
                                                           const Headers: OleVariant;
                                                           var Cancel: WordBool);
  private
    procedure Initialize;
    procedure NewDocument;
    function GetDocHTML(aDocument: IHTMLDocument2): AnsiString;
    function LoadFromIStream(aIStream: IStream): HResult;
    function LoadFromString(aString: AnsiString): HResult;
    function GetFonts: WideString;
    function GetFontIndex: integer;
    function GetHtmlDocument: IHTMLDocument2;
    function CommandTarget: IOleCommandTarget;
    procedure CommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
    function Color2HTML(Color: TColor): AnsiString;
    function DoCommand(aCommand: TCommandId; var aIn: OleVariant; var aOut: OleVariant): boolean; overload;
    function GetMHT: AnsiString;
    procedure SetMHT(const Value: AnsiString);
  protected  // IDocHostUIHandler
    function ShowContextMenu(const dwID: DWORD; const ppt: PPOINT; const pcmdtReserved: IUnknown; const pdispReserved: IDispatch): HRESULT; stdcall;
    function GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT; stdcall;
    function ShowUI(const dwID: DWORD; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function EnableModeless(const fEnable: BOOL): HRESULT; stdcall;
    function OnDocWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function OnFrameWindowActivate(const fActivate: BOOL): HRESULT; stdcall;
    function ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT; stdcall;
    function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT; stdcall;
    function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD): HRESULT; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HRESULT; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HRESULT; stdcall;
    function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HRESULT; stdcall;
  protected // IOleControlSite
    function OnControlInfoChanged: HResult; stdcall;
    function LockInPlaceActive(fLock: BOOL): HResult; stdcall;
    function GetExtendedControl(out disp: IDispatch): HResult; stdcall;
    function TransformCoords(var ptlHimetric: TPoint; var ptfContainer: TPointF; flags: Longint): HResult; stdcall;
    function IOleControlSite.TranslateAccelerator = OleControlSite_TranslateAccelerator;
    function OleControlSite_TranslateAccelerator(msg: PMsg; grfModifiers: Longint): HResult; stdcall;
    function OnFocus(fGotFocus: BOOL): HResult; stdcall;
    function ShowPropertyFrame: HResult; stdcall;
  public
    function CommandSet(aCommand: TCommandId; var aIn: OleVariant): boolean; overload;
    function CommandSet(aCommand: TCommandId): boolean; overload;
    function CommandGet(aCommand: TCommandId): OleVariant;
    function QueryStatus(aCommand: TCommandId): TCommandFlag;
    function QueryEnabled(aCommand: TCommandId): boolean;
    function GetFontSizeIndex(const aList: WideString; var Changed: WideString): Integer;
    procedure SetFontColor(aColor: TColor);
    procedure SetFocusToDocument;
    procedure NavigateURL(const aURL: WideString);
  public
    property HTMLDocument: IHTMLDocument2 read GetHtmlDocument;
    property Fonts: WideString read GetFonts;
    property FontIndex: integer read GetFontIndex;
    property OnChange: TNotifyEvent read GetOnChange write SetOnChange;
    property OnFocused: TFocusedNotifyEvent read GetOnFocused write SetOnOnFocused;
    property HTML: AnsiString read GetHTML write SetHTML;
    property MHT: AnsiString read GetMHT write SetMHT;
    property Text: WideString read GetText write SetText;
    property DesignMode: boolean read GetDesignMode write SetDesignMode;
    property InFocus: boolean read GetInFocus;
    property DocumentEdited: Boolean read fDocumentEdited;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
  end;

  function PlainTextToHTML(const aText: WideString): AnsiString;
  function StrToHTML(const Value: AnsiString): AnsiString;

const
  CGID_MSHTML: TGUID = '{DE4BA900-59CA-11CF-9592-444553540000}';

implementation

uses
  RegularExpressions;

function GetMHTFileFromHTML(const aHTMLinUTF8: AnsiString): WideString;
var
  imsg: IMessage;
  iconf: IConfiguration;
  stream: _Stream;
  fs: TFileStream;
  htmlFile: WideString;
  body: AnsiString;
  st: _Stream;
begin
  imsg := CoMessage.Create;
  imsg.MimeFormatted := True;
  iconf := CoConfiguration.Create;
  try
    imsg.Configuration := iconf;
    htmlFile := GetTempDirectory + FormatDateTime('_hhnnss_zzz', Now) + '.html';
    Result := GetTempDirectory + FormatDateTime('_hhnnss_zzz', Now) + '.mht';
    fs := TFileStream.Create(htmlFile, fmCreate);
    try
      fs.Write(pointer(aHTMLinUTF8)^, Length(aHTMLinUTF8));
    finally
      fs.Free;
    end;
    imsg.CreateMHTMLBody(htmlFile, cdoSuppressImages, '', '');

    stream := imsg.GetStream;
    stream.SaveToFile(Result, adSaveCreateOverWrite) ;
    Exit;

    imsg.TextBodyPart.ContentTransferEncoding := 'base64';
    st := imsg.TextBodyPart.GetEncodedContentStream;
    st.SaveToFile(Result + '.body', adSaveCreateOverWrite);
    fs := TFileStream.Create(Result + '.body', fmOpenRead);
    try
      SetLength(body, fs.Size);
      fs.Read(pointer(body)^, fs.Size);
    finally
      fs.Free;
    end;
    if FileExists(Result + '.body') then
      DeleteFile(Result + '.body');
    body := DecodeBase64(body);
    imsg.TextBody := UTF8Decode(body);
    imsg.TextBodyPart.Charset := 'utf-8';
    stream := imsg.GetStream;
    stream.SaveToFile(Result, adSaveCreateOverWrite);
  finally
    imsg := nil;
    iconf := nil;
    stream := nil;
  end;
  if FileExists(htmlFile) then
    DeleteFile(htmlFile);
end;

{ TSimpleWebBrowser }

function TSimpleWebBrowser.GetHtmlDocument: IHTMLDocument2;
begin
  if (Document = nil) then
    NewDocument;
  Result := Document as IHTMLDocument2;
end;

function EnumFontsProc(var LogFont: TLogFont; var Metric: TTextMetric; FontType: Integer; Data: Pointer): Integer; stdcall;
var
  st: TStrings;
  faceName: AnsiString;
begin
  st := TStrings(Data);
  faceName := LogFont.lfFaceName;
  if ((st.Count = 0) or (AnsiCompareText(st[st.Count - 1], faceName) <> 0)) and
    (Pos('@', faceName) <> 1) then
   st.Add(faceName);
  Result := 1;
end;

function TSimpleWebBrowser.GetFonts: WideString;
var
  dc: HDC;
  lfont: TLogFont;
begin
  fNoChangeEvent := True;
try
  if (fFonts = nil) then
    begin
    fFonts := TStringList.Create;
    dc := GetDC(Self.Handle);
    try
      fFonts.Add('Default');
      FillChar(lfont, sizeof(lfont), 0);
      lfont.lfCharset := DEFAULT_CHARSET;
      EnumFontFamiliesEx(dc, lfont, @EnumFontsProc, LongInt(fFonts), 0);
      fFonts.Sorted := True;
    finally
      ReleaseDC(0, dc);
    end;
    end;
  Result := fFonts.Text;
finally
  fNoChangeEvent := True;
end;  
end;

function CoInternetSetFeatureEnabled( FeatureEntry:integer; dwFlags:cardinal;
  fEnable:boolean): HRESULT; stdcall; external 'Urlmon.dll';

procedure TSimpleWebBrowser.Initialize;
const
   FEATURE_DISABLE_NAVIGATION_SOUNDS = 21;
   SET_FEATURE_ON_PROCESS = 2;
begin
  // відключимо звук при навігації
  CoInternetSetFeatureEnabled(FEATURE_DISABLE_NAVIGATION_SOUNDS, SET_FEATURE_ON_PROCESS, true);
  GetFonts;
end;

function TSimpleWebBrowser.GetFontIndex: integer;
var
  fontName: OleVariant;
begin
  fNoChangeEvent := True;
try
  Result := -1;
  if QueryEnabled(IDM_FONTNAME) then
    begin
    fontName := CommandGet(IDM_FONTNAME);
    if VarType(fontName) = varOleStr then
      Result := fFonts.IndexOf(fontName);
    end;    
finally
  fNoChangeEvent := False;
end;
end;

function TSimpleWebBrowser.DoCommand(aCommand: TCommandId; var aIn: OleVariant;
  var aOut: OleVariant): boolean;
var
  rv: HResult;
begin
  fNoChangeEvent := True;
try
  if (aCommand <> IDM_SELECTALL) and
     (aCommand <> IDM_SETDIRTY) and
     (aCommand <> IDM_FONTNAME) and
     (aCommand <> IDM_FONTSIZE) then
    fDocumentEdited := True;
  rv := CommandTarget.Exec(@CGID_MSHTML, aCommand,
    OLECMDEXECOPT_DODEFAULT, aIn, aOut);
  Result := rv = S_OK;
finally
  fNoChangeEvent := False;
end;  
end;

function TSimpleWebBrowser.QueryEnabled(aCommand: TCommandId): boolean;
begin
  Result := (QueryStatus(aCommand) and OLECMDF_ENABLED) = OLECMDF_ENABLED;
end;

function TSimpleWebBrowser.QueryStatus(aCommand: TCommandId): TCommandFlag;
var
  cmd: OLECMD;
begin
  fNoChangeEvent := True;
try
  cmd.CmdID := aCommand;
  if S_OK = CommandTarget.QueryStatus(@CGID_MSHTML, 1, @Cmd, nil) then
    Result := Cmd.cmdf
  else
    Result := 0;
finally
  fNoChangeEvent := False;
end;
end;

function TSimpleWebBrowser.CommandTarget: IOleCommandTarget;
begin
  Result := HtmlDocument as IOleCommandTarget;
end;

constructor TSimpleWebBrowser.Create(aOwner: TComponent);
begin
  inherited;
  TWinControl(Self).Parent := aOwner as TWinControl;
  Align := alClient;
  Self.OnCommandStateChange := CommandStateChange;
  Self.OnBeforeNavigate2 := OnBeforeNavigateEvent;
  Initialize;
end;

function TSimpleWebBrowser.GetOnChange: TNotifyEvent;
begin
  Result := fOnChange;
end;

procedure TSimpleWebBrowser.SetOnChange(const Value: TNotifyEvent);
begin
  fOnChange := Value;
end;

procedure TSimpleWebBrowser.CommandStateChange(Sender: TObject;
  Command: Integer; Enable: WordBool);
begin
  if not fNoChangeEvent then
    begin
    if Assigned(fOnChange) then
      if Assigned(HtmlDocument) then
        fOnChange(Sender);
    end;
end;

const
  TAB: WideString = #9;
  CRLF: WideString = #13#10;
  DBLCRLF: WideString = #13#10#13#10;

function TSimpleWebBrowser.GetFontSizeIndex(const aList: WideString;
  var Changed: WideString): Integer;
var
  ov: OleVariant;

  function GetBaseSize: WideString;
  begin
     Result := '8  pt' + CRLF +
               '10 pt' + CRLF +
               '12 pt' + CRLF +
               '14 pt' + CRLF +
               '18 pt' + CRLF +
               '24 pt' + CRLF +
               '36 pt';
  end;
begin
  Result := -1;

  if Length(aList) = 0 then
    Changed := GetBaseSize
  else
    Changed := '';

  if not QueryEnabled(IDM_FONTSIZE) then
    Exit;

  ov := CommandGet(IDM_FONTSIZE);
  if VarType(ov) = VarInteger then
    Result := ov - 1;
end;

procedure TSimpleWebBrowser.SetFontColor(aColor: TColor);
var
  ov: OleVariant;
begin
  ov := Color2HTML(aColor);
  CommandSet(IDM_FORECOLOR, Ov);;
  SetFocusToDocument;
end;

function TSimpleWebBrowser.Color2HTML(Color: TColor): AnsiString;
var
  Step: integer;
  Step2: AnsiString;
begin
  Step := ColorToRGB(Color);
  Step2 := IntToHex(Step, 6);
  //The result will be BBGGRR but I want it RRGGBB
  Result := '#' + Copy(Step2, 5, 2) + Copy(Step2, 3, 2) + Copy(Step2, 1, 2);
end;

function TSimpleWebBrowser.EnableModeless(const fEnable: BOOL): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.FilterDataObject(const pDO: IDataObject;
  out ppDORet: IDataObject): HRESULT;
begin
  Result := S_FALSE;
end;

function TSimpleWebBrowser.GetDropTarget(const pDropTarget: IDropTarget;
  out ppDropTarget: IDropTarget): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.GetExternal(out ppDispatch: IDispatch): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.GetHostInfo(var pInfo: TDOCHOSTUIINFO): HRESULT;
begin
 with pInfo do
   dwFlags := dwFlags or
     DOCHOSTUIFLAG_DISABLE_SCRIPT_INACTIVE or
     DOCHOSTUIFLAG_FLAT_SCROLLBAR;
  Result := S_OK;
end;

function TSimpleWebBrowser.GetOptionKeyPath(var pchKey: POLESTR;
  const dw: DWORD): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.HideUI: HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.OnDocWindowActivate(
  const fActivate: BOOL): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.OnFrameWindowActivate(
  const fActivate: BOOL): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.ResizeBorder(const prcBorder: PRECT;
  const pUIWindow: IOleInPlaceUIWindow; const fRameWindow: BOOL): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.ShowContextMenu(const dwID: DWORD;
  const ppt: PPOINT; const pcmdtReserved: IInterface;
  const pdispReserved: IDispatch): HRESULT;
begin
  if Assigned(PopupMenu) then
    begin
    if DesignMode then
      PopupMenu.Popup(ppt.X, ppt.Y);
    Result := S_OK;
    end
  else
    Result :=  S_FALSE;
end;

function TSimpleWebBrowser.ShowUI(const dwID: DWORD;
  const pActiveObject: IOleInPlaceActiveObject;
  const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
  const pDoc: IOleInPlaceUIWindow): HRESULT;
begin
  Result := S_FALSE;
end;

function TSimpleWebBrowser.TranslateAccelerator(const lpMsg: PMSG;
  const pguidCmdGroup: PGUID; const nCmdID: DWORD): HRESULT;
begin
  fDocumentEdited := True;
  Result := S_FALSE;
end;

function TSimpleWebBrowser.TranslateUrl(const dwTranslate: DWORD;
  const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HRESULT;
begin
  Result := S_FALSE;
end;

function TSimpleWebBrowser.UpdateUI: HRESULT;
begin
  Result := S_OK;
end;

procedure TSimpleWebBrowser.SetFocusToDocument;
begin
 if Assigned(HtmlDocument) and Showing then
   with Self.Application as IOleobject do
       DoVerb(OLEIVERB_UIACTIVATE, nil, Self as IOleClientSite, 0, Handle,
         GetClientRect);
end;

function TSimpleWebBrowser.CommandGet(aCommand: TCommandId): OleVariant;
begin
  DoCommand(aCommand, POleVariant(nil)^, Result);
end;

function TSimpleWebBrowser.CommandSet(aCommand: TCommandId;
  var aIn: OleVariant): boolean;
begin
  Result := DoCommand(aCommand, aIn, POleVariant(nil)^);
end;

function TSimpleWebBrowser.CommandSet(aCommand: TCommandId): boolean;
begin
  Result := DoCommand(aCommand, POleVariant(nil)^, POleVariant(nil)^);
  SetFocusToDocument;
end;

function TSimpleWebBrowser.GetExtendedControl(out disp: IDispatch): HResult;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.LockInPlaceActive(fLock: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.OleControlSite_TranslateAccelerator(msg: PMsg;
  grfModifiers: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.OnControlInfoChanged: HResult;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.OnFocus(fGotFocus: BOOL): HResult;
begin
  fInFocus := fGotFocus;
  if fGotFocus then
    begin
    SetFocusToDocument;
    if Showing then
      begin
      SetFocus;
      if Assigned(fOnFocused) then
        fOnFocused(Self, True);
      end;
    end
  else
    if Assigned(fOnFocused) then
      fOnFocused(Self, False);
  Result := S_OK;
end;

function TSimpleWebBrowser.ShowPropertyFrame: HResult;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.TransformCoords(var ptlHimetric: TPoint;
  var ptfContainer: TPointF; flags: Integer): HResult;
begin
  Result := E_NOTIMPL;
end;

function TSimpleWebBrowser.GetHTML: AnsiString;
begin
  if HTMLDocument = nil then
    Result := ''
  else
    Result := GetDocHTML(HTMLDocument);
end;

function TSimpleWebBrowser.GetText: WideString;
const
  cTag = '(<[^>]*>)|(&nbsp;)';
var
  html: WideString;
begin
  html := UTF8Decode(GetHTML);
  html := TRegEx.Replace(html, cTag, '');
  Result := Trim(html);
end;

procedure TSimpleWebBrowser.SetHTML(const Value: AnsiString);
var
  ov: OleVariant;
begin
  if Value = '' then
    (*LoadFromString(
      '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"> ' +
      '<HTML><HEAD>' +
      '<META http-equiv=Content-Type content="text/html; charset=utf-8">' +
      '<META content="MSHTML 6.00.6000.20935" name=GENERATOR></HEAD>' +
      '<BODY></BODY></HTML>')(*)
    NewDocument
  else
    begin
    LoadFromString(Value);
    ov := True;
    CommandSet(IDM_SETDIRTY, ov);
    DesignMode := True;
    end;
end;

procedure TSimpleWebBrowser.SetMHT(const Value: AnsiString);
begin
  //
end;

function StrToHTML(const Value: AnsiString): AnsiString;
var
  First, PC: PChar;
  Buf, Sufix: AnsiString;
begin
  Result:='';
  if Value = '' then
    Exit;
  PC := PChar(Value);
  First := PC;
  repeat
    case PC^ of
      #0: Break;
      '&': Sufix:='&amp;';
      '"': Sufix:='&quot;';
      '<': Sufix:='&lt;';
      '>': Sufix:='&gt;';
    else
      Inc(PC);
      Continue;
    end;
    SetString(Buf, First, PC - First);
    Result := Result + Buf + Sufix;
    Inc(PC);
    First := PC;
  until False;
  Result := Result + First;
end;

function PlainTextToHTML(const aText: WideString): AnsiString;
begin
  Result := StrToHTML(aText);
  Result := StringReplace(Result, TAB + CRLF, '<p>', [rfReplaceAll]);
  Result := StringReplace(Result, CRLF, '<br>', [rfReplaceAll]);
  Result := '<html><body>' + Result + '</body></html>';
end;

procedure TSimpleWebBrowser.SetText(const Value: WideString);
var
  v: Variant;
begin
  v := VarArrayCreate([0, 0], VarVariant);
  v[0] := PlainTextToHTML(Value);
  HTMLDocument.Write(PSafeArray(System.TVarData(v).VArray));
  HTMLDocument.Close;
end;

function TSimpleWebBrowser.GetDocHTML(aDocument: IHTMLDocument2): AnsiString;
var
  stream: TStringStream;
begin
  if aDocument = nil then
    Result := ''
  else
    begin
    aDocument.charset := 'utf-8';
    aDocument.defaultCharset := 'utf-8';
    stream := TStringStream.Create('');
    try
      if (aDocument as IPersistStreamInit).Save(TStreamAdapter.Create(stream), False) = S_OK then
        begin
        if stream.Size = 0 then
          begin
          Result := '';
          Exit;
          end;
        Result := stream.DataString;
        while Result[1] <> '<' do
          if Length(Result) > 0  then
            Delete(Result, 1, 1);
        end;
    finally
      stream.free;
    end;
    end;
end;

function TSimpleWebBrowser.LoadFromString(aString: AnsiString): HResult;
var
  handle: THandle;
  stream: IStream;
  len: integer;
begin
  len := Length(aString) + 1;
  handle := GlobalAlloc(GPTR, len);
  try
    if handle <> 0 then
      begin
      Move(aString[1], PChar(handle)^, len);
      CreateStreamOnHGlobal(handle, False, stream);
      Result := LoadFromIStream(stream);
      end
    else
      Result := S_FALSE;
  finally
    GlobalFree(handle);
  end;
end;

function TSimpleWebBrowser.LoadFromIStream(aIStream: IStream): HResult;
begin
  Result := (HTMLDocument as IPersistStreamInit).Load(aIStream);
  while (ReadyState <> READYSTATE_COMPLETE) do
    Forms.Application.ProcessMessages;
  fDocumentEdited := False;  
end;

procedure TSimpleWebBrowser.NavigateURL(const aURL: WideString);
begin
  fNoChangeEvent := True;
  try
    HandleNeeded;
    Navigate(aURL);
    while (ReadyState <> READYSTATE_COMPLETE) do
      Forms.Application.ProcessMessages;
  finally
    fNoChangeEvent := False;
  end;
end;

procedure TSimpleWebBrowser.NewDocument;
begin
  fNoChangeEvent := True;
  try
    DesignMode := False;
    HandleNeeded;
    Navigate('about:blank');
    while (ReadyState <> READYSTATE_COMPLETE) do
      Forms.Application.ProcessMessages;
    DesignMode := True;
    fDocumentEdited := False;
  finally
    fNoChangeEvent := False;
  end;
end;

function TSimpleWebBrowser.GetDesignMode: boolean;
begin
  Result := WideSameText(HTMLDocument.designMode, 'on');
end;

procedure TSimpleWebBrowser.SetDesignMode(const Value: boolean);
begin
  if Assigned(Document) then
    if Value then
      HtmlDocument.designMode := 'on'
    else
      HtmlDocument.designMode := 'off';
end;

function TSimpleWebBrowser.GetOnFocused: TFocusedNotifyEvent;
begin
  Result := fOnFocused;
end;

procedure TSimpleWebBrowser.SetOnOnFocused(const Value: TFocusedNotifyEvent);
begin
  fOnFocused := Value;
end;

destructor TSimpleWebBrowser.Destroy;
begin
  FreeAndNil(fFonts);
  fOnChange := nil;
  fOnFocused := nil;
  inherited;
end;

function TSimpleWebBrowser.GetInFocus: boolean;
begin
  Result := fInFocus;
end;

function TSimpleWebBrowser.GetMHT: AnsiString;
begin
  Result := GetMHTFileFromHTML(HTML);
end;

procedure TSimpleWebBrowser.OnBeforeNavigateEvent(ASender: TObject; const pDisp: IDispatch;
                                                           const URL: OleVariant;
                                                           const Flags: OleVariant;
                                                           const TargetFrameName: OleVariant;
                                                           const PostData: OleVariant;
                                                           const Headers: OleVariant;
                                                           var Cancel: WordBool);
begin
  if URL <> 'about:blank' then
    Cancel := True;
end;

end.


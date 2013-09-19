unit uHTMLEditFrame;

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
  Dialogs,
  uSimpleWebBrowser,
  ComCtrls,
  ToolWin,
  IeConst,
  ActiveX,
  MSHTML_TLB,
  SHDocVw_TLB,
  StdCtrls,
  ClipBrd,
  ExtActns,
  StdActns,
  ActnList,
  ImgList,
  Menus,
  ActnMan,
  ActnColorMaps,
  uSynapse,
  uUtils,
  uCorePath,
  OverbyteIcsMD5,
  OverbyteIcsUrl;

type
  TFrameHTMLEdit = class(TFrame)
    ToolBar: TToolBar;
    ButtonItalic: TToolButton;
    ButtonBold: TToolButton;
    ComboBoxFontSize: TComboBox;
    ComboBoxFonts: TComboBox;
    ButtonUnderline: TToolButton;
    ButtonColor: TToolButton;
    ButtonNumericBullets: TToolButton;
    ButtonBullets: TToolButton;
    ButtonOutdent: TToolButton;
    ButtonIndent: TToolButton;
    ButtonLeft: TToolButton;
    ButtonCenter: TToolButton;
    ButtonRight: TToolButton;
    ButtonLink: TToolButton;
    ButtonImage: TToolButton;
    ButtonLine: TToolButton;
    ActionList: TActionList;
    EditDelete: TEditDelete;
    EditUndo: TEditUndo;
    EditSelectAll: TEditSelectAll;
    EditPaste: TEditPaste;
    EditCopy: TEditCopy;
    EditCut: TEditCut;
    AlignCenter: TRichEditAlignCenter;
    AlignRight: TRichEditAlignRight;
    AlignLeft: TRichEditAlignLeft;
    Bullets: TRichEditBullets;
    TextColor: TRichEditStrikeOut;
    Underline: TRichEditUnderline;
    Italic: TRichEditItalic;
    Bold: TRichEditBold;
    ImageList: TImageList;
    NumericBullets: TAction;
    TextIndext: TAction;
    TextUniindent: TAction;
    InsertLine: TAction;
    InsertLink: TAction;
    InsertImage: TAction;
    EditRedo: TAction;
    PopupMenu: TPopupMenu;
    Copy: TMenuItem;
    Cut: TMenuItem;
    Paste: TMenuItem;
    Redo: TMenuItem;
    Undo: TMenuItem;
    SelectAll: TMenuItem;
    ColorDialog: TColorDialog;
    procedure ToolBarEnter(Sender: TObject);
    procedure ToolBarExit(Sender: TObject);
    procedure ComboBoxFontsChange(Sender: TObject);
    procedure BoldExecute(Sender: TObject);
    procedure ItalicExecute(Sender: TObject);
    procedure UnderlineExecute(Sender: TObject);
    procedure NumericBulletsExecute(Sender: TObject);
    procedure BulletsExecute(Sender: TObject);
    procedure TextUniindentExecute(Sender: TObject);
    procedure TextIndextExecute(Sender: TObject);
    procedure AlignLeftExecute(Sender: TObject);
    procedure AlignCenterExecute(Sender: TObject);
    procedure AlignRightExecute(Sender: TObject);
    procedure InsertLineExecute(Sender: TObject);
    procedure InsertLinkExecute(Sender: TObject);
    procedure InsertImageExecute(Sender: TObject);
    procedure EditUndoExecute(Sender: TObject);
    procedure EditRedoExecute(Sender: TObject);
    procedure EditCutExecute(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure EditPasteExecute(Sender: TObject);
    procedure ComboBoxFontSizeChange(Sender: TObject);
    procedure EditSelectAllExecute(Sender: TObject);
    procedure TextColorExecute(Sender: TObject);
    private
      fWebBrowser: TSimpleWebBrowser;
      fBrowserFocused: boolean;
      fToolbarFocused: boolean;
      fOnFocusChange: TFocusedNotifyEvent;
      fDesignMode: Boolean;
    private
      procedure _OnStateChange(Sender: TObject);
      procedure _OnFocusChange(Sender: TObject; aFocused: boolean);
      procedure Initialize;
      procedure UpdateControls;
      procedure UpdateFocus;
      function GetDesignMode: boolean;
      function GetHTML: AnsiString;
      function GetInFocus: boolean;
      function GetText: WideString;
      function GetToolbarEnabled: boolean;
      procedure SetDesignMode(const Value: boolean);
      procedure SetHTML(const Value: AnsiString);
      procedure SetText(const Value: WideString);
      procedure SetToolbarEnabled(const Value: boolean);
      function PackPictures(const aHTML: AnsiString): AnsiString;
      function UnpackPictures(const aHTML: AnsiString): AnsiString;
      function GetTempFilePath(aFileName: WideString): WideString;
      procedure WriteDataToFile(const aData: AnsiString; const aFileName: WideString);
      function ReadDataFromFile(const aFileName: WideString): AnsiString;
      function GetDocumentEdited: Boolean;
    public
      property HTML: AnsiString read GetHTML write SetHTML;
      property Text: WideString read GetText write SetText;
      property ToolbarEnabled: boolean read GetToolbarEnabled write SetToolbarEnabled;
      property DesignMode: boolean read GetDesignMode write SetDesignMode;
      property OnFocusChange: TFocusedNotifyEvent read fOnFocusChange write fOnFocusChange;
      property InFocus: boolean read GetInFocus;
      property DocumentEdited: Boolean read GetDocumentEdited;
    public
      procedure SaveToStream(aStream: TStream);
      procedure LoadFromStream(aStream: TStream);
      procedure InsertText(const aText: WideString);
      procedure Navigate(const aURL: WideString);
    public
      constructor Create(AOwner: TComponent);
      destructor Destroy; override;
  end;

implementation

uses
  RegularExpressions;

{$R *.DFM}

const
  cTempDirName = '\HTMLFrameData';

  { TFrameHTMLEdit }

procedure TFrameHTMLEdit.BulletsExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_UNORDERLIST);
end;

procedure TFrameHTMLEdit.ComboBoxFontsChange(Sender: TObject);
var
  ov: OleVariant;
begin
  ov := ComboBoxFonts.Text;
  fWebBrowser.CommandSet(IDM_FONTNAME, ov);
end;

procedure TFrameHTMLEdit.ComboBoxFontSizeChange(Sender: TObject);
var
  ov: OleVariant;
begin
  ov := ComboBoxFontSize.ItemIndex + 1;
  fWebBrowser.CommandSet(IDM_FONTSIZE, ov);
end;

constructor TFrameHTMLEdit.Create(Aowner: TComponent);
begin
  inherited;
  fWebBrowser := TSimpleWebBrowser.Create(Self);
  fWebBrowser.OnChange := _OnStateChange;
  fWebBrowser.OnFocused := _OnFocusChange;
  fWebBrowser.PopupMenu := PopupMenu;
  fWebBrowser.TabStop := True;
  Initialize;
end;

destructor TFrameHTMLEdit.Destroy;
begin
  FreeAndNil(fWebBrowser);
  inherited;
end;

procedure TFrameHTMLEdit.EditCopyExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_COPY);
end;

procedure TFrameHTMLEdit.EditCutExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_CUT);
end;

procedure TFrameHTMLEdit.EditPasteExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_PASTE);
end;

procedure TFrameHTMLEdit.EditRedoExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_REDO);
end;

procedure TFrameHTMLEdit.EditSelectAllExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_SELECTALL);
end;

procedure TFrameHTMLEdit.EditUndoExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_UNDO);
end;

function TFrameHTMLEdit.GetDesignMode: boolean;
begin
  Result := fDesignMode;
end;

function TFrameHTMLEdit.GetDocumentEdited: Boolean;
begin
  Result := fWebBrowser.DocumentEdited;
end;

function TFrameHTMLEdit.GetHTML: AnsiString;
begin
  Result := PackPictures(fWebBrowser.HTML);
end;

function TFrameHTMLEdit.GetInFocus: boolean;
begin
  Result := fBrowserFocused or fToolbarFocused;
end;

function TFrameHTMLEdit.GetTempFilePath(aFileName: WideString): WideString;
var
  tempDir: WideString;
begin
  tempDir := GetTempDirectory + cTempDirName;
  Result := tempDir + '\' + StrMD5(aFileName);
  if not DirectoryExists(tempDir) then
    ForceDirectories(tempDir);
end;

function TFrameHTMLEdit.GetText: WideString;
begin
  Result := fWebBrowser.Text;
end;

function TFrameHTMLEdit.GetToolbarEnabled: boolean;
begin
  Result := Toolbar.Enabled;
end;

procedure TFrameHTMLEdit.Initialize;
begin
  ComboBoxFonts.Items.Text := fWebBrowser.Fonts;
end;

procedure TFrameHTMLEdit.InsertImageExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_IMAGE);
end;

procedure TFrameHTMLEdit.InsertLineExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_HORIZONTALLINE);
end;

procedure TFrameHTMLEdit.InsertLinkExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_HYPERLINK);
end;

procedure TFrameHTMLEdit.InsertText(const aText: WideString);
begin
  Clipboard.AsText := aText;
  fWebBrowser.CommandSet(IDM_PASTE);
end;

procedure TFrameHTMLEdit.ItalicExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_ITALIC);
end;

procedure TFrameHTMLEdit.LoadFromStream(aStream: TStream);
var
  buff: AnsiString;
begin
  SetLength(buff, aStream.Size);
  aStream.Position := 0;
  aStream.Read(Pointer(buff)^, aStream.Size);
  aStream.Position := 0;
  HTML := buff;
  SetLength(buff, 0);
end;

procedure TFrameHTMLEdit.Navigate(const aURL: WideString);
begin
  fWebBrowser.NavigateURL(aURL);
end;

procedure TFrameHTMLEdit.NumericBulletsExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_ORDERLIST);
end;

function TFrameHTMLEdit.PackPictures(const aHTML: AnsiString): AnsiString;
const
  cFindSrc = 'src="(.*?)"';
var
  regExpr: TRegEx;
  fileName, fileType: AnsiString;
  dataURL: AnsiString;
  match: TMatch;
begin
  Result := aHTML;
  regExpr := TRegEx.Create(cFindSrc);
  for match in regExpr.Matches(aHTML) do
  begin
    fileName := match.Groups.Item[1].Value;
    if Pos('http://', fileName) <> 1 then
    begin
      fileType := ExtractFileExt(fileName);
      Delete(fileType, 1, 1);
      dataURL := 'data:image/' + fileType + ';base64,' + EncodeBase64(ReadDataFromFile(URLDecode(fileName)));
      Result := StringReplace(Result, fileName, dataURL, [rfReplaceAll])
    end;
  end;
end;

function TFrameHTMLEdit.ReadDataFromFile(const aFileName: WideString): AnsiString;
const
  fileProto: WideString = 'file:///';
var
  fileStream: TFileStream;
  fileName: WideString;
begin
  Result := '';
  fileName := aFileName;
  if not FileExists(aFileName) then
  begin
    // спробуємо прибрати протокол з урла і замінити слеші на бекслеші
    if Pos(fileProto, fileName) = 1 then
      Delete(fileName, 1, Length(fileProto));
    fileName := StringReplace(fileName, '/', '\', [rfReplaceAll]);
    if not FileExists(fileName) then
      Exit;
  end;

  fileStream := TFileStream.Create(fileName, fmOpenRead);
  try
    SetLength(Result, fileStream.Size);
    fileStream.Read(Pointer(Result)^, fileStream.Size);
  finally
    fileStream.Free;
  end;
end;

procedure TFrameHTMLEdit.AlignCenterExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_JUSTIFYCENTER);
end;

procedure TFrameHTMLEdit.AlignLeftExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_JUSTIFYLEFT);
end;

procedure TFrameHTMLEdit.AlignRightExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_JUSTIFYRIGHT);
end;

procedure TFrameHTMLEdit.BoldExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_BOLD);
end;

procedure TFrameHTMLEdit.SaveToStream(aStream: TStream);
var
  buff: AnsiString;
begin
  buff := HTML;
  aStream.Position := 0;
  aStream.Write(Pointer(buff)^, Length(buff));
  aStream.Position := 0;
end;

procedure TFrameHTMLEdit.SetDesignMode(const Value: boolean);
begin
  fDesignMode := Value;
  fWebBrowser.DesignMode := fDesignMode;
  Toolbar.Visible := fDesignMode;
end;

procedure TFrameHTMLEdit.SetHTML(const Value: AnsiString);
begin
  fWebBrowser.DesignMode := True;
  fWebBrowser.HTML := UnpackPictures(Value);
  fWebBrowser.DesignMode := fDesignMode;
end;

procedure TFrameHTMLEdit.SetText(const Value: WideString);
begin
  fWebBrowser.DesignMode := True;
  fWebBrowser.Text := Value;
  fWebBrowser.DesignMode := fDesignMode;
end;

procedure TFrameHTMLEdit.SetToolbarEnabled(const Value: boolean);
begin
  Toolbar.Enabled := Value;
end;

procedure TFrameHTMLEdit.TextColorExecute(Sender: TObject);
begin
  if ColorDialog.Execute(Self.Handle) then
    fWebBrowser.SetFontColor(ColorDialog.Color);
end;

procedure TFrameHTMLEdit.TextIndextExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_INDENT);
end;

procedure TFrameHTMLEdit.TextUniindentExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_OUTDENT);
end;

procedure TFrameHTMLEdit.ToolBarEnter(Sender: TObject);
var
  old, new: boolean;
begin
  old := InFocus;
  fToolbarFocused := True;
  new := InFocus;
  if old <> new then
    UpdateFocus;
end;

procedure TFrameHTMLEdit.ToolBarExit(Sender: TObject);
var
  old, new: boolean;
begin
  old := InFocus;
  fToolbarFocused := False;
  new := InFocus;
  if old <> new then
    UpdateFocus;
end;

procedure TFrameHTMLEdit.UnderlineExecute(Sender: TObject);
begin
  fWebBrowser.CommandSet(IDM_UNDERLINE);
end;

function TFrameHTMLEdit.UnpackPictures(const aHTML: AnsiString): AnsiString;
const
  cFindSrc = 'src="(data:image/(...);base64,(.*?))"';
var
  regExpr: TRegEx;
  fileName: string;
  data, url: AnsiString;
  match: TMatch;
begin
  Result := aHTML;
  regExpr := TRegEx.Create(cFindSrc);
  for match in regExpr.Matches(aHTML) do
  begin
    url := match.Groups[1].Value;
    data := match.Groups[3].Value;
    fileName := GetTempFilePath(url) + '.' + match.Groups[2].Value;
    if not FileExists(fileName) then
      WriteDataToFile(DecodeBase64(data), fileName);
    data := UTF8EncodeToShortString(fileName);
    Result := StringReplace(Result, url, data, [rfReplaceAll])
  end;
end;

procedure TFrameHTMLEdit.UpdateControls;
var
  index: integer;
  s: WideString;

procedure ButtonQueryStatus(cmdID: Cardinal; aButon: TToolButton);
var
  dwStatus: OLECMDF;
begin
  dwStatus := fWebBrowser.QueryStatus(cmdID);
  aButon.Enabled := ((dwStatus and OLECMDF_ENABLED) <> 0) and InFocus;
  aButon.Down := (dwStatus and OLECMDF_LATCHED) <> 0;
end;

procedure MenuItemQueryStatus(cmdID: Cardinal; aItem: TMenuItem);
var
  dwStatus: OLECMDF;
begin
  dwStatus := fWebBrowser.QueryStatus(cmdID);
  aItem.Enabled := ((dwStatus and OLECMDF_ENABLED) <> 0) and InFocus;
end;

begin
  ButtonQueryStatus(IDM_BOLD, ButtonBold);
  ButtonQueryStatus(IDM_ITALIC, ButtonItalic);
  ButtonQueryStatus(IDM_UNDERLINE, ButtonUnderline);
  ButtonQueryStatus(IDM_FORECOLOR, ButtonColor);

  ButtonQueryStatus(IDM_ORDERLIST, ButtonNumericBullets);
  ButtonQueryStatus(IDM_UNORDERLIST, ButtonBullets);
  ButtonQueryStatus(IDM_OUTDENT, ButtonOutdent);
  ButtonQueryStatus(IDM_INDENT, ButtonIndent);

  ButtonQueryStatus(IDM_JUSTIFYLEFT, ButtonLeft);
  ButtonQueryStatus(IDM_JUSTIFYCENTER, ButtonCenter);
  ButtonQueryStatus(IDM_JUSTIFYRIGHT, ButtonRight);

  ButtonQueryStatus(IDM_HYPERLINK, ButtonLink);
  ButtonLink.Enabled := InFocus;
  ButtonQueryStatus(IDM_IMAGE, ButtonImage);
  ButtonQueryStatus(IDM_HORIZONTALLINE, ButtonLine);

  MenuItemQueryStatus(IDM_CUT, Cut);
  MenuItemQueryStatus(IDM_COPY, Copy);
  MenuItemQueryStatus(IDM_PASTE, Paste);
  MenuItemQueryStatus(IDM_REDO, Redo);
  MenuItemQueryStatus(IDM_UNDO, Undo);
  MenuItemQueryStatus(IDM_SELECTALL, SelectAll);

  ComboBoxFonts.ItemIndex := fWebBrowser.FontIndex;

  ComboBoxFontSize.ItemIndex := fWebBrowser.GetFontSizeIndex(ComboBoxFontSize.Text, s);
  if Length(S) > 0 then
  begin
    index := ComboBoxFontSize.ItemIndex;
    ComboBoxFontSize.Items.Text := s;
    ComboBoxFontSize.ItemIndex := index;
  end;
end;

procedure TFrameHTMLEdit.UpdateFocus;
var
  i: integer;
begin
  for i := 0 to Toolbar.ButtonCount - 1 do
    Toolbar.Buttons[i].Enabled := InFocus;
  ComboBoxFonts.Enabled := InFocus;
  ComboBoxFontSize.Enabled := InFocus;
  if Assigned(fOnFocusChange) then
    fOnFocusChange(Self, InFocus);
end;

procedure TFrameHTMLEdit.WriteDataToFile(const aData: AnsiString; const aFileName: WideString);
var
  fileStream: TFileStream;
begin
  fileStream := TFileStream.Create(aFileName, fmCreate);
  try
    fileStream.Write(Pointer(aData)^, Length(aData));
  finally
    fileStream.Free;
  end;
end;

procedure TFrameHTMLEdit._OnFocusChange(Sender: TObject; aFocused: boolean);
var
  old, new: boolean;
begin
  if fBrowserFocused <> aFocused then
  begin
    old := InFocus;
    fBrowserFocused := aFocused;
    new := InFocus;
    if old <> new then
      UpdateFocus;
  end;
end;

procedure TFrameHTMLEdit._OnStateChange(Sender: TObject);
begin
  UpdateControls;
end;

end.

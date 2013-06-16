unit uGroupForm;

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
  StdCtrls,
  ExtCtrls,
  Buttons,
  ImgList,
  uRemotable;

type

  TLoginState = (lsNo, lsNoChecked, lsOK, lsFail);

  TGroupForm = class(TForm)
    PanelMain: TPanel;
    LabeledEditDescription: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    LabeledEditName: TEdit;
    ImageList: TImageList;
    ButtonCheckLogin: TImage;
    Label5: TLabel;
    PanelBottom: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    LabelError: TLabel;
    procedure FormShow(Sender: TObject);
    procedure LabeledEditLoginChange(Sender: TObject);
    procedure LabeledEditNameChange(Sender: TObject);
    procedure ButtonCheckLoginClick(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure LabeledEditDescriptionChange(Sender: TObject);
    private
      procedure SetLoginState(aState: TLoginState);
      procedure CheckValues;
      procedure SetPicture(aButton: TImage; aPictureNumber: Integer);
      function CheckName(aName: WideString): Boolean;
      function IsDataChanged: Boolean;
    public
      Host: string;
      Account: TAccount;
      Group: TGroup;
  end;

implementation

uses
  uInterfaces,
  uFactories,
 // uUtils,
  uTexts,
  uMainUnit;

{$R *.dfm}
{ TStudentForm }

function TGroupForm.CheckName(aName: WideString): Boolean;
var
  splash: ISplash;
  groups: TGroups;
begin
  splash := Dialog.NewSplash(Self);
  splash.ShowSplash(cCheckTitleUnical);
  try
    groups := Remotable.Administrator.GroupGet(Account);
    Result := Length(groups) = 0;
  finally
    splash.HideSplash;
  end;
end;

procedure TGroupForm.CheckValues;
var
  ok: boolean;
  message: WideString;
begin
  ok := True;
  if LabeledEditName.Text = '' then
  begin
    message := cEmptyTitle;
    ok := False;
  end;
  BitBtnOk.Enabled := ok;
  if not ok then
    LabelError.Caption := message
  else
    LabelError.Caption := '';
end;

function TGroupForm.IsDataChanged: Boolean;
begin
  if Group.Name <> '' then
    Result := (Group.Name <> LabeledEditName.Text) or (Group.Description <> LabeledEditDescription.Text)
  else
    Result := ('' <> LabeledEditName.Text) or ('' <> LabeledEditDescription.Text);
end;

procedure TGroupForm.LabeledEditDescriptionChange(Sender: TObject);
begin
  CheckValues;
end;

procedure TGroupForm.LabeledEditLoginChange(Sender: TObject);
begin
  if Trim(LabeledEditName.Text) <> '' then
    SetLoginState(lsNoChecked)
  else
    SetLoginState(lsNo);
  CheckValues;
end;

procedure TGroupForm.LabeledEditNameChange(Sender: TObject);
begin
  if Trim(LabeledEditName.Text) <> '' then
    SetLoginState(lsNoChecked)
  else
    SetLoginState(lsNo);
  CheckValues;
end;

procedure TGroupForm.SetLoginState(aState: TLoginState);
begin
  case aState of
    lsNo:
      begin
        SetPicture(ButtonCheckLogin, 0);
        ButtonCheckLogin.Hint := '';
        ButtonCheckLogin.Enabled := False;
      end;
    lsNoChecked:
      begin
        SetPicture(ButtonCheckLogin, 1);
        ButtonCheckLogin.Hint := cCheckTitleAvailable;
        ButtonCheckLogin.Enabled := True;
      end;
    lsOK:
      begin
        SetPicture(ButtonCheckLogin, 2);
        ButtonCheckLogin.Hint := cTitleUnical;
        ButtonCheckLogin.Enabled := False;
      end;
    lsFail:
      begin
        SetPicture(ButtonCheckLogin, 3);
        ButtonCheckLogin.Hint := cGroupAlreadyExists;
        ButtonCheckLogin.Enabled := False;
      end;
  end;
end;

procedure TGroupForm.SetPicture(aButton: TImage; aPictureNumber: Integer);
var
  btm: TBitmap;
begin
  btm := TBitmap.Create;
  try
    ImageList.GetBitmap(aPictureNumber, btm);
    btm.TransparentColor := clWhite;
    aButton.Picture.Bitmap := btm;
    aButton.Transparent := True;
  finally
    btm.Free;
  end;
end;

procedure TGroupForm.FormShow(Sender: TObject);
begin
  LabeledEditName.Text := Group.Name;
  LabeledEditDescription.Text := Group.Description;
  if Group.Name <> '' then
    SetLoginState(lsOK)
  else
    SetLoginState(lsNo);
  CheckValues;
end;

procedure TGroupForm.BitBtnOkClick(Sender: TObject);
var
  splash: ISplash;
begin
  if not IsDataChanged then
  begin
    ModalResult := mrCancel;
    Exit;
  end;
  splash := Dialog.NewSplash(Self);
  splash.ShowSplash(cAddGroup);
  try
    try
      if Group.Id = 0 then
        Remotable.Administrator.GroupAdd(Account, group)
      else
      begin
        Group.name := LabeledEditName.Text;
        Group.Description := LabeledEditDescription.Text;
        Remotable.Administrator.GroupEdit(Account, group);
      end;
    except
      on E: ERemotableError do
      begin
        ModalResult := mrCancel;
        Dialog.ShowWarningMessage(E.Message);
        Exit;
      end;
    end;
    ModalResult := mrOk;
  finally
    splash.HideSplash;
  end;
end;

procedure TGroupForm.ButtonCheckLoginClick(Sender: TObject);
begin
  if CheckName(LabeledEditName.Text) then
    SetLoginState(lsOK)
  else
    SetLoginState(lsFail);
end;

end.

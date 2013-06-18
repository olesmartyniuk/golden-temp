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

  TGroupForm = class(TForm)
    PanelMain: TPanel;
    LabeledEditDescription: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    LabeledEditName: TEdit;
    ImageList: TImageList;
    Label5: TLabel;
    PanelBottom: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    LabelError: TLabel;
    procedure FormShow(Sender: TObject);
    procedure LabeledEditLoginChange(Sender: TObject);
    procedure LabeledEditNameChange(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
    procedure LabeledEditDescriptionChange(Sender: TObject);
    private
      procedure CheckValues;
      function IsDataChanged: Boolean;
    public
      Group: TGroup;
  end;

implementation

uses
  uInterfaces,
  uFactories,
  uTexts,
  uMainUnit;

{$R *.dfm}

procedure TGroupForm.CheckValues;
var
  ok: boolean;
  message: string;
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
  CheckValues;
end;

procedure TGroupForm.LabeledEditNameChange(Sender: TObject);
begin
  CheckValues;
end;

procedure TGroupForm.FormShow(Sender: TObject);
begin
  LabeledEditName.Text := Group.Name;
  LabeledEditDescription.Text := Group.Description;
  CheckValues;
end;

procedure TGroupForm.BitBtnOkClick(Sender: TObject);
var
  splash: ISplash;
  grp: TGroup;
  server: IAdministrator;
begin
  if not IsDataChanged then
  begin
    ModalResult := mrCancel;
    Exit;
  end;

  try
    grp := TGroup.Create;
    grp.CopyFrom(Group);
    grp.Name := LabeledEditName.Text;
    grp.Description := LabeledEditDescription.Text;
    splash := Dialog.NewSplash(Self);
    splash.ShowSplash(cAddGroup);
    try
      server := Remotable.NewAdministrator();
      if grp.Id = 0 then
        grp.Id := server.GroupAdd(Remotable.Account, grp)
      else
        server.GroupEdit(Remotable.Account, grp);
    finally
      splash.HideSplash;
    end;
    Group.CopyFrom(grp);
  except
    on E: ERemotableError do
    begin
      ModalResult := mrNone;
      Dialog.ShowWarningMessage(E.Message, Self);
      Exit;
    end;
  end;
  ModalResult := mrOk;
end;

end.

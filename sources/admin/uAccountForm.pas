unit uAccountForm;

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
  uRemotable;

type
  TAccountForm = class(TForm)
    PanelMain: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditHost: TEdit;
    EditLogin: TEdit;
    EditPassword: TEdit;
    CheckBoxSavePassword: TCheckBox;
    Label5: TLabel;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    procedure Label5Click(Sender: TObject);
    private
      FAccount: TAccount;
    private
      function GetAccount: TAccount;
      procedure SetAccount(const Value: TAccount);
      { Private declarations }
    public
      property Account: TAccount read GetAccount write SetAccount;
  end;

implementation

uses
  uChangePasswordForm,
  uInterfaces,
  uFactories,
  uUtils,
  uMainUnit;

{$R *.DFM}

function TAccountForm.GetAccount: TAccount;
begin
  Result := FAccount;
end;

procedure TAccountForm.Label5Click(Sender: TObject);
var
  form: TPasswordForm;
  newPassword, oldPassword: WideString;
  splash: ISplash;
begin
{  form := TPasswordForm.Create(Self);
  try
    form.OldPassword := Account.Password;
    if form.ShowModal = mrCancel then
      Exit;
    oldPassword := form.LabeledEditOld.Text;
    newPassword := form.LabeledEditNew.Text;
  finally
    form.Free;
  end;

  splash := Dialog.NewSplash(Self);
  splash.ShowSplash(cMessPasswordChange);
  try
    Remotable.Administrator.PasswordEdit(Account, newPassword);
  finally
    splash.HideSplash;
  end;
}
end;

procedure TAccountForm.SetAccount(const Value: TAccount);
begin
  FAccount := Value;
  EditLogin.Text := FAccount.Login;
  EditPassword.Text := FAccount.Password;
end;

end.

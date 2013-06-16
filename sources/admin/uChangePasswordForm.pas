unit uChangePasswordForm;

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
  ExtCtrls,
  StdCtrls,
  Buttons;

type
  TPasswordForm = class(TForm)
    LabeledEditOld: TEdit;
    LabeledEditNew: TEdit;
    LabeledEditConfirm: TEdit;
    BitBtnCancel: TBitBtn;
    BitBtnOk: TBitBtn;
    Image: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelError: TLabel;
    procedure FormShow(Sender: TObject);
    procedure CheckCondition;
    procedure LabeledEditOldChange(Sender: TObject);
    procedure LabeledEditNewChange(Sender: TObject);
    procedure LabeledEditConfirmChange(Sender: TObject);
  public
    OldPassword: string;  
  end;

implementation

uses
  uUtils;

{$R *.dfm}

procedure TPasswordForm.CheckCondition;
begin
  BitBtnOk.Enabled := False;
  LabelError.Caption := '';
  if LabeledEditOld.Text <> OldPassword then
  begin
    LabelError.Caption := 'Не вірно вказано поточний пароль';
    Exit; 
  end;  
  if LabeledEditNew.Text <> LabeledEditConfirm.Text then
  begin
    LabelError.Caption := 'Пароль не підтвердженно';
    Exit; 
  end;  
  if LabeledEditOld.Text = '' then
  begin
    LabelError.Caption := 'Порожній пароль';
    Exit; 
  end;
  if LabeledEditNew.Text = '' then
  begin
    LabelError.Caption := 'Порожній новий пароль';
    Exit;
  end;  
  BitBtnOk.Enabled := True;
end;

procedure TPasswordForm.FormShow(Sender: TObject);
begin
  LabeledEditOld.Text := '';
  LabeledEditNew.Text := '';
  LabeledEditConfirm.Text := '';
  CheckCondition;
end;

procedure TPasswordForm.LabeledEditConfirmChange(Sender: TObject);
begin
  CheckCondition;
end;

procedure TPasswordForm.LabeledEditNewChange(Sender: TObject);
begin
  CheckCondition;
end;

procedure TPasswordForm.LabeledEditOldChange(Sender: TObject);
begin
  CheckCondition;
end;

end.

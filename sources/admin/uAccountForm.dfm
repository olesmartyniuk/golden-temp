object AccountForm: TAccountForm
  Left = 0
  Top = 0
  HelpContext = 3010
  ActiveControl = ButtonOK
  BorderStyle = bsDialog
  Caption = #1042#1093#1110#1076
  ClientHeight = 269
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    AlignWithMargins = True
    Left = 4
    Top = 4
    Width = 358
    Height = 225
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 34
      Top = 35
      Width = 27
      Height = 13
      Caption = #1061#1086#1089#1090':'
    end
    object Label2: TLabel
      Left = 31
      Top = 85
      Width = 30
      Height = 13
      Caption = #1051#1086#1075#1110#1085':'
    end
    object Label3: TLabel
      Left = 20
      Top = 137
      Width = 41
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100':'
    end
    object EditHost: TEdit
      Left = 74
      Top = 32
      Width = 274
      Height = 21
      TabOrder = 0
      Text = 'localhost'
    end
    object EditLogin: TEdit
      Left = 74
      Top = 82
      Width = 274
      Height = 21
      TabOrder = 1
      Text = 'admin'
    end
    object EditPassword: TEdit
      Left = 74
      Top = 134
      Width = 274
      Height = 21
      PasswordChar = '*'
      TabOrder = 2
      Text = '1'
    end
    object CheckBoxSavePassword: TCheckBox
      Left = 74
      Top = 161
      Width = 103
      Height = 17
      Caption = #1047#1073#1077#1088#1077#1075#1090#1080' '#1087#1072#1088#1086#1083#1100
      TabOrder = 3
    end
  end
  object ButtonOK: TButton
    Left = 197
    Top = 236
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = ButtonOKClick
  end
  object ButtonCancel: TButton
    Left = 283
    Top = 236
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1057#1082#1072#1089#1091#1074#1072#1090#1080
    ModalResult = 2
    TabOrder = 2
  end
end

object TeacherForm: TTeacherForm
  Left = 0
  Top = 0
  HelpContext = 3042
  BorderStyle = bsDialog
  Caption = #1040#1090#1088#1080#1073#1091#1090#1080' '#1074#1080#1082#1083#1072#1076#1072#1095#1072
  ClientHeight = 272
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 365
    Height = 222
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 107
      Width = 26
      Height = 13
      Caption = #1051#1086#1075#1110#1085
    end
    object Label2: TLabel
      Left = 16
      Top = 150
      Width = 37
      Height = 13
      Caption = #1055#1072#1088#1086#1083#1100
    end
    object Label3: TLabel
      Left = 187
      Top = 18
      Width = 18
      Height = 13
      Caption = #1030#1084#39#1103
    end
    object Label4: TLabel
      Left = 16
      Top = 18
      Width = 47
      Height = 13
      Caption = #1055#1088#1110#1079#1074#1080#1097#1077
    end
    object Label6: TLabel
      Left = 16
      Top = 64
      Width = 46
      Height = 13
      Caption = #1050#1072#1092#1077#1076#1088#1072
    end
    object Label7: TLabel
      Left = 187
      Top = 64
      Width = 37
      Height = 13
      Caption = #1055#1086#1089#1072#1076#1072
    end
    object LabeledEditLogin: TEdit
      Left = 16
      Top = 123
      Width = 327
      Height = 21
      TabOrder = 4
      OnChange = LabeledEditLoginChange
      OnKeyPress = LabeledEditLoginKeyPress
    end
    object LabeledEditPassword: TEdit
      Left = 16
      Top = 164
      Width = 327
      Height = 21
      TabOrder = 5
      OnChange = LabeledEditPasswordChange
    end
    object LabeledEditName: TEdit
      Left = 187
      Top = 34
      Width = 156
      Height = 21
      TabOrder = 1
      OnChange = LabeledEditSurnameChange
    end
    object LabeledEditSurname: TEdit
      Left = 16
      Top = 34
      Width = 145
      Height = 21
      TabOrder = 0
      OnChange = LabeledEditSurnameChange
    end
    object LabeledEditCathedra: TEdit
      Left = 16
      Top = 80
      Width = 145
      Height = 21
      TabOrder = 2
      OnChange = LabeledEditSurnameChange
    end
    object ComboBoxPosition: TComboBox
      Left = 187
      Top = 83
      Width = 156
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = '<'#1053#1077' '#1074#1082#1072#1079#1072#1085#1086'>'
      Items.Strings = (
        '<'#1053#1077' '#1074#1082#1072#1079#1072#1085#1086'>'
        #1040#1089#1080#1089#1090#1077#1085#1090
        #1042#1080#1082#1083#1072#1076#1072#1095
        #1057#1090#1072#1088#1096#1080#1081' '#1074#1080#1082#1083#1072#1076#1072#1095
        #1044#1086#1094#1077#1085#1090
        #1055#1088#1086#1092#1077#1089#1086#1088)
    end
  end
  object PanelBottom: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 231
    Width = 365
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object LabelError: TLabel
      Left = 19
      Top = 12
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BitBtnOk: TBitBtn
      AlignWithMargins = True
      Left = 187
      Top = 6
      Width = 75
      Height = 24
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 14
      Margins.Bottom = 8
      Align = alRight
      Caption = 'Ok'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = BitBtnOkClick
    end
    object BitBtnCancel: TBitBtn
      AlignWithMargins = True
      Left = 276
      Top = 6
      Width = 75
      Height = 24
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 14
      Margins.Bottom = 8
      Align = alRight
      Cancel = True
      Caption = #1057#1082#1072#1089#1091#1074#1072#1090#1080
      ModalResult = 2
      TabOrder = 1
    end
  end
end

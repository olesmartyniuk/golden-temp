object StudentListForm: TStudentListForm
  Left = 0
  Top = 0
  HelpContext = 3043
  Caption = #1057#1087#1080#1089#1086#1082' '#1089#1090#1091#1076#1077#1085#1090#1110#1074
  ClientHeight = 342
  ClientWidth = 495
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
  object LabelInfo: TLabel
    AlignWithMargins = True
    Left = 6
    Top = 5
    Width = 486
    Height = 13
    Margins.Left = 6
    Margins.Top = 5
    Margins.Bottom = 5
    Align = alTop
    Caption = 
      #1044#1083#1103' '#1075#1088#1091#1087#1086#1074#1086#1075#1086' '#1074#1080#1076#1110#1083#1077#1085#1085#1103' '#1074#1080#1082#1086#1088#1080#1089#1090#1086#1074#1091#1081#1090#1077' '#1082#1083#1110#1082' '#1074' '#1082#1086#1084#1073#1110#1085#1072#1094#1110#1103#1093' '#1110#1079' '#1079#1072#1090 +
      #1080#1089#1085#1077#1085#1080#1084#1080' Ctrl '#1072#1073#1086' Shift'
    ExplicitWidth = 451
  end
  object ListViewStudents: TListView
    Tag = 2
    AlignWithMargins = True
    Left = 3
    Top = 26
    Width = 489
    Height = 275
    Align = alClient
    Columns = <
      item
        Caption = #1051#1086#1075#1110#1085
        Width = 100
      end
      item
        Caption = #1055#1072#1088#1086#1083#1100
        MaxWidth = 1
        MinWidth = 1
        Width = 1
      end
      item
        AutoSize = True
        Caption = #1030#1084#39#1103
      end
      item
        AutoSize = True
        Caption = #1055#1088#1110#1079#1074#1080#1097#1077
      end>
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object PanelBottom: TPanel
    Left = 0
    Top = 304
    Width = 495
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object ButtonSelect: TButton
      AlignWithMargins = True
      Left = 14
      Top = 6
      Width = 96
      Height = 24
      Margins.Left = 14
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 8
      Align = alLeft
      Caption = #1042#1080#1073#1088#1072#1090#1080' '#1074#1089#1110#1093
      TabOrder = 0
      OnClick = ButtonSelectClick
    end
    object ButtonOk: TButton
      AlignWithMargins = True
      Left = 305
      Top = 6
      Width = 82
      Height = 24
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 14
      Margins.Bottom = 8
      Align = alRight
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = ButtonOkClick
    end
    object ButtonCancel: TButton
      AlignWithMargins = True
      Left = 401
      Top = 6
      Width = 80
      Height = 24
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 14
      Margins.Bottom = 8
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
      OnClick = ButtonCancelClick
    end
  end
end

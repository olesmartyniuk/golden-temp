object MainForm: TMainForm
  Left = 271
  Top = 114
  Caption = #1057#1077#1088#1074#1077#1088' '#1090#1077#1089#1090#1091#1074#1072#1085#1085#1103
  ClientHeight = 129
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonStart: TButton
    Left = 24
    Top = 8
    Width = 75
    Height = 25
    Caption = #1057#1090#1072#1088#1090
    TabOrder = 0
    OnClick = ButtonStartClick
  end
  object ButtonStop: TButton
    Left = 24
    Top = 48
    Width = 75
    Height = 25
    Caption = #1057#1090#1086#1087
    TabOrder = 1
    OnClick = ButtonStopClick
  end
  object ButtonOpenBrowser: TButton
    Left = 166
    Top = 8
    Width = 225
    Height = 25
    Caption = #1042#1110#1076#1082#1088#1080#1090#1080' '#1110#1085#1090#1077#1088#1092#1077#1089' '#1091' '#1073#1088#1072#1091#1079#1077#1088#1110
    TabOrder = 2
    OnClick = ButtonOpenBrowserClick
  end
  object ButtonDbCreate: TButton
    Left = 166
    Top = 48
    Width = 225
    Height = 49
    Caption = #1057#1090#1074#1086#1088#1080#1090#1080' '#1073#1072#1079#1091' '#1076#1072#1085#1080#1093' ('#1087#1072#1088#1086#1083#1100' '#1072#1076#1084#1110#1085#1072' 123)'
    TabOrder = 3
    WordWrap = True
    OnClick = ButtonDbCreateClick
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    Left = 176
    Top = 56
  end
end

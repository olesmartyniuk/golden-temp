object FormSplash: TFormSplash
  Left = 0
  Top = 0
  AlphaBlendValue = 0
  BorderStyle = bsNone
  Caption = 'FormSplash'
  ClientHeight = 126
  ClientWidth = 341
  Color = clWindow
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 341
    Height = 126
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    BorderWidth = 5
    Color = clWindow
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 5
    ParentBackground = False
    TabOrder = 0
    object LabelMessage: TLabel
      AlignWithMargins = True
      Left = 90
      Top = 35
      Width = 229
      Height = 43
      Margins.Top = 20
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'LabelMessage'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitLeft = 86
      ExplicitTop = 26
      ExplicitWidth = 74
      ExplicitHeight = 14
    end
    object Animate: TAnimate
      AlignWithMargins = True
      Left = 30
      Top = 18
      Width = 54
      Height = 53
      Margins.Left = 15
      Margins.Bottom = 10
      Align = alLeft
      StopFrame = 31
    end
    object ButtonCancel: TButton
      AlignWithMargins = True
      Left = 105
      Top = 84
      Width = 127
      Height = 25
      Margins.Left = 90
      Margins.Right = 90
      Align = alBottom
      Caption = #1057#1082#1072#1089#1091#1074#1072#1090#1080
      TabOrder = 1
      Visible = False
      OnClick = ButtonCancelClick
    end
  end
end

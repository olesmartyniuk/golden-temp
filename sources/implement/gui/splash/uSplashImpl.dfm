object FormSplash: TFormSplash
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FormSplash'
  ClientHeight = 128
  ClientWidth = 309
  Color = clWindow
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Microsoft Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 309
    Height = 128
    Cursor = crHourGlass
    Align = alClient
    BevelKind = bkFlat
    BorderWidth = 5
    Color = clWindow
    Padding.Left = 10
    Padding.Top = 10
    Padding.Right = 10
    Padding.Bottom = 10
    TabOrder = 0
    object LabelMessage: TLabel
      Left = 16
      Top = 16
      Width = 272
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'LabelMessage'
      WordWrap = True
    end
    object Animate: TAnimate
      Left = 16
      Top = 41
      Width = 272
      Height = 60
      Cursor = crHourGlass
      StopFrame = 31
    end
    object ProgressBar: TProgressBar
      Left = 16
      Top = 96
      Width = 272
      Height = 17
      TabOrder = 1
      Visible = False
    end
  end
end

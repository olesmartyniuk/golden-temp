object FormAddStudent: TFormAddStudent
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1044#1086#1076#1072#1090#1080' '#1076#1086' '#1075#1088#1091#1087#1080
  ClientHeight = 459
  ClientWidth = 468
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
    Left = 3
    Top = 44
    Width = 462
    Height = 368
    Align = alClient
    TabOrder = 0
    object ListView: TListView
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 454
      Height = 360
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Columns = <
        item
          AutoSize = True
          Caption = #1057#1090#1091#1076#1077#1085#1090
        end
        item
          Caption = #1051#1086#1075#1110#1085
          Width = 150
        end>
      HotTrack = True
      LargeImages = ImageList
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenu
      SmallImages = ImageList
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = ListViewDblClick
      OnSelectItem = ListViewSelectItem
    end
  end
  object PanelInfo: TPanel
    Left = 0
    Top = 0
    Width = 468
    Height = 41
    Align = alTop
    Caption = 
      #1044#1083#1103' '#1075#1088#1091#1087#1086#1074#1086#1075#1086' '#1074#1080#1076#1110#1083#1077#1085#1085#1103' '#1074#1080#1082#1086#1088#1080#1089#1090#1086#1074#1091#1081#1090#1077' '#1079#1072#1090#1080#1089#1085#1091#1090#1110' '#1082#1083#1072#1074#1110#1096#1110' Ctrl '#1072#1073 +
      #1086' Shift'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object PanelBottom: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 418
    Width = 462
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object ButtonOK: TButton
      AlignWithMargins = True
      Left = 284
      Top = 6
      Width = 75
      Height = 24
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 14
      Margins.Bottom = 8
      Align = alRight
      Caption = 'OK'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 0
      OnClick = ButtonOKClick
    end
    object ButtonCancel: TButton
      AlignWithMargins = True
      Left = 373
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
    object ButtonNewStudent: TButton
      AlignWithMargins = True
      Left = 14
      Top = 6
      Width = 107
      Height = 24
      Margins.Left = 14
      Margins.Top = 6
      Margins.Bottom = 8
      Align = alLeft
      Caption = #1044#1086#1076#1072#1090#1080' '#1085#1086#1074#1086#1075#1086
      TabOrder = 2
      OnClick = ButtonNewStudentClick
    end
  end
  object ImageList: TImageList
    Height = 20
    Width = 20
    Left = 8
    Top = 8
    Bitmap = {
      494C010101000400240014001400FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000500000001400000001002000000000000019
      00000000000000000000000000000000000000000000E0DDDB00D5CEC700D2C9
      C100D2C9C100D3CAC200D4CBC300D5CCC400D2CFCD00D1D1D100D1D0CE00D5CC
      C400D4CBC300D3CAC200D2C9C100D1C8C000D1CAC200D8D4D100E4E4E400FBFB
      FB00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DDDAD800BFA88F00BB8D5F00C28F
      5C00C8956100CF9C6800D5A36F00D3A16D00C2B1A000BDBDBD00C0B7AE00CF9D
      6900D3A26E00CE9A6700C8956200C1905B00BB8C5C00B99C7F00D0CBC600F9F9
      F900000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000E6DED700BB8D5E00D5A16E00E3AF
      7C00E9B68300F0BD8A00F7C79400E9BA8700DECDBC00E3E3E300E0D8CF00E1B1
      7E00F6C79400EFBC8900EAB78400E3B07D00D7A47000BF906000D8CABB00FCFC
      FC00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F3ECE400C5966500DDAA7700E4B1
      7E00E9B68300F0BD8A00F7C79400EABB8800E4D3C200E9E9E900E6DED500E3B3
      8000F6C69400EFBC8900EAB78400E3B17E00DDAB7700CA996900E8D9C900FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000F8F3EE00D6AF8800DAA87400E7B6
      8300EAB78400F0BD8A00F7C79400ECBD8A00EAD9C800F1F1F100EDE5DC00E6B6
      8300F6C79400EFBC8900EAB78400E6B58200DDAC7900D4AA7F00F2E8DD00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FEFDFD00EFDFCE00D7A97B00E2B1
      7E00EDBE8A00F1C08D00F7C89500EEBF8C00E8D7C600EBEBEB00E9E1D800E9B8
      8500F6C79400F1BF8C00EEBE8B00E5B48100D6A77700E9D3BD00FDFBFA00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FDFBFA00EFDDCB00DCB1
      8600E6B58200F2C49000FACE9B00E9C09100B4B1AD00A3B4C200ABB2B700E2B8
      8B00F9CD9A00F2C59100E8B98500DAAC7D00EBD6BF00FCF9F700FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FEFEFE00F4E7
      DA00E6C4A300E2B17F00EEBF8B00CFB3910099B7D00090C2EF0094BCDF00C2AB
      9100EEC08B00E3B27F00E3BD9700F2E1D100FEFEFE00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FBF5F000F2E1CF00E8C49F009C958E0074A1CC0084B7E6007CACD900848B
      9100E7BF9800F0DCC800F9F1E900FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FEFEFE00FBF6F20090A8C000336DA600316CA8003671AB006D8F
      B100FBF5F000FEFDFC00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FEFEFE00E0E8F100779EC4005F93C70076A9DB00669ACD006692
      BD00D3DFEB00FEFEFE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00EDF2F70099B6D3006799C8007EB1E10080B3E3007FB2E2006D9E
      CE0089AACC00E3EBF300FEFEFE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF009CB9D6005884B000628DB60088BBEA0087BAE80088BBE9006F9D
      C7005078A30091B2D300F0F4F800FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF005785B40041597A005C77970090C3EF008EC1EE008FC2EE007093
      B6003B4F6D005582B000E3EBF300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0089A5C200323E5700647D9A0096C9F40094C7F20095C8F3007799
      BA00323B51007992B000EEF3F800FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00DEDEE0003F3F5000536078007CA1C4008CB6DC008DB8DE007998
      B7003A3A4B00BDBDC200FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00E7E7E900676776005A5A6B005858690053536400505365005A66
      7B0057576700CDCDD100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F6F6F600A6A6AF0063637400676779006B6B7C00606072004D4D
      5E0077778400E1E1E300FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FEFEFE00EAEAEC00ABABB3007777860063637300707080009C9C
      A600D6D6DA00F7F7F700FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FEFEFE00F7F7F700EAEAEC00E4E4E600E8E8EA00F5F5
      F600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000050000000140000000100010000000000F00000000000000000000000
      000000000000000000000000FFFFFF0080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000}
  end
  object PopupMenu: TPopupMenu
    Left = 40
    Top = 8
    object N1: TMenuItem
      Caption = #1042#1080#1076#1110#1083#1080#1090#1080' '#1074#1089#1077
      OnClick = N1Click
    end
  end
end
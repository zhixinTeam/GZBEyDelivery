inherited fFormNewXSBill: TfFormNewXSBill
  Left = 386
  Top = 137
  ClientHeight = 502
  ClientWidth = 532
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 532
    Height = 502
    inherited BtnOK: TButton
      Left = 386
      Top = 469
      Caption = #24320#21333
      TabOrder = 22
    end
    inherited BtnExit: TButton
      Left = 456
      Top = 469
      TabOrder = 23
    end
    object EditReCode: TcxTextEdit [2]
      Left = 87
      Top = 36
      Hint = 'D.1'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 125
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 217
      Top = 36
      Hint = 'D.2'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 121
    end
    object EditPartCode: TcxTextEdit [4]
      Left = 87
      Top = 61
      Hint = 'D.3'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 125
    end
    object EditPartName: TcxTextEdit [5]
      Left = 217
      Top = 61
      Hint = 'D.4'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 121
    end
    object EditPCode: TcxTextEdit [6]
      Left = 87
      Top = 86
      Hint = 'D.5'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 125
    end
    object EditdRegCode: TcxTextEdit [7]
      Left = 87
      Top = 111
      Hint = 'D.7'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 125
    end
    object cxTextEdit12: TcxTextEdit [8]
      Left = 87
      Top = 231
      Hint = 'D.10'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 125
    end
    object cxTextEdit13: TcxTextEdit [9]
      Left = 275
      Top = 231
      Hint = 'D.11'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 117
    end
    object cxTextEdit14: TcxTextEdit [10]
      Left = 87
      Top = 256
      Hint = 'D.12'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 125
    end
    object cxTextEdit15: TcxTextEdit [11]
      Left = 275
      Top = 256
      Hint = 'D.13'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 117
    end
    object EditNum: TcxTextEdit [12]
      Left = 275
      Top = 294
      Hint = 'D.15'
      ParentFont = False
      Properties.MaxLength = 10
      Properties.ReadOnly = False
      TabOrder = 16
      OnKeyPress = EditNumKeyPress
      Width = 117
    end
    object EditTruck: TcxTextEdit [13]
      Left = 87
      Top = 294
      Hint = 'D.14'
      ParentFont = False
      Properties.MaxLength = 15
      Properties.ReadOnly = False
      TabOrder = 15
      OnKeyPress = EditTruckKeyPress
      Width = 125
    end
    object EditPName: TcxTextEdit [14]
      Left = 217
      Top = 86
      Hint = 'D.6'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 168
    end
    object cxLabel1: TcxLabel [15]
      Left = 23
      Top = 281
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Transparent = True
      Height = 8
      Width = 416
    end
    object EditSeal: TcxTextEdit [16]
      Left = 87
      Top = 344
      Hint = 'D.16'
      ParentFont = False
      Properties.MaxLength = 45
      TabOrder = 18
      OnKeyPress = EditNumKeyPress
      Width = 125
    end
    object EditType: TcxComboBox [17]
      Left = 87
      Top = 319
      Hint = 'D.17'
      ParentFont = False
      Properties.Items.Strings = (
        'C=C'#12289#26222#36890
        'Z=Z'#12289#26632#21488
        'V=V'#12289'VIP'
        'S=S'#12289#33337#36816)
      Style.HotTrack = False
      Style.PopupBorderStyle = epbsSingle
      TabOrder = 17
      Width = 121
    end
    object EditTruckType: TcxTextEdit [18]
      Left = 87
      Top = 136
      Hint = 'D.8'
      ParentFont = False
      Style.HotTrack = False
      TabOrder = 8
      Width = 125
    end
    object cxTextEdit9: TcxTextEdit [19]
      Left = 87
      Top = 161
      Hint = 'D.9'
      ParentFont = False
      Style.HotTrack = False
      TabOrder = 9
      Width = 121
    end
    object EditTruckName: TcxTextEdit [20]
      Left = 87
      Top = 369
      Hint = 'D.17'
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 19
      Width = 125
    end
    object EditTelNo: TcxTextEdit [21]
      Left = 87
      Top = 394
      Hint = 'D.18'
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 20
      Width = 121
    end
    object EditdRegName: TcxTextEdit [22]
      Left = 217
      Top = 111
      Hint = 'D.19'
      ParentFont = False
      TabOrder = 7
      Width = 216
    end
    object EditNumber: TcxTextEdit [23]
      Left = 87
      Top = 419
      Hint = 'D.19'
      ParentFont = False
      Properties.MaxLength = 25
      TabOrder = 21
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #35746#21333#20449#24687
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            Caption = #21806#36798#26041':'
            Control = EditReCode
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Control = cxTextEdit2
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #36865#36798#26041':'
            Control = EditPartCode
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Control = EditPartName
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group8: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item11: TdxLayoutItem
            Caption = #21697#31181':'
            Control = EditPCode
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item23: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Control = EditPName
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group10: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item12: TdxLayoutItem
            Caption = #38144#21806#21306#22495':'
            Control = EditdRegCode
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Control = EditdRegName
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group7: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxlytmLayout1Item7: TdxLayoutItem
            Caption = #36816#36755#26041#24335':'
            Control = EditTruckType
            ControlOptions.ShowBorder = False
          end
          object dxlytmLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #21512#21516#32534#21495' :'
            Control = cxTextEdit9
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxLayout1Group5: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #20132#36135#21333#20449#24687
        object dxLayout1Group6: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group12: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item14: TdxLayoutItem
              Caption = #35746#21333#25968#37327':'
              Control = cxTextEdit12
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item15: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #26410#25552#25968#37327':'
              Control = cxTextEdit13
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group14: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item16: TdxLayoutItem
              Caption = #24050#25552#25968#37327':'
              Control = cxTextEdit14
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item17: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21487#20351#29992#37327':'
              Control = cxTextEdit15
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item27: TdxLayoutItem
            Caption = 'cxLabel1'
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group15: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item19: TdxLayoutItem
              Caption = #25552#36135#36710#36742':'
              Control = EditTruck
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item18: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21150#29702#21544#25968':'
              Control = EditNum
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxlytmLayout1Item6: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #25552#36135#36890#36947':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item28: TdxLayoutItem
          Caption = #23553#31614#32534#21495':'
          Control = EditSeal
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #21496#26426#22995#21517':'
          Control = EditTruckName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #21496#26426#30005#35805':'
          Control = EditTelNo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #35777#20214#32534#21495':'
          Control = EditNumber
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

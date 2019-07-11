inherited fFormOptions: TfFormOptions
  Left = 278
  Top = 218
  Caption = #21442#25968#35774#32622
  ClientHeight = 359
  ClientWidth = 724
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object Label16: TLabel [0]
    Left = 31
    Top = 252
    Width = 66
    Height = 12
    Caption = #21253#35013#27491#35823#24046':'
  end
  object Label17: TLabel [1]
    Left = 221
    Top = 253
    Width = 198
    Height = 12
    Caption = '('#35831#36755#20837#23567#25968#20540'.'#20363#22914#35823#24046'1%'#23601#26159'0.01)'
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 724
    Height = 359
    inherited BtnOK: TButton
      Left = 578
      Top = 326
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 648
      Top = 326
      TabOrder = 2
    end
    object wPage: TcxPageControl [2]
      Left = 23
      Top = 36
      Width = 289
      Height = 193
      ActivePage = cxTabSheet2
      ParentColor = False
      ShowFrame = True
      Style = 9
      TabOrder = 0
      TabSlants.Kind = skCutCorner
      OnChange = wPageChange
      ClientRectBottom = 192
      ClientRectLeft = 1
      ClientRectRight = 288
      ClientRectTop = 19
      object Sheet1: TcxTabSheet
        Caption = #22522#26412#21442#25968
        ImageIndex = 0
        object CheckViaCard: TcxCheckBox
          Left = 12
          Top = 20
          Caption = #24320#21333#21518#30452#25509#21046#21345
          ParentFont = False
          TabOrder = 0
          OnClick = CheckViaCardClick
          Width = 379
        end
        object CheckPoundDai: TcxCheckBox
          Left = 12
          Top = 56
          Caption = #34955#35013#25552#36135#38656#35201#36807#30917
          ParentFont = False
          TabOrder = 1
          OnClick = CheckViaCardClick
          Width = 398
        end
        object CheckFSanZStop: TcxCheckBox
          Left = 13
          Top = 88
          Caption = #25955#35013#19981#20801#35768#36229#21457
          ParentFont = False
          TabOrder = 2
          OnClick = CheckViaCardClick
          Width = 406
        end
      end
      object Sheet2: TcxTabSheet
        Tag = 20
        Caption = #30917#31449#35774#32622
        ImageIndex = 1
        object Label1: TLabel
          Tag = 10
          Left = 17
          Top = 23
          Width = 54
          Height = 12
          Caption = #24037#21378#32534#21495':'
        end
        object Label2: TLabel
          Left = 12
          Top = 95
          Width = 6
          Height = 12
        end
        object Label14: TLabel
          Tag = 10
          Left = 6
          Top = 51
          Width = 66
          Height = 12
          Caption = #21253#35013#27491#35823#24046':'
        end
        object Label15: TLabel
          Tag = 30
          Left = 171
          Top = 52
          Width = 198
          Height = 12
          Caption = '('#35831#36755#20837#23567#25968#20540'.'#20363#22914#35823#24046'1%'#23601#26159'0.01)'
        end
        object Label18: TLabel
          Tag = 10
          Left = 6
          Top = 82
          Width = 66
          Height = 12
          Caption = #21253#35013#36127#35823#24046':'
        end
        object Label19: TLabel
          Tag = 30
          Left = 171
          Top = 82
          Width = 198
          Height = 12
          Caption = '('#35831#36755#20837#23567#25968#20540'.'#20363#22914#35823#24046'1%'#23601#26159'0.01)'
        end
        object Label30: TLabel
          Tag = 10
          Left = 6
          Top = 113
          Width = 66
          Height = 12
          Caption = #25955#35013#27491#35823#24046':'
        end
        object lbl2: TLabel
          Tag = 30
          Left = 171
          Top = 115
          Width = 210
          Height = 12
          Caption = '('#35831#36755#20837#35823#24046#20540'.'#20363#22914#35823#24046'1'#21544#23601#26159'1.000)'
        end
        object Label31: TLabel
          Tag = 10
          Left = 6
          Top = 145
          Width = 66
          Height = 12
          Caption = #25955#35013#36127#35823#24046':'
        end
        object lbl4: TLabel
          Tag = 30
          Left = 171
          Top = 146
          Width = 210
          Height = 12
          Caption = '('#35831#36755#20837#35823#24046#20540'.'#20363#22914#35823#24046'1'#21544#23601#26159'1.000)'
        end
        object EditFactID: TcxTextEdit
          Tag = 20
          Left = 71
          Top = 18
          ParentFont = False
          Properties.MaxLength = 10
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 0
          Width = 100
        end
        object EditDaiWuChaZ: TcxTextEdit
          Tag = 20
          Left = 71
          Top = 47
          ParentFont = False
          Properties.MaxLength = 10
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 1
          Width = 100
        end
        object EditDaiWuChaF: TcxTextEdit
          Tag = 20
          Left = 71
          Top = 78
          ParentFont = False
          Properties.MaxLength = 10
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 2
          Width = 100
        end
        object EditSanWuChaZ: TcxTextEdit
          Tag = 20
          Left = 71
          Top = 108
          ParentFont = False
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 3
          Width = 100
        end
        object EditSanWuChaF: TcxTextEdit
          Tag = 20
          Left = 70
          Top = 138
          ParentFont = False
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 4
          Width = 100
        end
      end
      object Sheet3: TcxTabSheet
        Caption = #38656#25171#21360#21697#31181
        ImageIndex = 2
        object Label6: TLabel
          Tag = 40
          Left = 3
          Top = 210
          Width = 54
          Height = 12
          Caption = #21697#31181#32534#21495':'
        end
        object Label3: TLabel
          Tag = 40
          Left = 3
          Top = 235
          Width = 54
          Height = 12
          Caption = #21697#31181#21517#31216':'
        end
        object ListStockPrint: TcxMCListBox
          Left = 0
          Top = 0
          Width = 287
          Height = 195
          Align = alTop
          HeaderSections = <
            item
              AutoSize = True
              Text = #32534#21495
              Width = 141
            end
            item
              AutoSize = True
              Text = #21517#31216
              Width = 142
            end>
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ParentFont = False
          TabOrder = 0
        end
        object EditStockId: TcxTextEdit
          Tag = 50
          Left = 56
          Top = 208
          ParentFont = False
          Properties.MaxLength = 50
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 1
          Width = 180
        end
        object EditStockName: TcxTextEdit
          Tag = 50
          Left = 57
          Top = 232
          ParentFont = False
          Properties.MaxLength = 50
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 2
          Width = 180
        end
        object BtnAdd: TcxButton
          Tag = 60
          Left = 237
          Top = 230
          Width = 55
          Height = 22
          Caption = #28155#21152
          TabOrder = 3
          OnClick = BtnAddClick
        end
        object BtnDel: TcxButton
          Tag = 60
          Left = 237
          Top = 207
          Width = 55
          Height = 22
          Caption = #21024#38500
          TabOrder = 4
          OnClick = BtnDelClick
        end
      end
      object cxTabSheet1: TcxTabSheet
        Caption = #26080#38656#21457#36135#21697#31181
        ImageIndex = 3
        object Label8: TLabel
          Tag = 40
          Left = 3
          Top = 210
          Width = 54
          Height = 12
          Caption = #21697#31181#32534#21495':'
        end
        object Label9: TLabel
          Tag = 40
          Left = 3
          Top = 234
          Width = 54
          Height = 12
          Caption = #21697#31181#21517#31216':'
        end
        object ListStockNF: TcxMCListBox
          Left = 0
          Top = 0
          Width = 287
          Height = 195
          Align = alTop
          HeaderSections = <
            item
              AutoSize = True
              Text = #32534#21495
              Width = 141
            end
            item
              AutoSize = True
              Text = #21517#31216
              Width = 142
            end>
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ParentFont = False
          TabOrder = 0
        end
        object EditStockId2: TcxTextEdit
          Tag = 50
          Left = 57
          Top = 208
          ParentFont = False
          Properties.MaxLength = 50
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 1
          Width = 180
        end
        object BtnDel2: TcxButton
          Tag = 60
          Left = 237
          Top = 206
          Width = 55
          Height = 22
          Caption = #21024#38500
          TabOrder = 2
          OnClick = BtnDel2Click
        end
        object BtnAdd2: TcxButton
          Tag = 60
          Left = 237
          Top = 230
          Width = 55
          Height = 22
          Caption = #28155#21152
          TabOrder = 3
          OnClick = BtnAdd2Click
        end
        object EditStockName2: TcxTextEdit
          Tag = 50
          Left = 57
          Top = 232
          ParentFont = False
          Properties.MaxLength = 50
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 4
          Width = 180
        end
      end
      object cxTabSheet2: TcxTabSheet
        Caption = #21457#36135#36890#36947#21697#31181
        ImageIndex = 4
        object Label10: TLabel
          Tag = 40
          Left = 3
          Top = 195
          Width = 54
          Height = 16
          Caption = #21697#31181#32534#21495':'
        end
        object Label11: TLabel
          Tag = 40
          Left = 3
          Top = 216
          Width = 54
          Height = 12
          Caption = #21697#31181#21517#31216':'
        end
        object Label4: TLabel
          Tag = 40
          Left = 2
          Top = 237
          Width = 54
          Height = 12
          Caption = #27700#27877#31867#22411':'
        end
        object ListStockLine: TcxMCListBox
          Left = 0
          Top = 0
          Width = 287
          Height = 186
          Align = alTop
          HeaderSections = <
            item
              AutoSize = True
              Text = #32534#21495
              Width = 30
            end
            item
              AutoSize = True
              Text = #21517#31216
              Width = 30
            end
            item
              Text = #21253#25955#31867#22411
              Width = 260
            end>
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ParentFont = False
          TabOrder = 0
        end
        object EditStockId3: TcxTextEdit
          Tag = 50
          Left = 56
          Top = 189
          ParentFont = False
          Properties.MaxLength = 50
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 1
          Width = 180
        end
        object EditStockName3: TcxTextEdit
          Tag = 50
          Left = 56
          Top = 213
          ParentFont = False
          Properties.MaxLength = 50
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 2
          Width = 180
        end
        object BtnDel3: TcxButton
          Tag = 60
          Left = 237
          Top = 206
          Width = 55
          Height = 22
          Caption = #21024#38500
          TabOrder = 3
          OnClick = BtnDel3Click
        end
        object BtnAdd3: TcxButton
          Tag = 60
          Left = 237
          Top = 230
          Width = 55
          Height = 22
          Caption = #28155#21152
          TabOrder = 4
          OnClick = BtnAdd3Click
        end
        object EditStockType3: TcxTextEdit
          Tag = 50
          Left = 56
          Top = 232
          ParentFont = False
          Properties.MaxLength = 50
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 5
          Width = 180
        end
      end
      object cxTabSheet3: TcxTabSheet
        Caption = #27700#27877#31867#22411#32500#25252
        ImageIndex = 5
        ParentShowHint = False
        ShowHint = True
        TabVisible = False
        object lbl5: TLabel
          Tag = 40
          Left = 3
          Top = 210
          Width = 54
          Height = 12
          Caption = #27700#27877#32534#21495':'
        end
        object lbl6: TLabel
          Tag = 40
          Left = 3
          Top = 235
          Width = 54
          Height = 12
          Caption = #27700#27877#31867#22411':'
        end
        object ListStockBreed: TcxMCListBox
          Left = 0
          Top = 0
          Width = 287
          Height = 195
          Align = alTop
          HeaderSections = <
            item
              AutoSize = True
              Text = #21517#31216
              Width = 141
            end
            item
              AutoSize = True
              Text = #31867#22411
              Width = 142
            end>
          ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
          ParentFont = False
          TabOrder = 0
        end
        object EditStockId4: TcxTextEdit
          Tag = 50
          Left = 57
          Top = 208
          ParentFont = False
          Properties.MaxLength = 50
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 1
          Width = 180
        end
        object BtnDel4: TcxButton
          Tag = 60
          Left = 237
          Top = 206
          Width = 55
          Height = 22
          Caption = #21024#38500
          TabOrder = 2
          OnClick = BtnDel4Click
        end
        object EditStockName4: TcxTextEdit
          Tag = 50
          Left = 57
          Top = 231
          ParentFont = False
          Properties.MaxLength = 50
          Properties.OnChange = EditFactIDPropertiesChange
          TabOrder = 3
          Width = 180
        end
        object BtnAdd4: TcxButton
          Tag = 60
          Left = 237
          Top = 230
          Width = 55
          Height = 22
          Caption = #28155#21152
          TabOrder = 4
          OnClick = BtnAdd4Click
        end
      end
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #21442#25968#35774#32622
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxPageControl1'
          ShowCaption = False
          Control = wPage
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

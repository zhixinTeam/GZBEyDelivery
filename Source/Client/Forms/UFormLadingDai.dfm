inherited fFormLadingDai: TfFormLadingDai
  Left = 306
  Top = 101
  Width = 486
  Height = 566
  BorderStyle = bsSizeable
  Caption = #36710#36742#20986#21378
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 470
    Height = 528
    inherited BtnOK: TButton
      Left = 324
      Top = 495
      Caption = #25918#34892
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 394
      Top = 495
      TabOrder = 5
    end
    object ListInfo: TcxMCListBox [2]
      Left = 23
      Top = 36
      Width = 314
      Height = 172
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 236
        end>
      ImeName = #20013#25991'('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      OnClick = ListInfoClick
    end
    object ListBill: TcxListView [3]
      Left = 23
      Top = 341
      Width = 350
      Height = 115
      Columns = <
        item
          Caption = #20132#36135#21333#21495
          Width = 80
        end
        item
          Alignment = taCenter
          Caption = #20132#36135#37327'('#21544')'
          Width = 100
        end
        item
          Caption = #27700#27877#31867#22411
          Width = 80
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 3
      ViewStyle = vsReport
      OnSelectItem = ListBillSelectItem
    end
    object EditCus: TcxTextEdit [4]
      Left = 81
      Top = 238
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 110
    end
    object EditBill: TcxTextEdit [5]
      Left = 81
      Top = 213
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 105
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #20132#36135#21333#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListInfo
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object LayItem1: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20132#36135#21333#21495':'
            Control = EditBill
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = #23458#25143#21517#31216':'
            Control = EditCus
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #20132#36135#21333#21015#34920
        object dxLayout1Item7: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxListView1'
          ShowCaption = False
          Control = ListBill
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

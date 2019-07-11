inherited fFrameBillPick: TfFrameBillPick
  Width = 1366
  Height = 706
  inherited ToolBar1: TToolBar
    Width = 1366
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Caption = #25315#37197
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 1366
    Height = 504
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 1366
    Height = 135
    object EditCus: TcxButtonEdit [0]
      Left = 387
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 105
    end
    object EditCard: TcxButtonEdit [1]
      Left = 234
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 90
    end
    object cxTextEdit1: TcxTextEdit [2]
      Left = 81
      Top = 93
      Hint = 'T.L_ID'
      ParentFont = False
      TabOrder = 5
      Width = 90
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 234
      Top = 93
      Hint = 'T.L_Truck'
      ParentFont = False
      TabOrder = 6
      Width = 90
    end
    object cxTextEdit4: TcxTextEdit [4]
      Left = 387
      Top = 93
      Hint = 'T.L_Stock'
      ParentFont = False
      TabOrder = 7
      Width = 165
    end
    object cxTextEdit3: TcxTextEdit [5]
      Left = 627
      Top = 93
      Hint = 'T.L_Value'
      ParentFont = False
      TabOrder = 8
      Width = 100
    end
    object EditDate: TcxButtonEdit [6]
      Left = 727
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 4
      Width = 176
    end
    object EditLID: TcxButtonEdit [7]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 90
    end
    object cxTextEdit5: TcxTextEdit [8]
      Left = 790
      Top = 93
      Hint = 'T.L_Memo'
      ParentFont = False
      TabOrder = 9
      Width = 121
    end
    object EditTruck: TcxButtonEdit [9]
      Left = 543
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 3
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item8: TdxLayoutItem
          Caption = #20132#36135#21333#21495':'
          Control = EditLID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20132#36135#21333#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36710#33337#21495#30721':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #29289#26009#21697#31181':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #20132#36135#37327'('#21544'):'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #25551#36848#20449#24687':'
          Control = cxTextEdit5
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 1366
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 1366
    inherited TitleBar: TcxLabel
      Caption = #20132#36135#21333#25315#37197#35760#24405#26597#35810
      Style.IsFontAssigned = True
      Width = 1366
      AnchorX = 683
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 236
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 236
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 4
    Top = 264
    object N1: TMenuItem
      Caption = #26597#35810#26410#25315#37197
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = #26597#35810#26410#25104#21151
      OnClick = N3Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #26102#38388#27573#26597#35810
      OnClick = N4Click
    end
  end
end

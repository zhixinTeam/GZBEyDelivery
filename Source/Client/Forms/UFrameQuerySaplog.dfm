inherited fFrameQuerySapLog: TfFrameQuerySapLog
  Width = 841
  Height = 527
  inherited ToolBar1: TToolBar
    Width = 841
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Caption = #21516#27493
      Visible = False
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Visible = False
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 217
    Width = 841
    Height = 310
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 841
    Height = 150
    object EditSerild: TcxButtonEdit [0]
      Left = 81
      Top = 36
      Hint = 'T.SID'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditSerildPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 100
    end
    object EditDate: TcxButtonEdit [1]
      Left = 244
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      Style.ButtonStyle = btsHotFlat
      TabOrder = 1
      Width = 185
    end
    object cxTextEdit1: TcxTextEdit [2]
      Left = 69
      Top = 93
      Hint = 'T.S_SerailID'
      ParentFont = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsSingle
      Style.HotTrack = False
      TabOrder = 3
      Width = 121
    end
    object EditStatus: TcxComboBox [3]
      Left = 468
      Top = 36
      ParentFont = False
      Properties.Items.Strings = (
        'U=U'#12289#24322#24120
        'Y=Y'#12289#25104#21151
        'N=N'#12289#22833#36133
        '')
      TabOrder = 2
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxlytmLayout1Item1: TdxLayoutItem
          Caption = #20256#36755#32534#21495':'
          Control = EditSerild
          ControlOptions.ShowBorder = False
        end
        object dxlytmLayout1Item2: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item1: TdxLayoutItem
          Caption = #29366#24577':'
          Control = EditStatus
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxlytmLayout1Item3: TdxLayoutItem
          Caption = #28040#24687#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 209
    Width = 841
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 841
    inherited TitleBar: TcxLabel
      Caption = #25509#21475#26085#24535#26597#35810
      Style.IsFontAssigned = True
      Width = 841
      AnchorX = 421
      AnchorY = 11
    end
  end
end

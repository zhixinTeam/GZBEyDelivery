inherited fFormNewBill: TfFormNewBill
  Left = 549
  Top = 219
  Caption = #21019#24314#20132#36135#21333
  ClientHeight = 148
  ClientWidth = 303
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 303
    Height = 148
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 157
      Top = 115
      Height = 20
      Caption = #30830#23450
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 227
      Top = 115
      TabOrder = 3
    end
    object EditXS: TcxTextEdit [2]
      Left = 93
      Top = 36
      ParentFont = False
      Properties.MaxLength = 10
      TabOrder = 0
      OnKeyPress = EditXSKeyPress
      Width = 121
    end
    object EditCRM: TcxTextEdit [3]
      Left = 93
      Top = 61
      ParentFont = False
      Properties.MaxLength = 10
      TabOrder = 1
      OnKeyPress = EditXSKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          Caption = #38144#21806#35746#21333#21495':'
          Control = EditXS
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30005#23376#25552#36135#21333':'
          Control = EditCRM
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

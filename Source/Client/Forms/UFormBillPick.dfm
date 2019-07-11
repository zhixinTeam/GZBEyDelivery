inherited fFormPickBill: TfFormPickBill
  Left = 657
  Top = 228
  ClientHeight = 175
  ClientWidth = 305
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 305
    Height = 175
    inherited BtnOK: TButton
      Left = 159
      Top = 142
      Caption = #30830#23450
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 229
      Top = 142
      TabOrder = 4
    end
    object EditID: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 121
    end
    object EditPValue: TcxTextEdit [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      OnKeyPress = EditPValueKeyPress
      Width = 121
    end
    object EditMValue: TcxTextEdit [4]
      Left = 81
      Top = 86
      ParentFont = False
      TabOrder = 2
      OnKeyPress = EditPValueKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20132#36135#21333#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #31216#37327#30382#37325':'
          Control = EditPValue
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #31216#37327#27611#37325':'
          Control = EditMValue
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

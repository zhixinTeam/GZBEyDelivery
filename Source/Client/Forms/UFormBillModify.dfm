inherited fFormModifyBill: TfFormModifyBill
  Left = 839
  Top = 249
  ClientHeight = 177
  ClientWidth = 347
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 347
    Height = 177
    inherited BtnOK: TButton
      Left = 201
      Top = 144
      Caption = #30830#23450
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 271
      Top = 144
      TabOrder = 5
    end
    object EditID: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 121
    end
    object EditValue: TcxTextEdit [3]
      Left = 81
      Top = 74
      ParentFont = False
      Properties.MaxLength = 8
      TabOrder = 2
      Width = 121
    end
    object EditTruck: TcxTextEdit [4]
      Left = 81
      Top = 99
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 3
      Width = 121
    end
    object cxLabel1: TcxLabel [5]
      Left = 23
      Top = 61
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 8
      Width = 283
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #25552#36135#21333#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #25552#36135#25968#37327':'
          Control = EditValue
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #36710#33337#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end

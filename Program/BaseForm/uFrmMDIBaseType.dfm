inherited frmMDIBaseType: TfrmMDIBaseType
  Width = 753
  Caption = 'frmMDIBaseType'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlTop: TPanel
    Width = 737
  end
  inherited pnlBottom: TPanel
    Width = 737
    object btnAdd: TcxButton
      Left = 40
      Top = 8
      Width = 75
      Height = 25
      Action = actAdd
      TabOrder = 0
    end
    object btnModify: TcxButton
      Left = 144
      Top = 8
      Width = 75
      Height = 25
      Action = actModify
      TabOrder = 1
    end
    object btnDelete: TcxButton
      Left = 240
      Top = 8
      Width = 75
      Height = 25
      Action = actDelete
      TabOrder = 2
    end
  end
  inherited pnlLeft: TPanel
    Width = 113
    inherited tvClass: TcxTreeView
      Width = 111
    end
  end
  inherited gridMainShow: TcxGrid
    Left = 113
    Width = 624
  end
  inherited dsMainShow: TDataSource
    Left = 80
    Top = 16
  end
  inherited cdsMainShow: TClientDataSet
    Left = 48
    Top = 16
  end
  inherited actlstEvent: TActionList
    Left = 16
    Top = 16
    object actAdd: TAction
      Caption = #26032#22686
      OnExecute = actAddExecute
    end
    object actModify: TAction
      Caption = #20462#25913
      OnExecute = actModifyExecute
    end
    object actDelete: TAction
      Caption = #21024#38500
      OnExecute = actDeleteExecute
    end
  end
end

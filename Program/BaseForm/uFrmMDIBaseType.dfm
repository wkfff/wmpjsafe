inherited frmMDIBaseType: TfrmMDIBaseType
  Width = 753
  Caption = 'frmMDIBaseType'
  PixelsPerInch = 96
  TextHeight = 13
  inherited splOP: TSplitter
    Left = 113
  end
  inherited pnlTop: TPanel
    Width = 737
  end
  inherited pnlBottom: TPanel
    Width = 737
    Caption = ''
    object btnAdd: TcxButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Action = actAdd
      TabOrder = 0
    end
    object btnModify: TcxButton
      Left = 211
      Top = 8
      Width = 75
      Height = 25
      Action = actModify
      TabOrder = 1
    end
    object btnDelete: TcxButton
      Left = 308
      Top = 8
      Width = 75
      Height = 25
      Action = actDelete
      TabOrder = 2
    end
    object btnClass: TcxButton
      Left = 405
      Top = 8
      Width = 75
      Height = 25
      Action = actClass
      TabOrder = 3
    end
    object btnList: TcxButton
      Left = 503
      Top = 8
      Width = 75
      Height = 25
      Action = actList
      TabOrder = 4
    end
    object btnQuery: TcxButton
      Left = 600
      Top = 8
      Width = 75
      Height = 25
      Action = actQuery
      TabOrder = 5
    end
    object btnCopyAdd: TcxButton
      Left = 113
      Top = 8
      Width = 75
      Height = 25
      Action = actCopyAdd
      TabOrder = 6
    end
  end
  inherited pnlTV: TPanel
    Width = 113
    inherited tvClass: TcxTreeView
      Width = 111
    end
  end
  inherited gridMainShow: TcxGrid
    Left = 116
    Width = 621
    inherited gridDTVMainShow: TcxGridDBTableView
      OnCellDblClick = gridDTVMainShowCellDblClick
    end
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
    object actClass: TAction
      Caption = #20998#31867
      OnExecute = actClassExecute
    end
    object actCopyAdd: TAction
      Caption = #22797#21046#26032#22686
      OnExecute = actCopyAddExecute
    end
    object actList: TAction
      Caption = #21015#34920
      OnExecute = actListExecute
    end
    object actQuery: TAction
      Caption = #26597#35810
      OnExecute = actQueryExecute
    end
  end
end

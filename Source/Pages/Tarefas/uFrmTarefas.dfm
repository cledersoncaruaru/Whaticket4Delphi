inherited FrmTarefas: TFrmTarefas
  OnDestroy = IWAppFormDestroy
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    OnAsyncClick = BTN_POSTAsyncClick
  end
  object NAME: TIWEdit [5]
    AlignWithMargins = False
    Left = 183
    Top = 84
    Width = 418
    Height = 25
    Hint = 'Informe o Nome'
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'NAME'
    SubmitOnAsyncEvent = True
    DataTypeOptions.StringCase = scUppercase
  end
  object BTN_ADICONAR: TIWButton [6]
    AlignWithMargins = False
    Left = 604
    Top = 84
    Width = 114
    Height = 30
    Caption = 'Adicionar'
    Color = clBtnFace
    FriendlyName = 'BTN_ADICONAR'
    OnAsyncClick = BTN_ADICONARAsyncClick
  end
  object id: TIWEdit [7]
    AlignWithMargins = False
    Left = 115
    Top = 84
    Width = 62
    Height = 25
    Hint = 'id'
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'id'
    SubmitOnAsyncEvent = True
  end
  object BTN_DELETE: TIWButton [8]
    AlignWithMargins = False
    Left = 607
    Top = 132
    Width = 114
    Height = 30
    Caption = 'BTN_DELETE'
    Color = clBtnFace
    FriendlyName = 'BTN_DELETE'
    OnAsyncClick = BTN_DELETEAsyncClick
  end
  object STATUS: TIWComboBox [9]
    AlignWithMargins = False
    Left = 115
    Top = 52
    Width = 200
    Height = 25
    Css = 'form-control select2'
    StyleRenderOptions.RenderBorder = False
    OnAsyncChange = STATUSAsyncChange
    ItemIndex = -1
    FriendlyName = 'STATUS'
    NoSelectionText = 'N'#227'o Selecionado'
  end
end

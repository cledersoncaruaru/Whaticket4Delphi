inherited FrmTags: TFrmTags
  OnDestroy = IWAppFormDestroy
  OnShow = IWAppFormShow
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    OnAsyncClick = BTN_POSTAsyncClick
  end
  object BTN_ADICONAR: TIWButton [5]
    AlignWithMargins = False
    Left = 440
    Top = 58
    Width = 120
    Height = 30
    Caption = 'Adicionar Tag'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
    OnAsyncClick = BTN_ADICONARAsyncClick
  end
  object name: TIWEdit [6]
    AlignWithMargins = False
    Left = 143
    Top = 136
    Width = 170
    Height = 25
    Hint = 'Informe o Nome'
    OnHTMLTag = nameHTMLTag
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'name'
    SubmitOnAsyncEvent = True
    DataTypeOptions.StringCase = scUppercase
  end
  object color: TIWEdit [7]
    AlignWithMargins = False
    Left = 143
    Top = 167
    Width = 170
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'color'
    SubmitOnAsyncEvent = True
    DataType = stColor
  end
  object kanban: TIWCheckBox [8]
    AlignWithMargins = False
    Left = 144
    Top = 232
    Width = 121
    Height = 21
    Caption = 'kanban'
    Editable = True
    SubmitOnAsyncEvent = True
    Style = stNormal
    Checked = True
    FriendlyName = 'kanban'
  end
  object id: TIWEdit [9]
    AlignWithMargins = False
    Left = 72
    Top = 136
    Width = 65
    Height = 25
    Hint = 'Id'
    OnHTMLTag = nameHTMLTag
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'id'
    SubmitOnAsyncEvent = True
    DataTypeOptions.StringCase = scUppercase
  end
  object BTN_DELETE: TIWButton [10]
    AlignWithMargins = False
    Left = 604
    Top = 39
    Width = 114
    Height = 30
    Caption = 'BTN_DELETE'
    Color = clBtnFace
    FriendlyName = 'BTN_DELETE'
    OnAsyncClick = BTN_DELETEAsyncClick
  end
  object STATUS: TIWComboBox [11]
    AlignWithMargins = False
    Left = 72
    Top = 107
    Width = 200
    Height = 23
    Css = 'form-control select2'
    StyleRenderOptions.RenderBorder = False
    OnAsyncChange = STATUSAsyncChange
    ItemIndex = -1
    FriendlyName = 'STATUS'
    NoSelectionText = 'N'#227'o Selecionado'
  end
end

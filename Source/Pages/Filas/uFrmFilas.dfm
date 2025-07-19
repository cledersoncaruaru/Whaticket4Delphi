inherited FrmFilas: TFrmFilas
  Width = 1079
  Height = 437
  OnDestroy = IWAppFormDestroy
  OnShow = IWAppFormShow
  ExplicitWidth = 1079
  ExplicitHeight = 437
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    Top = 392
    OnAsyncClick = BTN_POSTAsyncClick
    ExplicitTop = 392
  end
  inherited BTN_CANCEL: TIWButton
    Top = 392
    ExplicitTop = 392
  end
  object name: TIWEdit [5]
    AlignWithMargins = False
    Left = 86
    Top = 117
    Width = 225
    Height = 21
    OnHTMLTag = nameHTMLTag
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'name'
    SubmitOnAsyncEvent = True
    DataTypeOptions.StringCase = scUppercase
  end
  object color: TIWEdit [6]
    AlignWithMargins = False
    Left = 317
    Top = 117
    Width = 122
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'color'
    SubmitOnAsyncEvent = True
    DataType = stColor
  end
  object greetingMessage: TIWMemo [7]
    AlignWithMargins = False
    Left = 72
    Top = 144
    Width = 497
    Height = 130
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    BGColor = clNone
    Editable = True
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    SubmitOnAsyncEvent = True
    FriendlyName = 'greetingMessage'
  end
  object BTN_OP_ADICIONAR: TIWButton [8]
    AlignWithMargins = False
    Left = 72
    Top = 312
    Width = 137
    Height = 30
    Caption = 'Op'#231#245'es - Adicionar'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
  end
  object BTN_ADICONAR: TIWButton [9]
    AlignWithMargins = False
    Left = 86
    Top = 54
    Width = 120
    Height = 30
    Css = 'form-control'
    Caption = 'Adicionar Filas'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
    OnAsyncClick = BTN_ADICONARAsyncClick
  end
  object whatsappId: TIWComboBox [10]
    AlignWithMargins = False
    Left = 72
    Top = 280
    Width = 259
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    FriendlyName = 'whatsappId'
    NoSelectionText = 'N'#227'o Selecionado'
  end
  object isDefault: TIWCheckBox [11]
    AlignWithMargins = False
    Left = 480
    Top = 96
    Width = 200
    Height = 21
    Caption = 'Default'
    Editable = True
    SubmitOnAsyncEvent = True
    Style = stNormal
    Checked = False
    FriendlyName = 'isDefault'
  end
  object STATUS: TIWComboBox [12]
    AlignWithMargins = False
    Left = 86
    Top = 90
    Width = 259
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    OnAsyncChange = STATUSAsyncChange
    ItemIndex = -1
    FriendlyName = 'STATUS'
    NoSelectionText = 'N'#227'o Selecionado'
  end
  object BTN_DELETE: TIWButton [13]
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
end

inherited FrmAgendamentos: TFrmAgendamentos
  Height = 442
  OnDestroy = IWAppFormDestroy
  OnShow = IWAppFormShow
  ExplicitHeight = 442
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    Left = 177
    Top = 409
    OnAsyncClick = BTN_POSTAsyncClick
    ExplicitLeft = 177
    ExplicitTop = 409
  end
  inherited BTN_CANCEL: TIWButton
    Top = 408
    ExplicitTop = 408
  end
  object BTN_ADICONAR: TIWButton [5]
    AlignWithMargins = False
    Left = 72
    Top = 71
    Width = 168
    Height = 30
    Css = 'form-control'
    Caption = 'Adicionar Agendamento'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
    OnAsyncClick = BTN_ADICONARAsyncClick
  end
  object descricao: TIWEdit [6]
    AlignWithMargins = False
    Left = 72
    Top = 168
    Width = 225
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'descricao'
    SubmitOnAsyncEvent = True
    DataTypeOptions.StringCase = scUppercase
  end
  object id: TIWEdit [7]
    AlignWithMargins = False
    Left = 72
    Top = 139
    Width = 57
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'id'
    SubmitOnAsyncEvent = True
  end
  object body: TIWMemo [8]
    AlignWithMargins = False
    Left = 72
    Top = 251
    Width = 497
    Height = 138
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    BGColor = clNone
    Editable = True
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    SubmitOnAsyncEvent = True
    FriendlyName = 'body'
  end
  object sentAt: TIWEdit [9]
    AlignWithMargins = False
    Left = 72
    Top = 197
    Width = 129
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'sentAt'
    SubmitOnAsyncEvent = True
    DataType = stDateTimeLocal
    DataTypeOptions.StringCase = scUppercase
  end
  object saveMessage: TIWCheckBox [10]
    AlignWithMargins = False
    Left = 72
    Top = 224
    Width = 121
    Height = 21
    Editable = True
    SubmitOnAsyncEvent = True
    Style = stNormal
    Checked = True
    FriendlyName = 'saveMessage'
  end
  object BTN_DELETE: TIWButton [11]
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
  object COMBO_ContactId: TIWSelect [12]
    AlignWithMargins = False
    Left = 135
    Top = 136
    Width = 341
    Height = 23
    Css = 'form-select select2-modal'
    ZIndex = 19000
    StyleRenderOptions.RenderBorder = False
    Font.Color = clNone
    Font.FontFamily = 'Verdana, Helvetica, Sans-Serif'
    Font.Size = 12
    Font.Style = []
    Font.PxSize = 16
    RequireSelection = False
    RenderCDNFiles = False
    SelectOptions = [soAllowClear, soCloseOnSelect, soPlaceholder]
    MultiSelect = True
    SelectMinCountForSearch = 0
    ItemIndex = -1
    FriendlyName = 'COMBO_ContactId'
    NoSelectionText = 'Selecione'
  end
  object STATUS: TIWSelect [13]
    AlignWithMargins = False
    Left = 72
    Top = 107
    Width = 185
    Height = 23
    ZIndex = 11000
    StyleRenderOptions.RenderBorder = False
    Font.Color = clNone
    Font.FontFamily = 'Verdana, Helvetica, Sans-Serif'
    Font.Size = 12
    Font.Style = []
    Font.PxSize = 16
    ItemsHaveValues = True
    RequireSelection = False
    RenderCDNFiles = False
    SelectOptions = [soAllowClear, soCloseOnSelect, soPlaceholder]
    SelectMinCountForSearch = 0
    ItemIndex = -1
    FriendlyName = 'STATUS'
    NoSelectionText = 'Selecione'
  end
end

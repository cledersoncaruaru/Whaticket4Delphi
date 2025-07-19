inherited FrmConexoes: TFrmConexoes
  Width = 790
  Height = 660
  OnDestroy = IWAppFormDestroy
  OnShow = IWAppFormShow
  ExplicitWidth = 790
  ExplicitHeight = 660
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    Left = 525
    Top = 608
    OnAsyncClick = BTN_POSTAsyncClick
    ExplicitLeft = 525
    ExplicitTop = 608
  end
  inherited BTN_CANCEL: TIWButton
    Left = 399
    Top = 608
    ExplicitLeft = 399
    ExplicitTop = 608
  end
  object NAME: TIWEdit [5]
    AlignWithMargins = False
    Left = 118
    Top = 76
    Width = 243
    Height = 25
    Hint = 'Informe o Nome'
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'NAME'
    SubmitOnAsyncEvent = True
    Text = 'NAME'
  end
  object GREETINGMESSAGE: TIWMemo [6]
    AlignWithMargins = False
    Left = 118
    Top = 107
    Width = 523
    Height = 94
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    BGColor = clNone
    Editable = True
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    SubmitOnAsyncEvent = True
    FriendlyName = 'GREETINGMESSAGE'
  end
  object OUTOFHOURSMESSAGE: TIWMemo [7]
    AlignWithMargins = False
    Left = 118
    Top = 307
    Width = 523
    Height = 94
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    BGColor = clNone
    Editable = True
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    SubmitOnAsyncEvent = True
    FriendlyName = 'OUTOFHOURSMESSAGE'
  end
  object RATINGMESSAGE: TIWMemo [8]
    AlignWithMargins = False
    Left = 118
    Top = 407
    Width = 523
    Height = 94
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    BGColor = clNone
    Editable = True
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    SubmitOnAsyncEvent = True
    FriendlyName = 'RATINGMESSAGE'
  end
  object instanceid: TIWEdit [9]
    AlignWithMargins = False
    Left = 118
    Top = 507
    Width = 523
    Height = 25
    Hint = 'instanceid'
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'instanceid'
    SubmitOnAsyncEvent = True
    Text = 'instanceid'
  end
  object SENDIDQUEUE: TIWComboBox [10]
    AlignWithMargins = False
    Left = 118
    Top = 565
    Width = 259
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    FriendlyName = 'SENDIDQUEUE'
  end
  object TIMESENDQUEUE: TIWComboBox [11]
    AlignWithMargins = False
    Left = 383
    Top = 565
    Width = 258
    Height = 21
    Hint = 'TIMESENDQUEUE'
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    FriendlyName = 'TIMESENDQUEUE'
  end
  object ISDEFAULT: TIWCheckBox [12]
    AlignWithMargins = False
    Left = 541
    Top = 77
    Width = 100
    Height = 21
    Caption = 'Conex'#227'o Padr'#227'o'
    Editable = True
    SubmitOnAsyncEvent = True
    Style = stNormal
    Checked = False
    FriendlyName = 'ISDEFAULT'
  end
  object BTN_ADICIONAR: TIWButton [13]
    AlignWithMargins = False
    Left = 601
    Top = 39
    Width = 120
    Height = 30
    Caption = 'Adicionar'
    Color = clBtnFace
    FriendlyName = 'BTN_ADICIONAR'
    OnAsyncClick = BTN_ADICIONARAsyncClick
  end
  object NUMBER: TIWEdit [14]
    AlignWithMargins = False
    Left = 367
    Top = 76
    Width = 168
    Height = 25
    Hint = 'NUMBER'
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'NUMBER'
    SubmitOnAsyncEvent = True
    Text = 'NUMBER'
  end
  object QRCODE: TIWLabel [15]
    AlignWithMargins = False
    Left = 656
    Top = 107
    Width = 57
    Height = 17
    HasTabOrder = False
    FriendlyName = 'QRCODE'
    Caption = 'QRCODE'
    RawText = True
  end
  object BTN_DELETE: TIWButton [16]
    AlignWithMargins = False
    Left = 24
    Top = 608
    Width = 120
    Height = 30
    Caption = 'BTN_DELETE'
    Color = clBtnFace
    FriendlyName = 'BTN_DELETE'
    OnAsyncClick = BTN_DELETEAsyncClick
  end
  object CONTADOR: TIWLabel [17]
    AlignWithMargins = False
    Left = 656
    Top = 136
    Width = 77
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CONTADOR'
    Caption = 'CONTADOR'
    RawText = True
  end
  object PAIRINGCODE: TIWLabel [18]
    AlignWithMargins = False
    Left = 656
    Top = 165
    Width = 90
    Height = 17
    HasTabOrder = False
    FriendlyName = 'PAIRINGCODE'
    Caption = 'PAIRINGCODE'
    RawText = True
  end
  object COMPLATIONMESSAGE: TIWMemo [19]
    AlignWithMargins = False
    Left = 118
    Top = 207
    Width = 523
    Height = 94
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    BGColor = clNone
    Editable = True
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    SubmitOnAsyncEvent = True
    FriendlyName = 'COMPLATIONMESSAGE'
  end
  object BTN_MODAL_FECHAR: TIWButton [20]
    AlignWithMargins = False
    Left = 241
    Top = 608
    Width = 120
    Height = 30
    Caption = 'Fechar Modal'
    Color = clBtnFace
    FriendlyName = 'BTN_MODAL_FECHAR'
    OnAsyncClick = BTN_MODAL_FECHARAsyncClick
  end
  object FILAS: TIWSelect [21]
    AlignWithMargins = False
    Left = 118
    Top = 536
    Width = 523
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
    FriendlyName = 'FILAS'
    NoSelectionText = 'Selecione'
  end
  object IWQrCode: TIWTimer
    Enabled = False
    Interval = 15000
    ShowAsyncLock = False
    OnAsyncTimer = IWQrCodeAsyncTimer
    Left = 440
    Top = 8
  end
end

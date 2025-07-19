inherited FrmUsuario: TFrmUsuario
  Width = 1009
  Height = 446
  OnDestroy = IWAppFormDestroy
  OnShow = IWAppFormShow
  ExplicitWidth = 1009
  ExplicitHeight = 446
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    Left = 360
    Top = 400
    OnAsyncClick = BTN_POSTAsyncClick
    ExplicitLeft = 360
    ExplicitTop = 400
  end
  inherited BTN_CANCEL: TIWButton
    Left = 504
    Top = 400
    ExplicitLeft = 504
    ExplicitTop = 400
  end
  object BTN_ADICIONAR: TIWButton [5]
    AlignWithMargins = False
    Left = 625
    Top = 58
    Width = 120
    Height = 30
    Caption = 'Adicionar'
    Color = clBtnFace
    FriendlyName = 'BTN_ADICIONAR'
    OnAsyncClick = BTN_ADICIONARAsyncClick
  end
  object USERQUEUES: TIWSelect [6]
    AlignWithMargins = False
    Left = 126
    Top = 166
    Width = 483
    Height = 33
    ZIndex = 11000
    StyleRenderOptions.RenderBorder = False
    Font.Color = clNone
    Font.FontFamily = 'Verdana, Helvetica, Sans-Serif'
    Font.Size = 12
    Font.Style = []
    Font.PxSize = 16
    RequireSelection = False
    SelectOptions = [soCloseOnSelect, soPlaceholder]
    MultiSelect = True
    SelectMinCountForSearch = 0
    ItemIndex = -1
    FriendlyName = 'USERQUEUES'
    NoSelectionText = 'Please select one'
  end
  object PROFILE: TIWSelect [7]
    AlignWithMargins = False
    Left = 383
    Top = 123
    Width = 155
    Height = 23
    ZIndex = 11000
    StyleRenderOptions.RenderBorder = False
    Font.Color = clNone
    Font.FontFamily = 'Verdana, Helvetica, Sans-Serif'
    Font.Size = 12
    Font.Style = []
    Font.PxSize = 16
    RequireSelection = False
    RenderCDNFiles = False
    SelectOptions = [soAllowClear, soCloseOnSelect, soPlaceholder]
    SelectMinCountForSearch = 0
    ItemIndex = -1
    Items.Strings = (
      'Admin'
      'User')
    FriendlyName = 'PROFILE'
    NoSelectionText = 'Please select one'
  end
  object EMAIL: TIWEdit [8]
    AlignWithMargins = False
    Left = 126
    Top = 121
    Width = 251
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'EMAIL'
    SubmitOnAsyncEvent = True
    Attributes = []
  end
  object NAME: TIWEdit [9]
    AlignWithMargins = False
    Left = 126
    Top = 83
    Width = 251
    Height = 32
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'NAME'
    SubmitOnAsyncEvent = True
  end
  object PASSWORDHASH: TIWEdit [10]
    AlignWithMargins = False
    Left = 383
    Top = 85
    Width = 226
    Height = 32
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'PASSWORDHASH'
    SubmitOnAsyncEvent = True
    OnAsyncExit = PASSWORDHASHAsyncExit
  end
end

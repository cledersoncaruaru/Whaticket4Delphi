inherited FrmConfiguracoes: TFrmConfiguracoes
  Width = 1013
  Height = 509
  OnDestroy = IWAppFormDestroy
  ExplicitWidth = 1013
  ExplicitHeight = 509
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    Left = 232
    Top = 448
    ExplicitLeft = 232
    ExplicitTop = 448
  end
  inherited BTN_CANCEL: TIWButton
    Left = 376
    Top = 448
    ExplicitLeft = 376
    ExplicitTop = 448
  end
  object USERQUEUES: TIWComboBox [5]
    AlignWithMargins = False
    Left = 101
    Top = 92
    Width = 179
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    Items.Strings = (
      'Habilitadas'
      'Desabilitadas')
    FriendlyName = 'USERQUEUES'
  end
  object IPIXC: TIWEdit [6]
    AlignWithMargins = False
    Left = 101
    Top = 274
    Width = 126
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'IPIXC'
    SubmitOnAsyncEvent = True
    Text = 'IPIXC'
  end
  object IWComboBox1: TIWComboBox [7]
    AlignWithMargins = False
    Left = 286
    Top = 92
    Width = 179
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    Items.Strings = (
      'Desabilitado'
      'Gerenciamento Por Fila')
    FriendlyName = 'USERQUEUES'
  end
  object IWComboBox2: TIWComboBox [8]
    AlignWithMargins = False
    Left = 471
    Top = 92
    Width = 179
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    Items.Strings = (
      'Ativado'
      'Desativado')
    FriendlyName = 'USERQUEUES'
  end
  object IWComboBox3: TIWComboBox [9]
    AlignWithMargins = False
    Left = 101
    Top = 123
    Width = 179
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    Items.Strings = (
      'N'#227'o Aceitar'
      'Aceitar')
    FriendlyName = 'USERQUEUES'
  end
  object IWComboBox4: TIWComboBox [10]
    AlignWithMargins = False
    Left = 286
    Top = 123
    Width = 179
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    Items.Strings = (
      'Texto')
    FriendlyName = 'USERQUEUES'
  end
  object IWComboBox5: TIWComboBox [11]
    AlignWithMargins = False
    Left = 471
    Top = 123
    Width = 179
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    Items.Strings = (
      'Desabilitado'
      'Habilitado')
    FriendlyName = 'USERQUEUES'
  end
  object IWComboBox6: TIWComboBox [12]
    AlignWithMargins = False
    Left = 101
    Top = 154
    Width = 179
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    Items.Strings = (
      'Desabilitado'
      'Habilitado')
    FriendlyName = 'USERQUEUES'
  end
  object IWLabel1: TIWLabel [13]
    AlignWithMargins = False
    Left = 101
    Top = 54
    Width = 101
    Height = 32
    Font.Color = clWebRED
    Font.Size = 18
    Font.Style = [fsBold]
    Font.PxSize = 24
    HasTabOrder = False
    FriendlyName = 'IWLabel1'
    Caption = 'OP'#199#213'ES'
  end
  object IWLabel2: TIWLabel [14]
    AlignWithMargins = False
    Left = 101
    Top = 198
    Width = 179
    Height = 32
    Font.Color = clWebRED
    Font.Size = 18
    Font.Style = [fsBold]
    Font.PxSize = 24
    HasTabOrder = False
    FriendlyName = 'IWLabel1'
    Caption = 'INTEGRA'#199#213'ES'
  end
  object TOKENIXC: TIWEdit [15]
    AlignWithMargins = False
    Left = 233
    Top = 275
    Width = 96
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'TOKENIXC'
    SubmitOnAsyncEvent = True
    Text = 'TOKENIXC'
  end
  object IWLabel3: TIWLabel [16]
    AlignWithMargins = False
    Left = 101
    Top = 236
    Width = 42
    Height = 32
    Font.Color = clWebRED
    Font.Size = 18
    Font.Style = [fsBold]
    Font.PxSize = 24
    HasTabOrder = False
    FriendlyName = 'IWLabel1'
    Caption = 'IXC'
  end
  object IWLabel4: TIWLabel [17]
    AlignWithMargins = False
    Left = 101
    Top = 308
    Width = 126
    Height = 32
    Font.Color = clWebRED
    Font.Size = 18
    Font.Style = [fsBold]
    Font.PxSize = 24
    HasTabOrder = False
    FriendlyName = 'IWLabel1'
    Caption = 'MK-AUTH'
  end
  object IPMKAUTH: TIWEdit [18]
    AlignWithMargins = False
    Left = 101
    Top = 346
    Width = 126
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'IPMKAUTH'
    SubmitOnAsyncEvent = True
    Text = 'IPMKAUTH'
  end
  object CLIENTIDMKAUTH: TIWEdit [19]
    AlignWithMargins = False
    Left = 231
    Top = 346
    Width = 96
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'CLIENTIDMKAUTH'
    SubmitOnAsyncEvent = True
    Text = 'CLIENTIDMKAUTH'
  end
  object CLIENTSECRETMKAUTH: TIWEdit [20]
    AlignWithMargins = False
    Left = 331
    Top = 346
    Width = 100
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'CLIENTSECRETMKAUTH'
    SubmitOnAsyncEvent = True
    Text = 'CLIENTSECRETMKAUTH'
  end
  object IWLabel5: TIWLabel [21]
    AlignWithMargins = False
    Left = 101
    Top = 377
    Width = 84
    Height = 32
    Font.Color = clWebRED
    Font.Size = 18
    Font.Style = [fsBold]
    Font.PxSize = 24
    HasTabOrder = False
    FriendlyName = 'IWLabel1'
    Caption = 'ASAAS'
  end
  object ASAAS: TIWEdit [22]
    AlignWithMargins = False
    Left = 101
    Top = 410
    Width = 332
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'ASAAS'
    SubmitOnAsyncEvent = True
    Text = 'ASAAS'
  end
end

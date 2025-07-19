inherited FrmContatos: TFrmContatos
  Width = 855
  Height = 684
  OnDestroy = IWAppFormDestroy
  Css = 'form-control'
  ExplicitWidth = 855
  ExplicitHeight = 684
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    Left = 256
    Top = 392
    OnAsyncClick = BTN_POSTAsyncClick
    ExplicitLeft = 256
    ExplicitTop = 392
  end
  inherited BTN_CANCEL: TIWButton
    Left = 392
    Top = 392
    ExplicitLeft = 392
    ExplicitTop = 392
  end
  object BTN_IMPORTAR: TIWButton [5]
    AlignWithMargins = False
    Left = 346
    Top = 120
    Width = 120
    Height = 30
    Caption = 'Importar Contatos'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
  end
  object BTN_ADICONAR: TIWButton [6]
    AlignWithMargins = False
    Left = 472
    Top = 120
    Width = 120
    Height = 30
    Caption = 'Adicionar Contatos'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
    OnAsyncClick = BTN_ADICONARAsyncClick
  end
  object BTN_EXPORTAR: TIWButton [7]
    AlignWithMargins = False
    Left = 598
    Top = 120
    Width = 120
    Height = 30
    Caption = 'Exportar Contatos'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
  end
  object NAME: TIWEdit [8]
    AlignWithMargins = False
    Left = 56
    Top = 168
    Width = 170
    Height = 25
    Hint = 'Informe o Nome'
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'NAME'
    SubmitOnAsyncEvent = True
    Text = 'NAME'
  end
  object NUMBER: TIWEdit [9]
    AlignWithMargins = False
    Left = 232
    Top = 168
    Width = 121
    Height = 25
    Hint = '55 00 0 0000-0000'
    Css = 'form-control fixo'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'NUMBER'
    SubmitOnAsyncEvent = True
    Text = 'NUMBER'
  end
  object EMAIL: TIWEdit [10]
    AlignWithMargins = False
    Left = 56
    Top = 199
    Width = 297
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'EMAIL'
    SubmitOnAsyncEvent = True
    Text = 'EMAIL'
    DataTypeOptions.StringCase = scLowercase
  end
  object ADICIONAIS: TIWEdit [11]
    AlignWithMargins = False
    Left = 56
    Top = 230
    Width = 297
    Height = 25
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'ADICIONAIS'
    SubmitOnAsyncEvent = True
    Text = 'INFORMA'#199#213'ES ADICIONAIS'
  end
  object IWButton4: TIWButton [12]
    AlignWithMargins = False
    Left = 74
    Top = 261
    Width = 255
    Height = 30
    Caption = 'Adicionar Informa'#231#245'es'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
  end
  object BTN_MODAL_CANCEL: TIWButton [13]
    AlignWithMargins = False
    Left = 130
    Top = 297
    Width = 120
    Height = 30
    Caption = 'Cancelar'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
  end
  object BTN_MODAL_ADICIONAR: TIWButton [14]
    AlignWithMargins = False
    Left = 256
    Top = 297
    Width = 120
    Height = 30
    Caption = 'Adicionar'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
  end
  object FILAS: TIWComboBox [15]
    AlignWithMargins = False
    Left = 440
    Top = 199
    Width = 233
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    FriendlyName = 'FILAS'
  end
  object IWLabel1: TIWLabel [16]
    AlignWithMargins = False
    Left = 440
    Top = 162
    Width = 180
    Height = 31
    Font.Color = clWebRED
    Font.Size = 17
    Font.Style = [fsBold]
    Font.PxSize = 22
    HasTabOrder = False
    FriendlyName = 'IWLabel1'
    Caption = 'MODAL TICKET'
  end
  object Ds: TDataSource
    Left = 416
    Top = 8
  end
end

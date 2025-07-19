inherited FrmRespostas: TFrmRespostas
  OnDestroy = IWAppFormDestroy
  OnAsyncPageLoaded = IWAppFormAsyncPageLoaded
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    OnAsyncClick = BTN_POSTAsyncClick
  end
  object BTN_ADICONAR: TIWButton [5]
    AlignWithMargins = False
    Left = 104
    Top = 52
    Width = 120
    Height = 30
    Css = 'form-control'
    Caption = 'Nova Resposta'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
    OnAsyncClick = BTN_ADICONARAsyncClick
  end
  object MESSAGE: TIWMemo [6]
    AlignWithMargins = False
    Left = 96
    Top = 128
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
    FriendlyName = 'MESSAGE'
  end
  object SHORTCODE: TIWEdit [7]
    AlignWithMargins = False
    Left = 104
    Top = 88
    Width = 225
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'SHORTCODE'
    SubmitOnAsyncEvent = True
  end
  object BTN_EXCLUIR: TIWButton [8]
    AlignWithMargins = False
    Left = 581
    Top = 320
    Width = 137
    Height = 30
    Caption = 'BTN_EXCLUIR'
    Color = clBtnFace
    FriendlyName = 'BTN_EXCLUIR'
    OnAsyncClick = BTN_EXCLUIRAsyncClick
  end
end

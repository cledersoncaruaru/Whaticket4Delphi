inherited FrmLogin: TFrmLogin
  Width = 1129
  Height = 415
  OnShow = IWAppFormShow
  ExplicitWidth = 1129
  ExplicitHeight = 415
  DesignLeft = 2
  DesignTop = 2
  object EMAIL: TIWEdit [5]
    AlignWithMargins = False
    Left = 184
    Top = 112
    Width = 200
    Height = 32
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'EMAIL'
    SubmitOnAsyncEvent = True
    Text = 'admin@admin.com'
  end
  object SENHA: TIWEdit [6]
    AlignWithMargins = False
    Left = 184
    Top = 160
    Width = 200
    Height = 32
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'SENHA'
    SubmitOnAsyncEvent = True
    DataType = stPassword
  end
  object BTN_LOGIN: TIWButton [7]
    AlignWithMargins = False
    Left = 184
    Top = 216
    Width = 120
    Height = 30
    Caption = 'BTN_LOGIN'
    Color = clBtnFace
    FriendlyName = 'BTN_LOGIN'
    OnAsyncClick = BTN_LOGINAsyncClick
  end
  object ID_SESSAO: TIWEdit [8]
    AlignWithMargins = False
    Left = 408
    Top = 112
    Width = 614
    Height = 32
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'SENHA'
    SubmitOnAsyncEvent = True
    DataType = stPassword
  end
  object BTN_SESSAO: TIWButton [9]
    AlignWithMargins = False
    Left = 408
    Top = 150
    Width = 120
    Height = 30
    Caption = 'BTN_SESSAO'
    Color = clBtnFace
    FriendlyName = 'BTN_SESSAO'
  end
end

inherited FrmAtendimento: TFrmAtendimento
  Width = 1363
  Height = 630
  OnRender = IWAppFormRender
  OnDestroy = IWAppFormDestroy
  OnShow = IWAppFormShow
  OnAsyncPageLoaded = IWAppFormAsyncPageLoaded
  ExplicitWidth = 1363
  ExplicitHeight = 630
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    Left = 106
    Top = 488
    ExplicitLeft = 106
    ExplicitTop = 488
  end
  inherited BTN_CANCEL: TIWButton
    Left = 232
    Top = 488
    ExplicitLeft = 232
    ExplicitTop = 488
  end
  object MEMOCHAT: TIWMemo [5]
    AlignWithMargins = False
    Left = 403
    Top = 71
    Width = 909
    Height = 255
    Css = 'form-contol'
    StyleRenderOptions.RenderBorder = False
    BGColor = clNone
    Editable = True
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    SubmitOnAsyncEvent = True
    FriendlyName = 'chat-message'
  end
  object BTN_CRIAR: TIWButton [6]
    AlignWithMargins = False
    Left = 16
    Top = 128
    Width = 89
    Height = 30
    Caption = 'NOVO'
    Color = clBtnFace
    FriendlyName = 'BTN_CRIAR'
  end
  object COMBO_FILAS: TIWComboBox [7]
    AlignWithMargins = False
    Left = 183
    Top = 128
    Width = 121
    Height = 21
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    FriendlyName = 'COMBO_FILAS'
  end
  object IWLabel1: TIWLabel [8]
    AlignWithMargins = False
    Left = 25
    Top = 240
    Width = 102
    Height = 32
    Font.Color = clWebRED
    Font.Size = 18
    Font.Style = [fsBold]
    Font.PxSize = 24
    HasTabOrder = False
    FriendlyName = 'IWLabel1'
    Caption = 'BUSCAR'
  end
  object IWEdit1: TIWEdit [9]
    AlignWithMargins = False
    Left = 16
    Top = 278
    Width = 200
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'IWEdit1'
    SubmitOnAsyncEvent = True
    Text = 'IWEdit1'
  end
  object IWComboBox1: TIWComboBox [10]
    AlignWithMargins = False
    Left = 276
    Top = 278
    Width = 121
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    FriendlyName = 'COMBO_FILAS'
  end
  object IWComboBox2: TIWComboBox [11]
    AlignWithMargins = False
    Left = 16
    Top = 305
    Width = 381
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    FriendlyName = 'COMBO_FILAS'
  end
  object IWComboBox3: TIWComboBox [12]
    AlignWithMargins = False
    Left = 16
    Top = 332
    Width = 381
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    ItemIndex = -1
    FriendlyName = 'COMBO_FILAS'
  end
  object ATENDIMENTO_COUNT: TIWLabel [13]
    AlignWithMargins = False
    Left = 30
    Top = 359
    Width = 152
    Height = 17
    HasTabOrder = False
    FriendlyName = 'ATENDIMENTO_COUNT'
    Caption = 'ATENDIMENTO_COUNT'
    RawText = True
  end
  object AGUARDANDO_COUNT: TIWLabel [14]
    AlignWithMargins = False
    Left = 31
    Top = 380
    Width = 150
    Height = 17
    HasTabOrder = False
    FriendlyName = 'AGUARDANDO_COUNT'
    Caption = 'AGUARDANDO_COUNT'
    RawText = True
  end
  object CARDATENDIMENTO: TIWLabel [15]
    AlignWithMargins = False
    Left = 30
    Top = 401
    Width = 135
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CARDATENDIMENTO'
    Caption = 'CARDATENDIMENTO'
    RawText = True
  end
  object CARDAGUARDANDO: TIWLabel [16]
    AlignWithMargins = False
    Left = 32
    Top = 424
    Width = 133
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CARDAGUARDANDO'
    Caption = 'CARDAGUARDANDO'
    RawText = True
  end
  object CAR_CHAT_TOP: TIWLabel [17]
    AlignWithMargins = False
    Left = 403
    Top = 15
    Width = 316
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CAR_CHAT_TOP'
    Caption = 'DADOS CARD TOP - INFORMA'#199#213'ES DE USUARIO'
    RawText = True
  end
  object LABEL_CHAT: TIWLabel [18]
    AlignWithMargins = False
    Left = 403
    Top = 44
    Width = 35
    Height = 17
    HasTabOrder = False
    FriendlyName = 'LABEL_CHAT'
    Caption = 'CHAT'
    RawText = True
  end
  object BTN_RETORNA: TIWButton [19]
    AlignWithMargins = False
    Left = 1060
    Top = 15
    Width = 80
    Height = 42
    Caption = 'Retornar'
    Color = clBtnFace
    FriendlyName = 'BTN_RETORNA'
    OnAsyncClick = BTN_RETORNAAsyncClick
  end
  object BTN_RESOLVER: TIWButton [20]
    AlignWithMargins = False
    Left = 1146
    Top = 15
    Width = 80
    Height = 42
    Caption = 'Resolver'
    Color = clBtnFace
    FriendlyName = 'BTN_RESOLVER'
  end
  object BTN_OPCOES: TIWButton [21]
    AlignWithMargins = False
    Left = 1232
    Top = 15
    Width = 80
    Height = 42
    Caption = 'Options'
    Color = clBtnFace
    FriendlyName = 'BTN_OPCOES'
  end
  object BTN_ENVIAR: TIWButton [22]
    AlignWithMargins = False
    Left = 1192
    Top = 479
    Width = 120
    Height = 30
    Css = 'form-control'
    Caption = 'Enviar Msg'
    Color = clBtnFace
    FriendlyName = 'BTN_POST'
    OnAsyncClick = Btn_EnviarAsyncClick
  end
  object EDT_MESSAGE_: TIWEdit [23]
    AlignWithMargins = False
    Left = 403
    Top = 479
    Width = 783
    Height = 32
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    DoSubmitValidation = False
    FriendlyName = 'EDT_MESSAGE_'
    SubmitOnAsyncEvent = False
    OnAsyncKeyPress = EDT_MESSAGE_AsyncKeyPress
    Text = 'Ol'#225' Tudo Bem'
    DataTypeOptions.NumberType = ntText
  end
  object EDT_MESSAGE: TIWMemo [24]
    AlignWithMargins = False
    Left = 403
    Top = 332
    Width = 909
    Height = 44
    Css = 'form-contol'
    StyleRenderOptions.RenderBorder = False
    BGColor = clNone
    Editable = True
    InvisibleBorder = False
    HorizScrollBar = False
    VertScrollBar = True
    Required = False
    SubmitOnAsyncEvent = True
    FriendlyName = 'chat-message'
    OnAsyncKeyPress = EDT_MESSAGEAsyncKeyPress
  end
  object BTN_ATUALIZAR_MENSAGENS: TIWButton [25]
    AlignWithMargins = False
    Left = 974
    Top = 16
    Width = 80
    Height = 42
    Caption = 'Retornar'
    Color = clBtnFace
    FriendlyName = 'BTN_ATUALIZAR_MENSAGENS'
    OnAsyncClick = BTN_RETORNAAsyncClick
  end
  object MENSAGEM_UPDATE: TIWLabel [26]
    AlignWithMargins = False
    Left = 198
    Top = 81
    Width = 136
    Height = 17
    HasTabOrder = False
    FriendlyName = 'MENSAGEM_UPDATE'
    Caption = 'MENSAGEM_UPDATE'
    RawText = True
  end
  object UPFILE: TIWFileUploader [27]
    AlignWithMargins = False
    Left = 403
    Top = 529
    Width = 400
    Height = 60
    TextStrings.DragText = 'Drop files here to upload'
    TextStrings.UploadButtonText = 'Upload a file'
    TextStrings.CancelButtonText = 'Cancel'
    TextStrings.UploadErrorText = 'Upload failed'
    TextStrings.MultipleFileDropNotAllowedText = 'You may only drop a single file'
    TextStrings.OfTotalText = 'of'
    TextStrings.RemoveButtonText = 'Remove'
    TextStrings.TypeErrorText = 
      '{file} has an invalid extension. Only {extensions} files are all' +
      'owed.'
    TextStrings.SizeErrorText = '{file} is too large, maximum file size is {sizeLimit}.'
    TextStrings.MinSizeErrorText = '{file} is too small, minimum file size is {minSizeLimit}.'
    TextStrings.EmptyErrorText = '{file} is empty, please select files again without it.'
    TextStrings.NoFilesErrorText = 'No files to upload.'
    TextStrings.OnLeaveWarningText = 
      'The files are being uploaded, if you leave now the upload will b' +
      'e cancelled.'
    Style.ButtonOptions.Alignment = taCenter
    Style.ButtonOptions.Font.Color = clWebWHITE
    Style.ButtonOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
    Style.ButtonOptions.Font.Size = 10
    Style.ButtonOptions.Font.Style = []
    Style.ButtonOptions.Font.PxSize = 13
    Style.ButtonOptions.FromColor = clWebMAROON
    Style.ButtonOptions.ToColor = clWebMAROON
    Style.ButtonOptions.Height = 30
    Style.ButtonOptions.Width = 200
    Style.ButtonHoverOptions.Alignment = taCenter
    Style.ButtonHoverOptions.Font.Color = clWebWHITE
    Style.ButtonHoverOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
    Style.ButtonHoverOptions.Font.Size = 10
    Style.ButtonHoverOptions.Font.Style = []
    Style.ButtonHoverOptions.Font.PxSize = 13
    Style.ButtonHoverOptions.FromColor = 214
    Style.ButtonHoverOptions.ToColor = 214
    Style.ListOptions.Alignment = taLeftJustify
    Style.ListOptions.Font.Color = clWebBLACK
    Style.ListOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
    Style.ListOptions.Font.Size = 10
    Style.ListOptions.Font.Style = []
    Style.ListOptions.Font.PxSize = 13
    Style.ListOptions.FromColor = clWebGOLD
    Style.ListOptions.ToColor = clWebGOLD
    Style.ListOptions.Height = 30
    Style.ListOptions.Width = 0
    Style.ListSuccessOptions.Alignment = taLeftJustify
    Style.ListSuccessOptions.Font.Color = clWebWHITE
    Style.ListSuccessOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
    Style.ListSuccessOptions.Font.Size = 10
    Style.ListSuccessOptions.Font.Style = []
    Style.ListSuccessOptions.Font.PxSize = 13
    Style.ListSuccessOptions.FromColor = clWebFORESTGREEN
    Style.ListSuccessOptions.ToColor = clWebFORESTGREEN
    Style.ListErrorOptions.Alignment = taLeftJustify
    Style.ListErrorOptions.Font.Color = clWebWHITE
    Style.ListErrorOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
    Style.ListErrorOptions.Font.Size = 10
    Style.ListErrorOptions.Font.Style = []
    Style.ListErrorOptions.Font.PxSize = 13
    Style.ListErrorOptions.FromColor = clWebRED
    Style.ListErrorOptions.ToColor = clWebRED
    Style.DropAreaOptions.Alignment = taCenter
    Style.DropAreaOptions.Font.Color = clWebWHITE
    Style.DropAreaOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
    Style.DropAreaOptions.Font.Size = 10
    Style.DropAreaOptions.Font.Style = []
    Style.DropAreaOptions.Font.PxSize = 13
    Style.DropAreaOptions.FromColor = clWebDARKORANGE
    Style.DropAreaOptions.ToColor = clWebDARKORANGE
    Style.DropAreaOptions.Height = 60
    Style.DropAreaOptions.Width = 0
    Style.DropAreaActiveOptions.Alignment = taCenter
    Style.DropAreaActiveOptions.Font.Color = clWebWHITE
    Style.DropAreaActiveOptions.Font.FontFamily = 'Arial, Sans-Serif, Verdana'
    Style.DropAreaActiveOptions.Font.Size = 10
    Style.DropAreaActiveOptions.Font.Style = []
    Style.DropAreaActiveOptions.Font.PxSize = 13
    Style.DropAreaActiveOptions.FromColor = clWebLIMEGREEN
    Style.DropAreaActiveOptions.ToColor = clWebLIMEGREEN
    Style.DropAreaActiveOptions.Height = 60
    Style.DropAreaActiveOptions.Width = 0
    CssClasses.Strings = (
      'button='
      'button-hover='
      'drop-area='
      'drop-area-active='
      'drop-area-disabled='
      'list='
      'upload-spinner='
      'progress-bar='
      'upload-file='
      'upload-size='
      'upload-listItem='
      'upload-cancel='
      'upload-success='
      'upload-fail='
      'success-icon='
      'fail-icon=')
    OnAsyncUploadCompleted = UPFILEAsyncUploadCompleted
    OnAsyncUploadSuccess = UPFILEAsyncUploadSuccess
    FriendlyName = 'UPFILE'
  end
  object LISTA_UPLOAD: TIWLabel [28]
    AlignWithMargins = False
    Left = 31
    Top = 465
    Width = 93
    Height = 17
    HasTabOrder = False
    FriendlyName = 'LISTA_UPLOAD'
    Caption = 'LISTA_UPLOAD'
    RawText = True
  end
  object CARDRESOLVIDOS: TIWLabel [29]
    AlignWithMargins = False
    Left = 32
    Top = 445
    Width = 118
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CARDRESOLVIDOS'
    Caption = 'CARDRESOLVIDOS'
    RawText = True
  end
  object MONITORAMENSAGEM: TIWMonitor
    Enabled = False
    Interval = 1000
    OnAsyncEvent = MONITORAMENSAGEMAsyncEvent
    Left = 240
    Top = 16
  end
  object SocketConnection1: TSocketConnection
    Left = 240
    Top = 168
  end
end

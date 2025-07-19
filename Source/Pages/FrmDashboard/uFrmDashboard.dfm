inherited FrmDashboard: TFrmDashboard
  Width = 1101
  Height = 591
  OnShow = IWAppFormShow
  ExplicitWidth = 1101
  ExplicitHeight = 591
  DesignLeft = 2
  DesignTop = 2
  inherited BTN_POST: TIWButton
    Left = 400
    Top = 528
    ExplicitLeft = 400
    ExplicitTop = 528
  end
  inherited BTN_CANCEL: TIWButton
    Left = 544
    Top = 528
    ExplicitLeft = 544
    ExplicitTop = 528
  end
  object CADATENDIMENTOSEMATENDIMENTOS: TIWLabel [5]
    AlignWithMargins = False
    Left = 50
    Top = 140
    Width = 261
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CADATENDIMENTOSEMATENDIMENTOS'
    Caption = 'CADATENDIMENTOSEMATENDIMENTOS'
    RawText = True
  end
  object CADATENDIMENTOSFINALIZADOS: TIWLabel [6]
    AlignWithMargins = False
    Left = 334
    Top = 140
    Width = 218
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CADATENDIMENTOSFINALIZADOS'
    Caption = 'CADATENDIMENTOSFINALIZADOS'
    RawText = True
  end
  object CADATENDIMENTOSAGUARDANDO: TIWLabel [7]
    AlignWithMargins = False
    Left = 550
    Top = 140
    Width = 231
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CADATENDIMENTOSAGUARDANDO'
    Caption = 'CADATENDIMENTOSAGUARDANDO'
    RawText = True
  end
  object CARDCONTATOS: TIWLabel [8]
    AlignWithMargins = False
    Left = 56
    Top = 180
    Width = 110
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CARDCONTATOS'
    Caption = 'CARDCONTATOS'
    RawText = True
  end
  object CARDAGENDAMENTOS: TIWLabel [9]
    AlignWithMargins = False
    Left = 172
    Top = 180
    Width = 150
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CARDAGENDAMENTOS'
    Caption = 'CARDAGENDAMENTOS'
    RawText = True
  end
  object CARDTEMPOMEDOATENDIMENTO: TIWLabel [10]
    AlignWithMargins = False
    Left = 328
    Top = 180
    Width = 224
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CARDTEMPOMEDOATENDIMENTO'
    Caption = 'CARDTEMPOMEDOATENDIMENTO'
    RawText = True
  end
  object CARDTEMPOMEDIOESPERA: TIWLabel [11]
    AlignWithMargins = False
    Left = 558
    Top = 180
    Width = 177
    Height = 17
    HasTabOrder = False
    FriendlyName = 'CARDTEMPOMEDIOESPERA'
    Caption = 'CARDTEMPOMEDIOESPERA'
    RawText = True
  end
  object DATAINI: TIWEdit [12]
    AlignWithMargins = False
    Left = 63
    Top = 226
    Width = 121
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'DATAINI'
    SubmitOnAsyncEvent = True
    OnAsyncChange = DATAINIAsyncChange
    DataType = stDate
    DataTypeOptions.StringCase = scUppercase
  end
  object DATAFIM: TIWEdit [13]
    AlignWithMargins = False
    Left = 190
    Top = 226
    Width = 121
    Height = 21
    Css = 'form-control'
    StyleRenderOptions.RenderBorder = False
    FriendlyName = 'DATAFIM'
    SubmitOnAsyncEvent = True
    OnAsyncChange = DATAFIMAsyncChange
    DataType = stDate
    DataTypeOptions.StringCase = scUppercase
  end
end

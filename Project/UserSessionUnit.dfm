object IWUserSession: TIWUserSession
  OnCreate = IWUserSessionBaseCreate
  OnDestroy = IWUserSessionBaseDestroy
  Height = 282
  Width = 494
  object Conexao: TFDConnection
    Params.Strings = (
      'Server='
      'Port='
      'DriverID=PG')
    LoginPrompt = False
    Left = 24
    Top = 18
  end
  object DRIVER: TFDPhysPgDriverLink
    Left = 24
    Top = 74
  end
  object ConexaoEvolution: TFDConnection
    Params.Strings = (
      'Server='
      'DriverID=PG')
    LoginPrompt = False
    Left = 139
    Top = 24
  end
  object Qry: TFDQuery
    Connection = Conexao
    SQL.Strings = (
      'select teste from "Tags"')
    Left = 32
    Top = 160
    object Qryteste: TBlobField
      FieldName = 'teste'
      Origin = 'teste'
    end
  end
end

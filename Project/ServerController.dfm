object IWServerController: TIWServerController
  OnDestroy = IWServerControllerBaseDestroy
  AppName = 'Whaticket4D'
  Description = 'Whaticket For Intraweb'
  DisplayName = 'Whaticket For Intraweb'
  Port = 3001
  Version = '16.0.11'
  ShowStartParams = False
  ExceptionLogger.HtmlReportInfos = [riAppInfo, riExceptionInfo, riIWAppInfo, riStackTrace, riRequestInfo]
  JavaScriptOptions.RenderjQuery = False
  SecurityOptions.CorsOrigin = '*'
  SecurityOptions.MaxActiveSessionsPerIp = 50
  HttpSysOptions.VirtualHostNames = 'zapzap.gescomweb.com.br'
  SessionOptions.SessionTimeout = 240
  SessionOptions.LockSessionTimeout = 490000
  SessionOptions.RestartExpiredSession = True
  OnConfig = IWServerControllerBaseConfig
  OnException = IWServerControllerBaseException
  OnNewSession = IWServerControllerBaseNewSession
  LockerOptions.CustomLockerAnimationFile = 'aguarde.svg'
  LockerOptions.Style = lsDark
  LockerOptions.Caption = 'Aguarde ...'
  ServerMonitorOptions.Enabled = True
  ServerMonitorOptions.IntervalMinutes = 1
  Height = 310
  Width = 342
end

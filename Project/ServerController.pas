unit ServerController;
interface
uses
  SysUtils, Classes, IWServerControllerBase, IWBaseForm, HTTPApp,
  // For OnNewSession Event
  UserSessionUnit, IWApplication, IWAppForm, IW.Browser.Browser,
  IW.HTTP.Request, IW.HTTP.Reply,
  App.Config,IWDiscord,uWorkerThread,IW.Common.AppInfo;

type
  TIWServerController = class(TIWServerControllerBase)
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication);
    procedure IWServerControllerBaseConfig(Sender: TObject);
    procedure IWServerControllerBaseException(AApplication: TIWApplication;
      AException: Exception; var Handled: Boolean);
    procedure IWServerControllerBaseDestroy(Sender: TObject);
  private
    { Private declarations }
    FWorkerThread: TWorkerThread;
  public
    { Public declarations }
  end;
  function UserSession: TIWUserSession;
  function IWServerController: TIWServerController;

implementation
{$R *.dfm}
uses
  IWInit, IWGlobal, IW.Parser.Files, IWTemplateProcessorHTML,IW.Content.API,IW.Content.Handlers;


function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

function UserSession: TIWUserSession;
begin
  Result := TIWUserSession(WebApplication.Data);
end;
{ TIWServerController }
procedure TIWServerController.IWServerControllerBaseConfig(Sender: TObject);
var
AppName:String;
begin


    JavaScriptOptions.RenderjQuery := False;
    SecurityOptions.CheckSameUA    := False;
    SecurityOptions.CorsOrigin     := '*';
    ExceptionLogger.Enabled        := True;
    DisableTemplateCacheOnDebug    := True;

    ExceptionLogger.FilePath       := TIWAppInfo.GetAppPath  + '\Files\LogError\';
    if not DirectoryExists(ExceptionLogger.FilePath) then
           forceDirectories(ExceptionLogger.FilePath);

      SSLOptions.EnableACME    := True;
    {$IFDEF DEBUG}
      SSLOptions.NonSSLRequest := nsAccept;
      SSLOptions.Port          := 0;
    {$ELSE}
      SSLOptions.NonSSLRequest := nsRedirect;
      SSLOptions.Port          := 443;
    {$ENDIF}


    AppName := AppConfig.AppName;

   RegisterContentType('application/json');

  with THandlers.Add('', 'chatmessage', TContentAPI.Create) do begin
    CanStartSession      := True;
    RequiresSessionStart := False;
  end;

   FWorkerThread         := TWorkerThread.Create('Verify Schedules ', 2000); // once each 2 Segundos
   FWorkerThread.Start;

end;

procedure TIWServerController.IWServerControllerBaseDestroy(Sender: TObject);
begin
FWorkerThread.Free;
end;

procedure TIWServerController.IWServerControllerBaseException(
  AApplication: TIWApplication; AException: Exception; var Handled: Boolean);
begin

//     UserSession.Logs.SendLog('Error',
//         'Empresa:'+UserSession.Clipboard['Loguin_company'].s +sLineBreak+
//        'Aplicação:'+   NomeAplicacao+sLineBreak+
//        '- Data Hora : '+ DateTimeToStr(now) +sLineBreak+
//        '- CNPJ      : '+ ''+sLineBreak+
//        '- Empresa   : '+ ''+ sLineBreak+
//        '- Usuario   : '+ '' +' - '+''+sLineBreak+
//        '- Erro      : '+ AException.Message+sLineBreak+
//        'StackTrace'+AException.StackTrace+sLineBreak+
//        'ClassName'+AException.ClassName+sLineBreak+
//        'QualifiedClassName'+AException.QualifiedClassName);

// Log Completo = AException.StackTrace

end;

procedure TIWServerController.IWServerControllerBaseNewSession(
  ASession: TIWApplication);
begin
  ASession.Data := TIWUserSession.Create(nil, ASession);
  {$IFDEF DEBUG}
   TIWTemplateCache.Instance.ClearCache;
{$ENDIF}

end;
initialization
  TIWServerController.SetServerControllerClass;
end.

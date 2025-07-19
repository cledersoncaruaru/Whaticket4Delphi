unit Integracao.Discord;

interface

uses
  System.SysUtils,
  App.Config,
  IWDiscord;

type
  TDiscordLogger = class

  private

  public
    FEmpresa, FUsuario: string;
    function SendJson(const Msg: string): Boolean;
    function SendLog(const Titulo, NomeUnit, Funcao, Msg: string): Boolean;
  end;

implementation

{ TDiscordLogger }

function TDiscordLogger.SendJson(const Msg: string): Boolean;
begin
  TIWDiscordHelper.SendMessageAsyncEx(AppConfig.CDiscordToken, Msg, '');
  Result := True;
end;

function TDiscordLogger.SendLog(const Titulo, NomeUnit, Funcao, Msg: string):
  Boolean;
begin

  TIWDiscordHelper.SendMessageAsyncEx(
    AppConfig.CDiscordToken,
    ' - Titulo: ' + Titulo + sLineBreak +
    ' - DataHora: ' + DateTimeToStr(now) + ' - ' + sLineBreak +
    ' - Aplicação:' + AppConfig.cNome_Aplicacao + sLineBreak +
    ' - Empresa: ' + FEmpresa + sLineBreak +
    ' - Form/Unit :' + NomeUnit + sLineBreak +
    ' - Função :' + Funcao + sLineBreak +
    ' - Usuário: ' + FUsuario + sLineBreak +
    ' - Mensagem:' + Msg, '');

  Result := True;
end;

end.


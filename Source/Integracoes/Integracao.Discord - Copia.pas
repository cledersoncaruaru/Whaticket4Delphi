unit Integracao.Discord;

interface

uses
  ServerController,
  App.Config,

  IWTelegram,
  IWDiscord,
  System.SysUtils,

  Tipos.Types,
  Functions.Strings;

  Function Send_Log_Navegacao(Page:String):Boolean;
  function Send_Log_Acao(Acao:String):Boolean;
  Function SendLog(Titulo,NomeUnit,Funcao:string; Msg:String) :Boolean;
  Function SendJson(Msg:String) :Boolean;
  


implementation

Function SendJson(Msg:String) :Boolean;
var
   CNPJ : string;
Begin

  TIWDiscordHelper.SendMessageAsync( AppConfig.CDiscordToken,Msg,'');




  Result :=True;
end;



Function SendLog(Titulo,NomeUnit,Funcao:string; Msg:String) :Boolean;
var
   CNPJ : string;
Begin

  TIWDiscordHelper.SendMessageAsync(  AppConfig.CDiscordToken,
                                      ' - Titulo: '+ Titulo+sLineBreak+
                                      ' - DataHora: '+DateTimeToStr(now)  +' - '+sLineBreak+
                                      ' - Aplica��o:'+AppConfig.cNome_Aplicacao+sLineBreak+
                                      ' - Empresa: '+UserSession.Clipboard['Loguin_company'].s+sLineBreak+
                                      ' - Form/Unit :'+NomeUnit+sLineBreak+
                                      ' - Fun��o :'+Funcao+sLineBreak+
                                      ' - Usu�rio: '+UserSession.Clipboard['Loguin_email'].s+sLineBreak+
                                      ' - Mensagem:'+Msg,'');
  Result :=True;
end;

function Send_Log_Acao(Acao:String):Boolean;
var
   CNPJ : string;
begin
  Result :=  False;

  try
    Result := True;
  except
      raise;
  end;
end;



Function Send_Log_Navegacao(Page:String):Boolean;
var
 Tipo : LongInt;
 CNPJ : string;
Begin

  Result := False;

  try

//    case Tipo of
//
//      0: begin
//           UserType := tpCliente;
//           SendLog(NomeAplicacao+' -' ,' CNPJ: '+CNPJ+' Modulo : Cliente - Usu�rio: '+FUSERNAME+' acessou a pagina '+Page);
//         end;
//
//      1: begin
//           UserType := tpRevenda;
//           SendLog(NomeAplicacao+' -' ,' CNPJ: '+CNPJ+' Modulo : Revenda - Usu�rio: '+FUSERNAME+' acessou a pagina '+Page);
//         end;
//
//      2: begin
//           UserType := tpAdm;
//           SendLog(NomeAplicacao+' -' ,' CNPJ: '+CNPJ+' Modulo : Administrativo Academic - Usu�rio: '+FUSERNAME+' acessou a pagina '+Page);
//         end;
//
//    end;

    Result := True;

  except
  raise;
  end;

end;

end.

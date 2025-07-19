unit IW.Content.API;

interface

uses
  Integracao.Discord,
  Classes,
  System.JSON,
  Rest.JSON,
  IWApplication,
  IW.Content.Base,
  HTTPApp,
  IW.HTTP.Request,
  IW.HTTP.Reply,
  System.SysUtils,
  EncdDecd,
  System.IOUtils,
  IWAppCache,
  Tipos.Types,
  Functions.Rest,
  Functions.Strings,
  Dao.ProcessaMensagem,
  WebHook.MessageAudio,
  StrUtils;

type
  TContentAPI = class(TContentBase)
  var
  Contador             : Integer;
  ProcessaMensagem:TProcessaMensagem;

  protected
    function Execute(aRequest: THttpRequest; aReply: THttpReply; const aPathname: string; aSession: TIWApplication; aParams: TStrings): boolean; override;
  public
    constructor Create; override;

  private
  end;

implementation

uses
  IW.Content.Handlers, IWMimeTypes, ServerController, IW.HTTP.FileItem,
  Contnrs, IW.Common.FileStream;

constructor TContentAPI.Create;
begin
  inherited;
  mFileMustExist := False;
end;

function TContentAPI.Execute(aRequest: THttpRequest; aReply: THttpReply; const aPathname: string; aSession: TIWApplication;
  aParams: TStrings): boolean;
var
  TipoMensagem  : TpMensagemZap;
  JsonStr       : String;
  JsonArray     : TJSONArray;
  JsonObject    : TJSONObject;
  JSONValue     : TJSONValue;
  SL            : TStringList;
  vCompanyID,vWhatsAppID : Integer;

begin

   if aRequest.Files.Count = 1 then
   begin
      Result     := True;
      JsonStr    := RemoveCaracteresInvalidos(aRequest.Files.Items[0].ReadAllText);

      { TODO -oClederson -cMedio : Essas Linhas Somente para testes caso der erro, e quiser debugar algo }
      SL         := TStringList.Create;
//      SL.Add('Hora da Chegada:'+FormatDateTime('c',Now));
//      SL.Add('Chegou a Requisição ReadAllText - '+aRequest.Files.Items[0].ReadAllText);
//      SL.Add('***********************************************************************');
//      SL.Add('Chegou a Requisição RawHeaders - '+aRequest.RawHeaders.Text);
//      SL.SaveToFile('C:\Temp\'+FormatDateTime('ddmmyyyyhhnnss',Now)+'JSON.txt');

       JSONValue := TJSONObject.ParseJSONValue(aRequest.Files.Items[0].ReadAllText);

      if Assigned(JSONValue) and (JSONValue is TJSONArray) or Assigned(JSONValue) and (JSONValue is TJSONObject) then begin

         JsonArray     := TJSONArray(JSONValue);
         JsonObject    := TJSONObject(JSONValue);

         try

           //Primeiro Validar se Existe ApiKey
           if not ExisteApiKey( JsonStr) then begin
               aReply.Code := 404;
               aReply.WriteString('{"Error":"API Key Inexistente, Veirifique"}');
               Exit;
           end;

          ProcessaMensagem  := TProcessaMensagem.Create(JsonStr);

          if not ProcessaMensagem.Verifica_Existe_ApyKey( Get_ApiKeyFromJSON(JsonStr) , vCompanyID,vWhatsAppID)then begin
             aReply.Code := 204;
             aReply.WriteString('{"Error":"Não Existe API Key "}');
             Exit;
          end;

          TipoMensagem      := ObterTipoMensagem(JsonStr);

          if ProcessaMensagem.Processa_Dados(TipoMensagem) then begin
            aReply.Code := 200;
            aReply.WriteString('OK');


          end
          else begin
            aReply.Code := 204;
            aReply.WriteString('{"Error":"Mensagem Não Processada, Veirifique"}');
          end;

         finally
           JSONValue.Free;
           SL.Free;
         end;

      end
      else begin
         aReply.Code := 400;
         aReply.WriteString('{"Error":"Não é um Json Válido, Veirifique"}');
      end;

   end;

end;

initialization

end.

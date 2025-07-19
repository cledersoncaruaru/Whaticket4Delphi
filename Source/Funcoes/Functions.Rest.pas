unit Functions.Rest;

interface
uses
  EncdDecd,
  System.SysUtils,
  IdHashMessageDigest,
  Functions.Boolean,
  System.Classes,
  System.JSON,
  Rest.JSON,
  Tipos.Types,
  System.StrUtils,
  System.Generics.Collections,
  Integracao.Discord,
  IWJsonDataObjects;

  function Get_ApiKeyFromJSON(const JsonStr: string): string;
  function CleanJSONString(const S: string): string;
  function ObterTipoMensagem(const JsonStr: string): TpMensagemZap;
  function ExisteApiKey(const JsonStr: String): Boolean;


implementation

uses
  System.Math;


function CleanJSONString(const S: string): string;
var
  Tmp: string;
begin
  Tmp := S.Trim;

  if (Tmp.StartsWith('"')) and (Tmp.EndsWith('"')) then
  begin
    Tmp := Copy(Tmp, 2, Tmp.Length - 2);
    Tmp := Tmp.Replace('\"', '"', [rfReplaceAll]);
  end;
  Result := Tmp;
end;

function Get_ApiKeyFromJSON(const JsonStr: string): string;
var
 Root         : TJsonObject;
begin
  Result := '';

  try

    try
      Root      := TJsonObject.Parse(JsonStr) as TJsonObject;
      Result    := Root.S['apikey'];

    except on E: Exception do begin
      raise;
     end;
    end;

  finally
  Root.Free;
  end;

end;

function ObterTipoMensagem(const JsonStr: string): TpMensagemZap;
var
MessageType, EventType  : string;
Root                    :  TJsonObject;
begin
  Result := TpMsgDesconhecido;

  Root         := TJsonObject.Parse(JsonStr) as TJsonObject;
  EventType    := Root.S['event'];
  MessageType  := Root.O['data'].S['messageType'];

  try

    try
      if EventType = 'contacts.update' then
      begin
      Result := TpMsgProfile;
      Exit;
      end;

      if EventType = 'messages.delete' then
      begin
        Result := TpMensagemDelete;
        Exit;
      end;

      case AnsiIndexStr(MessageType,['extendedTextMessage','audioMessage','imageMessage',
                                     'documentMessage','contactMessage','messageContextInfo',
                                     'videoMessage','conversation']) of

       0 : Result := TpMsgMensagem;
       1 : Result := TpMsgAudio;
       2 : Result := TpMsgImage;
       3 : Result := TpMsgArquivos;
       4 : Result := TpMsgContact;
       5 : Result := TpMsgContextInfo;
       6 : Result := TpMsgVideo;
       7 : Result := TpConversation;
       else
          Result := TpMsgDesconhecido;

      end;

    except on E: Exception do
    raise;
    //SendLog('ObterTipoMensagem','Function Rest','',Ord(Result).ToString);
    end;

  finally
    Root.Free;
  end;

end;

function ExisteApiKey(const JsonStr: String): Boolean;
var
 ApiKeyValue  : string;
 Root         :  TJsonObject;
begin
  Result      := False;

  try

     try
      Root        := TJsonObject.Parse(JsonStr) as TJsonObject;
      ApiKeyValue := Root.S['apikey'];

      Result      := ApiKeyValue.Trim <> '';

    except on E: Exception do
     raise;
     //SendLog('ExisteApiKey','Function Rest','',e.Message);
    end;

  finally
   Root.Free;
  end;

end;

end.

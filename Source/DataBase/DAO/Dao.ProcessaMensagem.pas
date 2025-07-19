unit Dao.ProcessaMensagem;

interface

uses
  ServerController,
  System.Classes,
  System.StrUtils,
  System.JSON,
  System.SysUtils,
  EncdDecd,
  functions.Rest,
  System.IOUtils,
  REST.Json,
  functions.DataBase,
  Buttons.Icons,
  functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  WebHook.MessageText,
  WebHook.MessageAudio,
  WebHook.MessageProfileUpdate,
  WebHook.MessageImage,
  WebHook.MessageVideo,
  WebHook.MessageArquivos,
  Entidade.Tickets,
  Entidade.Filas,
  Dao.Filas,
  Dao.Messages,
  Dao.Contatos,
  Dao.Tickets,
  Dao.Conexao,
  functions.IW,
  DateUtils,
  uPopulaCrud,
  Integracao.API.Evolution,
  Entidade.Contatos,
  System.TypInfo,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef,System.IniFiles,IWJsonDataObjects;

  type
  TProcessaMensagem = class(TObject)

  Type

  TDadosGeralMensagem = record

  LastMessage   : String;
  ContactID     : Integer;
  CompanyID     : Integer;
  WhatsAppID    : Integer;
  ApiKey        : String;
  TicketID      : Integer;
  TrakingID     : Integer;
  UserID        : Integer;
  end;

  Private
    var
    FJson                          : String;
    DadosGeralMensagem             : TDadosGeralMensagem;
    PathCompleto,NomeFile          : String;
    EvolutionAPI                   : TEvolutionAPI;
    vResult                        : String;


 Public

    Constructor Create(Json:String);
    Destructor  Destroy; Override;

   function Verifica_Existe_ApyKey(ApiKey:String; Var CompanyID,WhatsAppID:Integer):Boolean;
   function Verifica_Existe_Message(ID: String): Boolean;
   function UpdateNomeContactByNumber(Name,Number,ApiKey,Instancia: String; companyId:Integer): Boolean;
   function Get_TicketByMessage(Numero:string):Boolean;
   function Get_Verifica_Status_TicketByContact(Numero:string; var Tickets:TTickets):Boolean;
   function Get_IDContactByNumero(Numero:String):Integer;
   function Get_UserIdByCompanyID(CompanyID:Integer):Integer;
   function Processa_Dados(TipoMensagem: TpMensagemZap):Boolean;
   function Set_Contact: Boolean;
   function Set_Ticket_Message:Boolean;
   function Set_Ticket_Traking:Boolean;
   function Set_Mensagem_Texto:Boolean;
   function Set_Mensagem_Audio:Boolean;
   function Set_Mensagem_Image:Boolean;
   function Set_Mensagem_Video:Boolean;
   function Set_Mensagem_Arquivos:Boolean;
   function Set_Message_Delete:Boolean;
   function Set_Envio_Zap(JsonStr:String):Boolean;

  end;


implementation

uses
  System.Variants;

constructor TProcessaMensagem.Create(Json: String);
var
vCompanyID,vWhatsAppID : Integer;
Root                   : TJsonObject;
ApiKey                 : String;
begin

 FJson                     := Json;
 EvolutionAPI              := TEvolutionAPI.Create(DadosGeralMensagem.ApiKey);
 DadosGeralMensagem.ApiKey := Get_ApiKeyFromJSON(FJson);
 Root                      := TJsonObject.Parse(FJson) as TJsonObject;
 ApiKey                    := Root.S['apikey'];

 if ApiKey = '' then begin
    ApiKey      := Get_CompanyByInstanceId(Root.S['instanceId']);
 end;


  vCompanyID  := Get_CompanyByAPIKey(ApiKey);


  try

    if not Verifica_Existe_ApyKey( ApiKey , vCompanyID,vWhatsAppID)then begin
       UserSession.DiscordLogger.SendLog('Verificar API Key','Dao.ProcessaMensagem','TProcessaMensagem.Create','NÃO EXISTE APIKEY');
       Exit;
    end
    else
    begin
        DadosGeralMensagem.CompanyID  := vCompanyID;
        DadosGeralMensagem.WhatsAppID := vWhatsAppID;
        UserSession.Clipboard.Put('ApiKey',DadosGeralMensagem.ApiKey);
    end;

  finally
  Root.Free
  end;

end;

destructor TProcessaMensagem.Destroy;
begin
  inherited;
  EvolutionAPI.Free;
end;

function TProcessaMensagem.Get_IDContactByNumero(Numero: String): Integer;
var
Qry                           : TFDQuery;
begin

  Result             := 0;
  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  try

   try

     Qry.SQL.Text  :=

     'SELECT id,"number"  FROM public."Contacts"'+
     'WHERE "number"=:number';
     Qry.ParamByName('number').AsString  := Trim(Numero);
     Qry.Open;

     Result := Qry.FieldByName('id').AsInteger;

   except on E: Exception do
     UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Get_IDContactByNumero',e.Message);
   end;

  finally
  Qry.Free;
  end;

end;

function TProcessaMensagem.Get_TicketByMessage(Numero: string): Boolean;
var
Qry                           : TFDQuery;
begin

  Result             := False;
  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  try

   try

    DadosGeralMensagem.ContactID   := Get_IDContactByNumero(Trim(Numero));


     Qry.SQL.Text  :=

     'SELECT id,"contactId" FROM "Tickets"'+
     'WHERE "contactId"=:contactId';
     Qry.ParamByName('contactId').AsInteger   := DadosGeralMensagem.ContactID;
     Qry.Open;

     DadosGeralMensagem.TicketID   := Qry.FieldByName('id').AsInteger;

   except on E: Exception do
    UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Get_TicketByMessage',e.Message);
   end;

  finally
  Qry.Free;
  end;



end;

function TProcessaMensagem.Get_UserIdByCompanyID(CompanyID: Integer): Integer;
var
Qry                           : TFDQuery;
begin

  Result             := 0;
  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  try

   try

     Qry.SQL.Text  :=

     'SELECT id,"companyId" FROM public."Users"'+
     'WHERE "companyId"=:companyId';
     Qry.ParamByName('companyId').AsInteger   := CompanyID;
     Qry.Open;

     Result             := Qry.FieldByName('id').AsInteger;



   except on E: Exception do
    UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Get_UserIdByCompanyID',e.Message);
   end;


  finally
  Qry.Free;
  end;

end;

function TProcessaMensagem.Get_Verifica_Status_TicketByContact(Numero: string;
  var Tickets: TTickets): Boolean;
var
Qry                           : TFDQuery;
begin

  Result             := False;
  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  try

   try

    DadosGeralMensagem.ContactID   := Get_IDContactByNumero(Trim(Numero));

     Qry.SQL.Text  :=

    'SELECT * FROM "Tickets"'+
     'WHERE "contactId"=:contactId'+
     ' and status in (''open'',''pending'')';
     Qry.ParamByName('contactId').AsInteger   := DadosGeralMensagem.ContactID;
     Qry.Open;
     Qry.First;

     DadosGeralMensagem.TicketID   := Qry.FieldByName('id').AsInteger;
     Tickets.id                    := Qry.FieldByName('id').AsInteger;

     if not Qry.IsEmpty then
      begin
        TPopulateFromQuery<TTickets>.PopulateFromDataSet(Tickets, Qry);
      end;

   except on E: Exception do
    UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Get_TicketByMessage',e.Message);
   end;

  finally
  Qry.Free;
  end;

end;

function TProcessaMensagem.Processa_Dados(TipoMensagem: TpMensagemZap): Boolean;
var
IDContact,IDTicket,WhatsAppID : Integer;
begin
    Result  := False;

     case TipoMensagem of

      TpMsgProfile :
                     begin

                      Result  := Set_Contact;
                      Result  := Set_Ticket_Message;
                      Result  := Set_Ticket_Traking;

                     end;

      TpMsgMensagem,TpConversation:
                     begin
                     Result  := Set_Mensagem_Texto;
                     end;

     TpMsgAudio:    begin
                     Result  := Set_Mensagem_Audio;

                    end;

     TpMsgImage:    begin
                     Result  := Set_Mensagem_Image;
                    end;


     TpMsgVideo:    begin
                     Result  := Set_Mensagem_Video;
                    end;

     TpMsgArquivos: begin
                     Result  := Set_Mensagem_Arquivos;
                    end;


     TpMsgContact:
                     begin
                     Result  := Set_Mensagem_Texto;
                     end;

     TpMensagemDelete:
                     begin

                      Result := Set_Message_Delete;

                     end;

     TpMsgDesconhecido:
                     begin
                      Result := False;
                      UserSession.DiscordLogger.SendLog('Erro-','TpMsgDesconhecido','TpMsgDesconhecido','');
                     end;


//      TpConversation :
//                      begin
//                        Result  := Set_Mensagem_Texto;
//                        // Verificar se a Resposta Coincide com as Filas
//                        // Verificar um Numero X de Vezes em Respostas Erradas
//                        // Se Corresponder a Mensagem Correta, Ecaminha o Ticket para Fila Correta
//                      end;

     end;

end;

function TProcessaMensagem.Set_Contact: Boolean;
var
Qry                        : TFDQuery;
WebHookContactsUpdate      : TWebHookContactsUpdate;
begin
  Result               := False;

  Qry                  := TFDQuery.Create(Nil);
  Qry.Connection       := UserSession.Conexao;


  WebHookContactsUpdate  := TWebHookContactsUpdate.CreateFromJSON(FJson);

 try



  try
    Qry.SQL.Text   :=

     ' INSERT INTO "Contacts" (                                    '+
     ' "name",                                                     '+
     ' "number",                                                   '+
     ' "profilePicUrl",                                            '+
     ' "createdAt",                                                '+
     ' "updatedAt",                                                '+
     ' email,                                                      '+
     ' "isGroup",                                                  '+
     ' "companyId"                                                 '+
     ' ) VALUES (                                                  '+
     ' :name,                                                      '+
     ' :number,                                                    '+
     ' :profilePicUrl,                                             '+
     ' NOW(),                                                      '+
     ' NOW(),                                                      '+
     ' :email,                                                     '+
     ' :isGroup,                                                   '+
     ' :companyId                                                  '+
     ' )                                                           '+
     ' ON CONFLICT ("number", "companyId") DO UPDATE SET           '+
     ' "name" = EXCLUDED."name",                                   '+
     ' "profilePicUrl" = EXCLUDED."profilePicUrl",                 '+
     ' "updatedAt" = EXCLUDED."updatedAt",                         '+
     ' email = EXCLUDED.email,                                     '+
     ' "isGroup" = EXCLUDED."isGroup"                              '+
     ' RETURNING "id";                                              ';

    Qry.ParamByName('name').AsString             := '';
    Qry.ParamByName('number').AsString           := StringReplace(WebHookContactsUpdate.body.data[0].remoteJid,'@s.whatsapp.net', '', [rfReplaceAll]);
    Qry.ParamByName('profilePicUrl').AsString    := WebHookContactsUpdate.body.data[0].profilePicUrl;
    Qry.ParamByName('email').AsString            := '';
    Qry.ParamByName('isGroup').AsBoolean         := False;
    Qry.ParamByName('companyId').AsInteger       := DadosGeralMensagem.CompanyID;
    Qry.Open;

    DadosGeralMensagem.ContactID                 := Qry.FieldByName('id').AsInteger;
    Result                                       := True;

  except on E: Exception do
     UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Set_Contact',e.Message);
  end;

 finally
 Qry.Free;
 WebHookContactsUpdate.Free;
 end;


end;

function TProcessaMensagem.Set_Envio_Zap(JsonStr: String): Boolean;
var
  Qry           : TFDQuery;
  Root          : TJsonObject;
  MessageType   : string;
  mediaUrl      : string;
  fromMe        : Boolean;
  Numero        : string;
  IDContact     : Integer;
  Body          : String;
  IDTickets     : Integer;
begin

  Result            := False;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  Root              := TJsonObject.Parse(JsonStr) as TJsonObject;
  MessageType       := Root.S['messageType'];
  fromMe            := Root.O['key'].B['fromMe'];

    case AnsiIndexStr(MessageType,['extendedTextMessage','audioMessage','imageMessage',
                                   'documentMessage','contactMessage','messageContextInfo',
                                   'videoMessage','conversation']) of

     0 : begin
          mediaUrl   := '';
          Body       := Root.O['message'].S['conversation'];
         end;

     1 : begin
          mediaUrl := Root.O['message'].S['mediaUrl'];
          Body       := Root.O['message'].O['documentMessage'].S['fileName'];
         end;

     2 : begin
          mediaUrl   := Root.O['message'].S['mediaUrl'];
          Body       := Root.O['message'].O['documentMessage'].S['fileName'];
         end;

     3 : begin
         mediaUrl   := Root.O['message'].S['mediaUrl'];
         Body       := Root.O['message'].O['documentMessage'].S['fileName'];
         end;

     4 : begin
         mediaUrl   := '';
         Body       := '';
         end;

     5 : begin
         mediaUrl   := '';
         Body       := '';
         end;

     6 : begin
         mediaUrl   := Root.O['message'].S['mediaUrl'];
         Body       := Root.O['message'].O['documentMessage'].S['fileName'];
         end;

     7 : begin
         mediaUrl   := '';
         Body       := Root.O['message'].S['conversation'];
         end
     else
        mediaUrl   := '';
        Body       := '';

    end;



  try

   try
        Qry.SQL.Text :=
        'INSERT INTO "Messages" '+
        ' (id, body, ack, "read", "mediaType", "mediaUrl", "ticketId", "createdAt", "updatedAt", '+
        ' "fromMe", "isDeleted", "contactId", "companyId", "remoteJid", "dataJson", participant) '+
        'VALUES(:id, :body, :ack, :"read", :"mediaType", :"mediaUrl", :"ticketId", :"createdAt", :"updatedAt", '+
        '       :"fromMe", :"isDeleted", :"contactId", :"companyId", :"remoteJid", :"dataJson", :participant) ';

        Numero           := StringReplace(Root.O['key'].S['remoteJid'],'@s.whatsapp.net', '', [rfReplaceAll]);
        IDContact        := Get_ContactByNumero(Numero);
        IDTickets        := Get_TicketByContact(Numero );

        Qry.ParamByName('id').AsString                 := Root.O['key'].S['id'];
        Qry.ParamByName('body').AsString               := Body;
        Qry.ParamByName('ack').AsInteger               := 0;
        Qry.ParamByName('read').AsBoolean              := False;
        Qry.ParamByName('mediaType').AsString          := MessageType;
        Qry.ParamByName('mediaUrl').AsString           := mediaUrl;
        Qry.ParamByName('ticketId').AsInteger          := IDTickets;
        Qry.ParamByName('createdAt').AsDateTime        := Now;
        Qry.ParamByName('updatedAt').AsDateTime        := Now;
        Qry.ParamByName('fromMe').AsBoolean            := fromMe;
        Qry.ParamByName('isDeleted').AsBoolean         := False;
        Qry.ParamByName('contactId').AsInteger         := IDContact;
        Qry.ParamByName('companyId').AsInteger         := UserSession.CompanyId;
        Qry.ParamByName('remoteJid').AsString          := Root.O['key'].S['remoteJid'];
        Qry.ParamByName('dataJson').DataType           := ftMemo;
        Qry.ParamByName('dataJson').Size               := Length(FJson);
        Qry.ParamByName('dataJson').Value              := FJson;
        Qry.ParamByName('participant').AsString        := '';

        Qry.ExecSQL;

        Result := True;

  except
    on E: Exception do
      UserSession.DiscordLogger.SendLog('Erro-', 'Dao.ProcessaMensagem', 'Set_Envion_Zap', E.Message);
  end;


  finally
     Qry.Free;
     Root.Free;
  end;

end;

function TProcessaMensagem.Set_Ticket_Message: Boolean;
var
Qry           : TFDQuery;
GUID          : TGUID;
GUIDString    : string;
ID            : Integer;
Root          : TJsonObject;
Numero        : String;
begin

  Result            := False;
  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;
  Root              := TJsonObject.Parse(FJson) as TJsonObject;

  Numero            := Root.O['data'].O['key'].S['remoteJid'];
  Numero            := StringReplace(Numero,'@s.whatsapp.net', '', [rfReplaceAll]);

  try

   try
    Qry.SQL.Text :=

      'INSERT INTO "Tickets" (id,status, "lastMessage", "contactId", "userId",      ' +
                              '"createdAt", "updatedAt", "whatsappId", "isGroup", ' +
                              '"unreadMessages", "queueId", "companyId",          ' +
                              'uuid, chatbot, "queueOptionId", channel)           ' +
      ' VALUES (:id, :status, :lastMessage, :contactId, :userId,                    ' +
      '  :createdAt, :updatedAt, :whatsappId, :isGroup,                             ' +
      '  :unreadMessages, :queueId, :companyId,                                     ' +
      '  :uuid, :chatbot, :queueOptionId, :channel)                                 ' ;


    if CreateGUID(GUID) = S_OK then
    begin
      GUIDString := GUIDToString(GUID);
      GUIDString := StringReplace(GUIDString, '{', '', [rfReplaceAll]);
      GUIDString := StringReplace(GUIDString, '}', '', [rfReplaceAll]);
    end;

    ID                                          := NextGeneratorPosteGresql('Tickets_id_seq');
    Qry.ParamByName('id').AsInteger             := ID;
    Qry.ParamByName('status').AsString          := 'pending';
    Qry.ParamByName('lastMessage').AsString     := '';
    Qry.ParamByName('contactId').AsInteger      := Get_ContactByNumero(Numero);
    Qry.ParamByName('userId').AsInteger         := 1;
    Qry.ParamByName('createdAt').AsDateTime     := Now;
    Qry.ParamByName('updatedAt').AsDateTime     := Now;
    Qry.ParamByName('whatsappId').AsInteger     := Get_CompanyIDByAPIKey(Root.S['apikey']);
    Qry.ParamByName('isGroup').AsBoolean        := False;
    Qry.ParamByName('unreadMessages').AsInteger := 0;

    with Qry.ParamByName('queueId') do
    begin
      DataType := ftInteger;
      Clear;
    end;

    Qry.ParamByName('companyId').AsInteger    := Get_CompanyByAPIKey(Root.S['apikey']);
    Qry.ParamByName('uuid').DataType          := ftGuid;
    Qry.ParamByName('uuid').AsGuid            := GUID;
    Qry.ParamByName('chatbot').AsBoolean      := False;

    with Qry.ParamByName('queueOptionId') do
    begin
      DataType := ftInteger;
      Clear;
    end;

    Qry.ParamByName('channel').AsString       := 'whatsapp';
    Qry.ExecSQL;

    DadosGeralMensagem.TicketID := ID;
    Result := True;


  except
    on E: Exception do
      UserSession.DiscordLogger.SendLog('Erro-', 'Dao.ProcessaMensagem', 'Set_Ticket', E.Message);
  end;

  finally
     Qry.Free;
     Root.Free;
  end;

end;

function TProcessaMensagem.Set_Ticket_Traking: Boolean;
var
Qry                            : TFDQuery;
begin
  Result            := False;
  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   try

    Qry.SQL.Text :=
    'INSERT INTO "TicketTraking"                                                ' +
    ' ("ticketId", "companyId", "whatsappId","createdAt", "updatedAt","rated")  ' +
    'VALUES (:ticketId, :companyId, :whatsappId, NOW(), NOW(),:rated)           ' +
    'ON CONFLICT ("ticketId", "companyId") DO UPDATE SET                        ' +
    '  "whatsappId" = EXCLUDED."whatsappId",                                    ' +
    '  "updatedAt" = NOW(),                                                     ' +
    '  "rated" = EXCLUDED."rated"                                               ';

    Qry.ParamByName('ticketId').AsInteger   := DadosGeralMensagem.TicketID;
    Qry.ParamByName('companyId').AsInteger  := DadosGeralMensagem.CompanyID;
    Qry.ParamByName('whatsappId').AsInteger := DadosGeralMensagem.WhatsAppID;
    Qry.ParamByName('rated').AsBoolean      := False;
    Qry.ExecSQL();

    Result    := True;

   except on E: Exception do
      UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Set_Ticket_Traking',e.Message);
   end;

  finally
  Qry.Free;
  end;

end;

function TProcessaMensagem.UpdateNomeContactByNumber(Name,Number,ApiKey,Instancia: String; companyId:Integer): Boolean;
var
Qry                            : TFDQuery;
ProfilePicUrl,ProfileName      : String;
begin

  Result            := False;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

     EvolutionAPI.Get_ProfileContact(Instancia,Trim(Number),ApiKey,ProfilePicUrl,ProfileName);

   try

    Qry.SQL.Text    :=
        'INSERT INTO "Contacts" ' +
        ' ( "name", "number", "companyId", "createdAt", "updatedAt", "isGroup","profilePicUrl" ) ' +
        ' VALUES ( :name, :number, :companyId, :createdAt, :updatedAt, :isGroup,:profilePicUrl ) ' +
        ' ON CONFLICT ("number", "companyId") DO UPDATE SET                                      ' +
        '  "name" = EXCLUDED."name",                                                             ' +
        '  "number" = EXCLUDED."number",                                                         ' +
        '  "companyId" = EXCLUDED."companyId",                                                   ' +
        '  "createdAt" = EXCLUDED."createdAt",                                                   ' +
        '  "updatedAt" = EXCLUDED."updatedAt",                                                   ' +
        '  "isGroup" = EXCLUDED."isGroup",                                                       ' +
        '  "profilePicUrl" = EXCLUDED."profilePicUrl";                                           ';

    Qry.ParamByName('name').AsString             := Name;
    Qry.ParamByName('number').AsString           := StringReplace(Number, '@s.whatsapp.net', '', [rfReplaceAll]);
    Qry.ParamByName('companyId').AsInteger       := CompanyId;
    Qry.ParamByName('createdAt').AsDateTime      := Now;
    Qry.ParamByName('updatedAt').AsDateTime      := Now;
    Qry.ParamByName('isGroup').AsBoolean         := false;
    Qry.ParamByName('profilePicUrl').AsString    := ProfilePicUrl;
    Qry.ExecSQL;

   except on E: Exception do
      UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','UpdateNomeContactByNumber',e.Message);
   end;

  finally
  Qry.Free;
  end;

end;

function TProcessaMensagem.Verifica_Existe_ApyKey(ApiKey: String; Var CompanyID,WhatsAppID:Integer): Boolean;
var
Qry                            : TFDQuery;
begin
  Result            := False;
  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;


  try

    try

      Qry.SQL.Text  :=
          '   SELECT  id,apikey,"companyId" FROM "Whatsapps"  '+
          '   WHERE apikey=:APIKEY                            ';



      Qry.ParamByName('APIKEY').AsString   := Trim(ApiKey);
      Qry.Open;

      if Qry.RecordCount >0 then begin
         CompanyID     := Qry.FieldByName('companyId').AsInteger;
         WhatsAppID    := Qry.FieldByName('id').AsInteger;
         Result       := True;
      end;

     except on E: Exception do
      UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Verifica_Existe_ApyKey',e.Message);
    end;

  finally
  Qry.Free
  end;

end;

function TProcessaMensagem.Verifica_Existe_Message(ID: String): Boolean;
var
Qry                            : TFDQuery;
begin
  Result            := False;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

    try

      Qry.SQL.Text  :=
          '   SELECT  id FROM "Messages"  '+
          '   WHERE id=:id                ';



      Qry.ParamByName('id').AsString   := Trim(ID);
      Qry.Open;

      if Qry.RecordCount <= 0 then begin
         Result  := True

      end;

    except on E: Exception do
      UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Verifica_Existe_Message',e.Message);
    end;

  finally
  Qry.Free
  end;

end;

function TProcessaMensagem.Set_Mensagem_Texto:Boolean;
var
Qry                  : TFDQuery;
WebHookMessageText   : TWebHookMessageText;
CompanyID            : Integer;
Tickets              : TTickets;
Fila                 : TFilas;
Numero               : String;
UUID                 : String;
vResult              : String;
DaoMessages          : TDaoMessages;
begin

  Result             := False;
  WebHookMessageText := TWebHookMessageText.CreateFromJSON(FJson);
  Tickets            := TTickets.Create;
  Fila               := TFilas.Create;

  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  DaoMessages        := TDaoMessages.Create(DadosGeralMensagem.CompanyID);


  Numero   := StringReplace(WebHookMessageText.data.key.remoteJid,'@s.whatsapp.net', '', [rfReplaceAll]);
  UpdateNomeContactByNumber(WebHookMessageText.data.pushName,
                            WebHookMessageText.data.key.remoteJid,
                            WebHookMessageText.apikey,
                            WebHookMessageText.instance,
                            DadosGeralMensagem.CompanyID);
  Get_Verifica_Status_TicketByContact(Numero,Tickets );
  UserSession.Clipboard.Put('Instancia',Trim(WebHookMessageText.instance));


   if Tickets.id = 0 then begin

      if Set_Ticket_Message then begin
          Get_QueuesFromMessage(Numero,FJson);
      end;

     // Criar um  Ticket para a Mensagem desse Usuario
     // enviar as filas disponiveis
     // esperar resposta,
     // X tentantivas , se não joga para uma Fila Generica

   end
   else begin

    if (WebHookMessageText.event = 'messages.upsert') and (WebHookMessageText.data.messageType  = 'conversation') then begin
       //Foi o Retorno da Mensagem da Fila
//         WebHookMessageText.body.event = 'messages.upsert'
//        WebHookMessageText.body.data.message.conversation  //retorno da mensagem
//        WebHookMessageText.body.data.messageType  = 'conversation';

      if Get_Queues(StrToIntDef(WebHookMessageText.data.message.conversation,0),Fila,vResult) then begin
         // Encaminhar para a Fila Correta
          DaoMessages.Update_MessageTicketID(DadosGeralMensagem.TicketID,Fila.id);

      end
      else begin
        // Tentar mais uma vez mandar a Fila
        // verificar um loop de pelo menos 4 tentantivas

      end;


    end;


   end;


  try

    try

        Qry.SQL.Text :=
        'INSERT INTO public."Messages" '+
        ' (id, body, ack, "read", "mediaType", "mediaUrl", "ticketId", "createdAt", "updatedAt",               '+
        '  "fromMe", "isDeleted", "contactId", "companyId", "remoteJid", "dataJson", participant)              '+
        'VALUES(:id, :body, :ack, :"read", :"mediaType", :"mediaUrl", :"ticketId", :"createdAt", :"updatedAt", '+
        '       :"fromMe", :"isDeleted", :"contactId", :"companyId", :"remoteJid", :"dataJson", :participant)  '+
        'ON CONFLICT (id, "ticketId") DO UPDATE SET  '+
        '  body = EXCLUDED.body,                     '+
        '  ack = EXCLUDED.ack,                       '+
        '  "read" = EXCLUDED."read",                 '+
        '  "mediaType" = EXCLUDED."mediaType",       '+
        '  "mediaUrl" = EXCLUDED."mediaUrl",         '+
        '  "ticketId" = EXCLUDED."ticketId",         '+
        '  "createdAt" = EXCLUDED."createdAt",       '+
        '  "updatedAt" = EXCLUDED."updatedAt",       '+
        '  "fromMe" = EXCLUDED."fromMe",             '+
        '  "isDeleted" = EXCLUDED."isDeleted",       '+
        '  "contactId" = EXCLUDED."contactId",       '+
        '  "companyId" = EXCLUDED."companyId",       '+
        '  "remoteJid" = EXCLUDED."remoteJid",       '+
        '  "dataJson" = EXCLUDED."dataJson",         '+
        '  participant = EXCLUDED.participant        '+
        'RETURNING id;                               ';

        Qry.ParamByName('id').AsString                 := WebHookMessageText.data.key.id;
        Qry.ParamByName('body').AsString               := WebHookMessageText.data.message.conversation;
        Qry.ParamByName('ack').AsInteger               := 0;
        Qry.ParamByName('read').AsBoolean              := False;
        Qry.ParamByName('mediaType').AsString          := WebHookMessageText.data.messageType;
        Qry.ParamByName('mediaUrl').AsString           := '';
        Qry.ParamByName('ticketId').AsInteger          := DadosGeralMensagem.TicketID;
        Qry.ParamByName('createdAt').AsDateTime        := ISO8601ToDate(WebHookMessageText.date_time);
        Qry.ParamByName('updatedAt').AsDateTime        := ISO8601ToDate(WebHookMessageText.date_time);
        Qry.ParamByName('fromMe').AsBoolean            := WebHookMessageText.data.key.fromMe;
        Qry.ParamByName('isDeleted').AsBoolean         := False;
        Qry.ParamByName('contactId').AsInteger         := DadosGeralMensagem.ContactID;
        Qry.ParamByName('companyId').AsInteger         := DadosGeralMensagem.CompanyID;
        Qry.ParamByName('remoteJid').AsString          := WebHookMessageText.data.key.remoteJid;
        Qry.ParamByName('dataJson').AsString           := FJson;
        Qry.ParamByName('participant').AsString        := '';

        Qry.Open;

        Result := True;

    except on E: Exception do

       UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Processa_Mensagens_Texto_Zap',e.Message);

    end;

  finally

   if Assigned(WebHookMessageText) then begin
      WebHookMessageText.Free;
   end;

  Qry.Free;
  Tickets.Free;
  Fila.Free;
  DaoMessages.Free;
  end;


end;


function TProcessaMensagem.Set_Mensagem_Audio:Boolean;
var
Qry                   : TFDQuery;
WebHookMessageAudio   : TWebHookMessageAudio;
CompanyID             : Integer;
Numero                : String;
Tickets               : TTickets;
Fila                  : TFilas;
DaoMessages           : TDaoMessages;
begin

  Result              := False;
  WebHookMessageAudio := TWebHookMessageAudio.CreateFromJSON(FJson);
  Tickets             := TTickets.Create;
  Fila                := TFilas.Create;
  DaoMessages         := TDaoMessages.Create(DadosGeralMensagem.CompanyID);
  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  try

    try

      Numero   := StringReplace(WebHookMessageAudio.data.key.remoteJid,'@s.whatsapp.net', '', [rfReplaceAll]);
      UpdateNomeContactByNumber(WebHookMessageAudio.data.pushName,
                                WebHookMessageAudio.data.key.remoteJid,
                                WebHookMessageAudio.apikey,
                                WebHookMessageAudio.instance,
                                DadosGeralMensagem.CompanyID);
      Get_Verifica_Status_TicketByContact(Numero,Tickets );


     if Tickets.id = 0 then begin

        if Set_Ticket_Message then begin
            Get_QueuesFromMessage(Numero,FJson);
        end;

       // Criar um  Ticket para a Mensagem desse Usuario
       // enviar as filas disponiveis
       // esperar resposta,
       // X tentantivas , se não joga para uma Fila Generica

     end
     else begin

//      if (WebHookMessageAudio.event = 'messages.upsert') and (WebHookMessageAudio.data.messageType  = 'conversation') then begin
//         //Foi o Retorno da Mensagem da Fila
//  //         WebHookMessageText.body.event = 'messages.upsert'
//  //        WebHookMessageText.body.data.message.conversation  //retorno da mensagem
//  //        WebHookMessageText.body.data.messageType  = 'conversation';
//
//        if Get_Queues(StrToIntDef(WebHookMessageAudio.data.message.conversation,0),Fila,vResult) then begin
//           // Encaminhar para a Fila Correta
//            DaoMessages.Update_MessageTicketID(DadosGeralMensagem.TicketID,Fila.id);
//
//        end
//        else begin
//          // Tentar mais uma vez mandar a Fila
//          // verificar um loop de pelo menos 4 tentantivas
//
//        end;
//
//
//      end;


     end;

      Qry.SQL.Text    :=

     ' INSERT INTO public."Messages"                                                                                      '+
     ' (id, body, ack, "read", "mediaType", "mediaUrl", "ticketId", "createdAt", "updatedAt",                             '+
     ' "fromMe", "isDeleted", "contactId",  "companyId", "remoteJid", "dataJson", participant,"mimeType")   '+
     ' VALUES(:id, :body, :ack, :"read", :"mediaType", :"mediaUrl", :"ticketId", :"createdAt", :"updatedAt", :"fromMe",   '+
     ':"isDeleted", :"contactId",  :"companyId", :"remoteJid",CAST(:dataJson AS json), :participant,:mimeType);     ';

      Qry.ParamByName('id').AsString                 := WebHookMessageAudio.data.key.id;
      Qry.ParamByName('body').AsString               := 'Áudio';
      Qry.ParamByName('ack').AsInteger               := 0;
      Qry.ParamByName('read').AsBoolean              := False;
      Qry.ParamByName('mediaType').AsString          := WebHookMessageAudio.data.messageType;
      Qry.ParamByName('mediaUrl').AsString           := WebHookMessageAudio.data.message.mediaUrl;   //NomeFile;
      Qry.ParamByName('ticketId').AsInteger          := DadosGeralMensagem.TicketID;
      Qry.ParamByName('createdAt').AsDateTime        := Now;
      Qry.ParamByName('updatedAt').AsDateTime        := Now;
      Qry.ParamByName('fromMe').AsBoolean            := False;
      Qry.ParamByName('isDeleted').AsBoolean         := False;
      Qry.ParamByName('contactId').AsInteger         := DadosGeralMensagem.ContactID;
      Qry.ParamByName('companyId').AsInteger         := DadosGeralMensagem.CompanyID;
      Qry.ParamByName('remoteJid').AsString          := WebHookMessageAudio.data.key.remoteJid;
      Qry.ParamByName('participant').AsString        := '';
      Qry.ParamByName('mimeType').AsString          := WebHookMessageAudio.data.message.audioMessage.mimetype;


       with Qry.ParamByName('dataJson') do
      begin
        DataType := ftWideMemo;
        Size     := Length(RemoveCaracteresInvalidos(FJson));
        AsString := RemoveCaracteresInvalidos(FJson);
      end;


      Qry.ExecSQL;

     Result := True;

    except on E: Exception do

    UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Set_Mensagem_Audio',e.Message);

    end;

  finally
  WebHookMessageAudio.Free;
  Qry.Free;
  Tickets.Free;
  Fila.Free;
  DaoMessages.Free;
  end;

end;

function TProcessaMensagem.Set_Mensagem_Image:Boolean;
var
Qry                   : TFDQuery;
WebHookMessageImage   : TWebHookMessageImage;
CompanyID             : Integer;
Tickets               : TTickets;
Fila                  : TFilas;
DaoMessages           : TDaoMessages;
Numero                : String;
begin

  Result              := False;
  WebHookMessageImage := TWebHookMessageImage.CreateFromJSON(FJson);
  Tickets             := TTickets.Create;
  Fila                := TFilas.Create;
  DaoMessages         := TDaoMessages.Create(DadosGeralMensagem.CompanyID);


  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  try

    try

      Numero   := StringReplace(WebHookMessageImage.data.key.remoteJid,'@s.whatsapp.net', '', [rfReplaceAll]);
      UpdateNomeContactByNumber(WebHookMessageImage.data.pushName,
                                WebHookMessageImage.data.key.remoteJid,
                                WebHookMessageImage.apikey,
                                WebHookMessageImage.instance,
                                DadosGeralMensagem.CompanyID);
       Get_Verifica_Status_TicketByContact(Numero,Tickets );


     if Tickets.id = 0 then begin

        if Set_Ticket_Message then begin
            Get_QueuesFromMessage(Numero,FJson);
        end;

       // Criar um  Ticket para a Mensagem desse Usuario
       // enviar as filas disponiveis
       // esperar resposta,
       // X tentantivas , se não joga para uma Fila Generica

     end
     else begin

//      if (WebHookMessageImage.event = 'messages.upsert') and (WebHookMessageImage.data.messageType  = 'conversation') then begin
//         //Foi o Retorno da Mensagem da Fila
//  //         WebHookMessageText.body.event = 'messages.upsert'
//  //        WebHookMessageText.body.data.message.conversation  //retorno da mensagem
//  //        WebHookMessageText.body.data.messageType  = 'conversation';
//
//        if Get_Queues(StrToIntDef(WebHookMessageText.data.message.conversation,0),Fila,vResult) then begin
//           // Encaminhar para a Fila Correta
//            DaoMessages.Update_MessageTicketID(DadosGeralMensagem.TicketID,Fila.id);
//
//        end
//        else begin
//          // Tentar mais uma vez mandar a Fila
//          // verificar um loop de pelo menos 4 tentantivas
//
//        end;
//
//
//      end;


     end;

      Qry.SQL.Text    :=

     ' INSERT INTO public."Messages"                                                                                        '+
     ' (id, body, ack, "read", "mediaType", "mediaUrl", "ticketId", "createdAt", "updatedAt",                               '+
     ' "fromMe", "isDeleted", "contactId",  "companyId", "remoteJid", "dataJson", participant,"mimeType")                   '+
     ' VALUES(:id, :body, :ack, :"read", :"mediaType", :"mediaUrl", :"ticketId", :"createdAt", :"updatedAt", :"fromMe",     '+
     ' :"isDeleted", :"contactId",  :"companyId", :"remoteJid",CAST(:dataJson AS json), :participant,:mimeType);            ';

      Qry.ParamByName('id').AsString                 := WebHookMessageImage.data.key.id;
      Qry.ParamByName('body').AsString               := 'Imagem';
      Qry.ParamByName('ack').AsInteger               := 0;
      Qry.ParamByName('read').AsBoolean              := False;
      Qry.ParamByName('mediaType').AsString          := WebHookMessageImage.data.messageType;
      Qry.ParamByName('mediaUrl').AsString           := WebHookMessageImage.data.message.mediaUrl;
      Qry.ParamByName('ticketId').AsInteger          := DadosGeralMensagem.TicketID;
      Qry.ParamByName('createdAt').AsDateTime        := Now;
      Qry.ParamByName('updatedAt').AsDateTime        := Now;
      Qry.ParamByName('fromMe').AsBoolean            := False;
      Qry.ParamByName('isDeleted').AsBoolean         := False;
      Qry.ParamByName('contactId').AsInteger         := DadosGeralMensagem.ContactID;
      Qry.ParamByName('companyId').AsInteger         := DadosGeralMensagem.CompanyID;
      Qry.ParamByName('remoteJid').AsString          := WebHookMessageImage.data.key.remoteJid;
      Qry.ParamByName('participant').AsString        := '';
      Qry.ParamByName('mimeType').AsString           := WebHookMessageImage.data.message.imageMessage.mimetype;

       with Qry.ParamByName('dataJson') do
      begin
        DataType := ftWideMemo;
        Size     := Length(RemoveCaracteresInvalidos(FJson));
        AsString := FJson;
      end;

     Qry.ExecSQL;

     Result := True;


    except on E: Exception do

     UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Set_Mensagem_Image',e.Message);

    end;

  finally
  WebHookMessageImage.Free;
  Qry.Free;
  Tickets.Free;
  Fila.Free;
  DaoMessages.Free;
  end;


end;

function TProcessaMensagem.Set_Mensagem_Video:Boolean;
var
Qry                   : TFDQuery;
WebHookMessageVideo   : TWebHookMessageVideo;
CompanyID             : Integer;
Tickets               : TTickets;
Numero                : String;
begin

  Result              := False;
  WebHookMessageVideo := TWebHookMessageVideo.CreateFromJSON(FJson);
  Tickets             := TTickets.Create;

  Qry                 := TFDQuery.Create(Nil);
  Qry.Connection      := UserSession.Conexao;

  try

    Numero   := StringReplace(WebHookMessageVideo.data.key.remoteJid,'@s.whatsapp.net', '', [rfReplaceAll]);
    UpdateNomeContactByNumber(WebHookMessageVideo.data.pushName,
                              WebHookMessageVideo.data.key.remoteJid,
                              WebHookMessageVideo.apikey,
                              WebHookMessageVideo.instance,
                              DadosGeralMensagem.CompanyID);
                              Get_Verifica_Status_TicketByContact(Numero,Tickets );


      if Tickets.id = 0 then begin
         Tickets.id              := 0;
         Tickets.Status          := 'pending';
         Tickets.Lastmessage     := '';
         Tickets.Contactid       := Get_ContactByNumero(Numero);
         Tickets.Userid          := UserSession.IDUser;
         Tickets.Createdat       := Now;
         Tickets.Updatedat       := Now;
         Tickets.Whatsappid      := Get_CompanyByAPIKey(WebHookMessageVideo.apikey);
         Tickets.Isgroup         := False;
         Tickets.Unreadmessages  := 0;
         Tickets.Queueid         := 0;
         Tickets.Companyid       := UserSession.CompanyId;
         Tickets.Chatbot         := False;
         Tickets.Queueoptionid   := 1;
         Tickets.Channel         := 'whatsapp';
         Set_Tickets(0,Tickets,vResult);

      end;



    try

      Qry.SQL.Text :=
      'INSERT INTO public."Messages" ' +
      '(id, body, ack, "read", "mediaType", "mediaUrl", "ticketId", "createdAt", "updatedAt", ' +
      '"fromMe", "isDeleted", "contactId", "companyId", "remoteJid", dataJson, participant, "mimeType") ' +
      'VALUES (:id, :body, :ack, :"read", :"mediaType", :"mediaUrl", :"ticketId", :"createdAt", :"updatedAt", ' +
      ':"fromMe", :"isDeleted", :"contactId", :"companyId", :"remoteJid", CAST(:dataJson AS json), :participant, :mimeType) ' +
      'ON CONFLICT (id) DO UPDATE SET        ' +
      'body = EXCLUDED.body,                 ' +
      'ack = EXCLUDED.ack,                   ' +
      '"read" = EXCLUDED."read",             ' +
      '"mediaType" = EXCLUDED."mediaType",   ' +
      '"mediaUrl" = EXCLUDED."mediaUrl",     ' +
      '"ticketId" = EXCLUDED."ticketId",     ' +
      '"createdAt" = EXCLUDED."createdAt",   ' +
      '"updatedAt" = EXCLUDED."updatedAt",   ' +
      '"fromMe" = EXCLUDED."fromMe",         ' +
      '"isDeleted" = EXCLUDED."isDeleted",   ' +
      '"contactId" = EXCLUDED."contactId",   ' +
      '"companyId" = EXCLUDED."companyId",   ' +
      '"remoteJid" = EXCLUDED."remoteJid",   ' +
      'dataJson = EXCLUDED.dataJson,         ' +
      'participant = EXCLUDED.participant,   ' +
      '"mimeType" = EXCLUDED."mimeType";     ';


      Qry.ParamByName('id').AsString                 := WebHookMessageVideo.data.key.id;
      Qry.ParamByName('body').AsString               := 'Video';
      Qry.ParamByName('ack').AsInteger               := 0;
      Qry.ParamByName('read').AsBoolean              := False;
      Qry.ParamByName('mediaType').AsString          := WebHookMessageVideo.data.messageType;
      Qry.ParamByName('mediaUrl').AsString           := WebHookMessageVideo.data.message.mediaUrl;
      Qry.ParamByName('ticketId').AsInteger          := Tickets.id;
      Qry.ParamByName('createdAt').AsDateTime        := Now;
      Qry.ParamByName('updatedAt').AsDateTime        := Now;
      Qry.ParamByName('fromMe').AsBoolean            := False;
      Qry.ParamByName('isDeleted').AsBoolean         := False;
      Qry.ParamByName('contactId').AsInteger         := DadosGeralMensagem.ContactID;
      Qry.ParamByName('companyId').AsInteger         := Get_CompanyByAPIKey(WebHookMessageVideo.apikey);
      Qry.ParamByName('remoteJid').AsString          := WebHookMessageVideo.data.key.remoteJid;
      Qry.ParamByName('participant').AsString        := '';
      Qry.ParamByName('mimeType').AsString           := WebHookMessageVideo.data.message.videoMessage.mimetype;

       with Qry.ParamByName('dataJson') do
      begin
        DataType := ftWideMemo;
        Size     := Length(RemoveCaracteresInvalidos(FJson));
        AsString := FJson;
      end;

     Qry.ExecSQL;

     Result := True;

    except on E: Exception do
    UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Set_Mensagem_Video',e.Message);
    end;

  finally
   Qry.Free;
   Tickets.Free;

   if Assigned(WebHookMessageVideo) then begin
      WebHookMessageVideo.Free;
   end;

  end;

end;

function TProcessaMensagem.Set_Message_Delete: Boolean;
var
Qry           : TFDQuery;
ID            : String;
CompanyID     : Integer;
Root          : TJsonObject;
begin

  Result             := False;

  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  Root      := TJsonObject.Parse(FJson) as TJsonObject;
  ID        := Root.O['body'].O['data'].S['id'];

  try

    try

      Qry.SQL.Text    :=

     ' UPDATE public."Messages"  SET "isDeleted"=:isDeleted    '+
     ' WHERE id=:id                                            ';

      Qry.ParamByName('id').AsString           := ID;
      Qry.ParamByName('isDeleted').AsBoolean   := True;

      Qry.ExecSQL;

      Result := True;

    except on E: Exception do
    UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Set_Message_Delete',e.Message);
    end;

  finally
  Qry.Free;
  Root.Free;
  end;

end;

function TProcessaMensagem.Set_Mensagem_Arquivos:Boolean;
var
Qry                      : TFDQuery;
WebHookMessageArquivos   : TWebHookMessageArquivos;
CompanyID                : Integer;
Tickets                  : TTickets;
Fila                     : TFilas;
DaoMessages              : TDaoMessages;
Numero                   : String;
begin

  Result                 := False;
  WebHookMessageArquivos := TWebHookMessageArquivos.CreateFromJSON(FJson);
  Tickets                := TTickets.Create;
  Fila                   := TFilas.Create;
  DaoMessages            := TDaoMessages.Create(DadosGeralMensagem.CompanyID);


  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  try

      try

        Numero   := StringReplace(WebHookMessageArquivos.data.key.remoteJid,'@s.whatsapp.net', '', [rfReplaceAll]);
        UpdateNomeContactByNumber(WebHookMessageArquivos.data.pushName,
                                  WebHookMessageArquivos.data.key.remoteJid,
                                  WebHookMessageArquivos.apikey,
                                  WebHookMessageArquivos.instance,
                                  DadosGeralMensagem.CompanyID);
         Get_Verifica_Status_TicketByContact(Numero,Tickets );

         if Tickets.id = 0 then begin

            if Set_Ticket_Message then begin
               Get_QueuesFromMessage(Numero,FJson);
            end;

           // Criar um  Ticket para a Mensagem desse Usuario
           // enviar as filas disponiveis
           // esperar resposta,
           // X tentantivas , se não joga para uma Fila Generica

         end;


         Qry.SQL.Text :=
          'INSERT INTO public."Messages" ' +
          '(id, body, ack, "read", "mediaType", "mediaUrl", "ticketId", "createdAt", "updatedAt",                               ' +
          '"fromMe", "isDeleted", "contactId", "companyId", "remoteJid", dataJson, participant, "mimeType")                     ' +
          'VALUES (:id, :body, :ack, :"read", :"mediaType", :"mediaUrl", :"ticketId", :"createdAt", :"updatedAt",               ' +
          ':"fromMe", :"isDeleted", :"contactId", :"companyId", :"remoteJid", CAST(:dataJson AS json), :participant, :mimeType) ' +
          'ON CONFLICT (id, "ticketId") DO UPDATE SET  ' +
          'body = EXCLUDED.body,                       ' +
          'ack = EXCLUDED.ack,                         ' +
          '"read" = EXCLUDED."read",                   ' +
          '"mediaType" = EXCLUDED."mediaType",         ' +
          '"mediaUrl" = EXCLUDED."mediaUrl",           ' +
          '"ticketId" = EXCLUDED."ticketId",           ' +
          '"createdAt" = EXCLUDED."createdAt",         ' +
          '"updatedAt" = EXCLUDED."updatedAt",         ' +
          '"fromMe" = EXCLUDED."fromMe",               ' +
          '"isDeleted" = EXCLUDED."isDeleted",         ' +
          '"contactId" = EXCLUDED."contactId",         ' +
          '"companyId" = EXCLUDED."companyId",         ' +
          '"remoteJid" = EXCLUDED."remoteJid",         ' +
          'dataJson = EXCLUDED.dataJson,               ' +
          'participant = EXCLUDED.participant,         ' +
          '"mimeType" = EXCLUDED."mimeType";           ';

        Qry.ParamByName('id').AsString                 := WebHookMessageArquivos.data.key.id;
        Qry.ParamByName('body').AsString               := WebHookMessageArquivos.data.message.documentMessage.fileName;
        Qry.ParamByName('ack').AsInteger               := 0;
        Qry.ParamByName('read').AsBoolean              := False;
        Qry.ParamByName('mediaType').AsString          := WebHookMessageArquivos.data.messageType;
        Qry.ParamByName('mediaUrl').AsString           := WebHookMessageArquivos.data.message.mediaUrl;
        Qry.ParamByName('ticketId').AsInteger          := Tickets.id;
        Qry.ParamByName('createdAt').AsDateTime        := Now;
        Qry.ParamByName('updatedAt').AsDateTime        := Now;
        Qry.ParamByName('fromMe').AsBoolean            := False;
        Qry.ParamByName('isDeleted').AsBoolean         := False;
        Qry.ParamByName('contactId').AsInteger         := DadosGeralMensagem.ContactID;
        Qry.ParamByName('companyId').AsInteger         := DadosGeralMensagem.CompanyID;
        Qry.ParamByName('remoteJid').AsString          := WebHookMessageArquivos.data.key.remoteJid;
        Qry.ParamByName('participant').AsString        := '';
        Qry.ParamByName('mimeType').AsString           := WebHookMessageArquivos.data.message.documentMessage.mimetype;

           with Qry.ParamByName('dataJson') do
        begin
          DataType := ftWideMemo;
          Size     := Length(RemoveCaracteresInvalidos(FJson));
          AsString := FJson;
        end;

        Qry.ExecSQL;

        Result := True;

      except on E: Exception do
      UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Set_Mensagem_Arquivos',e.Message);
      end;

  finally

    WebHookMessageArquivos.Free;
    Qry.Free;
    Tickets.Free;
    Fila.Free;
    DaoMessages.Free;

  end;


end;

end.


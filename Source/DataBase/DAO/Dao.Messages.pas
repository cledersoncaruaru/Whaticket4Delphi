unit Dao.Messages;

interface

uses
  System.Classes,
  System.StrUtils,
  System.DateUtils,
  Buttons.Icons,
  functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  Entidade.Messages,
  Entidade.Tickets,
  App.Config,
  Data.DB,
  Dao.Contatos,
  Dao.Conexao,
  Dao.Tickets,
  System.Generics.Collections,
  FireDAC.Comp.Client;

type
  TDaoMessages = class
  private
    FCompanyId      : Integer;
    FNomeConexao    : String;
  public
    constructor Create(aCompanyId: Integer);
    destructor Destroy; override;

    function Get_Monta_Card_Aguardando(var CardAtendimento, CardAguardando, CardResolvidos: String): String;
    function Get_Total_Tickets(var TotalAtendimento, TotalAguardando: String): String;
    function Set_Aceita_Ticket(ID, UserId: Integer): Boolean;
    function Set_Retorna_Ticket(ID: Integer): Boolean;
    function Set_Finaliza_Ticket(TicketId, UserId: Integer): Boolean;
    function Get_ContactByFone(Number: String; var ContactId, Name, ProfilePicUrl: String): Boolean;
    function Get_QueueByTicketID(TicketID: Integer): String;
    function Get_Card_Dados_Top(ContactId: String; var remoteJid: String): String;
    function Get_ChatByContactId(RemoteJID: String): String;
    function GenerateMessageHtml(Qry: TFDQuery): string;
    function Set_ReadMessage(id:String):Boolean;
    function Get_Conexao(companyId:Integer):String;
    function Update_MessageTicketID(TicketID,QueueID:Integer):Boolean;
    function Update_Mensagens_Servidor(Token:String):Boolean;
    function Get_Token_EvolutionID(Token:String):String;
    function ExisteMessage(id:String):Boolean;
    function Update_Message_Sicronizado(id:String):Boolean;
    function Get_ChatByContactId2(RemoteJID: String): String;
    function Get_TicketByMessage(id: String): Integer;



  end;

implementation

uses
  ServerController, System.SysUtils, System.TypInfo,
  System.JSON;

{ TDaoMessages }

constructor TDaoMessages.Create(aCompanyId: Integer);
begin
  FCompanyId    := aCompanyId;
  FNomeConexao  := Get_Conexao(FCompanyId);

end;

destructor TDaoMessages.Destroy;
begin
  inherited;
end;

function TDaoMessages.ExisteMessage(id: String): Boolean;
var
  Qry: TFDQuery;
begin

  Result         := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

   Qry.SQL.Text :=

   'select id from "Messages" '+
   ' where id=:id            ';
   Qry.ParamByName('id').AsString   := id;
   Qry.Open;

   if Qry.RecordCount >= 1 then
      Result         := True;



  finally
   Qry.Free;
  end;

end;

function TDaoMessages.Get_ChatByContactId2(RemoteJID: String): String;
var
  Qry: TFDQuery;
  Name, ProfilePicUrl, Img, Audio, Base64: String;
  ListaMessage: TStringList;
  DataHora: TDateTime;
  HoraFormatada: string;
  ClassLink: String;
begin
  Result := '';

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;
  ListaMessage   := TStringList.Create;

  try
    try
      Qry.SQL.Text :=
        'SELECT id, body, ack, "read", "mediaType", "mediaUrl", "ticketId",   ' +
        '"createdAt", "updatedAt", "fromMe", "isDeleted", "contactId",        ' +
        '"quotedMsgId", "companyId", "remoteJid","read"                       ' +
        'FROM "Messages"                                                      ' +
        'WHERE "companyId" =:companyId                                        ' +
         'AND "remoteJid" =:remoteJid                                         ' +
        ' ORDER BY "createdAt";                                               ';

      Qry.ParamByName('companyId').AsInteger      := FCompanyId;
      Qry.ParamByName('remoteJid').AsString       := RemoteJID;
      Qry.Open;
      Qry.First;

      while not Qry.Eof do
      begin
        ClassLink := '';
        Base64    := '';


        case AnsiIndexStr(Qry.FieldByName('mediaType').AsString,
          ['extendedTextMessage', 'audioMessage', 'imageMessage',
          'documentMessage', 'contactMessage', 'messageContextInfo', 'videoMessage']) of
          0:
            Base64 := '';
          1:
            begin



                Base64 :=
                '<audio controls=""><source src="./Files/Temp/' + Qry.FieldByName('mediaUrl').AsString +
                '" type="audio/ogg"></audio> ';
                 ClassLink := '';


            end;
          2:
            begin


                  Base64 :=
                ' <img class="img-fluid rounded my-2" ' +
                'src="./Files/Temp/' + Qry.FieldByName('mediaUrl').AsString + '" alt="Img" ' +
                'loading="lazy"> ';
                 ClassLink := '';



            end;
          3:
            begin


                      Base64 :=
                ' <div class="destaklink"> ' +
                '      <a target="_blank" ' +
                '          title="Clique Aqui Para Abrir o Arquivo" ' +
                '          href="./Files/Temp/' + Qry.FieldByName('mediaUrl').AsString + '" ' +
                '          class="stretched-link text-reset btn-link destaque"> ' +
                '          <i class="fa-solid fa-download"></i> ' +
                '          ' + Qry.FieldByName('mediaUrl').AsString +
                '      </a> ' +
                '  </div> ';
              ClassLink := 'classlink';



            end;
          4:
            Base64 := '';
          5:
            Base64 := '';
          6:
            begin

                Base64 :=
                ' <video width="312" height="330" controls> ' +
                '   <source src="' + Qry.FieldByName('mediaUrl').AsString + '" ' +
                '       type="video/mp4"> ' +
                '   <source src="mov_bbb.ogg" type="video/ogg"> ' +
                '   Your browser does not support HTML video. ' +
                ' </video> ';
              ClassLink := '';




            end;
        end;

        HoraFormatada := ExtractDataHoraByHora(Qry.FieldByName('createdAt').AsString);

        if not Qry.FieldByName('fromMe').AsBoolean then
        begin

              ListaMessage.Add(
              '        <div class="d-flex mb-2"> ' +
              '            <div class="bubble"> ' +
              Base64 +
              '                <p class="mb-1 ' + ClassLink + '">' + Qry.FieldByName('body').AsString + '</p> ' +
              '                <small class="text-muted">' + HoraFormatada + '</small> ' +
              '            </div> ' +
              '        </div> '
            );

        end
        else
        begin

          if  (Trim(Qry.FieldByName('body').AsString)<> '' ) then begin

                  ListaMessage.Add(
            '        <div class="d-flex justify-content-end mb-2"> ' +
            '            <div class="bubble bubble-primary"> ' +
            Base64 +
            '                <p class="mb-1">' + Qry.FieldByName('body').AsString + '</p> ' +
            '                <small class="text-muted">' + HoraFormatada + '</small> ' +
            '            </div> ' +
            '        </div> '
          );

          end;

        end;

        Qry.Next;
      end;

      Result := ListaMessage.Text;
    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Get_ChatByContactId -', E.Message);
    end;
  finally
    Qry.Free;
    ListaMessage.Free;
  end;
end;

function TDaoMessages.Get_ChatByContactId(RemoteJID: String): String;
var
  Qry, QryUpdate: TFDQuery;
  ListaMessage: TStringList;
  LastId: String;
  IsInitialFetch: Boolean;
  SQLBase: string;
  FetchedId: String;
begin

  Result     := '';

  Qry        := TFDQuery.Create(nil);
  QryUpdate  := TFDQuery.Create(nil);


  try

    Qry.Connection       := UserSession.Conexao;
    QryUpdate.Connection := UserSession.Conexao;

    // 1) Recupera LastId; se não existir, marcamos como fetch inicial
    if not UserSession.LastMsgIdByContact.TryGetValue(RemoteJID, LastId) then
    begin
      LastId := '';
      IsInitialFetch := True;
    end
    else
      IsInitialFetch := False;

    // 2) Recupera ou cria o cache de HTML em sessão
    if not UserSession.ChatHtmlByContact.TryGetValue(RemoteJID, ListaMessage) then
    begin
      ListaMessage := TStringList.Create;
      UserSession.ChatHtmlByContact.Add(RemoteJID, ListaMessage);
    end;

    // 3) Monta SQLBase
    SQLBase :=

        ' SELECT id, body, ack, "read", "mediaType", "mediaUrl", "ticketId",       ' +
        ' ("createdAt" AT TIME ZONE ''America/Sao_Paulo'') AS createdAt,           ' +
        ' ("updatedAt" AT TIME ZONE ''America/Sao_Paulo'') AS updatedAt,           ' +
        ' "fromMe", "isDeleted", "contactId",                                      ' +
        ' "quotedMsgId", "companyId", "remoteJid","read"                           ' +
        ' FROM "Messages"                                                          ' +
        ' WHERE "companyId" =:companyId                                            ' +
        ' AND "remoteJid" =:remoteJid                                              ' ;


    if IsInitialFetch then
      // pega as 150 mais recentes, independente de read
      SQLBase := SQLBase + 'ORDER BY "createdAt" DESC LIMIT 150'
    else
     SQLBase := SQLBase +
     //  'AND id > :lastId ' +
       'AND "read" = false ' +
       'ORDER BY "createdAt"';

    Qry.SQL.Text                           := SQLBase;
    Qry.ParamByName('companyId').AsInteger := FCompanyId;
    Qry.ParamByName('remoteJid').AsString  := RemoteJID;
    Qry.Open;

    // 4) Se for inicial, vamos percorrer do final para o início para manter ordem do mais antigo ao mais novo
    if IsInitialFetch then
      Qry.Last;

    // 5) Loop: monta só as mensagens novas (inicial ou incremental)
    while (IsInitialFetch and not Qry.BOF) or (not IsInitialFetch and not Qry.Eof) do
    begin
      FetchedId := Qry.FieldByName('id').AsString;
      if FetchedId > LastId then
        LastId := FetchedId;

      // Gera o HTML (extrai para um helper se preferir)
      ListaMessage.Add(
        GenerateMessageHtml(Qry)
      );

      // 6) Marca como lida
      Set_ReadMessage(FetchedId);

      // 7) Avança cursor
      if IsInitialFetch then
        Qry.Prior
      else
        Qry.Next;
    end;

    // 8) Atualiza o LastId na sessão
    UserSession.LastMsgIdByContact.AddOrSetValue(RemoteJID, LastId);

    // 9) Retorna TODO o HTML (iniciais + incrementais)
    Result := ListaMessage.Text;
  finally
    Qry.Free;
    QryUpdate.Free;
  end;
end;

function TDaoMessages.GenerateMessageHtml(Qry: TFDQuery): string;
var
  MediaHtml, HoraFmt,body: string;
  DataHora:TDateTime;
begin
  // Montagem simplificada de mídia (ajuste conforme seus tipos)
  case AnsiIndexStr(Qry.FieldByName('mediaType').AsString,
       ['extendedTextMessage',
       'audioMessage',
       'imageMessage',
       'documentMessage',
       'contactMessage',
       'messageContextInfo',
       'videoMessage',
       'conversation']) of

       //audioMessage
    1: MediaHtml := Format(
         '<audio controls><source src="%s" type="audio/ogg"></audio>',
         [Qry.FieldByName('mediaUrl').AsString]
       );

       //imageMessage
    2: MediaHtml := Format(
         '<img class="img-fluid rounded my-2" src="%s" loading="lazy">',
         [Qry.FieldByName('mediaUrl').AsString]
       );

       //documentMessage
    3: MediaHtml := Format(
         '<div class="destaklink"><a href="%s" target="_blank" ' +
         'class="stretched-link btn-link destaque"><i class="fa-solid fa-file-arrow-down fa-2x"></i> %s</a></div>',
       //  [Qry.FieldByName('mediaUrl').AsString,Qry.FieldByName('mediaUrl').AsString]
         [Qry.FieldByName('mediaUrl').AsString,Qry.FieldByName('body').AsString]
       );

     //videoMessage
    6: MediaHtml := Format(
         '<video controls width="312" height="330"><source src="%s" type="video/mp4"></video>',
         [Qry.FieldByName('mediaUrl').AsString]
       );
  else
    MediaHtml := '';
  end;

  HoraFmt  := FormatDateTime('hh:nn', Qry.FieldByName('createdAt').AsDateTime);

 if Qry.FieldByName('isDeleted').AsBoolean = true then
  begin
     body :=  ' <span class="msg-deleted" style="color: red;"> <i class="fa-solid fa-trash-can"></i>  '+
              ' Mensagem apagada  </span>' ;
  end
  else begin
     body   := Qry.FieldByName('body').AsString ;
  end;


  if not Qry.FieldByName('fromMe').AsBoolean then
    Result := Format(
      '<div class="d-flex mb-2"><div class="bubble  position-relative">%s' +
'      <input id="'+Qry.FieldByName('id').AsString+'" type="checkbox" class="bubble-check" style="display: none; position: absolute; top: 8px; left: 8px; z-index: 10;" onchange="atualizarBarraInferior()"> '+
      '<p class="mb-1">%s</p><small class="text-muted">%s</small>' +
      '</div></div>',
      [MediaHtml, body, HoraFmt]
    )
  else
    Result := Format(
      '<div class="d-flex justify-content-end mb-2">' +
      '<div class="bubble  position-relative bubble-primary">%s' +
     ' <input id="'+Qry.FieldByName('id').AsString+'" type="checkbox" class="bubble-check" style="display: none; position: absolute; top: 8px; left: 8px; z-index: 10;" onchange="atualizarBarraInferior()"> '+
      '<p class="mb-1">%s</p><small class="text-muted">%s</small>' +
      '</div></div>',
      [MediaHtml, body, HoraFmt]
    );

end;

function TDaoMessages.Get_Card_Dados_Top(ContactId: String; var remoteJid: String): String;
var
  Qry: TFDQuery;
  Name, ProfilePicUrl: String;
  BTN_VOLTAR, BTN_RESOLVER, BTN_OPCOES: String;
begin

  Result := '';

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try
    try
      Qry.SQL.Text :=
        'SELECT id, "name", "number", "profilePicUrl", "companyId"        ' +
        'FROM "Contacts"                                                  ' +
        ' WHERE "companyId" =:companyId                                   ' +
        'AND id = :id;                                                    ';

      Qry.ParamByName('companyId').AsInteger     := FCompanyId;
      Qry.ParamByName('id').AsInteger            := StrToIntDef(ContactId, 0);
      Qry.Open;

      if Qry.RecordCount = 1 then
      begin
        Name            := Qry.FieldByName('name').AsString;
        ProfilePicUrl   := Qry.FieldByName('profilePicUrl').AsString;
        BTN_VOLTAR :=
          '             <button type="button" title="Voltar o Card" ' +
          'class="btn btn-icon btn-success btn-lg rounded-circle">  ' +
          '    <i class="fa-solid fa-rotate-left"></i>              ' +
          '</button> ';
        BTN_RESOLVER :=
          '          <button type="button" title="Resolver"        ' +
          'class="btn btn-icon btn-success btn-lg rounded-circle"> ' +
          '    <i class="fa-solid fa-check"></i>                   ' +
          '</button> ';
        BTN_OPCOES :=
          '  <div class="dropdown"> ' +
          '  <button class="btn btn-icon btn-sm btn-hover btn-light"  ' +
          '      data-bs-toggle="dropdown" aria-expanded="false">     ' +
          '      <i class="demo-pli-dot-horizontal fs-5"></i>         ' +
          '      <span class="visually-hidden">Toggle Dropdown</span> ' +
          '  </button> ' +
          '  <ul class="dropdown-menu dropdown-menu-end">   ' +
          '      <li>                                       ' +
          '          <a href="#" class="dropdown-item">     ' +
          '              <i class="demo-pli-pen-5 fs-5 me-2"></i> Agendamento ' +
          '          </a> ' +
          '      </li> ' +
          '      <li> ' +
          '          <a href="#" class="dropdown-item text-danger">                  ' +
          '              <i class="fa-solid fa-right-left fs-5 me-2"></i> Transferir ' +
          '          </a> ' +
          '      </li> ' +
          '      <li> ' +
          '          <hr class="dropdown-divider"> ' +
          '      </li> ' +
          '      <li> ' +
          '          <a href="#" class="dropdown-item text-danger">           ' +
          '              <i class="demo-pli-recycling fs-5 me-2"></i> Deletar ' +
          '          </a> ' +
          '      </li> ' +
          '  </ul> ' +
          ' </div> ';

        remoteJid := Qry.FieldByName('number').AsString + '@s.whatsapp.net';
      end
      else
      begin
        Name          := 'Usuário Não Selecionado';
        ProfilePicUrl := './assets/img/profile-photos/2.png';
        BTN_VOLTAR    := '';
        BTN_RESOLVER  := '';
        BTN_OPCOES    := '';
      end;
    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Get_Card_Dados_Top -', E.Message);
    end;
  finally
    Qry.Free;
  end;

  Result :=
    '     <div class="d-flex"> ' +
    '       <figure class="d-flex align-items-center position-relative"> ' +
    '           <div class="flex-shrink-0 me-3"> ' +
    '               <img class="img-sm rounded-circle" src="' + Trim(ProfilePicUrl) +
    '" alt="Profile Picture" loading="lazy"> ' +
    '           </div> ' +
    '           <div class="flex-fill overflow-hidden"> ' +
    '               <a href="#" class="h6 d-block mb-1 stretched-link text-nowrap text-truncate text-decoration-none pe-2"> ' +
    '               ' + Name + '</a> ' +
    '               <small class="text-success fw-bold fst-italic text-truncate pe-2">Está Digitando...</small> ' +
    '           </div> ' +
    '       </figure> ' +
    '       <div class="d-flex gap-2 ms-auto mt-1"> ' +
    BTN_VOLTAR +
    BTN_RESOLVER +
    BTN_OPCOES +
    '       </div> ' +
    '     </div> ';
end;

function TDaoMessages.Get_Conexao(companyId: Integer): String;
var
  Qry: TFDQuery;
begin
  Result         := '' ;
  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

    try

      Qry.SQL.Text :=
        'SELECT "name"                   ' +
        'FROM "Whatsapps"                ' +
        'WHERE "companyId" =:companyId     ';

      Qry.ParamByName('companyId').AsInteger := FCompanyId;
      Qry.Open;

      Result          := Qry.FieldByName('name').AsString;

    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Get_Conexao -', E.Message);
    end;
  finally
    Qry.Free;
  end;

end;

function TDaoMessages.Get_ContactByFone(Number: String; var ContactId, Name, ProfilePicUrl: String): Boolean;
var
  Qry: TFDQuery;
begin
  Result            := False;
  Qry               := TFDQuery.Create(nil);
  Qry.Connection    := UserSession.Conexao;

  try
    try
      Qry.SQL.Text :=
        'SELECT id, "name", "number", "profilePicUrl", "companyId" ' +
        'FROM "Contacts"                                           ' +
        'WHERE "companyId" =:companyId                             ' +
        'AND number = :number;                                     ';

      Qry.ParamByName('number').AsString := StringReplace(Number, '@s.whatsapp.net', '', [rfReplaceAll]);
      Qry.ParamByName('companyId').AsInteger := FCompanyId;
      Qry.Open;

      if not Qry.IsEmpty then
      begin
        ContactId       := Qry.FieldByName('id').AsString;
        Name            := Qry.FieldByName('name').AsString;
        ProfilePicUrl   := Qry.FieldByName('profilePicUrl').AsString;
        Result          := True;
      end;
    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Get_ContactByFone -', E.Message);
    end;
  finally
    Qry.Free;
  end;
end;

function TDaoMessages.Get_QueueByTicketID(TicketID: Integer): String;
var
  Qry: TFDQuery;
begin
  Result         := '';

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try
    try
      Qry.SQL.Text :=
        'SELECT id, "name", "number", "profilePicUrl" ' +
        'FROM "Contacts"                              ' +
        'WHERE companyId =:companyId                  ' +
        'AND id = :ticketId;                          ';
      Qry.ParamByName('companyId').AsInteger  := FCompanyId;
      Qry.ParamByName('ticketId').AsInteger   := TicketID;
      Qry.Open;

      if not Qry.IsEmpty then
        Result := Qry.FieldByName('id').AsString;
    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Get_QueueByTicketID -', E.Message);
    end;
  finally
    Qry.Free;
  end;
end;

function TDaoMessages.Set_Aceita_Ticket(ID, UserId: Integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result         := False;
  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try
    try
      Qry.SQL.Text :=
        'UPDATE "Messages" SET "read" = :read                ' +
        'WHERE "companyId" =:companyId                       ' +
        'AND "ticketId" =:ticketId;                          ';
      Qry.ParamByName('read').AsBoolean         := True;
      Qry.ParamByName('ticketId').AsInteger     := ID;
      Qry.ParamByName('companyId').AsInteger   := FCompanyId;
      Qry.ExecSQL;

      Qry.SQL.Text :=
        'UPDATE "Tickets" SET status = :status, "userId" = :userId '+
        'WHERE id = :id                                            '+
        ' AND "companyId" =:companyId                               ';
      Qry.ParamByName('status').AsString       := 'open';
      Qry.ParamByName('userId').AsInteger      := UserId;
      Qry.ParamByName('id').AsInteger          := ID;
      Qry.ParamByName('companyId').AsInteger   := FCompanyId;
      Qry.ExecSQL;

      Qry.SQL.Text :=
        'UPDATE "TicketTraking" SET "userId" = :userId   ' +
        'WHERE "ticketId" = :ticketId                    '+
        ' AND "companyId" =:companyId                     ';
      Qry.ParamByName('userId').AsInteger      := UserId;
      Qry.ParamByName('ticketId').AsInteger    := ID;
      Qry.ParamByName('companyId').AsInteger   := FCompanyId;
      Qry.ExecSQL;

      Result := True;
    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Set_Aceita_Ticket -', E.Message);
    end;

  finally
    Qry.Free;
  end;
end;

function TDaoMessages.Set_Finaliza_Ticket(TicketId, UserId: Integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result         := False;
  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try
    try

      Qry.SQL.Text :=
        'UPDATE "Tickets" SET status = :status, "userId" =:userId   '+
        'WHERE id = :id                                             '+
        ' AND "companyId" =:companyId                               ';
      Qry.ParamByName('status').AsString       := 'closed';
      Qry.ParamByName('userId').AsInteger      := UserId;
      Qry.ParamByName('id').AsInteger          := TicketId;
      Qry.ParamByName('companyId').AsInteger   := FCompanyId;
      Qry.ExecSQL;

      Qry.SQL.Text :=
        'UPDATE "TicketTraking" SET "userId" = :userId, "finishedAt"=:finishedAt   ' +
        'WHERE "ticketId" = :ticketId                    '+
        ' AND "companyId" =:companyId                     ';
      Qry.ParamByName('userId').AsInteger      := UserId;
      Qry.ParamByName('ticketId').AsInteger    := TicketId;
      Qry.ParamByName('companyId').AsInteger   := FCompanyId;
      Qry.ParamByName('finishedAt').AsDateTime := Now;
      Qry.ExecSQL;

      Result := True;


     // Disparar a Mensagem de Finalizado
     // Caso tenha Fila, pois no Cadastro da Conexão tem isso
     // Validar Tudo isso no cadastro


    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Set_Finaliza_Ticket -', E.Message);
    end;

  finally
    Qry.Free;
  end;
end;



function TDaoMessages.Set_ReadMessage(id: String): Boolean;
var
Qry  : TFDQuery;
begin

  Result := False;

  Qry := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;


  try

    try

      Qry.SQL.Text :=
      'UPDATE "Messages" SET "read" = TRUE WHERE id = :id';
      Qry.ParamByName('id').AsString := id;
      Qry.ExecSQL;

    except on E: Exception do
      UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Set_ReadMessage -', E.Message);
    end;


  finally
  Qry.Free;
  end;

end;

function TDaoMessages.Set_Retorna_Ticket(ID: Integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;
  Qry := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try
    try
      Qry.SQL.Text :=
        'UPDATE "Messages" SET "read" = :read '+
        'WHERE "ticketId" = :ticketId;        '+
        ' AND "companyId"=:companyId          ';

      Qry.ParamByName('read').AsBoolean        := True;
      Qry.ParamByName('ticketId').AsInteger    := ID;
      Qry.ParamByName('companyId').AsInteger   := FCompanyId;
      Qry.ExecSQL;

      Qry.SQL.Text :=
        'UPDATE "Tickets" SET status = :status  ' +
        'WHERE id = :id;                        '+
        ' AND "companyId"=:companyId            ';

      Qry.ParamByName('status').AsString         := 'open';
      Qry.ParamByName('id').AsInteger            := ID;
      Qry.ParamByName('companyId').AsInteger     := FCompanyId;
      Qry.ExecSQL;

      Qry.SQL.Text :=
        'UPDATE "TicketTraking" SET "userId" = NULL ' +
        'WHERE "ticketId" = :ticketId;              ' +
          ' AND "companyId"=:companyId              ';
      Qry.ParamByName('ticketId').AsInteger      := ID;
      Qry.ParamByName('companyId').AsInteger     := FCompanyId;
      Qry.ExecSQL;

      Result := True;
    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Set_Retorna_Ticket -', E.Message);
    end;
  finally
    Qry.Free;
  end;
end;

function TDaoMessages.Update_Mensagens_Servidor(Token: String): Boolean;
var
  QryLocal,QryServidor  : TFDQuery;
  RawJSON               : string;
  MsgID                 : string;
  IDContact             : Integer;
  IDTickets             : Integer;
  Numero                : String;
  Ticket                : TTickets;
  vResult               : String;
  DataHora              : TDateTime;
begin

  Ticket                    := TTickets.Create;

  QryLocal                  := TFDQuery.Create(nil);
  QryLocal.Connection       := UserSession.Conexao;

  QryServidor               := TFDQuery.Create(nil);
  QryServidor.Connection    := UserSession.ConexaoEvolution;

  try

  try

        QryServidor.SQL.Text   :=
       '   SELECT m.id,                                                                                                                '+
       '    (m."key"   ->> ''id'')        AS msg_id,                                                                                   '+
       '   ((m."key" ->> ''fromMe'')::boolean) AS from_me,                                                                             '+
       '   (m."key"   ->> ''remoteJid'') AS remote_jid,                                                                                '+
       '   (m."key"   ->> ''participant'') AS ContactGroup,                                                                            '+
       '   (m.message ->> ''conversation'')                                             AS conversation,                               '+
       '   (m.message ->> ''mediaUrl'')                                                 AS mediaUrl,                                   '+
       '   (m.message -> ''messageContextInfo'' ->> ''messageSecret'')                  AS message_secret,                             '+
       '   (m.message -> ''documentMessage'' ->> ''caption'')                   AS caption,                                            '+
       '   (m.message -> ''documentMessage'' ->> ''fileName'')                  AS fileName,                                           '+
       '   (m.message -> ''messageContextInfo'' -> ''deviceListMetadata'' ->> ''senderKeyHash'')      AS sender_key_hash,              '+
       '   (m.message -> ''messageContextInfo'' -> ''deviceListMetadata'' ->> ''senderTimestamp'')    AS sender_timestamp,             '+
       '   (m.message -> ''messageContextInfo'' -> ''deviceListMetadata'' ->> ''recipientKeyHash'')   AS recipient_key_hash,           '+
       '   (m.message -> ''messageContextInfo'' -> ''deviceListMetadata'' ->> ''senderAccountType'')  AS sender_account_type,          '+
       '   (m.message -> ''messageContextInfo'' -> ''deviceListMetadata'' ->> ''recipientTimestamp'') AS recipient_timestamp,          '+
       '   (m.message -> ''messageContextInfo'' -> ''deviceListMetadata'' ->> ''receiverAccountType'') AS receiver_account_type,       '+
       '   ((m.message -> ''messageContextInfo'' ->> ''deviceListMetadataVersion'')::int)           AS metadata_version,               '+
       '   m."pushName", m.participant, m."messageType",m.message as dataJson,                                                         '+
       '   m."contextInfo",                                                                                                            '+
       '   m."source", m."messageTimestamp", m."chatwootMessageId", m."chatwootInboxId", m."chatwootConversationId",                   '+
       '   m."chatwootContactInboxSourceId", m."chatwootIsRead",                                                                       '+
       '   m."instanceId", m."webhookUrl", m."sessionId", m.status,m.sicronizado,mu.status as update_status                            '+
       ' FROM "Message" m                                                                                                              '+
       ' LEFT JOIN                                                                                                                     '+
       ' "MessageUpdate" mu ON mu."messageId" = m.id                                                                                   '+
       ' WHERE m.sicronizado IS NULL OR m.sicronizado = false                                                                          '+
       ' and m."instanceId"=:instanceId                                                                                                ';

     QryServidor.ParamByName('instanceId').AsString   :=  Get_Token_EvolutionID(Token);
     QryServidor.Open;
     QryServidor.First;

     while not QryServidor.Eof do begin

        QryLocal.SQL.Text :=
        'INSERT INTO "Messages" (id, BODY, ack, "read", "mediaType", "mediaUrl",                         ' +
        '  "ticketId", "createdAt", "updatedAt", "fromMe", "isDeleted", "contactId", "quotedMsgId",      ' +
        '  "companyId", "remoteJid", "dataJson", participant, "queueId", channel, "isEdited",            ' +
        '  "thumbnailUrl", "userId")                                                                     ' +
        'VALUES (:id, :body, :ack, :read, :mediaType, :mediaUrl, :ticketId, :createdAt, :updatedAt,      ' +
        '  :fromMe, :isDeleted, :contactId, :quotedMsgId, :companyId, :remoteJid,                        ' +
        '  CAST(:dataJson AS json), :participant, :queueId, :channel, :isEdited, :thumbnailUrl, :userId) ' +
        'ON CONFLICT (id, "ticketId") DO UPDATE SET   ' +
        '  BODY = EXCLUDED.BODY,                      ' +
        '  ack = EXCLUDED.ack,                        ' +
        '  "read" = EXCLUDED."read",                  ' +
        '  "mediaType" = EXCLUDED."mediaType",        ' +
        '  "mediaUrl" = EXCLUDED."mediaUrl",          ' +
        '  "createdAt" = EXCLUDED."createdAt",        ' +
        '  "updatedAt" = EXCLUDED."updatedAt",        ' +
        '  "fromMe" = EXCLUDED."fromMe",              ' +
        '  "isDeleted" = EXCLUDED."isDeleted",        ' +
        '  "contactId" = EXCLUDED."contactId",        ' +
        '  "quotedMsgId" = EXCLUDED."quotedMsgId",    ' +
        '  "companyId" = EXCLUDED."companyId",        ' +
        '  "remoteJid" = EXCLUDED."remoteJid",        ' +
        '  "dataJson" = EXCLUDED."dataJson",          ' +
        '  participant = EXCLUDED.participant,        ' +
        '  "queueId" = EXCLUDED."queueId",            ' +
        '  channel = EXCLUDED.channel,                ' +
        '  "isEdited" = EXCLUDED."isEdited",          ' +
        '  "thumbnailUrl" = EXCLUDED."thumbnailUrl",  ' +
        '  "userId" = EXCLUDED."userId";              ';

       Numero      := StringReplace(QryServidor.FieldByName('remote_jid').AsString,'@s.whatsapp.net', '', [rfReplaceAll]);
       IDContact   := Get_ContactByNumero(Numero);
       IDTickets   := Get_TicketByMessage(QryServidor.FieldByName('msg_id').AsString);

       if IDTickets <=0 then begin
          IDTickets        := Get_TicketByContact(Numero );
          Ticket.Channel   := 'WebHookBanco';
       end;

       if IDContact = 0 then begin

        Numero   := StringReplace(QryServidor.FieldByName('remote_jid').AsString,'@s.whatsapp.net', '', [rfReplaceAll]);
        UpdateNomeContactByNumber(Numero,Get_TokenByIDCompany(UserSession.CompanyId),Get_InstanciaByIDCompany(UserSession.CompanyId),UserSession.CompanyId);

       end;

       if IDTickets = 0 then begin

           Ticket.id                   := 0;
           Ticket.Status               := 'pending';
           Ticket.Lastmessage          :=  '';
           Ticket.Contactid            := IDContact;
           Ticket.Userid               := UserSession.IDUser;
           Ticket.Createdat            := Now;
           Ticket.Updatedat            := Now;
           Ticket.Whatsappid           := 1;
           Ticket.IsGroup := 
            (not QryServidor.FieldByName('participant').IsNull) and
            (QryServidor.FieldByName('participant').AsString <> '');

           Ticket.Unreadmessages       := 0;
           Ticket.Queueid              := 0;
           Ticket.Companyid            := UserSession.CompanyId;
           Ticket.Uuid                 := '';
           Ticket.Chatbot              := False;
           Ticket.Queueoptionid        := 0;
           Ticket.Channel              := 'WebHookBanco';
           Set_Tickets(Ticket.id , Ticket,vResult);
           IDTickets                   := Ticket.id;
       end;

        DataHora := UnixToDateTime(QryServidor.FieldByName('messageTimestamp').AsInteger); // Está em UTC
        DataHora := DataHora - (3/24);                                                    // Ajuste para UTC-3
        QryLocal.ParamByName('id').AsString                 := QryServidor.FieldByName('msg_id').AsString;

        if QryServidor.FieldByName('conversation').AsString = '' then begin
           QryLocal.ParamByName('body').AsString               := QryServidor.FieldByName('fileName').AsString;
        end
        else begin
        QryLocal.ParamByName('body').AsString               := QryServidor.FieldByName('conversation').AsString;
        end;

        QryLocal.ParamByName('ack').AsInteger               := 0;// Verificar o que é esse ack
        QryLocal.ParamByName('read').AsBoolean              := False;
        QryLocal.ParamByName('mediaType').AsString          := QryServidor.FieldByName('messageType').AsString;
        QryLocal.ParamByName('mediaUrl').DataType           := ftString;
        QryLocal.ParamByName('mediaUrl').Size               := Length(QryServidor.FieldByName('mediaUrl').AsString);
        QryLocal.ParamByName('mediaUrl').AsString           := QryServidor.FieldByName('mediaUrl').AsString;
        QryLocal.ParamByName('ticketId').AsInteger          := IDTickets;
        QryLocal.ParamByName('createdAt').AsDateTime        := DataHora;
        QryLocal.ParamByName('updatedAt').AsDateTime        := DataHora;
        QryLocal.ParamByName('fromMe').AsBoolean            := QryServidor.FieldByName('from_me').AsBoolean;

        if QryServidor.FieldByName('update_status').AsString = 'DELETED'  then begin
           QryLocal.ParamByName('isDeleted').AsBoolean         := True;
        end
        else begin
           QryLocal.ParamByName('isDeleted').AsBoolean         := False;
        end;

        QryLocal.ParamByName('contactId').AsInteger         := Get_ContactByNumero(StringReplace(QryServidor.FieldByName('remote_jid').AsString, '@s.whatsapp.net', '', [rfReplaceAll]) );
        QryLocal.ParamByName('quotedMsgId').DataType        := ftString;
        QryLocal.ParamByName('quotedMsgId').Clear;
        QryLocal.ParamByName('companyId').AsInteger         := UserSession.CompanyId;
        QryLocal.ParamByName('remoteJid').AsString          := QryServidor.FieldByName('remote_jid').AsString;
        QryLocal.ParamByName('dataJson').DataType           := ftMemo;
        QryLocal.ParamByName('dataJson').Size               := Length(QryServidor.FieldByName('dataJson').Value);
        QryLocal.ParamByName('dataJson').Value              := QryServidor.FieldByName('dataJson').Value;
        QryLocal.ParamByName('participant').DataType        := ftString;
        QryLocal.ParamByName('participant').AsString        := QryServidor.FieldByName('participant').AsString;
        QryLocal.ParamByName('queueId').DataType            := ftInteger;
        QryLocal.ParamByName('queueId').Clear;
        QryLocal.ParamByName('channel').AsString            := Ticket.Channel;
        QryLocal.ParamByName('isEdited').AsBoolean          := False;
        QryLocal.ParamByName('thumbnailUrl').DataType       := ftInteger;
        QryLocal.ParamByName('thumbnailUrl').Clear;
        QryLocal.ParamByName('userId').DataType             := ftInteger;
        QryLocal.ParamByName('userId').AsInteger            := UserSession.IDUser;
        QryLocal.ExecSQL;

      Update_Message_Sicronizado(QryServidor.FieldByName('id').AsString);

      UserSession.ContadorUpdate  := QryServidor.RecNo;

      QryServidor.Next;
     end;

  except on E: Exception do begin
       UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Update_Mensagens_Servidor - '+QryServidor.FieldByName('msg_id').AsString , E.Message);
      end;
  end;

 finally
  QryLocal.Free;
  QryServidor.Free;
  Ticket.Free;
 end;

end;

function TDaoMessages.Update_MessageTicketID(TicketID,QueueID: Integer): Boolean;
var
  Qry: TFDQuery;
begin

  Result            := False;

  Qry               := TFDQuery.Create(nil);
  Qry.Connection    := UserSession.Conexao;

  try

    try

      Qry.SQL.Text :=
        ' update "Messages" set "queueId"=:queueId'+
        ' WHERE "ticketId"=:ticketId              ';
      Qry.ParamByName('ticketId').AsInteger    := TicketID;
      Qry.ParamByName('queueId').AsInteger     := QueueID;
      Qry.ExecSQL;

      Result            := True;

    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Update_MessageTicketID -', E.Message);
    end;
  finally
    Qry.Free;
  end;

end;

function TDaoMessages.Update_Message_Sicronizado(id:String): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  Qry               := TFDQuery.Create(nil);
  Qry.Connection    := UserSession.ConexaoEvolution;

  try

   try
      Qry.SQL.Text  := ' UPDATE "Message" SET sicronizado=:sicronizado   '+
                       ' where id=:id                                    ';
      Qry.ParamByName('id').AsString            :=  id;
      Qry.ParamByName('sicronizado').AsBoolean  :=  True;
      Qry.ExecSQL;

      Result := True;

      UserSession.ConexaoEvolution.Commit;

   except on E: Exception do begin
       UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Update_Message_Sicronizado -', E.Message);
       UserSession.ConexaoEvolution.Rollback;

    end;

   end;

  finally
  Qry.Free
  end;

end;

function TDaoMessages.Get_TicketByMessage(id: String): Integer;
var
  Qry: TFDQuery;
begin
  Result := 0;

  Qry               := TFDQuery.Create(nil);
  Qry.Connection    := UserSession.Conexao;

  try

   try
      Qry.SQL.Text  := ' SELECT id, "ticketId" FROM "Messages" '+
                       ' where id=:id           ';
      Qry.ParamByName('id').AsString     :=  id;
      Qry.Open;

      Result := Qry.FieldByName('ticketId').AsInteger;

   except on E: Exception do
       UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Get_TicketByMessage -', E.Message);
   end;


  finally
  Qry.Free
  end;

end;

function TDaoMessages.Get_Token_EvolutionID(Token: String): String;
var
  Qry: TFDQuery;
begin
  Result := '';

  Qry               := TFDQuery.Create(nil);
  Qry.Connection    := UserSession.ConexaoEvolution;

  try

   try
      Qry.SQL.Text  := ' SELECT id, "token" FROM "Instance" '+
                       ' where "token"=:token           ';
      Qry.ParamByName('token').AsString    :=  Token;
      Qry.Open;

      Result := Qry.FieldByName('id').AsString;

   except on E: Exception do
       UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Get_Token_EvolutionID -', E.Message);
   end;

  finally
  Qry.Free
  end;

end;

function TDaoMessages.Get_Total_Tickets(var TotalAtendimento, TotalAguardando: String): String;
var
  Qry: TFDQuery;
begin
  Qry               := TFDQuery.Create(nil);
  Qry.Connection    := UserSession.Conexao;
  TotalAtendimento  := '0';
  TotalAguardando   := '0';

  try

    try

      Qry.SQL.Text :=
        'SELECT                                                                   ' +
        'SUM(CASE WHEN status = ''pending'' THEN 1 ELSE 0 END) AS total_pending,  ' +
        'SUM(CASE WHEN status = ''open'' THEN 1 ELSE 0 END) AS total_open         ' +
        'FROM "Tickets" t                                                         '+
        ' WHERE t."companyId" =:companyId                                         ';
      Qry.ParamByName('companyId').AsInteger     := FCompanyId;
      Qry.Open;
      TotalAtendimento                            := Qry.FieldByName('total_open').AsString;
      TotalAguardando                             := Qry.FieldByName('total_pending').AsString;

    except
      on E: Exception do
        UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao + '- Error', 'Dao.Messages', 'Get_Total_Tickets -', E.Message);
    end;
  finally
    Qry.Free;
  end;
end;

function TDaoMessages.Get_Monta_Card_Aguardando(var CardAtendimento, CardAguardando, CardResolvidos: String): String;
var
  Qry: TFDQuery;
  ListaMessage: TStringList;
  ContactId, Name, ProfilePicUrl: String;
begin
  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;
  ListaMessage   := TStringList.Create;

   try

    try

      Qry.SQL.Text  :=

      'SELECT DISTINCT ON (m."remoteJid")                    '+
      '     m.id as id_mensagem,                             '+
      '     m.body,                                          '+
      '     m.ack,                                           '+
      '     m."read",                                        '+
      '     m."mediaType",                                   '+
      '     m."mediaUrl",                                    '+
      '     m."ticketId",                                    '+
      '     m."createdAt",                                   '+
      '     m."updatedAt",                                   '+
      '     m."fromMe",                                      '+
      '     m."isDeleted",                                   '+
      '     m."contactId",                                   '+
      '     m."quotedMsgId",                                 '+
      '     m."companyId",                                   '+
      '     m."remoteJid",                                   '+
      '     m."dataJson",                                    '+
      '     m.participant,                                   '+
      '     m."queueId",                                     '+
      '     t.status,                                        '+
      '     c.name,                                          '+
      '     c."profilePicUrl",                               '+
      '     c."number"                                       '+
      ' FROM public."Messages" m                             '+
      ' INNER JOIN "Tickets" t ON t.id = m."ticketId"        '+
      ' left join  "Contacts" c on c."id" = m."contactId"    '+
      ' where t.status =:status                              '+
       'AND m."companyId" =:companyId                        ' +
      ' ORDER BY m."remoteJid", m."createdAt" DESC;          ';

      Qry.ParamByName('STATUS').AsString          :='open';
      Qry.ParamByName('companyId').AsInteger      := FCompanyId;
      Qry.Open;
      Qry.First;




      if Qry.RecordCount > 0 then begin

        while not Qry.Eof do begin

           Get_ContactByFone(Qry.FieldByName('remoteJid').AsString,ContactId,Name,ProfilePicUrl);

           UserSession.Clipboard.Put('remoteJid',Qry.FieldByName('remoteJid').AsString);
           UserSession.Clipboard.Put('ContactId',ContactId);


           ListaMessage.Add(

        '  <div class="chat-item" id="'+ContactId+'" onclick="selecionarCard(this)">                                                                                         '+
        '    <div>                                                                                                                                                           '+
        '       <img src="'+Trim(ProfilePicUrl)+'"  alt="Profile Picture" loading="lazy" >                                                                                   '+
        '        <div class="acao">                                                                                                                                          '+
        ' <button type="button" class="btn btn-primary btn-xs" onclick="ajaxCall(''Action'', ''Finalizar='+Qry.FieldByName('ticketId').AsString+''')">Finalizar</button>     '+
        '        </div>                                                                                                                                                      '+
        '    </div>                                                                                                                                                          '+
        '    <div class="chat-content">                                                                                                                                      '+
        '        <div class="phone-number">                                                                                                                                  '+
        '           '+Name+' <i class="fas fa-eye eye-icon"></i>                                                                                                             '+
        '        </div>                                                                                                                                                      '+
        '        <div class="message">                                                                                                                                       '+
        '           '+Copy(Qry.FieldByName('body').AsString,1,50)+'                                                                                                          '+
        '        </div>                                                                                                                                                      '+
        '        <div class="labelConexao">                                                                                                                                  '+
        '            <span class="nameconexao">Conexão:'+FNomeConexao+'</span>                                                                                               '+
        '        </div>                                                                                                                                                      '+
        '        <div class="labels">                                                                                                                                        '+
        '            <span class="label-fila">SEM FILA</span>                                                                                                                '+
        '        </div>                                                                                                                                                      '+
        '    </div>                                                                                                                                                          '+
        '    <div class="time">'+FormatDateTime('hh:nn:ss',Qry.FieldByName('createdAt').AsDateTime)+'</div>                                                                                                                                   '+
        '</div>                                                                                                                                                              ' );

        Qry.Next;
        end;

        CardAtendimento  := ListaMessage.Text;

      end
      else
      begin

        ListaMessage.Add(
        '  <div class="chat-item" id="'+ContactId+'" onclick="selecionarCard(this)">                                                                                                                        '+
        '    <div>                                                                                                                                                           '+
        '       <img src="./assets/img/profile-photos/1.png"  alt="Sem Atendimento" loading="lazy" >                                                                         '+
        '    </div>                                                                                                                                                          '+
        '    <div class="chat-content">                                                                                                                                      '+
        '        <div class="semmessage">                                                                                                                                    '+
        '           <span">Nenhum Atendimento</span>                                                                                                                         '+
        '        </div>                                                                                                                                                      '+
        '    </div>                                                                                                                                                          '+
        '</div>                                                                                                                                                              ' );

       CardAtendimento  := ListaMessage.Text;
      end;

      ListaMessage.Clear;

      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Text  :=

      'SELECT DISTINCT ON (m."remoteJid")                    '+
      '     m.id as id_mensagem,                             '+
      '     m.body,                                          '+
      '     m.ack,                                           '+
      '     m."read",                                        '+
      '     m."mediaType",                                   '+
      '     m."mediaUrl",                                    '+
      '     m."ticketId",                                    '+
      '     m."createdAt",                                   '+
      '     m."updatedAt",                                   '+
      '     m."fromMe",                                      '+
      '     m."isDeleted",                                   '+
      '     m."contactId",                                   '+
      '     m."quotedMsgId",                                 '+
      '     m."companyId",                                   '+
      '     m."remoteJid",                                   '+
      '     m."dataJson",                                    '+
      '     m.participant,                                   '+
      '     m."queueId",                                     '+
      '     t.status,                                        '+
      '     c.name,                                          '+
      '     c."profilePicUrl",                               '+
      '     c."number"                                       '+
      ' FROM public."Messages" m                             '+
      ' INNER JOIN "Tickets" t ON t.id = m."ticketId"        '+
      ' left join  "Contacts" c on c."id" = m."contactId"    '+
      ' where t.status =:status                              '+
      'AND m."companyId" =:companyId                         ' +
      ' ORDER BY m."remoteJid", m."createdAt" DESC;          ';

      Qry.ParamByName('STATUS').AsString          :='pending';
      Qry.ParamByName('companyId').AsInteger      := FCompanyId;
      Qry.Open;
      Qry.First;


      if Qry.RecordCount > 0 then begin


        while not Qry.Eof do begin

           Get_ContactByFone(Qry.FieldByName('remoteJid').AsString,ContactId,Name,ProfilePicUrl);

           if Trim(ProfilePicUrl) = '' then begin

              ProfilePicUrl := './assets/img/profile-photos/1.png';
           end;


           ListaMessage.Add(

          '  <div class="chat-item" id="'+ContactId+'" onclick="selecionarCard(this)">                                                                                                                        '+
          '    <div>                                                                                                                                                           '+
          '       <img src="'+Trim(ProfilePicUrl)+'"  alt="Profile Picture" loading="lazy" >                                                                                   '+
          '        <div class="acao">                                                                                                                                          '+
          ' <button type="button" class="btn btn-success btn-xs" onclick="ajaxCall(''Action'', ''Aceitar='+Qry.FieldByName('ticketId').AsString+''')">Aceitar</button>         '+
          ' <button type="button" class="btn btn-primary btn-xs" onclick="ajaxCall(''Action'', ''Finalizar='+Qry.FieldByName('ticketId').AsString+''')">Finalizar</button>     '+
          '        </div>                                                                                                                                                      '+
          '    </div>                                                                                                                                                          '+
          '    <div class="chat-content">                                                                                                                                      '+
          '        <div class="phone-number">                                                                                                                                  '+
          '           '+Name+' <i class="fas fa-eye eye-icon"></i>                                                                                                             '+
          '        </div>                                                                                                                                                      '+
          '        <div class="message">                                                                                                                                       '+
          '           '+Qry.FieldByName('body').AsString+'                                                                                                                     '+
          '        </div>                                                                                                                                                      '+
          '        <div class="labelConexao">                                                                                                                                  '+
          '            <span class="nameconexao">Conexão:'+FNomeConexao+'</span>                                                                                               '+
          '        </div>                                                                                                                                                      '+
          '        <div class="labels">                                                                                                                                        '+
          '            <span class="label-fila">SEM FILA</span>                                                                                                                '+
          '        </div>                                                                                                                                                      '+
          '    </div>                                                                                                                                                          '+
          '    <div class="time">'+FormatDateTime('hh:nn:ss',Qry.FieldByName('createdAt').AsDateTime)+'</div>                                                                                                                                   '+
          '</div>                                                                                                                                                              ' );

        Qry.Next;
        end;

      CardAguardando  := ListaMessage.Text;

      end
      else
      begin

        ListaMessage.Add(
        '  <div class="chat-item" id="'+ContactId+'" onclick="selecionarCard(this)">                                                                                                                        '+
        '    <div>                                                                                                                                                           '+
        '       <img src="./assets/img/profile-photos/1.png"  alt="Sem Atendimento" loading="lazy" >                                                                         '+
        '    </div>                                                                                                                                                          '+
        '    <div class="chat-content">                                                                                                                                      '+
        '        <div class="semmessage">                                                                                                                                    '+
        '           <span">Nenhum Atendimento</span>                                                                                                                         '+
        '        </div>                                                                                                                                                      '+
        '    </div>                                                                                                                                                          '+
        '</div>                                                                                                                                                              ' );

       CardAguardando  := ListaMessage.Text;

      end;

     ListaMessage.Clear;

      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Text  :=

      'SELECT DISTINCT ON (m."remoteJid")                    '+
      '     m.id as id_mensagem,                             '+
      '     m.body,                                          '+
      '     m.ack,                                           '+
      '     m."read",                                        '+
      '     m."mediaType",                                   '+
      '     m."mediaUrl",                                    '+
      '     m."ticketId",                                    '+
      '     m."createdAt",                                   '+
      '     m."updatedAt",                                   '+
      '     m."fromMe",                                      '+
      '     m."isDeleted",                                   '+
      '     m."contactId",                                   '+
      '     m."quotedMsgId",                                 '+
      '     m."companyId",                                   '+
      '     m."remoteJid",                                   '+
      '     m."dataJson",                                    '+
      '     m.participant,                                   '+
      '     m."queueId",                                     '+
      '     t.status,                                        '+
      '     c.name,                                          '+
      '     c."profilePicUrl",                               '+
      '     c."number"                                       '+
      ' FROM public."Messages" m                             '+
      ' INNER JOIN "Tickets" t ON t.id = m."ticketId"        '+
      ' left join  "Contacts" c on c."id" = m."contactId"    '+
      ' where t.status =:status                              '+
      'AND m."companyId" =:companyId                         ' +
      ' ORDER BY m."remoteJid", m."createdAt" DESC;          ';

      Qry.ParamByName('STATUS').AsString          :='closed';
      Qry.ParamByName('companyId').AsInteger      := FCompanyId;
      Qry.Open;
      Qry.First;


      if Qry.RecordCount > 0 then begin


        while not Qry.Eof do begin

           Get_ContactByFone(Qry.FieldByName('remoteJid').AsString,ContactId,Name,ProfilePicUrl);

           ListaMessage.Add(

          '  <div class="chat-item" id="'+ContactId+'" onclick="selecionarCard(this)">                                                            '+
          '    <div>                                                                                               '+
          '       <img src="'+Trim(ProfilePicUrl)+'"  alt="Profile Picture" loading="lazy" >                       '+
          '    </div>                                                                                              '+
          '    <div class="chat-content">                                                                          '+
          '        <div class="phone-number">                                                                      '+
          '           '+Name+' <i class="fas fa-eye eye-icon"></i>                                                 '+
          '        </div>                                                                                          '+
          '        <div class="message">                                                                           '+
          '           '+Qry.FieldByName('body').AsString+'                                                         '+
          '        </div>                                                                                          '+
          '        <div class="labelConexao">                                                                      '+
          '            <span class="nameconexao">Conexão:'+FNomeConexao+'</span>                                   '+
          '        </div>                                                                                          '+
          '        <div class="labels">                                                                            '+
          '            <span class="label-fila">SEM FILA</span>                                                    '+
          '        </div>                                                                                          '+
          '    </div>                                                                                              '+
          '    <div class="time">'+FormatDateTime('hh:nn:ss',Qry.FieldByName('createdAt').AsDateTime)+'</div>      '+
          '</div>                                                                                                  ' );

        Qry.Next;
        end;

      CardResolvidos  := ListaMessage.Text;

      end
      else
      begin

        ListaMessage.Add(
        '  <div class="chat-item" id="'+ContactId+'" onclick="selecionarCard(this)">                                                      '+
        '    <div>                                                                                         '+
        '       <img src="./assets/img/profile-photos/1.png"  alt="Sem Atendimento" loading="lazy" >       '+
        '    </div>                                                                                        '+
        '    <div class="chat-content">                                                                    '+
        '        <div class="semmessage">                                                                  '+
        '           <span">Nenhum Atendimento</span>                                                       '+
        '        </div>                                                                                    '+
        '    </div>                                                                                        '+
        '</div>                                                                                            ' );


       CardResolvidos    := ListaMessage.Text;

      end;

    except on E: Exception do
     UserSession.DiscordLogger.SendLog(AppConfig.cNome_Aplicacao+ '- Error','Dao.Messages','Get_Monta_Card_Aguardando -',e.Message);
    end;


   finally
   Qry.Free;
   ListaMessage.Free;
   end;

end;

end.


unit Dao.Tickets;

interface

uses
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  Entidade.Filas,
  uPopulaCrud,
  functions.DataBase,
  Entidade.Tickets,
  Dao.Contatos,
  Data.DB;

  function Get_Tickets(id: Longint; var Tickets: TTickets; var vResult: string): Boolean;
  function Set_Tickets (Codigo:Longint; Var Tickets:TTickets; var vResult:string):Boolean;
  function GetAll (ID_EMPRESA:LongInt; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
  function Get_TicketByContact(Numero: string): Integer;

implementation

uses
  FireDAC.Comp.Client, ServerController, System.SysUtils, System.TypInfo;

function Get_TicketByContact(Numero: string): Integer;
var
Qry                           : TFDQuery;
ContactID                     : Integer;
begin

  Result             := 0;
  Qry                := TFDQuery.Create(Nil);
  Qry.Connection     := UserSession.Conexao;

  try

   try

    ContactID   := Get_ContactByNumero(Trim(Numero));


     Qry.SQL.Text  :=

     'SELECT id,"contactId" FROM "Tickets"'+
     'WHERE "contactId"=:contactId'+
     ' and status in (''open'',''pending'')';
     Qry.ParamByName('contactId').AsInteger   := ContactID;
     Qry.Open;
     Qry.First;

      Result   := Qry.FieldByName('id').AsInteger;


   except on E: Exception do
    UserSession.DiscordLogger.SendLog('Erro-','Dao.ProcessaMensagem','Get_Verifica_Status_TicketByContact',e.Message);
   end;

  finally
  Qry.Free;
  end;

end;

function GetAll (ID_EMPRESA:LongInt; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
var
  wresult, SQL_AND               : String;
  wtotal                         : Integer;
  vstart, vlength                : Integer;
  Pessoa ,Tomador,Usuario,Status : String;
  QtdeConsultas                  : LongInt;
  vOrderBy                       : String;
  Buttons,BtnOptions             : String;
  Qry                            : TFDQuery;
  BTN_EDITAR,BTN_EXCLUIR         : String;
begin

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   try

    vstart       := StrToIntDef(aParams.Values['start'], 0);
    vlength      := StrToIntDef(aParams.Values['length'], 10);


      Qry.SQL.Add('SELECT *  FROM "Queues" ');
      Qry.SQL.Add(' WHERE "companyId"='+ID_EMPRESA.ToString                                                                             );


     if aParams.Values['search[value]'] <> '' then begin

            SQL_AND :=' AND "name" like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' color like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' "greetingMessage" like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%''';

      Qry.SQL.Add(SQL_AND);

     end;

      case UserType of
        tpAdmin:      begin

                    end;

        tpUser:  begin
                   //     Qry.SQL.Add(' AND n.cod_prestador='+UserSession.IDEmpLogada.ToString);
                    end;

        tpRevenda:  begin

                    end;
      end;


      case StrToIntDef(aParams.Values['order[0][column]'],0) of

        0: Qry.SQL.Add(' Order by "name"      '+aParams.Values['order[0][dir]']  + ' ');
        1: Qry.SQL.Add(' Order by color            '+aParams.Values['order[0][dir]']  + ' ');
        2: Qry.SQL.Add(' Order by "greetingMessage"       '+aParams.Values['order[0][dir]']  + ' ');

      end;


      Qry.Open;
      wtotal        := Qry.RecordCount;  // Total de registros sem paginação

      // Aplicar paginação
      Qry.FetchOptions.RecsSkip := vstart;
      Qry.FetchOptions.RecsMax  := vlength;
      Qry.Refresh;
      Qry.First;


      wresult:='{'+
        '"draw": '+StrToIntDef(aParams.Values['draw'],0).ToString + ', ' +
        '"recordsTotal": '+wtotal.ToString + ', ' +
        '"recordsFiltered": '+wtotal.ToString + ', ' +
        '"data": [';

       QtdeConsultas   := 0;


      while not Qry.Eof do
      begin

        BTN_EDITAR         := '';
        BTN_EXCLUIR        := '';

        BTN_EDITAR         := ' <button id=\"BTN_EDITAR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Editar\" type=\"button\"'+
                              ' class=\"btn btn-primary '+Button_Size+'\"    onclick=\"ajaxCall(''actions'', ''Edit='+Qry.FieldByName('ID').AsString+''')\"><i class=\"'+Icon_Edit+'\"></i></button> ';

        BTN_EXCLUIR       := ' <button id=\"BTN_CANCELAR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Cancelar\" type=\"button\"'+
                             ' class=\"btn btn-danger '+Button_Size+'\"   onclick=\"ajaxCall(''actions'', ''cancelamento='+Qry.FieldByName('ID').AsString+''')\"><i class=\"'+Icon_Delete+'\"></i></button> ';




        wresult := wresult + '['+

                             '"'+Trim(Qry.FieldByName('name').AsString)+'", '+
                             '"'+Trim(Qry.FieldByName('color').AsString)+'", '+
                             '"'+Trim(Qry.FieldByName('greetingMessage').AsString) +'", '+
                             '"'+
                              BTN_EDITAR + BTN_EXCLUIR+
                             '"'+

                             '],';

        Qry.Next;

      end;

     Qry.Close;
    if wtotal <= 0 then
      wresult := wresult + ']}'
    else
      wresult := LeftStr(Trim(wresult),Length(Trim(wresult))-1) + ']}';

      aResult := RemoveCaracteresInvalidos(wresult);


   except on E: Exception do
    UserSession.DiscordLogger.SendLog('Error','Dao.Filas','GetAll',e.Message);
   end;

  finally
  Qry.Free;
  end;

end;

function Get_Tickets(id: Longint; var Tickets: TTickets; var vResult: string): Boolean;
var
  Qry: TFDQuery;
begin


  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;


  try

    try

      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Add('Select * from "Tickets" where id =:id');
      Qry.ParamByName('id').AsInteger   := id;
      Qry.Open;

      if Qry.RecordCount <=0 then
        Exit;


      if not Qry.IsEmpty then
      begin
        TPopulateFromQuery<TTickets>.PopulateFromDataSet(Tickets, Qry);
      end;

      Result := True;

    except on E: Exception do

		      UserSession.DiscordLogger.SendLog(
        'Erro ao Selecionar Tickets',
        'Dao.Tickets',
        'Get_Tickets',
        '- Erro : '+ e.Message);
    end;
  finally
    Qry.Free;
  end;



end;

function Set_Tickets (Codigo:Longint; Var Tickets:TTickets; var vResult:string):Boolean;
var
  Qry           : TFDQuery;
  GUID       : TGUID;
  GUIDString : string;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;



  try

      if Tickets.id = 0 then
         Tickets.id  := NextGeneratorPosteGresql('Tickets_id_seq');

          if Tickets.Uuid = '' then
          begin
            if CreateGUID(GUID) = S_OK then
            begin
              // GUIDToString já inclui as chaves '{...}'
              GUIDString := GUIDToString(GUID);
              Tickets.Uuid := GUIDString;
            end;
          end
          else
          begin
            // Se a propriedade já tinha string, converta pra TGUID local
            GUID := StringToGUID(Tickets.Uuid);
          end;
   try


    Qry.SQL.Text   :=

      'INSERT INTO public."Tickets" (                         '+
      '  id, status, "lastMessage", "contactId", "userId",    '+
      '  "createdAt", "updatedAt", "whatsappId", "isGroup",   '+
      '  "unreadMessages", "queueId", "companyId", uuid,      '+
      '  chatbot, "queueOptionId", channel                    '+
      ') VALUES ('+
      '  :id, :status, :lastMessage, :contactId, :userId,     '+
      '  :createdAt, :updatedAt, :whatsappId, :isGroup,       '+
      '  :unreadMessages, :queueId, :companyId, :uuid,        '+
      '  :chatbot, :queueOptionId, :channel                   '+
      ') ON CONFLICT (id) DO UPDATE SET                       '+
      '  status = EXCLUDED.status,                            '+
      '  "lastMessage" = EXCLUDED."lastMessage",              '+
      '  "contactId" = EXCLUDED."contactId",                  '+
      '  "userId" = EXCLUDED."userId",                        '+
      '  "createdAt" = EXCLUDED."createdAt",                  '+
      '  "updatedAt" = EXCLUDED."updatedAt",                  '+
      '  "whatsappId" = EXCLUDED."whatsappId",                '+
      '  "isGroup" = EXCLUDED."isGroup",                      '+
      '  "unreadMessages" = EXCLUDED."unreadMessages",        '+
      '  "queueId" = EXCLUDED."queueId",                      '+
      '  "companyId" = EXCLUDED."companyId",                  '+
      '  uuid = EXCLUDED.uuid,                                '+
      '  chatbot = EXCLUDED.chatbot,                          '+
      '  "queueOptionId" = EXCLUDED."queueOptionId",          '+
      '  channel = EXCLUDED.channel;                          ';


    Qry.ParamByName('id').AsInteger                   := Tickets.id;
    Qry.ParamByName('status').AsString                := Tickets.status;
    Qry.ParamByName('lastMessage').AsString           := Tickets.lastMessage;
    Qry.ParamByName('contactId').AsInteger            := Tickets.contactId;
    Qry.ParamByName('userId').AsInteger               := Tickets.userId;
    Qry.ParamByName('createdAt').AsDateTime           := Tickets.createdAt;
    Qry.ParamByName('updatedAt').AsDateTime           := Tickets.updatedAt;
    Qry.ParamByName('whatsappId').AsInteger           := Tickets.whatsappId;
    Qry.ParamByName('isGroup').AsBoolean              := Tickets.isGroup;
    Qry.ParamByName('unreadMessages').AsInteger       := Tickets.unreadMessages;
    Qry.ParamByName('queueId').AsInteger              := Tickets.queueId;
    Qry.ParamByName('companyId').AsInteger            := Tickets.companyId;

    with Qry.ParamByName('uuid') do
    begin
      DataType     := ftGuid;
      DataTypeName := 'uuid';
      Size         := 16;
      AsGuid       := GUID;
    end;

    Qry.ParamByName('chatbot').AsBoolean              := Tickets.chatbot;
    Qry.ParamByName('queueOptionId').AsInteger        := Tickets.queueOptionId;
    Qry.ParamByName('channel').AsString               := Tickets.channel;
    Qry.ExecSQL;

   Result := True;

   except on E: Exception do

    UserSession.DiscordLogger.SendLog('Error','Dao.Set_Tickets','Set_Tickets',E.Message);

   end;

  finally
    Qry.Free;
  end;
end;


end.


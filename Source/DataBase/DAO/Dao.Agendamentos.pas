unit Dao.Agendamentos;

interface

  uses
    App.Config,
    Buttons.Icons,
    Data.DB,
    System.Classes,
    FireDAC.Stan.Param,
    System.StrUtils,
    ServerController,
    System.SysUtils,
    FireDAC.Comp.Client,
    Tipos.Types,
    Integracao.Discord,
    Entidade.Agendamentos,
    Functions.Strings,
    uPopulaCrud,
    Functions.DataBase;

    function Get_Agendamentos(ID:LongInt; var Agendamento:TAgendamentos; var vResult:String)   : Boolean;
    function Set_Agendamento(Codigo:Longint; var Agendamento:TAgendamentos; var vResult:string)               : Boolean;
    function Delete_Agendamentos(ID:Longint)                   : Boolean;
    function Get_Agendamento(ID_EMPRESA:LongInt;  Status:Integer; aParams: TStrings; out aResult: String; UserType : TUserType):string;

implementation

uses System.DateUtils;

function Get_Agendamentos(ID:LongInt; var Agendamento:TAgendamentos; var vResult:String): Boolean;
var
Qry     : TFDQuery;
begin

  Result := False;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('Select * from "Schedules" where id =:id');
    Qry.ParamByName('id').AsInteger          := ID;

   try

    Qry.Open;

      if not Qry.IsEmpty then
      begin
        TPopulateFromQuery<TAgendamentos>.PopulateFromDataSet(Agendamento, Qry);
      end;

     Result := True;

   except

    on e:exception do

     UserSession.DiscordLogger.SendLog('Error:','Dao.Agendamentos','Get',e.Message);

   end;

  finally
   Qry.Free;
  end;

end;

function Set_Agendamento   (Codigo:Longint; var Agendamento:TAgendamentos; var vResult:string)               : Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

      if Agendamento.id = 0 then begin
         Agendamento.id       := NextGeneratorPosteGresql('Schedules_id_seq');
         Agendamento.status   := 5;
      end;
      Agendamento.companyId     := UserSession.Clipboard['Loguin_companyId'].I;
      Agendamento.userId        := UserSession.Clipboard['Loguin_id'].I;

   try

     TSaveObjectToDatabase<TAgendamentos>.Save(Agendamento, Qry, 'Schedules');



     Result := True;

   except on E: Exception do

    UserSession.DiscordLogger.SendLog('Error','Dao.Agendamentos','Set_Queues',E.Message);

   end;

  finally
    Qry.Free;
  end;
end;

function Delete_Agendamentos (ID:Longint)                   : Boolean;
var
  Qry   :TFDQuery;
begin

  Result := False;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

    try

     Qry.Close;
     Qry.sql.Clear;
     Qry.SQL.Text    := ' update "Schedules" SET "Status"=:status  '+
                        ' where id =:id';
     Qry.ParamByName('id').AsInteger     := ID;
     Qry.ParamByName('status').AsInteger := 3;
     Qry.ExecSQL;

     Result := True;

     except on E: Exception do

       UserSession.DiscordLogger.SendLog('Error','Dao.Agendamentos','Delete_Agendamentos',E.Message);
    end;

  finally
  Qry.Free;
  end;

end;

function Get_Agendamento (ID_EMPRESA:LongInt; Status:Integer; aParams: TStrings; out aResult: String; UserType : TUserType):string;
var
  wresult, SQL_AND               : String;
  wtotal                         : Integer;
  vstart, vlength                : Integer;
  vOrderBy                       : String;
  Qry                            : TFDQuery;
  BTN_EDITAR,BTN_EXCLUIR         : String;
begin

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   try

    vstart       := StrToIntDef(aParams.Values['start'], 0);
    vlength      := StrToIntDef(aParams.Values['length'], 10);


    Qry.SQL.Text   :=

       '   SELECT                                                              '+
       '   s.id,                                                               '+
       '   s.body,                                                             '+
       '   s."sendAt",                                                         '+
       '   s.descricao,                                                        '+
       '   s."sentAt",                                                         '+
       '   s."userId",                                                         '+
       '   s."companyId",                                                      '+
       '   s."createdAt",                                                      '+
       '   s."updatedAt",                                                      '+
       '   s."Status",                                                         '+
       '   s2.descricao AS Status_Descricao,                                   '+
       '   STRING_AGG(c.name, '', '') AS nomecontatos,                         '+
       '   CASE                                                                '+
       '   WHEN s."saveMessage" = true THEN ''Sim''                            '+
       '   ELSE ''Não''                                                        '+
       '   END AS save_message                                                 '+
       '   FROM "Schedules" s                                                  '+
       '   LEFT JOIN LATERAL (                                                 '+
       '   SELECT name                                                         '+
       '   FROM "Contacts" c                                                   '+
       '   WHERE c.id::text = ANY(string_to_array(s."contactId"::text, '','')) '+
       '   ) c ON true                                                         '+
       '   LEFT JOIN "Status" s2 ON s2.id = s."Status"                         '+
       '   WHERE s."companyId" =:companyId                                     '+
       '   GROUP BY                                                            '+
       '   s.id, s.body, s."sendAt", s.descricao, s."sentAt",                  '+
       '   s."userId", s."companyId", s."createdAt", s."updatedAt",            '+
       '   s."Status", s2.descricao, s."saveMessage"                           ';

       Qry.ParamByName('companyId').AsInteger   := ID_EMPRESA;


      if Status >0 then begin
        Qry.SQL.Add(' and s."Status"=:status');
        Qry.ParamByName('status').AsInteger  := Status;
      end
      else begin
        Qry.SQL.Add(' and s."Status" in (4,5)');
      end;


     if aParams.Values['search[value]'] <> '' then begin

            SQL_AND :=' AND descricao like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' body like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' ''sendAt'' like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' Status like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' body like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%''';

      Qry.SQL.Add(SQL_AND);

     end;


      case UserType of

        tpAdmin:     begin
                       // Fazer as Verificações de Super Usuario/Admin/User;
                     end;

        tpUser:      begin
                       // Fazer as Verificações de Super Usuario/Admin/User;
                     end;

        tpRevenda:   begin
                       // Fazer as Verificações de Super Usuario/Admin/User;
                     end;
      end;


      case StrToIntDef(aParams.Values['order[0][column]'],0) of

        0: Qry.SQL.Add(' Order by id              '+aParams.Values['order[0][dir]']  + ' ');
        1: Qry.SQL.Add(' Order by nomecontatos    '+aParams.Values['order[0][dir]']  + ' ');
        2: Qry.SQL.Add(' Order by descricao       '+aParams.Values['order[0][dir]']  + ' ');
        3: Qry.SQL.Add(' Order by BODY            '+aParams.Values['order[0][dir]']  + ' ');
        4: Qry.SQL.Add(' Order by BODY            '+aParams.Values['order[0][dir]']  + ' ');
        5: Qry.SQL.Add(' Order by save_message    '+aParams.Values['order[0][dir]']  + ' ');
        6: Qry.SQL.Add(' Order by Status          '+aParams.Values['order[0][dir]']  + ' ');

      end;


      Qry.Open;
      wtotal    := Qry.RecordCount;  // Total de registros sem paginação

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

      while not Qry.Eof do
      begin

        BTN_EDITAR         := '';
        BTN_EXCLUIR        := '';

        BTN_EDITAR         := ' <button id=\"BTN_EDITAR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Editar\" type=\"button\"'+
                              ' class=\"btn btn-primary '+Button_Size+'\"    onclick=\"ajaxCall(''actions'', ''Edit='+Qry.FieldByName('ID').AsString+''')\"><i class=\"'+Icon_Edit+'\"></i></button> ';

        BTN_EXCLUIR       := ' <button id=\"BTN_DELETE\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Excluir\" type=\"button\"'+
                             ' class=\"btn btn-danger '+Button_Size+'\"   onclick=\"ajaxCall(''actions'', ''Deletar='+Qry.FieldByName('ID').AsString+''')\"><i class=\"'+Icon_Delete+'\"></i></button> ';

        wresult := wresult + '['+
                              '"'+Qry.FieldByName('id').AsString+'", '+
                              '"'+Qry.FieldByName('nomecontatos').AsString+'", '+
                              '"'+Qry.FieldByName('descricao').AsString+'", '+
                              '"'+Qry.FieldByName('body').AsString+'", '+
                              '"'+ StringReplace(Trim(DatahoraBrasileira(Qry.FieldByName('sendAt').AsDateTime)), '"', '\"', [rfReplaceAll])+'", '+
                              '"'+ StringReplace(Trim(Qry.FieldByName('save_message').AsString), '"', '\"', [rfReplaceAll])+'", '+
                              '"'+Qry.FieldByName('Status_Descricao').AsString+'", '+
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
       UserSession.DiscordLogger.SendLog('Error','Dao.Agendamentos','GetAll',E.Message);
   end;

  finally
  Qry.Free;
  end;

end;

end.

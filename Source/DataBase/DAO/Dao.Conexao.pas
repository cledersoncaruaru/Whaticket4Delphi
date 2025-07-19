unit Dao.Conexao;

interface

uses
  ServerController,
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  Entidade.Conexao,
  uPopulaCrud,
  functions.DataBase,
  Data.DB;

  function Get_Whatsapps(id: Longint; var Conexao: TConexao; var vResult: string): Boolean;
  function Set_Whatsapps (Codigo:Longint; Var Conexao:TConexao; var vResult:string; Lista: TStringList):Boolean;
  function Set_Whatsapps_Queues(Lista:TStringList; whatsappId:Integer):Boolean;
  function GetAll (CompanyId:LongInt; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
  function Delete_Whatsapps (ID:Longint; var vResult:string):Boolean;
  function UpdateSuatus_Whatsapps (Name,Status:String; var vResult:string):Boolean;
  function Set_Whatsapps_teste (Codigo:Longint; Var Conexao:TConexao; var vResult:string):Boolean;
  function Get_TokenByIDCompany(IDCompany:Integer):string;
  function Get_InstanciaByIDCompany(IDCompany:Integer):string;
  function Get_NomeByIDCompany(IDCompany:Integer):string;
  function Get_CompanyByAPIKey(ApiKey:String):Integer;
  function Get_CompanyIDByAPIKey(ApiKey:String):Integer;
  function Get_Whatsapps_Queues(whatsappId: Longint): String;
  function Get_CompanyByInstanceId(InstanceId:String):String;



implementation

uses
  FireDAC.Comp.Client, System.SysUtils, System.TypInfo;

function Get_CompanyByInstanceId(InstanceId:String):String;
var
  Qry               : TFDQuery;
begin
  Result            := '';

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   Qry.SQL.Text  :=  'select id,apikey,"companyId" from "Whatsapps"  '+
                     ' where "instanceid"=:instanceid                ';

   Qry.ParamByName('instanceid').AsString   := InstanceId;
   Qry.Open;
   Qry.First;

   if Qry.RecordCount >0 then
      Result    := Qry.FieldByName('apikey').AsString;


  finally
   Qry.Free;
  end;

end;


function Get_CompanyByAPIKey(ApiKey:String):Integer;
var
  Qry               : TFDQuery;
begin
  Result            := 0;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   Qry.SQL.Text  :=  'select id,"token",apikey,"companyId" from "Whatsapps" '+
                     ' where "token"=:token             ';

   Qry.ParamByName('token').AsString   := ApiKey;
   Qry.Open;
   Qry.First;

   if Qry.RecordCount >0 then
      Result    := Qry.FieldByName('companyId').AsInteger;


  finally
   Qry.Free;
  end;

end;

function Get_CompanyIDByAPIKey(ApiKey:String):Integer;
var
  Qry               : TFDQuery;
begin
  Result            := 0;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   Qry.SQL.Text  :=  'select id,"token",apikey,"companyId" from "Whatsapps" '+
                     ' where "token"=:token             ';

   Qry.ParamByName('token').AsString   := ApiKey;
   Qry.Open;
   Qry.First;

   if Qry.RecordCount >0 then
      Result    := Qry.FieldByName('id').AsInteger;


  finally
   Qry.Free;
  end;

end;



function Get_TokenByIDCompany(IDCompany:Integer):string;
var
  Qry               : TFDQuery;
begin
  Result            := '';

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   Qry.SQL.Text  :=  'select id,"token",apikey from "Whatsapps" '+
                     ' where "companyId"=:companyId             ';

   Qry.ParamByName('companyId').AsInteger   := IDCompany;
   Qry.Open;
   Qry.First;

   if Qry.RecordCount >0 then
      Result    := Qry.FieldByName('apikey').AsString;


  finally
   Qry.Free;
  end;

end;


function Get_InstanciaByIDCompany(IDCompany:Integer):string;
var
  Qry               : TFDQuery;
begin
  Result            := '';

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   Qry.SQL.Text  :=  'select id,instanceid from "Whatsapps" '+
                     ' where "companyId"=:companyId             ';

   Qry.ParamByName('companyId').AsInteger   := IDCompany;
   Qry.Open;
   Qry.First;

   if Qry.RecordCount >0 then
      Result    := Qry.FieldByName('instanceid').AsString;


  finally
   Qry.Free;
  end;

end;


function Get_NomeByIDCompany(IDCompany:Integer):string;
var
  Qry               : TFDQuery;
begin
  Result            := '';

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   Qry.SQL.Text  :=  'select id,name from "Whatsapps" '+
                     ' where "companyId"=:companyId             ';

   Qry.ParamByName('companyId').AsInteger   := IDCompany;
   Qry.Open;
   Qry.First;

   if Qry.RecordCount >0 then
      Result    := Qry.FieldByName('name').AsString;


  finally
   Qry.Free;
  end;

end;



function UpdateSuatus_Whatsapps (Name,Status:String; var vResult:string):Boolean;
var
  Qry               : TFDQuery;
begin
  Result            := False;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

 try

  try


   Qry.SQL.Add('UPDATE "Whatsapps" set status=:status,"updatedAt"=:updatedAt');
   Qry.SQL.Add('WHERE Name=:Name');
   Qry.ParamByName('Name').AsString           := Name;
   Qry.ParamByName('status').AsString         := Status;
   Qry.ParamByName('updatedAt').AsDateTime    := Now;
   Qry.ExecSQL;

   Result   := True;


  except on E: Exception do
    UserSession.DiscordLogger.SendLog('Error:','Dao.Conexao','UpdateSuatus_Whatsapps',e.Message);
  end;


 finally
 Qry.Free;
 end;

end;

function Delete_Whatsapps (ID:Longint; var vResult:string):Boolean;
var
  Qry               : TFDQuery;
begin
  Result            := False;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;


  try

   try

      Qry.SQL.Add('DELETE FROM public."Whatsapps" ') ;
      Qry.SQL.Add(' WHERE id=:ID                  ');
      Qry.ParamByName('ID').AsInteger    := ID;
      Qry.ExecSQL;

      Result  := True;

   except on E: Exception do
    UserSession.DiscordLogger.SendLog('Error:','Dao.Conexao','Delete_Whatsapps',e.Message);
   end;

  finally
  Qry.Free;
  end;


end;



function GetAll (CompanyId:LongInt; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
var
  Qry                            : TFDQuery;
  wresult, SQL_AND               : String;
  wtotal                         : Integer;
  vstart, vlength                : Integer;
  vOrderBy                       : String;
  BTN_EDITAR,BTN_EXCLUIR         : String;
  BTN_STATUS,BTN_QRCODE          : String;
begin

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   try

      vstart       := StrToIntDef(aParams.Values['start'], 0);
      vlength      := StrToIntDef(aParams.Values['length'], 10);


      Qry.SQL.Add(' select * from "Whatsapps" w                 ');
      Qry.SQL.Add('WHERE w."companyId"='+CompanyId.ToString   );

      case UserType of
        tpAdmin: begin

                    end;

        tpUser:  begin
                   //     Qry.SQL.Add(' AND n.cod_prestador='+UserSession.IDEmpLogada.ToString);
                    end;

        tpRevenda:  begin

                    end;
      end;


      case StrToIntDef(aParams.Values['order[0][column]'],0) of

        0: Qry.SQL.Add(' Order by name            '+aParams.Values['order[0][dir]']  + ' ');
        1: Qry.SQL.Add(' Order by status          '+aParams.Values['order[0][dir]']  + ' ');
        2: Qry.SQL.Add(' Order by status          '+aParams.Values['order[0][dir]']  + ' ');
        3: Qry.SQL.Add(' Order by updatedAt       '+aParams.Values['order[0][dir]']  + ' ');
        4: Qry.SQL.Add(' Order by isDefault       '+aParams.Values['order[0][dir]']  + ' ');
      end;


      Qry.Open;
      wtotal    := Qry.RecordCount;

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
                              ' class=\"btn btn-primary '+Button_Size+'\"    onclick=\"ajaxCall(''Actions'', ''Edit='+Qry.FieldByName('ID').AsString+''')\"><i class=\"'+Icon_Edit+'\"></i></button> ';

        BTN_EXCLUIR       := ' <button id=\"BTN_CANCELAR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Excluir\" type=\"button\"'+
                             ' class=\"btn btn-danger '+Button_Size+'\"   onclick=\"ajaxCall(''Actions'', ''Excluir='+Qry.FieldByName('ID').AsString+'&Name='+Qry.FieldByName('NAME').AsString+''')\"><i class=\"'+Icon_Delete+'\"></i></button> ';


        BTN_STATUS        := ' <button id=\"BTN_STATUS\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Status\" type=\"button\"'+
                             ' class=\"btn btn-info '+Button_Size+'\"   onclick=\"ajaxCall(''Actions'', ''Status='+Qry.FieldByName('ID').AsString+'&Name='+Qry.FieldByName('NAME').AsString+''')\"><i class=\"'+Icon_State+'\"></i></button> ';

        BTN_QRCODE        := ' <button id=\"BTN_QRCODE\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"QrCode\" type=\"button\"'+
                             ' class=\"btn btn-success '+Button_Size+'\"   onclick=\"ajaxCall(''Actions'', ''QrCode='+Qry.FieldByName('ID').AsString+'&Name='+Qry.FieldByName('NAME').AsString+'''); chamaMsgHoldon(''Aguarde, Gerando o QrCode ...'')\"><i class=\"'+Icon_QrCode+'\"></i></button> ';


        wresult := wresult + '['+

                                '"'+Qry.FieldByName('id').AsString+'", '+
                                '"'+Qry.FieldByName('NAME').AsString+'", '+
                                '"'+Qry.FieldByName('STATUS').AsString+'", '+
                                '"'+Qry.FieldByName('STATUS').AsString+'", '+
                                '"'+Qry.FieldByName('updatedAt').AsString+'", '+
                                '"'+Qry.FieldByName('isDefault').AsString+'", '+
                                '"'+
                                 BTN_EDITAR + BTN_STATUS + BTN_QRCODE +BTN_EXCLUIR+
                             '"'+

                             '],';

        Qry.Next;

      end;

     Qry.Close;
    if wtotal <= 0 then
      wresult := wresult + ']}'
    else
      wresult := LeftStr(Trim(wresult),Length(Trim(wresult))-1) + ']}';

      aResult := wresult;


   except on E: Exception do
    UserSession.DiscordLogger.SendLog('Error:','Dao.Conexao','GetAll',e.Message);
   end;

  finally
  Qry.Free;
  end;


end;

function Get_Whatsapps(id: Longint; var Conexao: TConexao; var vResult: string): Boolean;
var
  Qry: TFDQuery;
begin


  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;


  try

    try

      Qry.SQL.Text  :=
      ' Select * from "Whatsapps"  '+
      ' where id =:id              '+
      ' and "companyId"=:companyId;   ';

      Qry.ParamByName('id').AsInteger           := id;
      Qry.ParamByName('companyId').AsInteger    := UserSession.CompanyId;
      Qry.Open;

      if Qry.RecordCount <=0 then
        Exit;

      if not Qry.IsEmpty then
      begin
        TPopulateFromQuery<TConexao>.PopulateFromDataSet(Conexao, Qry);
      end;

      Result := True;

    except on E: Exception do
         UserSession.DiscordLogger.SendLog('Error','Dao.Conexão','Get_Whatsapps', E.Message);
    end;
  finally
    Qry.Free;
  end;



end;

function Set_Whatsapps (Codigo:Longint; Var Conexao:TConexao; var vResult:string; Lista: TStringList):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;



  try

    if Conexao.id <=0 then begin

     Conexao.id    := NextGeneratorPosteGresql('Whatsapps_id_seq');

    end;

      Conexao.proxyConfig := '[]';



   try

    Qry.SQL.Text   :=
    ' INSERT INTO "Whatsapps" (id,"session", qrcode, status, battery, plugged, "createdAt",                                     '+
    ' "updatedAt", "name", "isDefault", retries, "greetingMessage", "companyId", "complationMessage",                           '+
    ' "outOfHoursMessage", "ratingMessage", "token", "farewellMessage", provider, channel, "facebookUserToken",                 '+
    ' "tokenMeta", "facebookPageUserId", "facebookUserId", "transferMessage", "restrictToQueues", "transferToNewTicket",        '+
    ' "proxyConfig", apikey, "number", instanceid, integration,queueid)                                                                 '+
    ' VALUES (:id,:session, :qrcode, :status, :battery, :plugged, :createdAt, :updatedAt, :name, :isDefault,                    '+
    ' :retries, :greetingMessage, :companyId, :complationMessage, :outOfHoursMessage, :ratingMessage, :token,                   '+
    ':farewellMessage, :provider, :channel, :facebookUserToken, :tokenMeta, :facebookPageUserId, :facebookUserId,               '+
    ':transferMessage, :restrictToQueues, :transferToNewTicket, :proxyConfig, :apikey, :number, :instanceid, :integration,:queueid)      '+
    ' ON CONFLICT (id)                                                                                                          '+
    ' DO UPDATE                                                                                                                 '+
    ' SET "session"=EXCLUDED."session", qrcode=EXCLUDED.qrcode, status=EXCLUDED.status,                                         '+
    ' battery=EXCLUDED.battery, plugged=EXCLUDED.plugged, "createdAt"=EXCLUDED."createdAt",                                     '+
    ' "updatedAt"=EXCLUDED."updatedAt", "name"=EXCLUDED."name", "isDefault"=EXCLUDED."isDefault",                               '+
    ' retries=EXCLUDED.retries, "greetingMessage"=EXCLUDED."greetingMessage", "companyId"=EXCLUDED."companyId",                 '+
    '"complationMessage"=EXCLUDED."complationMessage", "outOfHoursMessage"=EXCLUDED."outOfHoursMessage",                        '+
    '"ratingMessage"=EXCLUDED."ratingMessage", "token"=EXCLUDED."token", "farewellMessage"=EXCLUDED."farewellMessage",          '+
    ' provider=EXCLUDED.provider, channel=EXCLUDED.channel, "facebookUserToken"=EXCLUDED."facebookUserToken",                   '+
    '"tokenMeta"=EXCLUDED."tokenMeta", "facebookPageUserId"=EXCLUDED."facebookPageUserId", "facebookUserId"=EXCLUDED."facebookUserId",'+
    ' "transferMessage"=EXCLUDED."transferMessage", "restrictToQueues"=EXCLUDED."restrictToQueues",                             '+
    ' "transferToNewTicket"=EXCLUDED."transferToNewTicket", "proxyConfig"=EXCLUDED."proxyConfig",                               '+
    ' apikey=EXCLUDED.apikey, "number"=EXCLUDED."number", instanceid=EXCLUDED.instanceid, integration=EXCLUDED.integration,queueid=EXCLUDED.queueid; ';

    Qry.ParamByName('id').AsInteger                  := Conexao.id;

    Qry.ParamByName('session').DataType              := ftString;
    Qry.ParamByName('session').Size                  := Length(Conexao.session);
    Qry.ParamByName('session').AsString              := Conexao.session;
    Qry.ParamByName('qrcode').DataType               := ftString;
    Qry.ParamByName('qrcode').Size                   := Length(Conexao.qrcode);
    Qry.ParamByName('qrcode').AsString               := Conexao.qrcode;
    Qry.ParamByName('status').AsString               := Conexao.status;
    Qry.ParamByName('battery').AsString              := Conexao.battery;
    Qry.ParamByName('plugged').AsBoolean             := Conexao.plugged;
    Qry.ParamByName('createdAt').AsDateTime          := Conexao.updatedAt;
    Qry.ParamByName('updatedAt').AsDateTime          := Conexao.updatedAt;
    Qry.ParamByName('name').AsString                 := Conexao.name;
    Qry.ParamByName('isDefault').AsBoolean           := Conexao.isDefault;
    Qry.ParamByName('retries').AsInteger             := Conexao.retries;
    Qry.ParamByName('greetingMessage').AsString      := Conexao.greetingMessage;
    Qry.ParamByName('companyId').AsInteger           := Conexao.companyId;
    Qry.ParamByName('complationMessage').AsString    := Conexao.complationMessage;
    Qry.ParamByName('outOfHoursMessage').AsString    := Conexao.outOfHoursMessage;
    Qry.ParamByName('ratingMessage').AsString        := Conexao.ratingMessage;
    Qry.ParamByName('token').AsString                := Conexao.token;
    Qry.ParamByName('farewellMessage').AsString      := Conexao.farewellMessage;
    Qry.ParamByName('provider').AsString             := Conexao.provider;
    Qry.ParamByName('channel').AsString              := Conexao.channel;
    Qry.ParamByName('facebookUserToken').AsString    := Conexao.facebookUserToken;
    Qry.ParamByName('tokenMeta').AsString            := Conexao.tokenMeta;
    Qry.ParamByName('facebookPageUserId').AsString   := Conexao.facebookPageUserId;
    Qry.ParamByName('facebookUserId').AsString       := Conexao.facebookUserId;
    Qry.ParamByName('transferMessage').AsString      := Conexao.transferMessage;
    Qry.ParamByName('restrictToQueues').AsBoolean    := Conexao.restrictToQueues;
    Qry.ParamByName('transferToNewTicket').AsBoolean := Conexao.transferToNewTicket ;
    Qry.ParamByName('proxyConfig').Value             := Conexao.proxyConfig;
    Qry.ParamByName('proxyConfig').DataType          := ftWideMemo;
    Qry.ParamByName('proxyConfig').DataTypeName      := 'jsonb';
    Qry.ParamByName('apikey').AsString               := Conexao.apikey;
    Qry.ParamByName('number').AsString               := Conexao.number;
    Qry.ParamByName('instanceid').AsString           := Conexao.instanceid;
    Qry.ParamByName('integration').AsString          := Conexao.integration;
    Qry.ParamByName('queueid').AsInteger             := Conexao.queueid;
    Qry.ExecSQL;

    Result := Set_Whatsapps_Queues(Lista,Conexao.id);

   except on E: Exception do

    UserSession.DiscordLogger.SendLog('Error','Dao.Conexao','Set_Whatsapps - ', E.Message);

   end;

  finally
    Qry.Free;
  end;
end;
function Set_Whatsapps_teste (Codigo:Longint; Var Conexao:TConexao; var vResult:string):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

   try

    if Conexao.id <=0 then begin

     Conexao.id    := NextGeneratorPosteGresql('Whatsapps_id_seq');

    end;

      Conexao.proxyConfig := '[]';

       qry.SQL.Text  := 'update Whatsapps set proxyConfig=:proxyConfig where id=2';
       qry.ParamByName('proxyConfig').AsString   := Conexao.proxyConfig;
   try

     Qry.ExecSQL;
     Result := True;


   except on E: Exception do

    UserSession.DiscordLogger.SendLog('Error','Dao.Conexao','Set_Whatsapps - ', E.Message);

   end;

  finally
    Qry.Free;
  end;
end;

function Get_Whatsapps_Queues(whatsappId: Longint): String;
var
  Qry: TFDQuery;
begin


  Result := '';

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;


  try

    try


       Qry.SQL.Text :=
      'SELECT string_agg(CAST("queueId" AS TEXT), '','') AS fila_ids ' +
      'FROM "WhatsappQueues" ' +
      'WHERE "whatsappId" = :whatsappId';

      Qry.ParamByName('whatsappId').AsInteger := whatsappId;
      Qry.Open;

      Result := Qry.FieldByName('fila_ids').AsString;

    except on E: Exception do

        UserSession.DiscordLogger.SendLog('Error','Dao.Conexao','Get_Whatsapps_Queues - Error: - ' , E.Message);
    end;
  finally
    Qry.Free;
  end;

end;

function Set_Whatsapps_Queues(Lista:TStringList; whatsappId:Integer):Boolean;
 var
  Qry   : TFDQuery;
  I     : Integer;
  Item  : string;
 begin

    Result      := False;

    Qry               := TFDQuery.Create(Nil);
    Qry.Connection    := UserSession.Conexao;

   try

    try

      Qry.SQL.Text   := 'delete from "WhatsappQueues" '+
                        'where "whatsappId"=:whatsappId   ';

      Qry.ParamByName('whatsappId').AsInteger      := whatsappId;
      Qry.ExecSQL;

      for Item in Lista do
      begin

         Qry.Close;
         Qry.SQL.Clear;
         Qry.SQL.Text   :=

         ' INSERT INTO "WhatsappQueues"                     '+
         ' ("whatsappId", "queueId", "createdAt", "updatedAt")     '+
         ' VALUES(:whatsappId, :queueId, now(), now() );           ';

        Qry.ParamByName('whatsappId').AsInteger  := whatsappId;
        Qry.ParamByName('queueId').AsInteger     := StrToIntDef(Item, 0);
        Qry.ExecSQL;

      end;

      Result      := True;

    except on E: Exception do
           UserSession.DiscordLogger.SendLog('Error','Dao.Usuario','Set_Whatsapps_Queues',e.Message);
    end;


   finally
   Qry.Free;
   end;

 end;


end.


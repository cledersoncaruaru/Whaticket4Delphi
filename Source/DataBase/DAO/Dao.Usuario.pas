unit Dao.Usuario;

interface

uses
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  Entidade.Usuarios,
  BCrypt, BCrypt.Types,
  System.TypInfo,
  uPopulaCrud,
  Dao.Conexao,
  Functions.DataBase;

  function Get_Users(id: Longint; var Usuario: TUsuarios; var vResult: string): Boolean;
  function Set_Users (Codigo:Longint; Var Usuario:TUsuarios; var vResult:string; IsHash:Boolean; Lista:TStringList):Boolean;
  function GetAll (ID_EMPRESA:LongInt; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
  function Autentica_Usuario(Email,Senha:String):Boolean;
  function Set_User_Queues(Lista:TStringList; UserId:Integer):Boolean;
  function Get_Users_Queues(UserId: Longint): String;


implementation

uses
  FireDAC.Comp.Client, ServerController, System.SysUtils;

function Set_User_Queues(Lista:TStringList; UserId:Integer):Boolean;
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

      Qry.SQL.Text   := 'delete from "UserQueues" '+
                        'where "userId"=:userId   ';

      Qry.ParamByName('userId').AsInteger      := UserId;
      Qry.ExecSQL;

      for Item in Lista do
      begin

         Qry.Close;
         Qry.SQL.Clear;
         Qry.SQL.Text   :=

         ' INSERT INTO public."UserQueues"                     '+
         ' ("userId", "queueId", "createdAt", "updatedAt")     '+
         ' VALUES(:userId, :queueId, now(), now() );           ';

        Qry.ParamByName('userId').AsInteger      := UserId;
        Qry.ParamByName('queueId').AsInteger     := StrToIntDef(Item, 0);
        Qry.ExecSQL;

      end;

      Result      := True;

    except on E: Exception do
           UserSession.DiscordLogger.SendLog('Error','Dao.Usuario','Set_User_Queues',e.Message);
    end;

   finally
   Qry.Free;
   end;





 end;


 function Autentica_Usuario(Email,Senha:String):Boolean;
 var
    Qry                  : TFDQuery;
    UserExists           : Boolean;
    StoredPasswordHash   : String;
 begin

   Result      := False;
   UserExists  := False;

    Qry               := TFDQuery.Create(Nil);
    Qry.Connection    := UserSession.Conexao;

   try

    try

      Qry.SQL.Add('SELECT u.id, u."name" as UserName, u.email,            ');
      Qry.SQL.Add('u."passwordHash", u."createdAt",                       ');
      Qry.SQL.Add('u."updatedAt", u.profile,                              ');
      Qry.SQL.Add('u."tokenVersion", u."companyId",                       ');
      Qry.SQL.Add('u.super, u.online,                                     ');
      Qry.SQL.Add('c."name" as company,                                   ');
      Qry.SQL.Add('c."dueDate" as Datavencimento                          ');
      Qry.SQL.Add('from "Users" u                                         ');
      Qry.SQL.Add('inner join "Companies" c on c.id = u."companyId"       ');
      Qry.SQL.Add('WHERE u.email=:email                                   ');


      Qry.ParamByName('email').AsString              := Trim(Email);
      Qry.Open;

      UserExists := not Qry.IsEmpty;

      if UserExists then
      begin

       StoredPasswordHash := Qry.FieldByName('passwordHash').AsString;

        if TBCrypt.CompareHash(Trim(Senha), StoredPasswordHash) then
        begin

          UserSession.Clipboard.Put('Loguin_id',Qry.FieldByName('id').AsInteger);
          UserSession.Clipboard.Put('Loguin_name',Qry.FieldByName('UserName').AsString);
          UserSession.Clipboard.Put('Loguin_createdAt',Qry.FieldByName('createdAt').AsString);
          UserSession.Clipboard.Put('Loguin_updatedAt',Qry.FieldByName('updatedAt').AsString);
          UserSession.Clipboard.Put('Loguin_profile',Qry.FieldByName('profile').AsString);
          UserSession.Clipboard.Put('Loguin_tokenVersion',Qry.FieldByName('tokenVersion').AsString);
          UserSession.Clipboard.Put('Loguin_companyId',Qry.FieldByName('companyId').AsInteger);
          UserSession.Clipboard.Put('Loguin_super',Qry.FieldByName('super').AsString);
          UserSession.Clipboard.Put('Loguin_online',Qry.FieldByName('online').AsString);
          UserSession.Clipboard.Put('Loguin_email',Qry.FieldByName('email').AsString);
          UserSession.Clipboard.Put('Loguin_company',Qry.FieldByName('company').AsString);
          UserSession.Clipboard.Put('companyId',Qry.FieldByName('companyId').AsInteger);

          UserSession.CompanyId              := Qry.FieldByName('companyId').AsInteger;
          UserSession.CompanyName            := Qry.FieldByName('company').AsString;
          UserSession.IDUser                 := Qry.FieldByName('id').AsInteger;
          UserSession.Username               := Qry.FieldByName('UserName').AsString;
          UserSession.UserEmail              := Qry.FieldByName('email').AsString;

          if Qry.FieldByName('profile').AsString = 'Admin' then begin
             UserSession.Profile                := tpAdmin;
          end
          else begin
            UserSession.Profile                := tpUser;
          end;

          if Qry.FieldByName('super').AsBoolean then begin
             UserSession.Super                 := TpSuper;
          end
          else begin
             UserSession.Super                  := TpNotSuper;
          end;

          UserSession.DueDate                := Qry.FieldByName('Datavencimento').AsDateTime;
          UserSession.InstanceName           := Get_NomeByIDCompany(Qry.FieldByName('companyId').AsInteger);
          UserSession.Token                  := Get_TokenByIDCompany(Qry.FieldByName('companyId').AsInteger);
          Result := True;

        end;

      end;


    except on E: Exception do
       UserSession.DiscordLogger.SendLog('Error','Dao.Usuario','Autentica_Usuario',e.Message);
    end;

   finally

   Qry.Free;
   end;

 end;


function GetAll (ID_EMPRESA:LongInt; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
var
  Qry                            : TFDQuery;
  wresult, SQL_AND               : String;
  wtotal                         : Integer;
  vstart, vlength                : Integer;
  vOrderBy                       : String;
  BTN_EDITAR,BTN_EXCLUIR         : String;
begin

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   try

    vstart       := StrToIntDef(aParams.Values['start'], 0);
    vlength      := StrToIntDef(aParams.Values['length'], 10);


    Qry.SQL.Add(' select * from "Users" u                 ');
    Qry.SQL.Add('WHERE u."companyId"='+ID_EMPRESA.ToString   );


     if aParams.Values['search[value]'] <> '' then begin

            SQL_AND :=' AND name like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      '  email ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                       ' profile like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%''';

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

        0: Qry.SQL.Add(' Order by name      '+aParams.Values['order[0][dir]']  + ' ');
        1: Qry.SQL.Add(' Order by email            '+aParams.Values['order[0][dir]']  + ' ');
        2: Qry.SQL.Add(' Order by profile       '+aParams.Values['order[0][dir]']  + ' ');

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

        BTN_EXCLUIR       := ' <button id=\"BTN_CANCELAR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Excluir\" type=\"button\"'+
                             ' class=\"btn btn-danger '+Button_Size+'\"   onclick=\"ajaxCall(''actions'', ''cancelamento='+Qry.FieldByName('ID').AsString+''')\"><i class=\"'+Icon_Delete+'\"></i></button> ';


        wresult := wresult + '['+

                                '"'+Qry.FieldByName('NAME').AsString+'", '+
                                '"'+Qry.FieldByName('EMAIL').AsString+'", '+
                                '"'+Qry.FieldByName('PROFILE').AsString+'", '+
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

      aResult := wresult;


   except on E: Exception do
    UserSession.DiscordLogger.SendLog('Error:','Dao.Usuario','GetAll - Error -  ',e.Message);
   end;

  finally
  Qry.Free;
  end;

end;

function Get_Users_Queues(UserId: Longint): String;
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
      'FROM "UserQueues" ' +
      'WHERE "userId" = :userId';

      Qry.ParamByName('userId').AsInteger := UserId;
      Qry.Open;

      Result := Qry.FieldByName('fila_ids').AsString;

    except on E: Exception do

        UserSession.DiscordLogger.SendLog('Error','Dao.Users','Get_Users_Queues - Error: - ' , E.Message);
    end;
  finally
    Qry.Free;
  end;

end;

function Get_Users(id: Longint; var Usuario: TUsuarios; var vResult: string): Boolean;
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
      Qry.SQL.Add('Select * from "Users" where id =:id');
      Qry.ParamByName('id').AsInteger  := id;
      Qry.Open;

      if not Qry.IsEmpty then
        begin
          TPopulateFromQuery<TUsuarios>.PopulateFromDataSet(Usuario, Qry);
        end;

      Result := True;

    except on E: Exception do

        UserSession.DiscordLogger.SendLog('Error','Dao.Users','Get_Users - Error: - ' , E.Message);
    end;
  finally
    Qry.Free;
  end;

end;



function Set_Users (Codigo:Longint; Var Usuario:TUsuarios; var vResult:string; IsHash:Boolean; Lista:TStringList):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

    Qry.SQL.Text  :=

    '  INSERT INTO "Users" (id,"name",email,"passwordHash","createdAt","updatedAt",PROFILE,"tokenVersion","companyId",super,ONLINE)                                     '+
    '  VALUES (:id, :"name", :email, :"passwordHash", :"createdAt", :"updatedAt", :profile, :"tokenVersion", :"companyId", :super, :online) ON CONFLICT (id) DO         '+
    '  UPDATE                                                                                                                                                           '+
    '  SET "name" = EXCLUDED."name",                                                                                                                                    '+
    '  email = EXCLUDED.email,                                                                                                                                          '+
    '  "passwordHash" = EXCLUDED."passwordHash",                                                                                                                        '+
    '  "createdAt" = EXCLUDED."createdAt",                                                                                                                              '+
    '  "updatedAt" = EXCLUDED."updatedAt",                                                                                                                              '+
    '  PROFILE = EXCLUDED.profile,                                                                                                                                      '+
    '  "tokenVersion" = EXCLUDED."tokenVersion",                                                                                                                        '+
    '  "companyId" = EXCLUDED."companyId",                                                                                                                              '+
    '  super = EXCLUDED.super,                                                                                                                                          '+
    '  ONLINE = EXCLUDED.online;                                                                                                                                         ';


    if Usuario.id <=0 then begin

      Usuario.id         := NextGeneratorPosteGresql('Contacts_id_seq');
      Usuario.Createdat  := Now;
      Usuario.Updatedat  := Now;
      Usuario.companyId  := UserSession.Clipboard['Loguin_companyId'].I;
    end;


    Qry.ParamByName('id').AsInteger                                    := Usuario.id;
    Qry.ParamByName('name').AsString                                   := Usuario.name;
    Qry.ParamByName('email').AsString                                  := Usuario.email;

    if IsHash = True then begin
     Qry.ParamByName('passwordHash').AsString                          := TBCrypt.GenerateHash(Trim(Usuario.passwordHash)) ;
    end
    else begin
     Qry.ParamByName('passwordHash').AsString                          := Usuario.Passwordhash;
    end;

    Qry.ParamByName('createdAt').AsDateTime                            := Usuario.createdAt;
    Qry.ParamByName('updatedAt').AsDateTime                            := Usuario.updatedAt;
    Qry.ParamByName('profile').AsString                                := Usuario.profile;
    Qry.ParamByName('tokenVersion').AsInteger                          := Usuario.tokenVersion;
    Qry.ParamByName('companyId').AsInteger                             := Usuario.companyId;
    Qry.ParamByName('super').AsBoolean                                 := Usuario.super;
    Qry.ParamByName('online').AsBoolean                                := Usuario.online;

   try

     Qry.ExecSQL;

     Result := True;

    Result := Set_User_Queues(Lista,Usuario.id);


   except on E: Exception do

    UserSession.DiscordLogger.SendLog('Error','Dao.Users','Set_Users - Error: - ' , E.Message);

   end;

  finally
    Qry.Free;
  end;
end;


end.


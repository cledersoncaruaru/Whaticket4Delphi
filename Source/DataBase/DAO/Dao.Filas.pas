unit Dao.Filas;

interface

uses
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  Functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  Entidade.Filas,
  uPopulaCrud,
  Functions.DataBase,
  Integracao.API.Evolution,
  IWJsonDataObjects;

  function Get_Queues(id: Longint; var Filas: TFilas; var vResult: string): Boolean;
  function Get_QueuesFromMessage(Numero:String; FJson:String): Boolean;
  function Set_Queues (Codigo:Longint; Var Filas:TFilas; var vResult:string):Boolean;
  function GetAll (ID_EMPRESA:LongInt; Status:Integer; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
  function CheckDefault(ID:Integer):Boolean;
  function Delete_Fila(ID:Integer):Boolean;


implementation

uses
  FireDAC.Comp.Client, ServerController, System.SysUtils, System.TypInfo;

function Delete_Fila(ID:Integer):Boolean;
 var
   Qry  : TFDQuery;
begin

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

      Qry.SQL.Text := ' UPDATE "Queues" SET "Status"=:Status ' +
                      ' WHERE id = :id                       ';

      Qry.ParamByName('id').AsInteger       := ID;
      Qry.ParamByName('Status').AsInteger   := 3;
      Qry.ExecSQL;

      Result := True;

  finally
  Qry.Free;
  end;

end;

function CheckDefault(ID:integer):Boolean;
 var
   Qry  : TFDQuery;
begin

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

      Qry.SQL.Text := 'SELECT COUNT(*) AS Total FROM "Queues" ' +
                      'WHERE "isDefault" = true AND id <> :id   ';
      Qry.ParamByName('id').AsInteger := ID;
      Qry.Open;

      Result := Qry.FieldByName('Total').AsInteger > 0;

  finally
  Qry.Free;
  end;

end;


function GetAll (ID_EMPRESA:LongInt; Status:Integer; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
var
  wresult, SQL_AND               : String;
  wtotal                         : Integer;
  vstart, vlength                : Integer;
  Pessoa ,Tomador,Usuario        : String;
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

        Qry.SQL.Text   :=
         ' SELECT * FROM "Queues"                    '+
         ' WHERE "companyId"=:companyId             ';



    if Status >0 then begin
      Qry.SQL.Add(' and "Status"=:status');
      Qry.ParamByName('status').AsInteger  := Status;
    end
    else begin
      Qry.SQL.Add(' and "Status" in (1,2)');
    end;

    Qry.ParamByName('companyId').AsInteger  := ID_EMPRESA;


     if aParams.Values['search[value]'] <> '' then begin

            SQL_AND :=' AND name like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' body color ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' "greetingMessage" like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%''';

      Qry.SQL.Add(SQL_AND);

     end;


//      Qry.SQL.Text  :=
//                     ' SELECT * FROM "Queues"                  '+
//                     ' WHERE "companyId"=:companyId            ';
//
//      if Status >0 then begin
//        Qry.SQL.Add(' and t."Status"=:status');
//        Qry.ParamByName('status').AsInteger  := Status;
//      end
//      else begin
//        Qry.SQL.Add(' and t."Status" in (1,2)');
//      end;
//
//      Qry.ParamByName('companyId').AsInteger   := ID_EMPRESA;
//
//       if aParams.Values['search[value]'] <> '' then begin
//
//              SQL_AND :=' AND "name" like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
//                        ' color like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
//                        ' "greetingMessage" like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%''';
//
//        Qry.SQL.Add(SQL_AND);
//
//       end;


        case UserType of
          tpAdmin:    begin

                      end;

          tpUser:     begin
                     //     Qry.SQL.Add(' AND empresaud='+UserSession.IDEmpLogada.ToString);
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

        BTN_EXCLUIR       := ' <button id=\"BTN_DELETE\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Excluir\" type=\"button\"'+
                             ' class=\"btn btn-danger '+Button_Size+'\"   onclick=\"ajaxCall(''actions'', ''Deletar='+Qry.FieldByName('ID').AsString+''')\"><i class=\"'+Icon_Delete+'\"></i></button> ';

        wresult := wresult + '['+
                              '"'+Trim(Qry.FieldByName('id').AsString)+'", '+
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

function Get_Queues(id: Longint; var Filas: TFilas; var vResult: string): Boolean;
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
      Qry.SQL.Add('Select * from "Queues" where id =:id');
      Qry.ParamByName('id').AsInteger   := id;
      Qry.Open;

      if Qry.RecordCount <=0 then
        Exit;


      if not Qry.IsEmpty then
      begin
        TPopulateFromQuery<TFilas>.PopulateFromDataSet(Filas, Qry);
      end;

      Result := True;

    except on E: Exception do

		  UserSession.DiscordLogger.SendLog(
        'Erro ao Selecionar Filas',
        'Dao.Filas',
        'Get_Queues',
        '- Erro : '+ e.Message);
    end;
  finally
    Qry.Free;
  end;



end;

function Get_QueuesFromMessage(Numero:String; FJson:String): Boolean;
var
  Qry          : TFDQuery;
  Lista        : TStringList;
  EvolutionAPI : TEvolutionAPI;
  Instancia    : String;
  Root         :  TJsonObject;
begin
  Result         := False;
  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;
  Lista          := TStringList.Create;
  Root           := TJsonObject.Parse(FJson) as TJsonObject;

  try

   Instancia    := Root.S['apikey'];

    try

      Qry.Close;
      Qry.SQL.Clear;
      Qry.SQL.Add('Select * from "Queues"');
      Qry.SQL.Add(' order by id');
      Qry.Open;
      Qry.First;

      if Qry.RecordCount >0 then begin

        while not Qry.Eof do  begin

         Lista.Add(Qry.FieldByName('id').AsString +' - '+Qry.FieldByName('name').AsString );

         Qry.Next;
        end;

      end;


      EvolutionAPI        := TEvolutionAPI.Create(UserSession.Conexao);
      EvolutionAPI.ApiKey := Root.S['apikey'];
      UserSession.Clipboard.Get('Instancia',Instancia,True);
      EvolutionAPI.Envia_Filas(Instancia,Numero,Lista.Text);

      Result := True;

    except on E: Exception do

		 UserSession.DiscordLogger.SendLog('Erro ao Selecionar Filas','Dao.Filas','Get_Queues','- Erro : '+ e.Message);
    end;


  finally
    Qry.Free;
    Lista.Free;
    EvolutionAPI.Free;
    Root.Free;
  end;

end;

function Set_Queues (Codigo:Longint; Var Filas:TFilas; var vResult:string):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;



  try

    if Filas.schedules.Trim = '' then
      Filas.schedules := '[]';

      if Filas.id = 0 then begin
         Filas.id     := NextGeneratorPosteGresql('Queues_id_seq');
         Filas.Status := 1;
      end;
     Filas.companyId   := UserSession.CompanyId;

     TSaveObjectToDatabase<TFilas>.Save(Filas, Qry, 'Queues');

   try

    Result := True;

   except on E: Exception do

    UserSession.DiscordLogger.SendLog('Error','Dao.Filas','Set_Queues',E.Message);

   end;

  finally
    Qry.Free;
  end;
end;


end.


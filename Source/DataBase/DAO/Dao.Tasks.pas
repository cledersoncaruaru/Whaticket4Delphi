unit Dao.Tasks;

interface

uses
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  uPopulaCrud,
  Entidade.Tasks,
  functions.DataBase;

  function Get_Tasks(id: Longint; var Tasks: TTasks; var vResult: string): Boolean;
  function Set_Tasks (Codigo:Longint; Var Tasks:TTasks; var vResult:string):Boolean;
  function GetAll (ID_EMPRESA:LongInt; aParams: TStrings; Status:Integer; out aResult: String; UserType : TUserType):string;
  function Delete_Tasks (ID:Longint):Boolean;

implementation

uses
  FireDAC.Comp.Client, ServerController, System.SysUtils, System.TypInfo;

function GetAll (ID_EMPRESA:LongInt; aParams: TStrings; Status:Integer; out aResult: String; UserType : TUserType):string;
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


    Qry.SQL.Text   :=
         ' SELECT * FROM "Tasks"                    '+
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
                      ' body name ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' name like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%''';

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

        0: Qry.SQL.Add(' Order by id             '+aParams.Values['order[0][dir]']  + ' ');
        1: Qry.SQL.Add(' Order by name           '+aParams.Values['order[0][dir]']  + ' ');
        2: Qry.SQL.Add(' Order by createdAt      '+aParams.Values['order[0][dir]']  + ' ');


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
                              ' class=\"btn btn-primary '+Button_Size+'\"    onclick=\"ajaxCall(''actions'', ''Edit='+Qry.FieldByName('id').AsString+''')\"><i class=\"'+Icon_Edit+'\"></i></button> ';

        BTN_EXCLUIR       := ' <button id=\"BTN_EXCLUIR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Excluir\" type=\"button\"'+
                             ' class=\"btn btn-danger '+Button_Size+'\"   onclick=\"ajaxCall(''actions'', ''Deletar='+Qry.FieldByName('id').AsString+''')\"><i class=\"'+Icon_Delete+'\"></i></button> ';


        wresult := wresult + '['+

                             '"'+Trim(Qry.FieldByName('id').AsString)+'", '+
                             '"'+Trim(Qry.FieldByName('name').AsString)+'", '+
                             '"'+ StringReplace(Trim(DatahoraBrasileira(Qry.FieldByName('createdAt').AsDateTime)), '"', '\"', [rfReplaceAll])+'", '+
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
		      UserSession.DiscordLogger.SendLog(
        'Erro ao Carregar Tasks',
        'Dao.Tasks',
        'Get_Tasks',
        '- Erro : '+ e.Message);
   end;

  finally
  Qry.Free;
  end;


end;


function Get_Tasks(id: Longint; var Tasks: TTasks; var vResult: string): Boolean;
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
      Qry.SQL.Add('Select * from "Tasks" where id =:id');
      Qry.ParamByName('id').AsInteger   := id;
      Qry.Open;

      if Qry.RecordCount <=0 then
        Exit;


      if not Qry.IsEmpty then
      begin
        TPopulateFromQuery<TTasks>.PopulateFromDataSet(Tasks, Qry);
      end;

      Result := True;

    except on E: Exception do

      UserSession.DiscordLogger.SendLog(
        'Erro ao Selecionar Tasks',
        'Dao.Tasks',
        'Get_Tasks',
        '- Erro : '+ e.Message);
    end;
  finally
    Qry.Free;
  end;

end;

function Set_Tasks (Codigo:Longint; Var Tasks:TTasks; var vResult:string):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;



  try

      if Tasks.id = 0 then begin
         Tasks.id           := NextGeneratorPosteGresql('Tasks_id_seq');
         Tasks.createdAt    := Now;
         Tasks.updatedAt    := Now;
         Tasks.Status       := 1;
      end;

     Tasks.companyId   := UserSession.CompanyId;

     TSaveObjectToDatabase<TTasks>.Save(Tasks, Qry, 'Tasks');

   try

     Result := True;


   except on E: Exception do

		    UserSession.DiscordLogger.SendLog(
        'Erro ao Gravar Tasks',
        'Dao.Tasks',
        'Set_Tasks',
        '- Erro : '+ e.Message);

   end;

  finally
    Qry.Free;
  end;
end;

function Delete_Tasks (ID:Longint):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

   try

     Qry.SQL.Text   := 'UPDATE "Tasks" SET status=3 '+
                       ' where id=:id';

     Qry.ParamByName('id').AsInteger    := ID;
     Qry.ExecSQL;
     Result := True;


   except on E: Exception do

		    UserSession.DiscordLogger.SendLog(
        'Erro ao Deletar Tasks',
        'Dao.Tasks',
        'Delete_Tasks',
        '- Erro : '+ e.Message);

   end;

  finally
    Qry.Free;
  end;
end;

end.


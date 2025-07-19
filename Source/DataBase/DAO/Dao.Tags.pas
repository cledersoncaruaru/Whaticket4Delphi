unit Dao.Tags;

interface

uses
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  Functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  uPopulaCrud,
  Entidade.Tags,
  Functions.DataBase;

  function Get_Tags(id: Longint; var Tags: TTags; var vResult: string): Boolean;
  function Set_Tags (Codigo:Longint; Var Tags:TTags; var vResult:string):Boolean;
  function GetAll (ID_EMPRESA:LongInt;  Status:Integer; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
  function Delete_Tags (ID:Longint):Boolean;

implementation

uses
  FireDAC.Comp.Client, ServerController, System.SysUtils, System.TypInfo;

function GetAll (ID_EMPRESA:LongInt; Status:Integer; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
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
   '   SELECT                                   '+
   '     t.*,                                   '+
   '     CASE                                   '+
   '       WHEN t.kanban = 1 THEN ''Sim''       '+
   '       ELSE ''Não''                         '+
   '     END AS kanban_legenda                  '+
   '   FROM "Tags" t                            '+
   ' WHERE t."companyId"=:companyId               ';

    Qry.ParamByName('companyId').AsInteger  := ID_EMPRESA;

    if Status >0 then begin
      Qry.SQL.Add(' and t."Status"=:status');
      Qry.ParamByName('status').AsInteger  := Status;
    end
    else begin
      Qry.SQL.Add(' and t."Status" in (1,2)');
    end;


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

        0: Qry.SQL.Add(' Order by name           '+aParams.Values['order[0][dir]']  + ' ');
        1: Qry.SQL.Add(' Order by color          '+aParams.Values['order[0][dir]']  + ' ');
        2: Qry.SQL.Add(' Order by kanban_legenda '+aParams.Values['order[0][dir]']  + ' ');

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

        BTN_EXCLUIR       := ' <button id=\"BTN_DELETE\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Excluir\" type=\"button\"'+
                             ' class=\"btn btn-danger '+Button_Size+'\"   onclick=\"ajaxCall(''actions'', ''Deletar='+Qry.FieldByName('id').AsString+''')\"><i class=\"'+Icon_Delete+'\"></i></button> ';


        wresult := wresult + '['+
                             '"'+Trim(Qry.FieldByName('id').AsString)+'", '+
                             '"'+Trim(Qry.FieldByName('name').AsString)+'", '+
                             '"'+Trim(Qry.FieldByName('color').AsString)+'", '+
                              '"'+Trim(Qry.FieldByName('kanban_legenda').AsString)+'", '+
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
        'Erro ao Carregar Tags',
        'Dao.Tags',
        'Get_Tags',
        '- Erro : '+ e.Message);
   end;

  finally
  Qry.Free;
  end;


end;

function Get_Tags(id: Longint; var Tags: TTags; var vResult: string): Boolean;
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
      Qry.SQL.Add('Select * from "Tags" where id =:id');
      Qry.ParamByName('id').AsInteger   := id;
      Qry.Open;

      if Qry.RecordCount <=0 then
        Exit;


      if not Qry.IsEmpty then
      begin
        TPopulateFromQuery<TTags>.PopulateFromDataSet(Tags, Qry);
      end;

      Result := True;

    except on E: Exception do

      UserSession.DiscordLogger.SendLog(
        'Erro ao Selecionar Tags',
        'Dao.Tags',
        'Get_Tags',
        '- Erro : '+ e.Message);
    end;
  finally
    Qry.Free;
  end;

end;

function Set_Tags (Codigo:Longint; Var Tags:TTags; var vResult:string):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;



  try

      if Tags.id = 0 then
         Tags.id  := NextGeneratorPosteGresql('Tags_id_seq');

     Tags.companyId   := UserSession.CompanyId;

     TSaveObjectToDatabase<TTags>.Save(Tags, Qry, 'Tags');

   try

     Qry.ExecSQL;
     Result := True;


   except on E: Exception do

      UserSession.DiscordLogger.SendLog(
        'Erro ao Gravar Tags',
        'Dao.Tags',
        'Set_Tags',
        '- Erro : '+ e.Message);

   end;


  finally
    Qry.Free;
  end;
end;

function Delete_Tags (ID:Longint):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

   try

     Qry.SQL.Text    := ' update "Tags" SET "Status"=:status  '+
                        ' where id =:id';
     Qry.ParamByName('id').AsInteger     := ID;
     Qry.ParamByName('status').AsInteger := 3;
     Qry.ExecSQL;

     Result := True;

   except on E: Exception do

      UserSession.DiscordLogger.SendLog(
        'Erro ao Deletar Tags',
        'Dao.Tags',
        'Delete_Tags',
        '- Erro : '+ e.Message);

   end;

  finally
    Qry.Free;
  end;
end;


end.


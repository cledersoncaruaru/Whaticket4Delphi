unit Dao.Respostas;

interface

uses
  ServerController,

  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  Functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  Entidade.Respostas,
  uPopulaCrud,
  Functions.DataBase;

  function Get_QuickMessages(id: Longint; var Respostas: TRespostas; var vResult: string): Boolean;
  function Set_QuickMessages (Codigo:Longint; Var Respostas:TRespostas; var vResult:string):Boolean;
  function GetAll (ID_EMPRESA:LongInt; aParams: TStrings;  out aResult: String; UserType : TUserType):string;
  function Delete_Resposta(ID:Integer):Integer;


implementation

uses
  FireDAC.Comp.Client, System.SysUtils, System.TypInfo;

function Delete_Resposta(ID:Integer):Integer;
var
  Qry                            : TFDQuery;
begin
  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

   try

    Qry.SQL.Add('DELETE FROM "QuickMessages" ');
    Qry.SQL.Add('WHERE ID=:ID     ');
    Qry.ParamByName('ID').AsInteger   := ID;
    Qry.ExecSQL;

   except on E: Exception do
     UserSession.DiscordLogger.SendLog('Error-','Dao.Respostas','Delete_Resposta',e.Message);
   end;

  finally
  Qry.free;
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


    Qry.SQL.Add(' select * from "QuickMessages" q                 ');
    Qry.SQL.Add('WHERE q."companyId"='+ID_EMPRESA.ToString   );


     if aParams.Values['search[value]'] <> '' then begin

            SQL_AND :=' AND shortcode like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                       ' message like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%''';

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
        0: Qry.SQL.Add(' Order by id          '+aParams.Values['order[0][dir]']  + ' ');
        1: Qry.SQL.Add(' Order by shortcode          '+aParams.Values['order[0][dir]']  + ' ');
        2: Qry.SQL.Add(' Order by message            '+aParams.Values['order[0][dir]']  + ' ');
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
                              ' class=\"btn btn-primary '+Button_Size+'\"    onclick=\"ajaxCall(''Actions'', ''Edit='+Qry.FieldByName('ID').AsString+''')\"><i class=\"'+Icon_Edit+'\"></i></button> ';

        BTN_EXCLUIR       := ' <button id=\"BTN_CANCELAR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Excluir\" type=\"button\"'+
                             ' class=\"btn btn-danger '+Button_Size+'\"   onclick=\"ajaxCall(''actions'', ''Delete='+Qry.FieldByName('ID').AsString+''')\"><i class=\"'+Icon_Delete+'\"></i></button> ';


        wresult := wresult + '['+

                             '"'+Qry.FieldByName('shortcode').AsString+'", '+
                             '"'+Trim(Qry.FieldByName('message').AsString)+'", '+
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
    UserSession.DiscordLogger.SendLog('Error','Dao.Respostas','GetAll',e.Message);
   end;

  finally
  Qry.Free;
  end;

end;

function Get_QuickMessages(id: Longint; var Respostas: TRespostas; var vResult: string): Boolean;
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
      Qry.SQL.Add('Select * from "QuickMessages" where id=:id');
      Qry.ParamByName('id').AsInteger     := id;
      Qry.Open;

      if not Qry.IsEmpty then
      begin
        TPopulateFromQuery<TRespostas>.PopulateFromDataSet(Respostas, Qry);
      end;


      Result := True;

    except on E: Exception do

      UserSession.DiscordLogger.SendLog('Error-','Dao.Respostas','Get_QuickMessages',e.Message);
    end;

  finally
    Qry.Free;
  end;



end;

function Set_QuickMessages (Codigo:Longint; Var Respostas:TRespostas; var vResult:string):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;



  try

     if Respostas.id <=0 then begin
      Respostas.id         := NextGeneratorPosteGresql('QuickMessages_id_seq');
      Respostas.Createdat  := Now;
      Respostas.Updatedat  := Now;
      Respostas.companyId  := UserSession.Clipboard['Loguin_companyId'].I;
      Respostas.userId     := UserSession.Clipboard['Loguin_id'].I;

     end;

     TSaveObjectToDatabase<TRespostas>.Save(Respostas, Qry, 'QuickMessages');

   try

     Qry.ExecSQL;
     Result := True;


   except on E: Exception do

    UserSession.DiscordLogger.SendLog('Error','Dao.Respostas','Set_QuickMessages', E.Message);

   end;

  finally
    Qry.Free;
  end;
end;

end.


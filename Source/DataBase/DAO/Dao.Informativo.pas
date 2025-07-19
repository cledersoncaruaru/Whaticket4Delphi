unit Dao.Informativo;

interface

uses
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  Functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  Entidade.Informativo;

  function Get_Announcements(id: Longint; var Informativo: TInformativo; var vResult: string): Boolean;
  function Set_Announcements (Codigo:Longint; Var Informativo:TInformativo; var vResult:string):Boolean;
  function GetAll (ID_EMPRESA:LongInt; aParams: TStrings;  out aResult: String; UserType : TUserType):string;

implementation

uses
  FireDAC.Comp.Client, ServerController, System.SysUtils, System.TypInfo;

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


    Qry.SQL.Add(' select * from "Announcements" a                 ');
    Qry.SQL.Add('WHERE a."companyId"='+ID_EMPRESA.ToString   );


     if aParams.Values['search[value]'] <> '' then begin

            SQL_AND :=' AND title like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      '  priority ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                      ' "mediaPath" ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%'' or ' +
                       ' status like ''%'+StringReplace(aParams.Values['search[value]'], ' ', '%', [rfReplaceAll])+'%''';

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

        0: Qry.SQL.Add(' Order by title      '+aParams.Values['order[0][dir]']  + ' ');
        1: Qry.SQL.Add(' Order by priority            '+aParams.Values['order[0][dir]']  + ' ');
        2: Qry.SQL.Add(' Order by mediaPath       '+aParams.Values['order[0][dir]']  + ' ');
        3: Qry.SQL.Add(' Order by status       '+aParams.Values['order[0][dir]']  + ' ');
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

                                '"'+Qry.FieldByName('TITLE').AsString+'", '+
                                '"'+Qry.FieldByName('priority').AsString+'", '+
                                '"'+Qry.FieldByName('mediaPath').AsString+'", '+
                                '"'+Qry.FieldByName('status').AsString+'", '+
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
       UserSession.DiscordLogger.SendLog('Error','Dao.Informativo','GetAll', E.Message);
   end;

  finally
  Qry.Free;
  end;

end;

function Get_Announcements(id: Longint; var Informativo: TInformativo; var vResult: string): Boolean;
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
      Qry.SQL.Add('Select * from Announcements where id =: id');
      Qry.ParamByName('id').AsInteger   := id;
      Qry.Open;

      if Qry.RecordCount <=0 then
        Exit;

      Informativo.id         := Qry.FieldByName('id').AsInteger;
      Informativo.priority   := Qry.FieldByName('priority').AsInteger;
      Informativo.title      := Qry.FieldByName('title').AsString;
      Informativo.text       := Qry.FieldByName('text').AsString;
      Informativo.mediaPath  := Qry.FieldByName('mediaPath').AsString;
      Informativo.mediaName  := Qry.FieldByName('mediaName').AsString;
      Informativo.companyId  := Qry.FieldByName('companyId').AsInteger;
      Informativo.status     := Qry.FieldByName('status').AsString;
      Informativo.createdAt  := Qry.FieldByName('createdAt').AsString;
      Informativo.updatedAt  := Qry.FieldByName('updatedAt').AsString;


      Result := True;

    except on E: Exception do
       UserSession.DiscordLogger.SendLog('Error','Dao.Informativo','Get_Announcements', E.Message);
    end;
  finally
    Qry.Free;
  end;

end;

function Set_Announcements (Codigo:Longint; Var Informativo:TInformativo; var vResult:string):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;



  try

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE OR INSERT INTO Announcements(id,priority,title,text,mediaPath,mediaName,companyId,status,createdAt,updatedAt) ');
    Qry.SQL.Add('VALUES (:id:priority:title:text:mediaPath:mediaName:companyId:status:createdAt:updatedAt) ');


    Qry.ParamByName('id').AsInteger          := Informativo.id;
    Qry.ParamByName('priority').AsInteger    := Informativo.priority;
    Qry.ParamByName('title').AsString        := Informativo.title;
    Qry.ParamByName('text').AsString         := Informativo.text;
    Qry.ParamByName('mediaPath').AsString    := Informativo.mediaPath;
    Qry.ParamByName('mediaName').AsString    := Informativo.mediaName;
    Qry.ParamByName('companyId').AsInteger   := Informativo.companyId;
    Qry.ParamByName('status').AsString       := Informativo.status;
    Qry.ParamByName('createdAt').AsString    := Informativo.createdAt;
    Qry.ParamByName('updatedAt').AsString    := Informativo.updatedAt;

   try

     Qry.ExecSQL;
     Result := True;


   except on E: Exception do

    UserSession.DiscordLogger.SendLog('Error','Dao.Informativo','Set_Announcements', E.Message);

   end;

  finally
    Qry.Free;
  end;
end;



end.


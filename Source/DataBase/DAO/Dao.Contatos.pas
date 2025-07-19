unit Dao.Contatos;

interface

uses
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  Functions.Strings,
  Tipos.Types,
  Integracao.Discord,
  uPopulaCrud,
  Entidade.Contatos,
  Functions.DataBase,
  Integracao.API.Evolution;

function Get_Contacts(id: Longint; var Contatos: TContatos; var vResult:
  string): Boolean;
function Set_Contacts(Codigo: Longint; var Contatos: TContatos; var vResult:
  string): Boolean;
function GetAll(ID_EMPRESA: LongInt; aParams: TStrings; out aResult: string;
  UserType: TUserType): string;
function Get_Existe_Contato(Number: string; ID: Integer): Boolean;
function Get_ContactByNumero(Numero: string): Integer;
function UpdateNomeContactByNumber(Number, ApiKey, Instancia: string; companyId:
  Integer): Integer;

implementation

uses
  FireDAC.Comp.Client, ServerController, System.SysUtils, System.TypInfo;

function Get_ContactByNumero(Numero: string): Integer;
var
  Qry: TFDQuery;
begin

  Result := 0;
  Qry := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

    try

      Qry.SQL.Text :=

      'SELECT id,"number"  FROM public."Contacts"' +
        'WHERE "number"=:number';
      Qry.ParamByName('number').AsString := Trim(Numero);
      Qry.Open;

      Result := Qry.FieldByName('id').AsInteger;

    except on E: Exception do
        UserSession.DiscordLogger.SendLog('Erro-', 'Dao.ProcessaMensagem',
          'Get_IDContactByNumero', e.Message);
    end;

  finally
    Qry.Free;
  end;

end;

function Get_Existe_Contato(Number: string; ID: Integer): Boolean;
var
  Qry: TFDQuery;
begin

  Result := False;

  Qry := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

    Qry.SQL.Add('select number from "Contacts"');
    Qry.SQL.Add('where number=:number');
    Qry.SQL.Add(' and id<>:id');
    Qry.ParamByName('number').AsString := SomenteNumeros(Number);
    Qry.ParamByName('id').AsInteger := id;
    Qry.Open;

    if Qry.RecordCount = 1 then
      Result := True;

  finally
    Qry.Free;
  end;

end;

function GetAll(ID_EMPRESA: LongInt; aParams: TStrings; out aResult: string;
  UserType: TUserType): string;
var
  Qry: TFDQuery;
  wresult, SQL_AND: string;
  wtotal: Integer;
  vstart, vlength: Integer;
  vOrderBy: string;
  BTN_EDITAR, BTN_EXCLUIR, BTN_TICKET: string;
  Img: string;
begin

  Qry := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  Img := '';

  try

    try

      vstart := StrToIntDef(aParams.Values['start'], 0);
      vlength := StrToIntDef(aParams.Values['length'], 10);

      Qry.SQL.Add('select * from "Contacts"                   ');
      Qry.SQL.Add('WHERE "companyId"=' + ID_EMPRESA.ToString);

      if aParams.Values['search[value]'] <> '' then
      begin

        SQL_AND := ' AND name like ''%' +
          PrimeiraLetraMaiuscula(StringReplace(aParams.Values['search[value]'],
          ' ', '%', [rfReplaceAll])) + '%'' or ' +
          ' number like ''%' + StringReplace(aParams.Values['search[value]'],
            ' ', '%', [rfReplaceAll]) + '%'' or ' +
          ' email like ''%' + StringReplace(aParams.Values['search[value]'], ' ',
            '%', [rfReplaceAll]) + '%''';

        Qry.SQL.Add(SQL_AND);

      end;

      case StrToIntDef(aParams.Values['order[0][column]'], 0) of

        0: Qry.SQL.Add(' Order by name      ' + aParams.Values['order[0][dir]'] +
          ' ');
        1: Qry.SQL.Add(' Order by number            ' +
          aParams.Values['order[0][dir]'] + ' ');
        2: Qry.SQL.Add(' Order by email       ' + aParams.Values['order[0][dir]']
          + ' ');

      end;

      Qry.Open;
      wtotal := Qry.RecordCount; // Total de registros sem paginação

      // Aplicar paginação
      Qry.FetchOptions.RecsSkip := vstart;
      Qry.FetchOptions.RecsMax := vlength;
      Qry.Refresh;
      Qry.First;

      wresult := '{' +
        '"draw": ' + StrToIntDef(aParams.Values['draw'], 0).ToString + ', ' +
        '"recordsTotal": ' + wtotal.ToString + ', ' +
        '"recordsFiltered": ' + wtotal.ToString + ', ' +
        '"data": [';

      while not Qry.Eof do
      begin

        BTN_EDITAR := '';
        BTN_EXCLUIR := '';

        BTN_EDITAR := ' <button id=\"BTN_EDITAR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Editar\" type=\"button\"'
          +
          ' class=\"btn btn-primary ' + Button_Size +
            '\"    onclick=\"ajaxCall(''actions'', ''Edit=' +
            Qry.FieldByName('ID').AsString + ''')\"><i class=\"' + Icon_Edit +
            '\"></i></button> ';

        BTN_EXCLUIR := ' <button id=\"BTN_CANCELAR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Excluir\" type=\"button\"'
          +
          ' class=\"btn btn-danger ' + Button_Size +
            '\"   onclick=\"ajaxCall(''actions'', ''cancelamento=' +
            Qry.FieldByName('ID').AsString + ''')\"><i class=\"' + Icon_Delete +
            '\"></i></button> ';

        BTN_TICKET := ' <button id=\"BTN_CANCELAR\" data-toggle=\"tooltip\" data-placement=\"top\" title=\"Criar Ticket\" type=\"button\"'
          +
          ' class=\"btn btn-success ' + Button_Size +
            '\"   onclick=\"ajaxCall(''actions'', ''ticket=' +
            Qry.FieldByName('ID').AsString + ''')\"><i class=\"' + Icon_WhatsApp +
            '\"></i></button> ';

        if Qry.FieldByName('profilePicUrl').AsString <> '' then
        begin
          Img := '<img src=' + Trim(Qry.FieldByName('profilePicUrl').AsString) +
            'alt=\"Profile Image \" style=\"width: 40px; height: 40px; border-radius: 50%;\"> ';
        end
        else
        begin
          Img :=
            '<img src=\"./assets/img/profile-photos/1.png \" alt=\"Profile Image \" style=\"width: 40px; height: 40px; border-radius: 50%;\"> ';
        end;

        wresult := wresult + '[' +
          '"' + Qry.FieldByName('id').AsString + '", ' +
          '"' + Img + '", ' +
          '"' + Qry.FieldByName('NUMBER').AsString + '", ' +
          '"' + Qry.FieldByName('NAME').AsString + '", ' +
          '"' + Qry.FieldByName('EMAIL').AsString + '", ' +
          '"' +
          BTN_TICKET + BTN_EDITAR + BTN_EXCLUIR +
          '"' +

        '],';

        Qry.Next;

      end;

      Qry.Close;
      if wtotal <= 0 then
        wresult := wresult + ']}'
      else
        wresult := LeftStr(Trim(wresult), Length(Trim(wresult)) - 1) + ']}';

      aResult := wresult;

    except on E: Exception do
        UserSession.DiscordLogger.SendLog('Error', 'Dao.Contatos', 'GetAll -',
          e.Message);
    end;

  finally
    Qry.Free;
  end;

end;

function Get_Contacts(id: Longint; var Contatos: TContatos; var vResult:
  string): Boolean;
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
      Qry.SQL.Add('Select * from "Contacts" where id =:id');
      Qry.ParamByName('id').AsInteger := id;
      Qry.Open;

      if not Qry.IsEmpty then
      begin
        TPopulateFromQuery<TContatos>.PopulateFromDataSet(Contatos, Qry);
      end;

      Result := True;

    except on E: Exception do

        UserSession.DiscordLogger.SendLog('Error', 'Dao.Contatos',
          'Get_Contacts', e.Message);
    end;
  finally
    Qry.Free;
  end;

end;

function UpdateNomeContactByNumber(Number, ApiKey, Instancia: string; companyId:
  Integer): Integer;
var
  Qry: TFDQuery;
  ProfilePicUrl, ProfileName: string;
  EvolutionAPI: TEvolutionAPI;
begin
  Result := 0;
  Qry := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;
  EvolutionAPI := TEvolutionAPI.Create;
  try

    try
      Qry.SQL.Text :=
        'INSERT INTO public."Contacts" ' +
        ' ( "name", "number", "companyId", "createdAt", "updatedAt", "isGroup","profilePicUrl" ) ' +
        ' VALUES ' +
        ' ( :name, :number, :companyId, :createdAt, :updatedAt, :isGroup,:profilePicUrl )' +
        ' ON CONFLICT ("number", "companyId") DO UPDATE SET ' +
        '  "name" = EXCLUDED."name", ' +
        '  "updatedAt" = EXCLUDED."updatedAt"' +
        'RETURNING id;';

      EvolutionAPI.Get_ProfileContact(Instancia, Number, ApiKey, ProfilePicUrl,
        ProfileName);

      Qry.ParamByName('name').AsString          := ProfileName;
      Qry.ParamByName('number').AsString        := StringReplace(Number,'@s.whatsapp.net', '', [rfReplaceAll]);
      Qry.ParamByName('companyId').AsInteger    := CompanyId;
      Qry.ParamByName('createdAt').AsDateTime   := Now;
      Qry.ParamByName('updatedAt').AsDateTime   := Now;
      Qry.ParamByName('isGroup').AsBoolean      := false;
      Qry.ParamByName('profilePicUrl').AsString := ProfilePicUrl;
      Qry.Open;

      Result := Qry.FieldByName('id').AsInteger;

    except on E: Exception do
        UserSession.DiscordLogger.SendLog('Erro-', 'Dao.ProcessaMensagem',
          'UpdateNomeContactByNumber', e.Message);
    end;

  finally
    Qry.Free;
    EvolutionAPI.Free;
  end;

end;

function Set_Contacts(Codigo: Longint; var Contatos: TContatos; var vResult:
  string): Boolean;
var
  Qry: TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

    if Contatos.id <= 0 then
    begin
      Contatos.id         := NextGeneratorPosteGresql('Contacts_id_seq');
      Contatos.Createdat  := Now;
      Contatos.Updatedat  := Now;
      Contatos.companyId  := UserSession.Clipboard['Loguin_companyId'].I;
    end;

    Qry.SQL.Add('INSERT INTO "Contacts" (id, "name", "number", "profilePicUrl", "createdAt", "updatedAt", email, "isGroup", "companyId")    ');
    Qry.SQL.Add('VALUES (:id, :name, :number, :profilePicUrl, :createdAt, :updatedAt, :email, :isGroup, :companyId)                         ');
    Qry.SQL.Add('ON CONFLICT (id)                                                                                                           ');
    Qry.SQL.Add('DO UPDATE SET                                                                                                              ');
    Qry.SQL.Add('"name" = EXCLUDED."name",                                                                                                  ');
    Qry.SQL.Add('"number" = EXCLUDED."number",                                                                                               ');
    Qry.SQL.Add('"profilePicUrl" = EXCLUDED."profilePicUrl",                                                                                 ');
    Qry.SQL.Add('"createdAt" = EXCLUDED."createdAt",                                                                                         ');
    Qry.SQL.Add('"updatedAt" = EXCLUDED."updatedAt",                                                                                         ');
    Qry.SQL.Add('email = EXCLUDED.email,                                                                                                    ');
    Qry.SQL.Add('"isGroup" = EXCLUDED."isGroup",                                                                                             ');
    Qry.SQL.Add('"companyId" = EXCLUDED."companyId";                                                                                         ');

    Qry.ParamByName('id').AsInteger           := Contatos.id;
    Qry.ParamByName('name').AsString          := PrimeiraLetraMaiuscula(Contatos.name);
    Qry.ParamByName('number').AsString        := SomenteNumeros(Contatos.number);
    Qry.ParamByName('profilePicUrl').AsString := Contatos.profilePicUrl;
    Qry.ParamByName('createdAt').AsDateTime   := Contatos.createdAt;
    Qry.ParamByName('updatedAt').AsDateTime   := Contatos.updatedAt;
    Qry.ParamByName('email').AsString         := Contatos.email;
    Qry.ParamByName('isGroup').AsBoolean      := False;
    Qry.ParamByName('companyId').AsInteger    := Contatos.companyId;

    try

      Qry.ExecSQL;
      Result := True;

    except on E: Exception do

        UserSession.DiscordLogger.SendLog('Error-', 'Dao.Contacts-',
          ' Set_Contacts - ', E.Message);

    end;

  finally
    Qry.Free;
  end;
end;

end.

end.


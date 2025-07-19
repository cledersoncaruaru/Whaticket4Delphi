unit Functions.DataBase;

interface

uses
  ServerController,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  System.SysUtils,
  Functions.Strings,
  IWCompListbox,
  Integracao.Discord,
  System.Classes;

  function  Get_Field_String_Param_Int (Field: String; Tabela:String; Param:string; vValue:Longint):String;
  function  Get_Field_String_Param_Str (Field: String; Tabela:String; Param:string; vValue:String):String;
  function  NextGeneratorPosteGresql(Campo: String): Longint;
  procedure Load_Combobox_Status(var Combobox: TIWComboBox; Crud:Boolean=False);
  function  SalvarConsultaComParametros(const Query: TFDQuery):Boolean;
  function  Get_Indice_Combo(ID:Integer; var ComboBox:TIWComboBox):Integer;
  procedure Load_ComboboxContact(CompanyId: LongInt; var Combobox: TIWSelect);
  function  GerarIDUnico: string;
  procedure Load_Combobox_Filas(CompanyId: LongInt; var Combobox: TIWSelect);
  procedure Load_Combobox_Conexoes(CompanyId: LongInt; var Combobox: TIWComboBox);
  procedure Load_Combobox_Status_Select(var Combobox: TIWSelect; Crud:Boolean=False);

implementation

function GerarIDUnico: string;
var
  GUID: TGUID;
begin
  if CreateGUID(GUID) = S_OK then begin
    Result := GUIDToString(GUID);
    Result := StringReplace(Result,'{','', [rfReplaceAll]);
    Result := StringReplace(Result,'}','', [rfReplaceAll]);
    Result := StringReplace(Result,'-','', [rfReplaceAll]);
  end
  else
    Result := '';
end;

Function Get_Indice_Combo(ID:Integer; var ComboBox:TIWComboBox):Integer;
var
i      :Integer;
ItemID : String;
begin

 Result := -1;

   for i := 0 to ComboBox.Items.Count - 1 do
    begin
      ItemID := ComboBox.Items.ValueFromIndex[i];
      if ItemID = IntToStr(ID) then
      begin
        Result := i;
        Break;
      end;
    end;

end;

Function SalvarConsultaComParametros(const Query: TFDQuery):Boolean;
var
  I:Integer;
  Param: TFDParam;
  Lista  : TStringList;
begin

  Lista  := TStringList.Create;

 try

  for I := 0 to Query.Params.Count - 1 do
  begin
    Param := Query.Params[I];
    Lista.Add(Param.Name + ': ' + Param.AsString);
  end;

 finally
 Lista.Free;
 end;

end;

procedure Load_ComboboxContact(CompanyId: LongInt; var Combobox: TIWSelect);
var
Qry   : TFDQuery;
Name  : String;
begin

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

    Combobox.MultiSelect             := True;
    Combobox.SelectMinInputLength    := 0;
    Combobox.SelectMinCountForSearch := 0;
    Combobox.ItemsHaveValues         := True;

    Qry.SQL.Add(' SELECT id,name,"companyId","number" FROM "Contacts" ');
    Qry.SQL.Add('WHERE "companyId"=:companyId');
    Qry.ParamByName('companyId').AsInteger := CompanyId;
    Qry.Open;

    while not (Qry.Eof) do
    begin

      if Trim(Qry.FieldByName('name').AsString) = '' then begin
         Name := 'Não Informado';
      end
      else begin
       Name   := Trim(Qry.FieldByName('name').AsString);
      end;

      Combobox.Items.Add(Name +' - '+Trim(Qry.FieldByName('number').AsString)+ '=' + Qry.FieldByName('id').AsString);
      Qry.Next;

    end;

  finally
  Qry.Free;
  end;

end;

procedure Load_Combobox_Status_Select(var Combobox: TIWSelect; Crud:Boolean=False);
var
Qry  :TFDQuery;
begin

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

    Combobox.MultiSelect             := False;
    Combobox.SelectMinInputLength    := 0;
    Combobox.SelectMinCountForSearch := 0;
    Combobox.ItemsHaveValues         := True;

    Qry.SQL.Add(' SELECT id,descricao,crud FROM "Status"');
    Qry.SQL.Add(' WHERE crud=:crud');

    Qry.ParamByName('crud').AsBoolean    := Crud;

    try

      Qry.Open;
      Qry.First;

      while not (Qry.Eof) do begin
        Combobox.Items.Add(Qry.FieldByName('descricao').AsString+'=' + Qry.FieldByName('id').AsString);
        Qry.Next;

      end;

      Combobox.ItemIndex := 0;

    except on e:exception do
      raise;

    end;

  finally
  Qry.Free;
  end;

end;

procedure Load_Combobox_Status(var Combobox: TIWComboBox; Crud:Boolean=False);
var
Qry  :TFDQuery;
begin

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    := UserSession.Conexao;

  try

    Combobox.ItemsHaveValues := True;
    Combobox.Items.Clear;

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT id,descricao,crud FROM "Status"');
    Qry.SQL.Add(' WHERE crud=:crud');

    Qry.ParamByName('crud').AsBoolean    := Crud;

    try

      Qry.Open;
      Qry.First;

      while not (Qry.Eof) do begin
        Combobox.Items.Add(Qry.FieldByName('descricao').AsString+'=' + Qry.FieldByName('id').AsString);
        Qry.Next;

      end;

      Combobox.ItemIndex := -1;

    except on e:exception do
      raise;
    end;

  finally
  Qry.Free;
  end;

end;

procedure Load_Combobox_Filas(CompanyId: LongInt; var Combobox: TIWSelect);
var
Qry   : TFDQuery;
begin

  Qry             := TFDQuery.Create(nil);
  Qry.Connection  := UserSession.Conexao;

  try

    Combobox.MultiSelect             := True;
    Combobox.SelectMinInputLength    := 0;
    Combobox.SelectMinCountForSearch := 0;
    Combobox.ItemsHaveValues         := True;

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT id, "name",  "companyId" from "Queues"');
    Qry.SQL.Add(' where "companyId"=:companyId');
    Qry.SQL.Add(' order by id');
    Qry.ParamByName('companyId').AsInteger  := CompanyId;

    try

      Qry.Open;
      Qry.First;

      while not (Qry.Eof) do
      begin

        Combobox.Items.Add(Qry.FieldByName('name').AsString + '=' + Qry.FieldByName('id').AsString);
        Qry.Next;

      end;

    except on E: Exception do
    raise;
      //SendLog('Error','Function.DataBase','Load_Combobox - ',e.Message);
    end;

  finally
  Qry.Free;
  end;

end;

procedure Load_Combobox_Conexoes(CompanyId: LongInt; var Combobox: TIWComboBox);
var
Qry   : TFDQuery;
begin

  Qry            := TFDQuery.Create(nil);
  Qry.Connection  := UserSession.Conexao;

  try

    Combobox.ItemsHaveValues := True;
    Combobox.Items.Clear;

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add(' SELECT id, "name", "isDefault", "companyId" FROM "Whatsapps"');
    Qry.SQL.Add(' where "companyId"=:companyId');
    Qry.SQL.Add(' order by id');
    Qry.ParamByName('companyId').AsInteger  := CompanyId;

    try

      Qry.Open;
      Qry.First;

      while not (Qry.Eof) do
      begin

        Combobox.Items.Add(Qry.FieldByName('name').AsString + '=' + Qry.FieldByName('id').AsString);
        Qry.Next;

      end;

    except on E: Exception do
    raise;
      //SendLog('Error','Function.DataBase','Load_Combobox_Conexoes - ',e.Message);
    end;

  finally
  Qry.Free;
  end;

end;

function NextGeneratorPosteGresql(Campo: String): Longint;
var
Qry     : TFDQuery;
begin

  Result            := 0;

  Qry               := TFDQuery.Create(Nil);
  Qry.Connection    :=  UserSession.Conexao;

  try

   try

    Qry.SQL.Add('SELECT nextval(''"' + Campo + '"'')');
    Qry.Open;

    Result       := Qry.FieldByName('nextval').AsInteger;

    except on E: Exception do
     raise;
     //SendLog('Error','Function.DataBase','NextGeneratorPosteGresql - ',e.Message);
    end;


  finally
  Qry.Free;
  end;

end;

Function Get_Field_String_Param_Int (Field: String; Tabela:String; Param:string; vValue:Longint):String;
var
  Qry : TFDQuery;
begin

  Result := '';

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;


  try
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('Select '+Field+' from '+Tabela+' where ' + Param+' = '+QuotedStr(vValue.ToString) );

    try

      Qry.Open;

      if not Qry.Fields[0].IsNull then
        Result := Qry.Fields[0].AsString;

    except
        on E: Exception do begin
         raise;
        end;

    end;

  finally
    Qry.FREE;
  end;

end;

Function Get_Field_String_Param_Str (Field: String; Tabela:String; Param:string; vValue:String):String;
var
  Qry : TFDQuery;
begin

  Result := '';

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('Select '+Field+' from '+Tabela+' where ' + Param+' = '+QuotedStr(vValue) );

    try

      Qry.Open;

      if not Qry.Fields[0].IsNull then
        Result := Qry.Fields[0].AsString;

    except

        on E: Exception do begin
          raise;
        end;


    end;

  finally
    Qry.Free;
  end;

end;

end.


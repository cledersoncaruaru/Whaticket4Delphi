// Atenção, essa Classe foi Baseada nos conceitos de RTTI, Geralmente em Pequenos casos e casos isolados
// é bom fazer com RTTI, etretanto, pode ser mais pesado do que outros metodos nomaiis que se usa no dia a dia
// esse exemplo foi implementado visando dar agilidade ao processo de construção da aplicação

unit uPopulaCrud;

interface

uses
  System.Rtti, System.SysUtils,Data.DB,
  System.Classes,IWControl,IWVCLComponent,
  IWCompExtCtrls,
  IWCompEdit,
  IWCompMemo,
  IWCompCheckbox,
  Functions.DataBase,
  Integracao.Discord,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  FireDAC.DApt,

  IWCompListbox,IWVCLBaseControl,
  IWBaseControl,IWTypes,IWApplication,IWAppForm,
  IWBaseHTMLControl,IWBaseLayoutComponent,IWBaseContainerLayout,IWContainerLayout,
  System.JSON ;



type
  TPopulateFromScreen<T: class> = class
  public
    class procedure PopulaObjeto(AObj: T; AOwner: TComponent);
    class procedure PopulateScreenFromObject(AObj: T; AOwner: TComponent);
  end;


type
  TPopulateFromQuery<T: class, constructor> = class
  public
    class procedure PopulateFromDataSet(AObj: T; ADataSet: TDataSet);
  end;

   type
  TSaveObjectToDatabase<T: class> = class
  public
      class procedure Save(AObj: T; AQuery: TFDQuery; const TableName: string);
  end;

type
  TPopulateQueryParams<T: class> = class
  public
    class procedure Populate(AObj: T; AQuery: TFDQuery);
  end;


function IsValidJSON(const AText: string): Boolean;

implementation



class procedure TPopulateFromQuery<T>.PopulateFromDataSet(AObj: T; ADataSet: TDataSet);
var
  ctx: TRttiContext;
  typ: TRttiType;
  prop: TRttiProperty;
  Value: TValue;
  Field: TField;
begin
  if not Assigned(AObj) or not Assigned(ADataSet) or not ADataSet.Active or ADataSet.IsEmpty then
    Exit;

  ctx := TRttiContext.Create;
  try
    typ := ctx.GetType(T); // Obtemos o tipo de T

    // Percorre todas as propriedades da classe genérica T
    for prop in typ.GetProperties do
    begin
      // Verifica se há um campo na consulta com o mesmo nome da propriedade
      Field := ADataSet.FindField(prop.Name);
      if Assigned(Field) then
      begin

        case prop.PropertyType.TypeKind of
          tkUString:
            Value := Field.AsString;
          tkInteger:
            Value := Field.AsInteger;
          tkFloat:
            Value := Field.AsFloat;
          tkInt64:
            Value := Field.AsLargeInt;
          tkEnumeration:
            begin
              if prop.PropertyType.Handle = TypeInfo(Boolean) then
                Value := Field.AsBoolean
              else
                Value := TValue.FromOrdinal(prop.PropertyType.Handle, Field.AsInteger);
            end;
          tkClass:
            if Field.DataType = ftDateTime then
              Value := Field.AsDateTime;
        end;
        // Atribui o valor à propriedade usando RTTI
        prop.SetValue(TValue.From<T>(AObj).AsObject, Value);
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class procedure TPopulateFromScreen<T>.PopulaObjeto(AObj: T; AOwner: TComponent);
var
  ctx: TRttiContext;
  typ: TRttiType;
  prop: TRttiProperty;
  comp: TComponent;
  Value: TValue;
  obj: TObject;
  i: Integer;
begin
  ctx := TRttiContext.Create;
  try
    typ := ctx.GetType(TypeInfo(T)); // Get RTTI type information for T
    obj := TValue.From<T>(AObj).AsObject; // Convert AObj to TObject

    if obj = nil then
      Exit;

    // Iterate over all properties of the object
    for prop in typ.GetProperties do
    begin
      comp := nil;

      // Busca case-insensitive pelo componente com o mesmo nome da propriedade
      for i := 0 to AOwner.ComponentCount - 1 do
      begin
        if SameText(AOwner.Components[i].Name, prop.Name) then
        begin
          comp := AOwner.Components[i];
          Break;
        end;
      end;

      if comp <> nil then
      begin
        Value := TValue.Empty;

        // Prepara o valor com base no tipo do componente e da propriedade
        if comp is TIWEdit then
        begin
          if prop.PropertyType.TypeKind in [tkUString, tkString, tkLString, tkWString] then
            Value := TIWEdit(comp).Text
          else if prop.PropertyType.TypeKind in [tkInteger, tkInt64] then
            Value := StrToIntDef(TIWEdit(comp).Text, 0)
          else if prop.PropertyType.TypeKind = tkFloat then
            Value := StrToFloatDef(TIWEdit(comp).Text, 0)
          else if (prop.PropertyType.TypeKind = tkEnumeration) and (prop.PropertyType.Handle = TypeInfo(Boolean)) then
            Value := SameText(TIWEdit(comp).Text, 'True');
        end
        else if comp is TIWComboBox then
        begin
          if prop.PropertyType.TypeKind in [tkInteger, tkInt64] then
            Value := TIWComboBox(comp).ItemIndex
          else if prop.PropertyType.TypeKind in [tkUString, tkString, tkLString, tkWString] then
            Value := TIWComboBox(comp).Text;
        end
        else if comp is TIWCheckBox then
        begin
          if prop.PropertyType.TypeKind in [tkInteger, tkInt64] then
            Value := Ord(TIWCheckBox(comp).Checked)
          else if (prop.PropertyType.TypeKind = tkEnumeration) and (prop.PropertyType.Handle = TypeInfo(Boolean)) then
            Value := TIWCheckBox(comp).Checked;
        end

        else if comp is TIWMemo then
        begin
          if prop.PropertyType.TypeKind in [tkUString, tkString, tkLString, tkWString] then
            Value := TIWMemo(comp).Text;
        end;

        // Atribui o valor à propriedade se válido
        if not Value.IsEmpty then
        begin
          try
            prop.SetValue(obj, Value);
          except
            on E: Exception do
            begin
              // Log opcional
              // ShowMessage(Format('Erro ao atribuir %s: %s', [prop.Name, E.Message]));
            end;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

class procedure TPopulateFromScreen<T>.PopulateScreenFromObject(AObj: T; AOwner: TComponent);
var
  ctx: TRttiContext;
  typ: TRttiType;
  prop: TRttiProperty;
  comp: TComponent;
  Value: TValue;
  obj: TObject;
  i: Integer;
begin
  ctx := TRttiContext.Create;
  try
    typ := ctx.GetType(TypeInfo(T));
    obj := TValue.From<T>(AObj).AsObject;

    if obj = nil then
      Exit;

    for prop in typ.GetProperties do
    begin
      Value := prop.GetValue(obj);

      comp := nil;
      for i := 0 to AOwner.ComponentCount - 1 do
      begin
        if SameText(AOwner.Components[i].Name, prop.Name) then
        begin
          comp := AOwner.Components[i];
          Break;
        end;
      end;

      if comp <> nil then
      begin
        if comp is TIWEdit then
        begin
          if Value.Kind in [tkUString, tkString, tkLString, tkWString] then
            TIWEdit(comp).Text := Value.AsString
          else if Value.Kind in [tkInteger, tkInt64] then
            TIWEdit(comp).Text := IntToStr(Value.AsInteger)
          else if Value.Kind = tkFloat then
            TIWEdit(comp).Text := FloatToStr(Value.AsExtended)
          else if (Value.Kind = tkEnumeration) and (prop.PropertyType.Handle = TypeInfo(Boolean)) then
            TIWEdit(comp).Text := BoolToStr(Value.AsBoolean, True);
        end
        else if comp is TIWComboBox then
        begin
          if Value.Kind in [tkInteger, tkInt64] then
            TIWComboBox(comp).ItemIndex := Value.AsInteger
          else if Value.Kind in [tkUString, tkString, tkLString, tkWString] then
            TIWComboBox(comp).Text := Value.AsString;
        end
           else if comp is TIWCheckBox then
        begin
          if Value.Kind in [tkInteger, tkInt64] then
            TIWCheckBox(comp).Checked := Value.AsInteger <> 0
          else if (Value.Kind = tkEnumeration) and (prop.PropertyType.Handle = TypeInfo(Boolean)) then
            TIWCheckBox(comp).Checked := Value.AsBoolean;
        end
        else if comp is TIWMemo then
        begin
          TIWMemo(comp).Text := Value.ToString;
        end;

        if comp is TIWCustomControl then
          TIWCustomControl(comp).Invalidate;
      end;
    end;
  finally
    ctx.Free;
  end;
end;

{ TPopulateQueryParams<T> }

class procedure TPopulateQueryParams<T>.Populate(AObj: T; AQuery: TFDQuery);
var
  ctx: TRttiContext;
  typ: TRttiType;
  prop: TRttiProperty;
  Value: TValue;
  Param: TFDParam;
begin
  if not Assigned(AObj) or not Assigned(AQuery) then
    Exit;

  ctx := TRttiContext.Create;
  try
    typ := ctx.GetType(T); // Obtemos o tipo de T

    // Percorre todas as propriedades da classe genérica T
    for prop in typ.GetProperties do
    begin
      if prop.IsReadable then
      begin
        Param := AQuery.FindParam(prop.Name);
        if Assigned(Param) then
        begin
          Value := prop.GetValue(TValue.From<T>(AObj).AsObject);

          case prop.PropertyType.TypeKind of
            tkUString, tkString:
              Param.AsString := Value.AsString;
            tkInteger, tkInt64:
              Param.AsInteger := Value.AsInteger;
            tkFloat:
              Param.AsFloat := Value.AsExtended;
            tkClass:
              if prop.PropertyType.Handle = TypeInfo(TDateTime) then
                Param.AsDateTime := Value.AsExtended;
          end;
        end;
      end;
    end;
  finally
    ctx.Free;
  end;

end;

class procedure TSaveObjectToDatabase<T>.Save(AObj: T; AQuery: TFDQuery; const TableName: string);
var
  QryMeta: TFDQuery;
  ctx: TRttiContext;
  typ: TRttiType;
  prop: TRttiProperty;
  Cols: TStringList;
  i: Integer;
  EscTable, fieldStr, paramStr, updateStr: string;
  Param: TFDParam;
  Value: TValue;
  ObjAsTObject: TObject;
begin
  // 0) Validações iniciais
  if TableName.Trim.IsEmpty then
    raise Exception.Create('Save: TableName não pode ser vazio.');
  if not Assigned(AObj) or not Assigned(AQuery) or not Assigned(AQuery.Connection) then
    Exit;

  ObjAsTObject := TObject(AObj);
  EscTable := '"' + TableName + '"';

  // 1) Consulta metadados para obter colunas escapadas
  QryMeta := TFDQuery.Create(nil);
  try
    QryMeta.Connection := AQuery.Connection;
    QryMeta.SQL.Text :=
      'SELECT quote_ident(column_name) AS col ' +
      'FROM information_schema.columns ' +
      'WHERE table_schema = :schema ' +
      '  AND table_name   = :table ' +
      'ORDER BY ordinal_position';
    QryMeta.ParamByName('schema').AsString := 'public';
    QryMeta.ParamByName('table').AsString  := TableName;
    QryMeta.Open;

    Cols := TStringList.Create;
    try
      while not QryMeta.Eof do
      begin
        Cols.Add(QryMeta.FieldByName('col').AsString);
        QryMeta.Next;
      end;
      if Cols.Count = 0 then
        raise Exception.CreateFmt('Save: não encontrei colunas em %s.', [TableName]);

      // 2) Monta fieldStr, paramStr e updateStr
      fieldStr := '';
      paramStr := '';
      updateStr := '';
      for i := 0 to Cols.Count - 1 do
      begin
        if i > 0 then
        begin
          fieldStr  := fieldStr  + ', ';
          paramStr  := paramStr  + ', ';
          updateStr := updateStr + ', ';
        end;
        fieldStr  := fieldStr  + Cols[i];
        paramStr  := paramStr  + ':' + Cols[i].Replace('"','');
        updateStr := updateStr + Format('%s = EXCLUDED.%s', [Cols[i], Cols[i]]);
      end;
    finally
      Cols.Free;
    end;

    // 3) Monta o SQL de INSERT ... ON CONFLICT
    with AQuery do
    begin
      Close;
      SQL.Clear;
      SQL.Add(Format('INSERT INTO public.%s (%s)', [EscTable, fieldStr]));
      SQL.Add(Format('VALUES (%s)', [paramStr]));
      SQL.Add(Format('ON CONFLICT (id) DO UPDATE SET %s', [updateStr]));
      // **NÃO** invoque Prepared aqui
    end;

    // 4) Preenche parâmetros via RTTI, tratando UUIDs separadamente
    ctx := TRttiContext.Create;
    try
      typ := ctx.GetType(ObjAsTObject.ClassType);
      for prop in typ.GetProperties do
      begin
        Param := AQuery.Params.FindParam(prop.Name);
        if not Assigned(Param) then
          Continue;

        // Tratamento especial para GUID/UUID
        if prop.PropertyType.Handle = TypeInfo(TGUID) then
        begin
          Param.DataType     := ftGuid;
          Param.DataTypeName := 'uuid';
          Param.Size         := 16;
          Value := prop.GetValue(ObjAsTObject);
          Param.AsGuid       := Value.AsType<TGUID>;
          Continue;
        end;

        // Caso geral para strings, inteiros, floats, boolean e datetime
        Value := prop.GetValue(ObjAsTObject);
        case prop.PropertyType.TypeKind of
          tkString, tkLString, tkWString, tkUString:
            Param.AsString := Value.AsString;
          tkInteger, tkInt64:
            if prop.PropertyType.Handle = TypeInfo(Boolean) then
              Param.AsBoolean := Value.AsBoolean
            else
              Param.AsInteger := Value.AsOrdinal;
          tkFloat:
            if prop.PropertyType.Handle = TypeInfo(TDateTime) then
              Param.AsDateTime := Value.AsExtended
            else
              Param.AsFloat := Value.AsExtended;
          tkEnumeration:
            if prop.PropertyType.Handle = TypeInfo(Boolean) then
              Param.AsBoolean := Value.AsBoolean
            else
              Param.AsInteger := Value.AsOrdinal;
        else
          Param.Value := Value.AsVariant;
        end;
      end;
    finally
      ctx.Free;
    end;

    // 5) Executa INSERT/UPSERT (o FireDAC prepara automaticamente)
    try
      AQuery.ExecSQL;
    except
      on E: Exception do
    end;

  finally
    QryMeta.Free;
  end;
end;

function IsValidJSON(const AText: string): Boolean;
var
  JsonValue: TJSONValue;
begin
  try
    JsonValue := TJSONObject.ParseJSONValue(AText);
    Result := Assigned(JsonValue);
    JsonValue.Free;
  except
    Result := False;
  end;
end;



end.



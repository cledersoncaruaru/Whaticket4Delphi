unit Functions.Strings;

interface
uses
  EncdDecd,
  System.NetEncoding,
  IdCoderMIME,
  IdGlobal,
  System.SysUtils,
  System.Classes,
  IdHashMessageDigest,
  Functions.Boolean,
  System.RegularExpressions,
  System.JSON,DateUtils,
  Windows,
  ActiveX,
  UrlMon;

  function MD5(const texto: string): string;
  function Str2Num(ValorString: String): LongInt;
  function RemoverMascaras(Texto: string): string;
  function RemovaZerosAEsquerda(Valor: String): String;
  function Money2Float(Valor_Monetario: String): Currency;
  function Ltrim(xMens: String): String;
  function Float2Money(Valor_Real: Currency): String;
  function Is_Number(Numero: String): Boolean;
  function R_FORMAT(Stt: String): String;
  function R_FORMAT4(Stt: String): String;
  function Rtrim(xMens: String): String;
  function Substitua(VAR Texto: String; ValorOriginal, NovoValor: String) : Boolean;
  function Replicate(Caracter: String; Quant: integer): String;
  function DeleteMask(Texto: string): string;
  function Get_Token : string;
  function GeraSenha(QtdCaracteres: Byte; SoNumeros: Boolean = False; MaisculasEMinusculas: Boolean = True): String;
  function RoundTo5(const Valor: Double; const Casas: Integer): Double;
  function RemoveAll(Subst: String; Texto: String): String;
  function TrocaVirgPPto(Valor: string): String;
  function TratarMensagemSweetAlert(const aMensagem: String): String;
  function RemoveCaracteresInvalidos(const ABase64Str: string): string;
  function PrimeiraLetraMaiuscula(const AText: string): string;
  function SomenteNumeros(const AText: string): string;
  function Base64ToFile(const Base64String, FileName: string):String;
  function ExtractMimeTypeSubType(const JSONString: string):String;
  function ExtractExtensao(const JSONString: string):String;
  function ExtractFileExtension(const JSONString: string):String;
  function ExtractDataHoraByHora(vDataHora:String):String;
  function ExtrairHoraMinuto(const DataHoraStr: string): string;
  function ParseBrazilianDateTime(const AText: string; const ADefault: TDateTime): TDateTime;
  function DatahoraBrasileira(const ADateTime: TDateTime): string;
  function Base64Invalids(const ABase64Str: string): string;
  function SomenteNumero(Texto : String): String;
  function GetMimeType(const FileName: string): string;
  function GetMediaTypeClass(const FileName: string): string;
  function TrataDadosSelect2(const Entrada: string): string;

implementation

uses
  System.Math;

function TrataDadosSelect2(const Entrada: string): string;
var
  Lista: TStringList;
  i: Integer;
begin
  Lista := TStringList.Create;
  try
    Lista.StrictDelimiter := True;
    Lista.Delimiter := ',';
    Lista.Duplicates := dupIgnore;
    Lista.Sorted := False;
    Lista.DelimitedText := Entrada;

    for i := Lista.Count - 1 downto 0 do
    begin
      if (Lista[i] = '-1') or (Trim(Lista[i]) = '') then
        Lista.Delete(i);
    end;

    Result := Lista.DelimitedText;
  finally
    Lista.Free;
  end;
end;

function GetMediaTypeClass(const FileName: string): string;
var
  Mime: string;
begin
  Mime := LowerCase(GetMimeType(FileName));

  if Mime.StartsWith('image/') then
    Result := 'image'
  else if Mime.StartsWith('video/') then
    Result := 'video'
  else if Mime.StartsWith('application/pdf') or
          Mime.StartsWith('application/msword') or
          Mime.Contains('officedocument') or
          Mime.StartsWith('text/plain') then
    Result := 'document'
  else
    Result := 'unknown';
end;


function GetMimeType(const FileName: string): string;
var
  Buffer: array[0..255] of Byte;
  ReadStream: TFileStream;
  MimeType: LPWSTR;
  BytesRead: Integer;
begin
  Result := '';
  if not FileExists(FileName) then Exit;

  ReadStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    BytesRead := ReadStream.Read(Buffer, SizeOf(Buffer));
    FindMimeFromData(nil, PWideChar(WideString(FileName)), @Buffer, BytesRead, nil, 0, MimeType, 0);
    Result := MimeType;
    CoTaskMemFree(MimeType);
  finally
    ReadStream.Free;
  end;
end;



function SomenteNumero(Texto : String): String;
var
  I : Byte;
begin
   Result := '';
   for I := 1 To Length(Texto) do
       if Texto [I] In ['0'..'9'] Then
            Result := Result + Texto [I];
end;


function Base64Invalids(const ABase64Str: string): string;
begin
  Result := ABase64Str;
  Result := StringReplace(Result, #13#10, '', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '', [rfReplaceAll]);
  Result := StringReplace(Result, #$D#$A, '', [rfReplaceAll]);

end;

function DatahoraBrasileira(const ADateTime: TDateTime): string;
var
  FS: TFormatSettings;
begin
  FS := TFormatSettings.Create;
  FS.DateSeparator   := '/';
  FS.ShortDateFormat := 'dd/MM/yyyy';
  FS.TimeSeparator   := ':';
  FS.LongTimeFormat  := 'HH:mm:ss';
  Result := FormatDateTime('dd/MM/yyyy HH:nn:ss', ADateTime, FS);
end;



function ParseBrazilianDateTime(const AText: string;
  const ADefault: TDateTime): TDateTime;
var
  FS: TFormatSettings;
begin
  FS := TFormatSettings.Create;
  FS.DateSeparator   := '/';
  FS.ShortDateFormat := 'dd/MM/yyyy';
  FS.TimeSeparator   := ':';
  FS.LongTimeFormat  := 'HH:mm:ss';

  Result := StrToDateTimeDef(AText, ADefault, FS);
end;

function ExtrairHoraMinuto(const DataHoraStr: string): string;
var
  DataHora: TDateTime;
  StrSemFuso: string;
begin
  // Pega só os 19 primeiros caracteres: '2025-06-07 15:32:35'
  StrSemFuso := Copy(DataHoraStr, 1, 19);

  // Converte para TDateTime (pode precisar adaptar a configuração regional)
  DataHora := StrToDateTime(StrSemFuso);

  // Retorna só hora e minuto
  Result := FormatDateTime('hh:nn', DataHora);
end;
Function ExtractDataHoraByHora(vDataHora:String):String;
var
  DataHoraStr: string;
  DataHora: TDateTime;
  HoraFormatada: string;
begin
  DataHoraStr := vDataHora;
  // Remove o fuso horário (-0300) para converter a string em um TDateTime
  Delete(DataHoraStr, Length(DataHoraStr) - 5, 6);  // Remove o espaço e -0300

  // Converte a string para TDateTime (formato americano: yyyy-mm-dd hh:nn:ss)
  DataHora := StrToDateTime(Copy(DataHoraStr, 1, 19));

  // Formata a data para exibir apenas a hora e minutos
  HoraFormatada := FormatDateTime('hh:nn', DataHora);

  // Exibe o resultado
 Result :=  HoraFormatada;
end;

Function ExtractFileExtension(const JSONString: string):String;
var
  JSONValue: TJSONValue;
  JSONObject: TJSONObject;
  FileNameValue: TJSONValue;
  FileNameStr: string;
  FileExt: string;
begin

  JSONValue := TJSONObject.ParseJSONValue(JSONString);

  if JSONValue = nil then
  begin
    Exit;
  end;

  try

    if not (JSONValue is TJSONObject) then
    begin
      Exit;
    end;

    JSONObject := TJSONObject(JSONValue);

    FileNameValue := JSONObject.Values['fileName'];
    if FileNameValue = nil then
    begin
      Exit;
    end;

    FileNameStr := FileNameValue.Value;
    Result      := ExtractFileExt(FileNameStr);

  finally
    JSONValue.Free;
  end;
end;

Function ExtractMimeTypeSubType(const JSONString: string):String;
var
  RegEx: TRegEx;
  Match: TMatch;
  MimeType, SubType: string;
begin

  Result := '';

  RegEx := TRegEx.Create('"mimetype"\s*:\s*"([^"]+)"', [roIgnoreCase]);
  Match := RegEx.Match(JSONString);

  if Match.Success then
  begin
    MimeType := Match.Groups[1].Value;
    SubType  := Copy(MimeType, Pos('/', MimeType) + 1, Length(MimeType));
    Result   := SubType;
  end
  else
  //  Writeln('O campo "mimetype" não foi encontrado na string.');
end;

Function ExtractExtensao(const JSONString: string):String;
var
  RegEx: TRegEx;
  Match: TMatch;
  MimeType, SubType: string;
begin

 Result := '';

  // Expressão regular para encontrar o valor do "mimetype"
  RegEx := TRegEx.Create('"fileName"\s*:\s*"([^"]+)"', [roIgnoreCase]);
  Match := RegEx.Match(JSONString);

  if Match.Success then
  begin
    // Extrai o valor do "mimetype"
    MimeType := Match.Groups[1].Value;

    // Extrai a parte após a barra '/'
    SubType := Copy(MimeType, Pos('.', MimeType) + 1, Length(MimeType));

    // Exibe o resultado
   // Writeln('SubTipo extraído: ', SubType);
   Result := SubType;
  end
  else
  //  Writeln('O campo "mimetype" não foi encontrado na string.');
end;


function Base64ToFile(const Base64String, FileName: string):String;
var
  Bytes: TBytes;
  MemoryStream: TMemoryStream;
begin
  Bytes := TNetEncoding.Base64.DecodeStringToBytes(Base64String);

  MemoryStream := TMemoryStream.Create;
  try
    MemoryStream.WriteData(Bytes, Length(Bytes));
    MemoryStream.SaveToFile(FileName);

    Result := FileName;
  finally
    MemoryStream.Free;
  end;
end;

function SomenteNumeros(const AText: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AText) do
  begin
    if AText[I] in ['0'..'9'] then
      Result := Result + AText[I];
  end;
end;

function PrimeiraLetraMaiuscula(const AText: string): string;
var
  I: Integer;
  CapitalizeNext: Boolean;
begin
  Result := LowerCase(AText);
  CapitalizeNext := True;

  for I := 1 to Length(Result) do
  begin
    if CapitalizeNext and (Result[I] <> ' ') then
      Result[I] := UpCase(Result[I]);

    CapitalizeNext := (Result[I] = ' ');
  end;
end;

function RemoveCaracteresInvalidos(const ABase64Str: string): string;
begin

  Result := ABase64Str;
  Result := StringReplace(Result, #13#10, '', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '', [rfReplaceAll]);
  Result := StringReplace(Result, #9#9#9#9, '', [rfReplaceAll]);
  Result := StringReplace(Result, #$D#$A, '', [rfReplaceAll]);
  Result := StringReplace(Result, #9#9, '', [rfReplaceAll]);
end;

function TratarMensagemSweetAlert(const aMensagem: String): String;
var
  xPosFim: Integer;
begin
  Result := aMensagem;
  Result := aMensagem;
  Result := StringReplace(Result, '[FireDAC][Phys][FB]exception 3', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '[FireDAC][Phys][FB]', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, 'EXCEPTION 1', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, 'EXCEPTION_001', '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, chr(13)+chr(10), '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, chr(10), '', [rfReplaceAll, rfIgnoreCase]);
  xPosFim := Pos('At procedure', Result)-1;
  if xPosFim <= 0 then
    xPosFim := Pos(Result, 'At trigger')-1;
  if xPosFim >= 0 then
  begin
    Result := Copy(Result, 1, xPosFim);
    Result := Trim(Result);
  end;
end;

function TrocaVirgPPto(Valor: string): String;
var i:integer;
begin
    if Valor <>'' then begin
        for i := 0 to Length(Valor) do begin
            if Valor[i]=',' then Valor[i]:='.';

        end;
     end;
     Result := valor;
end;

function RemovaZerosAEsquerda(Valor: String): String;
VAR
  C: LongInt;
  St: String;
BEGIN
  Result := Valor;
  If Valor = '0' Then
    Exit;
  St := Valor;
  If Length(St) = 0 Then
    Exit;
  REPEAT
    If (St[1] = '0') Then
      Delete(St, 1, 1);
  UNTIL (St[1] <> '0') Or (St = '0');
  Result := St;
END;

function Ltrim(xMens: String): String;
Var
  Contax: byte;
Begin
  Contax := 1;
  While Copy(xMens, Contax, 1) = ' ' Do
  Begin
    Inc(Contax);
  End;
  Ltrim := Copy(xMens, Contax, Length(xMens) - Contax + 1);
End;

function RemoveAll(Subst: String; Texto: String): String;
BEGIN

  REPEAT
    If Pos(Subst, Texto) <> 0 Then
      Delete(Texto, Pos(Subst, Texto), Length(Subst));
  UNTIL Pos(Subst, Texto) = 0;
  Result := Texto;

END;

function RoundTo5(const Valor: Double; const Casas: Integer): Double;
var
  xValor, xDecimais: String;
  p, nCasas: Integer;
  nValor: Double;
  {$IFDEF DELPHIXE2_UP}
  OldRoundMode: TRoundingMode;
  {$ELSE}
  OldRoundMode: TFPURoundingMode;
  {$ENDIF}
begin
  nValor := Valor;
  xValor := Trim(FloatToStr(Valor));
  p := pos(',', xValor);
  if Casas < 0 then
    nCasas := -Casas
  else
    nCasas := Casas;
  if p > 0 then
  begin
    xDecimais := Copy(xValor, p + 1, Length(xValor));
    OldRoundMode := GetRoundMode;
    try
      if Length(xDecimais) > nCasas then
      begin
        if xDecimais[nCasas + 1] >= '5' then
          SetRoundMode(rmUP)
        else
          SetRoundMode(rmNearest);
      end;
      nValor := RoundTo(Valor, Casas);
    finally
      SetRoundMode(OldRoundMode);
    end;
  end;
  Result := nValor;
end;

function DeleteMask(Texto: string): string;
begin

  Result := Texto;

  Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '', [rfReplaceAll]);
  Result := StringReplace(Result, '\', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := StringReplace(Result, '(', '', [rfReplaceAll]);
  Result := StringReplace(Result, ')', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result := StringReplace(Result, ';', '', [rfReplaceAll]);
  Result := StringReplace(Result, ':', '', [rfReplaceAll]);
  Result := StringReplace(Result, '%', '', [rfReplaceAll]);

end;

function GeraSenha(QtdCaracteres: Byte; SoNumeros: Boolean = False; MaisculasEMinusculas: Boolean = True): String;
//Gera uma senha aleatória com letras e numeros ou só numeros
const
  Letras: array[0..25] of string = ('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
var
  ParteNumerica, i, MaiMin: Byte;
  ParteCaracter: string;
  ContaMais1: Boolean;
begin
  Result:= '';
  Randomize;
  ContaMais1:= False;
  for I := 1 to QtdCaracteres  do
  begin
    if not ContaMais1 then
    begin
      ParteNumerica:= Random(9);
      Result:= Result+ IntToStr(ParteNumerica);


      if not SoNumeros then
      begin
        ParteCaracter:= Letras[Random(26)];


        if MaisculasEMinusculas then
        begin
          MaiMin:= Random(2);
          case MaiMin of
            0: Result:= Result+ LowerCase(ParteCaracter);
            1: Result:= Result+ UpperCase(ParteCaracter);
          end;
        end
        else
          Result:= Result+ LowerCase(ParteCaracter);
        ContaMais1:= True; //incrementa contador de caracteres pois no mesmo loop gerou um numero e uma letra
      end;
    end
    else
      ContaMais1:= False;
  end;

end;

function Replicate(Caracter: String; Quant: integer): String;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Quant do
    Result := Result + Caracter;
end;

function Substitua(VAR Texto: String; ValorOriginal, NovoValor: String)
  : Boolean;
VAR
  Posicao: LongInt;
BEGIN
  Result := false;

  If ValorOriginal = NovoValor Then
  Begin
    Result := true;
    Exit;
  End;

  REPEAT
    Posicao := Pos(ValorOriginal, Texto);
    If Posicao > 0 Then
    Begin
      If (Length(ValorOriginal) = 1) AND (Length(NovoValor) = 1) Then
      Begin
        Texto[Posicao] := NovoValor[1];
      End
      Else
      Begin
        Delete(Texto, Posicao, Length(ValorOriginal));
        Insert(NovoValor, Texto, Posicao);
      End
    End;
  UNTIL Posicao <= 0;


END;

function Rtrim(xMens: String): String;
Var
  Contax: byte;
Begin
  Contax := Length(xMens);
  While Copy(xMens, Contax, 1) = ' ' do
  Begin
    Dec(Contax);
  End;
  Rtrim := Copy(xMens, 1, Contax)
End;

function R_FORMAT4(Stt: String): String;
VAR
  V1: String;
  C: word;
  Virgulas: word; // Conta o número de vírgulas... Se tiver mais de um, tira...

BEGIN
  V1 := TrimLeft(TrimRight(Stt));

  If (Pos(' ', V1) = 1) Or (V1 = '') Then
    V1 := '0,0000';
  If Pos(V1[1], '.,') <> 0 Then
    V1 := '0' + V1;

  If (V1[1] = '-') AND (Pos(V1[2], '.,') <> 0) Then
    Insert('0', V1, 2);

  { Checando se Tem Letras }
  C := 1;
  Virgulas := 0;
  REPEAT
    If V1[C] = '.' Then
    Begin
      Delete(V1, C, 1);
      Insert(',', V1, C);
      If Length(V1) = 0 Then
        V1 := '0,00';
      Dec(C);
    End;
    If Pos(V1[C], '-1234567890,') = 0 Then
    Begin
      V1 := '0,00';
      C := Length(V1);
    End;
    If V1[C] = ',' Then
      Inc(Virgulas);
    Inc(C);
  UNTIL C > Length(V1);

  If Virgulas > 1 Then
  Begin
    REPEAT
      Delete(V1, Pos(',', V1), 1);
      Dec(Virgulas);
    UNTIL Virgulas = 1;
  End;

  If Pos(',', V1) = 0 Then
    V1 := V1 + ',0000';
  If Pos(',', V1) = 1 Then
    V1 := '0' + V1;

  If Length(V1) - Pos(',', V1) = 0 Then
    V1 := V1 + '0000';
  If Length(V1) - Pos(',', V1) = 1 Then
    V1 := V1 + '000';
  If Length(V1) - Pos(',', V1) = 2 Then
    V1 := V1 + '00';
  If Length(V1) - Pos(',', V1) = 3 Then
    V1 := V1 + '0';
  If Length(V1) - Pos(',', V1) > 4 Then
    Delete(V1, Pos(',', V1) + 4, 50);

  Result := V1;

END;

function R_FORMAT(Stt: String): String;
VAR
  V1: String;
  C: word;
  Virgulas: word; // Conta o número de vírgulas... Se tiver mais de um, tira...

BEGIN
  V1 := TrimLeft(TrimRight(Stt));

  If (Pos(' ', V1) = 1) Or (V1 = '') Then
    V1 := '0,00';
  If Pos(V1[1], '.,') <> 0 Then
    V1 := '0' + V1;

  If (V1[1] = '-') AND (Pos(V1[2], '.,') <> 0) Then
    Insert('0', V1, 2);

  { Checando se Tem Letras }
  C := 1;
  Virgulas := 0;
  REPEAT
    If V1[C] = '.' Then
    Begin
      Delete(V1, C, 1);
      Insert(',', V1, C);
      If Length(V1) = 0 Then
        V1 := '0,00';
      Dec(C);
    End;
    If Pos(V1[C], '-1234567890,') = 0 Then
    Begin
      V1 := '0,00';
      C := Length(V1);
    End;
    If V1[C] = ',' Then
      Inc(Virgulas);
    Inc(C);
  UNTIL C > Length(V1);

  If Virgulas > 1 Then
  Begin
    REPEAT
      Delete(V1, Pos(',', V1), 1);
      Dec(Virgulas);
    UNTIL Virgulas = 1;
  End;

  If Pos(',', V1) = 0 Then
    V1 := V1 + ',00';
  If Pos(',', V1) = 1 Then
    V1 := '0' + V1;

  If Length(V1) - Pos(',', V1) = 0 Then
    V1 := V1 + '00';
  If Length(V1) - Pos(',', V1) = 1 Then
    V1 := V1 + '0';
  If Length(V1) - Pos(',', V1) > 2 Then
    Delete(V1, Pos(',', V1) + 3, 50);

  R_FORMAT := V1;

END;

function Is_Number(Numero: String): Boolean; // (Aceita negativo)
VAR
  C: word;
BEGIN

  If Length(Numero) = 0 Then
  Begin
    Result := false;
    Exit;
  End;

  Result := true;
  C := 1;
  REPEAT
    If (Numero[C] = '-') AND (C <> 1) Then
    Begin
      Result := false;
      Exit;
    End;
    If Pos(Numero[C], '-0123456789') = 0 Then
    Begin
      Result := false;
      Exit;
    End;
    Inc(C);
  UNTIL C > Length(Numero);

  If Pos('-', Numero) > 1 Then
    Result := false;

END;

function Float2Money(Valor_Real: Currency): String;
BEGIN

  Float2Money := R_FORMAT(FloatToStr(Valor_Real));

END;

function Float2Money4(Valor_Real: Currency): String;
BEGIN

  Result := R_FORMAT4(FloatToStr(Valor_Real));

END;

function Float2TextEx(Valor: Currency; CasasDecimais: word): String;
VAR
  Menos: Boolean;
  St, Decimais: String;
  Numero: Currency;
  C, i: word;

LABEL RES;
BEGIN

  St := Float2Money4(Valor);

  Menos := false;
  If Pos('-', St) = 1 Then
  Begin
    Menos := true;
    Delete(St, 1, 1);
  End;

  Decimais := Copy(St, Pos(',', St) + 1, 4); // Guardei as casas decimais
  Delete(St, Pos(',', St), 5);

  If CasasDecimais > 0 Then
  Begin

    If CasasDecimais >= 90 Then
    Begin
      Substitua(Decimais, '0', ' ');
      Decimais := Rtrim(Decimais);
      Substitua(Decimais, ' ', '0');
      If Decimais = Replicate('0', Length(Decimais)) Then
        Decimais := '';
      Case CasasDecimais Of
        91:
          If Length(Decimais) = 0 Then
            Decimais := Decimais + '0';
        92:
          If Length(Decimais) < 2 Then
            Decimais := Decimais + Replicate('0', 2 - Length(Decimais));
        93:
          If Length(Decimais) < 3 Then
            Decimais := Decimais + Replicate('0', 3 - Length(Decimais));
      End;

    End
    Else
      Decimais := Copy(Decimais, 1, CasasDecimais);

  End
  Else
    Decimais := '';

  C := Length(St);
  If C <= 3 Then
    Goto RES;

  i := 1;
  REPEAT
    If (i = 3) AND (C > 1) Then
    Begin
      Insert('.', St, C);
      i := 1;
    End
    Else
      Inc(i);
    Dec(C);
  UNTIL C = 0;

RES:
  If Menos Then
    St := '-' + St;

  If Length(Decimais) > 0 Then
    St := St + ',' + Decimais;

  Result := St;

END;

function RemoverMascaras(Texto: string): string;
begin
  Result := Texto;

  Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  Result := StringReplace(Result, '/', '', [rfReplaceAll]);
  Result := StringReplace(Result, '\', '', [rfReplaceAll]);
  Result := StringReplace(Result, '-', '', [rfReplaceAll]);
  Result := StringReplace(Result, '(', '', [rfReplaceAll]);
  Result := StringReplace(Result, ')', '', [rfReplaceAll]);
  Result := StringReplace(Result, ' ', '', [rfReplaceAll]);
  Result := StringReplace(Result, ';', '', [rfReplaceAll]);
  Result := StringReplace(Result, ':', '', [rfReplaceAll]);
  Result := StringReplace(Result, '%', '', [rfReplaceAll]);
end;

function MD5(const texto: string): string;
var
  idmd5: TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  try
    Result := idmd5.HashStringAsHex(texto);
  finally
    idmd5.Free;
  end;

end;

function Str2Num(ValorString: String): LongInt;
BEGIN

  If ValorString = '-' Then
  Begin
    Result := 0;
    Exit;
  End;

  If Not Is_Number(ValorString) Then
    Str2Num := 0
  Else
  Begin
    If (StrToFloat(ValorString) > 2147483647) Or
      (StrToFloat(ValorString) < -2147483647) Then
      Result := 0
    Else
      Str2Num := StrToInt(ValorString);
  End;

END;

function Get_Token : string;
var
  Senha: string;
Begin

  Senha:= GeraSenha(15,False,true);
  Senha := EncodeString(Senha);

  Result := Senha;

End;

function Money2Float(Valor_Monetario: String): Currency;
BEGIN

  Valor_Monetario := RemoveAll('+', Valor_Monetario);

  Money2Float := 0.00;

  Valor_Monetario := Rtrim(Ltrim(Valor_Monetario));
  Valor_Monetario := RemovaZerosAEsquerda(Valor_Monetario);
  Valor_Monetario := R_FORMAT(Valor_Monetario);

  If Length(Valor_Monetario) < 17 Then
    // Para nao ultrapassar o limite de valor FLOAT
    Money2Float := StrToFloat(Valor_Monetario);

END;

end.

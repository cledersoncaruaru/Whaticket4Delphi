unit Functions.Boolean;


interface

uses SysUtils,
  ACBrBase,ACBrValidador;

  Function Is_Number(Numero: String): Boolean;
  Function ValidaDocumento(Documento:String; TpDoc:TACBrValTipoDocto):Boolean;

implementation

Function ValidaDocumento(Documento:String; TpDoc:TACBrValTipoDocto):Boolean;
var
ACBrValidador: TACBrValidador;
begin

   Result  := False;

   ACBrValidador                := TACBrValidador.Create(Nil);
   ACBrValidador.TipoDocto      := TpDoc;
   ACBrValidador.Documento      := Documento;

  try

   if ACBrValidador.Validar then begin

   Result  := True;

   end;

  finally

  ACBrValidador.Free;

  end;


end;


Function Is_Number(Numero: String): Boolean; // (Aceita negativo)
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

end.

unit uCriptografia;

interface

uses

System.SysUtils;


  Type
 TTipoCript = (tcCript, tcDecript);

 Const

 ChaveKey = 'Teste!@#$';


 Function Crypt(Const Action: TTipoCript; Const Texto: String): String;


implementation

Function Crypt(Const Action: TTipoCript; Const Texto: String): String;
Var
 KeyLen, KeyPos, OffSet, SrcPos, SrcAsc, TmpSrcAsc, Range: Integer;
 Dest: String;
Begin
 Result := '';
 If Texto <> '' Then
  Begin
   Dest := '';
   KeyLen := Length(ChaveKey);
   KeyPos := 0;
   Range := 256;
   If (Action = tcCript) Then
    Begin
     Randomize;
     OffSet := Random(Range);
     Dest := Format('%1.2x', [OffSet]);
     For SrcPos := 1 To Length(Texto) Do
      Begin
//       Application.ProcessMessages;
       SrcAsc := (Ord(Texto[SrcPos]) + OffSet) Mod 255;

       If KeyPos < KeyLen Then
        KeyPos := KeyPos + 1
       Else
        KeyPos := 1;

       SrcAsc := SrcAsc Xor Ord(ChaveKey[KeyPos]);
       Dest := Dest + Format('%1.2x', [SrcAsc]);
       OffSet := SrcAsc;
      End;
    End
   Else
    If (Action = tcDecript) Then
    Begin
     OffSet := StrToIntDef('$' + Copy(Texto, 1, 2), 0);
     SrcPos := 3;
     Repeat
      SrcAsc := StrToIntDef('$' + Copy(Texto, SrcPos, 2), 0);

      If (KeyPos < KeyLen) Then
       KeyPos := KeyPos + 1
      Else
       KeyPos := 1;

      TmpSrcAsc := SrcAsc Xor Ord(ChaveKey[KeyPos]);

      If TmpSrcAsc <= OffSet Then
       TmpSrcAsc := 255 + TmpSrcAsc - OffSet
      Else
       TmpSrcAsc := TmpSrcAsc - OffSet;

      Dest := Dest + Chr(TmpSrcAsc);
      OffSet := SrcAsc;
      SrcPos := SrcPos + 2;
     Until (SrcPos >= Length(Texto));
    End;
   Result := Dest;
  End;


end;



end.


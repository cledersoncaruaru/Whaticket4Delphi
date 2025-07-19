unit Functions.IW;

interface
uses

  IWCompEdit,
  IWCompMemo,
  IWAppForm,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Forms,
  IW.Common.AppInfo,
  IWCompListbox,IWCompLabel,RTTI, TypInfo;

  procedure ClearFields(Form: TIWAppForm);
  function Set_Nome_File(Extensao:String; var PathCompleto:String; RemoteJid:String) : String;
  function ValidarCampo(AForm: TComponent; const CampoNome: string; MaxLength: Integer = 0; SomenteSeNaoVazio: Boolean = False): Boolean;


implementation

function ValidarCampo(AForm: TComponent; const CampoNome: string; MaxLength: Integer = 0; SomenteSeNaoVazio: Boolean = False): Boolean;
var
  Comp: TComponent;
  texto: string;
begin
  Result := True;

  Comp := AForm.FindComponent(CampoNome);
  if not Assigned(Comp) then
    Exit(True);

  if Comp is TIWEdit then
    texto := Trim(TIWEdit(Comp).Text)
  else if Comp is TIWMemo then
    texto := Trim(TIWMemo(Comp).Lines.Text)
  else if Comp is TIWComboBox then
    texto := Trim(TIWComboBox(Comp).Text)
  else
    Exit(True);

  if (SomenteSeNaoVazio and (texto = '')) then
    Exit(True);

  if texto = '' then
    Exit(False);

  if (MaxLength > 0) and (Length(texto) > MaxLength) then
    Exit(False);

  Result := True;
end;

Function Set_Nome_File(Extensao:String; var PathCompleto:String; RemoteJid:String) : String;
begin

 Result   := '';

 if not DirectoryExists(TIWAppInfo.GetAppPath+'\wwwroot\Files\Temp\'+RemoteJid) then
        ForceDirectories(TIWAppInfo.GetAppPath+'\wwwroot\Files\Temp\'+RemoteJid);

 PathCompleto  := TIWAppInfo.GetAppPath+'wwwroot\Files\Temp\'+RemoteJid+'\'+FormatDateTime('ddmmyyyy_hhnnsszzz', Now)+Extensao;
 Result        := FormatDateTime('ddmmyyyy_hhnnsszzz', Now)+Extensao;

end;

Procedure ClearFields(Form: TIWAppForm);
Var
I:LongInt;
begin
  for i := 0 to Form.ControlCount - 1 do
    if (Form.Controls[i] is TIWEdit) then
      (Form.Controls[i] as TIWEdit).Text :=''
    else if (Form.Controls[i] is TIWMemo) then
      (Form.Controls[i] as TIWMemo).Text :='';

end;


end.

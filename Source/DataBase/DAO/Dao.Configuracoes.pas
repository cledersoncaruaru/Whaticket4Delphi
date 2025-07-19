unit Dao.Configuracoes;

interface

uses
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  Functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  Entidade.Configuracoes,
  uPopulaCrud;

  function Get_Settings(CompanyId: Longint; var Configuracoes: TConfiguracoes; var vResult: string): Boolean;
  function Set_Settings (Codigo:Longint; Var Configuracoes:TConfiguracoes; var vResult:string):Boolean;




implementation

uses
  FireDAC.Comp.Client, ServerController, System.SysUtils, System.TypInfo;



function Get_Settings(CompanyId: Longint; var Configuracoes: TConfiguracoes; var vResult: string): Boolean;
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
      Qry.SQL.Add('Select "key", value, "createdAt", "updatedAt", "companyId", id ');
      Qry.SQL.Add('from "Settings" s where s."companyId" =:companyId');
      Qry.ParamByName('companyId').AsInteger  := CompanyId;
      Qry.Open;

      if Qry.RecordCount <=0 then
        Exit;
      TPopulateFromQuery<TConfiguracoes>.PopulateFromDataSet(Configuracoes, Qry);

      Result := True;

    except on E: Exception do
      UserSession.DiscordLogger.SendLog('Error','Dao.Configuracoes','Get_Settings', E.Message);
    end;
  finally
    Qry.Free;
  end;

end;

function Set_Settings (Codigo:Longint; Var Configuracoes:TConfiguracoes; var vResult:string):Boolean;
var
  Qry : TFDQuery;
begin

  Result := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;

  try

    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('UPDATE OR INSERT INTO Settings(key,value,createdAt,updatedAt,companyId,id) ');
    Qry.SQL.Add('VALUES (:key:value:createdAt:updatedAt:companyId:id) ');


    Qry.ParamByName('key').AsString                                   := Configuracoes.key;
    Qry.ParamByName('value').AsString                                 := Configuracoes.value;
    Qry.ParamByName('createdAt').AsString                             := Configuracoes.createdAt;
    Qry.ParamByName('updatedAt').AsString                             := Configuracoes.updatedAt;
    Qry.ParamByName('companyId').AsInteger                            := Configuracoes.companyId;
    Qry.ParamByName('id').AsInteger                                   := Configuracoes.id;

   try

     Qry.ExecSQL;
     Result := True;

   except on E: Exception do

   UserSession.DiscordLogger.SendLog('Error','Dao.Settings','Set_Settings', E.Message);

   end;



  finally
    Qry.Free;
  end;
end;

{(DEL)}
{(LIST)}


end.


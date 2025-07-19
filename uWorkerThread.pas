unit uWorkerThread;

interface

uses
  Integracao.API.Evolution,
  SysUtils, Classes,
  IW.Common.Threads,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.VCLUI.Wait,
  Data.DB,
  FireDAC.Comp.Client,
  System.IniFiles,
  FireDAC.Phys.PG,
  Integracao.Discord,
  IW.Common.AppInfo;

type
  TWorkerThread = class(TIWTimedThread)
  strict private
    Conexao       : TFDConnection;
    DRIVER        : TFDPhysPgDriverLink;
    DiscordLogger : TDiscordLogger;
    FQry          : TFDQuery;
    FQryUpd       : TFDQuery;
    EvolutionAPI  : TEvolutionAPI;
    ListaUploads  : TStringList;
  protected
    procedure DoExecute; override;
    Function UpdateSchedules(ID:Integer):Boolean;
  public
    constructor Create(const AName: string; AInterval: Integer); reintroduce;
    destructor Destroy; override;

  end;


implementation

uses
  ActiveX, IW.Common.SysTools;

constructor TWorkerThread.Create(const AName: string; AInterval: Integer);
var
ArquivoINI_Local: TIniFile;
begin
  inherited Create(AName, AInterval);

  DiscordLogger         := TDiscordLogger.Create;
  ArquivoINI_Local      := TIniFile.Create(TIWAppInfo.GetAppPath+'Configuracao.ini');

  Conexao               := TFDConnection.Create(nil);
  Conexao.LoginPrompt   := False;
  DRIVER                := TFDPhysPgDriverLink.Create(Nil);

  FQry                  := TFDQuery.Create(nil);
  FQry.Connection       := Conexao;

  FQryUpd               := TFDQuery.Create(nil);
  FQryUpd.Connection    := Conexao;




  Conexao.Connected   := false;
  Conexao.LoginPrompt := false;
  Conexao.Params.Clear;
  Conexao.Params.Add('Protocol=TCPIP');
  Conexao.Params.Add('Server='   + Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'Server', '127.0.0.1') ));
  Conexao.Params.Add('user_name='+ Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'User_name', 'postegres')));
  Conexao.Params.Add('Password=' + Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'Password', '123456') ));
  Conexao.Params.Add('port='     + Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'Port', '5432')));
  Conexao.Params.Add('Database=' + Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'Database', 'whaticket')));
  Conexao.Params.Add('DriverID=' + Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'DriverID', 'PG')));

  DRIVER.VendorLib              :=  TIWAppInfo.GetAppPath+Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'LibDll', '') );

  EvolutionAPI := TEvolutionAPI.Create(Conexao);
  ListaUploads := TStringList.Create;


   try

    Conexao.Connected  := True;

   except on E: Exception do
    DiscordLogger.SendLog('Error','userSession','IWUserSessionBaseCreate - Conexão Local',E.Message);

   end;

end;

destructor TWorkerThread.Destroy;
begin
    FreeAndNil(Conexao);
    FreeAndNil(DRIVER);
    FreeAndNil(DiscordLogger);
    FreeAndNil(FQry);
    FreeAndNil(FQryUpd);
    FreeAndNil(ListaUploads);
    FreeAndNil(EvolutionAPI);
  inherited;
end;

procedure TWorkerThread.DoExecute;
var
  Json: string;
begin

  try

    //CoInitialize(nil);   para ADO
    Conexao.Connected     := True;

    try

         FQry.SQL.Text :=
      '   SELECT                                                                  ' +
      '    ag.*,                                                                  ' +
      '    ct."number",                                                           ' +
      '    ct."name" as NameContact,                                              ' +
      '    c."name" as NameCompany,                                               ' +
      '    w."name" as NameInstance,                                              ' +
      '    w."session",                                                           ' +
      '    w."token",                                                             ' +
      '    w.apikey                                                               ' +
      '    FROM "Schedules" ag                                                    ' +
      '    LEFT JOIN LATERAL (                                                    ' +
      '    SELECT * FROM "Contacts" ct                                            ' +
      '    WHERE ct.id::text = ANY(string_to_array(ag."contactId"::text, '',''))  ' +
      '    ) ct ON TRUE                                                           ' +
      '    INNER JOIN "Companies" c on ag."companyId" = c.id                      ' +
      '    INNER JOIN "Whatsapps" w on c.id  = w."companyId"                      ' +
      '    WHERE ag."Status" = 5                                                  ' +
      '    AND ag."sendAt"  <= now();                                             ';
          FQry.Open;
          FQry.First;

        except
    on E: Exception do
        begin
          DiscordLogger.SendLog('Error',Self.FName,'DoExecute  : ',E.Message);
          LogFileAppend('Error while executing ' + Self.FName + ': ' + E.Message);
        end;

    end;

      while not FQry.Eof do
      begin

         EvolutionAPI.ApiKey   := FQry.FieldByName('apikey').AsString;

         if Trim(FQry.FieldByName('number').AsString) = '' then begin
            FQry.Next;
            Continue;
         end;


        if EvolutionAPI.Envia(
          Trim(FQry.FieldByName('NameInstance').AsString),
          Trim(FQry.FieldByName('number').AsString),
          Trim(FQry.FieldByName('body').AsString),
          ListaUploads, Json) then
        begin
         UpdateSchedules(FQry.FieldByName('ID').AsInteger);
        end;

        FQry.Next;

      end;

    finally
    FQry.Close;
      //CoUninitialize; Para ADO
    end;



end;


function TWorkerThread.UpdateSchedules(ID: Integer): Boolean;
begin

  Result := False;

  try

     try

      FQryUpd.SQL.Text :=
                   ' update "Schedules" SET "updatedAt" =NOW(), "Status" =:status ' +
                   ' WHERE ID=:ID';
      FQryUpd.ParamByName('status').AsInteger       := 4; //Enviado
      FQryUpd.ParamByName('id').AsInteger           := ID;
      FQryUpd.ExecSQL;

      Result := True;

     except on E: Exception do
       DiscordLogger.SendLog('Error','uWorkerThread','UpdateSchedules',E.Message);
     end;

  finally
   FQryUpd.Close;
  end;

end;

end.


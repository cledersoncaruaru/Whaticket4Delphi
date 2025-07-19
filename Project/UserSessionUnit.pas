unit UserSessionUnit;
{
  This is a DataModule where you can add components or declare fields that are specific to 
  ONE user. Instead of creating global variables, it is better to use this datamodule. You can then
  access the it using UserSession.
}
interface
uses
  IWUserSessionBase,
  Integracao.Discord,
  SysUtils,
  Classes,
  Tipos.Types,
  IW.Common.AppInfo,
  System.Generics.Collections,

  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef,System.IniFiles, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;
type
  TIWUserSession = class(TIWUserSessionBase)
    Conexao: TFDConnection;
    DRIVER: TFDPhysPgDriverLink;
    ConexaoEvolution: TFDConnection;
    Qry: TFDQuery;
    Qryteste: TBlobField;
    procedure IWUserSessionBaseCreate(Sender: TObject);
    procedure IWUserSessionBaseDestroy(Sender: TObject);

  type
  TConfiguracoesINILocal = record
    Servidor : string;
    Usuario  : string;
    Senha    : string;
    Porta    : Integer;
    Driver   : string;
    UseSSL   : Boolean;
    PortaAPI : Integer;
    Database : String;
    LibDll   : String;
  end;


 TConfiguracoesINIEvolution= record
    Servidor : string;
    Usuario  : string;
    Senha    : string;
    Porta    : Integer;
    Driver   : string;
    UseSSL   : Boolean;
    PortaAPI : Integer;
    Database : String;
    LibDll   : String;
  end;



  private
    FID_Cadastro: LongInt;
    FToken: String;
    FChave_PK: String;
    FUserType: TUserType;
    FCompanyId: Integer;
    FContadorUpdate: Integer;
    FInstanceName: String;
    FChatHtmlByContact: TDictionary<string, TStringList>;
    FLastMsgIdByContact: TDictionary<string, string>;
    FIDUser: Integer;
    FCompanyName: String;
    FUsername: String;
    FDueDate: TDateTime;
    FAppName: String;
    FUserEmail: String;
    FSuper: TSuperUser;
    FProfile: TUserType;

    procedure SetID_Cadastro(const Value: LongInt);
    procedure SetToken(const Value: String);
    procedure SetChave_PK(const Value: String);
    procedure SetUserType(const Value: TUserType);
    procedure SetCompanyId(const Value: Integer);
    procedure SetContadorUpdate(const Value: Integer);
    procedure SetInstanceName(const Value: String);
    procedure SetChatHtmlByContact(
      const Value: TDictionary<string, TStringList>);
    procedure SetLastMsgIdByContact(const Value: TDictionary<string, string>);
    procedure SetIDUser(const Value: Integer);
    procedure SetCompanyName(const Value: String);
    procedure SetUsername(const Value: String);
    procedure SetDueDate(const Value: TDateTime);
    procedure SetAppName(const Value: String);
    procedure SetUserEmail(const Value: String);
    procedure SetProfile(const Value: TUserType);
    procedure SetSuper(const Value: TSuperUser);

  public
    { Public declarations }

    DiscordLogger           : TDiscordLogger;

    Property ID_Cadastro    : LongInt read FID_Cadastro write SetID_Cadastro;
    Property Token          : String read FToken write SetToken;
    Property Chave_PK       : String read FChave_PK write SetChave_PK ;
    Property UserType       : TUserType read FUserType write SetUserType;
    Property CompanyId      : Integer read FCompanyId write SetCompanyId;
    Property CompanyName    : String read FCompanyName write SetCompanyName;
    Property ContadorUpdate : Integer read FContadorUpdate write SetContadorUpdate;
    Property InstanceName   : String read FInstanceName write SetInstanceName;
    Property IDUser         : Integer read FIDUser write SetIDUser;
    Property Username       : String read FUsername write SetUsername;
    Property UserEmail      : String read FUserEmail write SetUserEmail;
    property LastMsgIdByContact: TDictionary<string, String> read FLastMsgIdByContact write SetLastMsgIdByContact;
    property ChatHtmlByContact: TDictionary<string, TStringList> read FChatHtmlByContact write SetChatHtmlByContact;
    Property DueDate          : TDateTime read FDueDate write SetDueDate;
    Property AppName          : String read FAppName write SetAppName;
    Property Profile          : TUserType read FProfile write SetProfile;
    Property Super            : TSuperUser read FSuper write SetSuper;


    function LerConfiguracoesINI_Evolution: TConfiguracoesINIEvolution;
    function LerConfiguracoesINI_Local: TConfiguracoesINILocal;



  end;
implementation
{$R *.dfm}


procedure TIWUserSession.IWUserSessionBaseCreate(Sender: TObject);
var
Config_Local      : TConfiguracoesINILocal;
Config_Evolution  : TConfiguracoesINIEvolution;
begin

    DiscordLogger          := TDiscordLogger.Create;
    DiscordLogger.FEmpresa := Clipboard['Loguin_company'].s;
    DiscordLogger.FUsuario := Clipboard['Loguin_email'].s;

    Config_Local          := LerConfiguracoesINI_Local;

    Conexao.Connected   := false;
    Conexao.LoginPrompt := false;
    Conexao.Params.Clear;
    Conexao.Params.Add('Protocol=TCPIP');
    Conexao.Params.Add('Server='+ Config_Local.Servidor);
    Conexao.Params.Add('user_name='+ Config_Local.Usuario);
    Conexao.Params.Add('Password='+ Config_Local.Senha);
    Conexao.Params.Add('port='+ IntToStr(Config_Local.Porta));
    Conexao.Params.Add('Database='+ Config_Local.Database);
    Conexao.Params.Add('DriverID='+ Config_Local.Driver);

    DRIVER.VendorLib                  :=  TIWAppInfo.GetAppPath+Config_Local.LibDll;

     try

       Conexao.Connected  := True;

     except on E: Exception do
      DiscordLogger.SendLog('Error','userSession','IWUserSessionBaseCreate - Conexão Local',E.Message);


     end;


    Config_Evolution             := LerConfiguracoesINI_Evolution;

    ConexaoEvolution.Connected   := false;
    ConexaoEvolution.LoginPrompt := false;
    ConexaoEvolution.Params.Clear;
    ConexaoEvolution.Params.Add('Protocol=TCPIP');
    ConexaoEvolution.Params.Add('Server='+ Config_Evolution.Servidor);
    ConexaoEvolution.Params.Add('user_name='+ Config_Evolution.Usuario);
    ConexaoEvolution.Params.Add('Password='+ Config_Evolution.Senha);
    ConexaoEvolution.Params.Add('port='+ IntToStr(Config_Evolution.Porta));
    ConexaoEvolution.Params.Add('Database='+ Config_Evolution.Database);
    ConexaoEvolution.Params.Add('DriverID='+ Config_Evolution.Driver);

    DRIVER.VendorLib                  :=  TIWAppInfo.GetAppPath+Config_Local.LibDll;

     try

       ConexaoEvolution.Connected  := True;

     except on E: Exception do

       DiscordLogger.SendLog('Error','userSession','IWUserSessionBaseCreate - Conexão Evolution',E.Message);

     end;

  FLastMsgIdByContact := TDictionary<string, String>.Create;
  FChatHtmlByContact  := TDictionary<string, TStringList>.Create;

end;

function TIWUserSession.LerConfiguracoesINI_Local: TConfiguracoesINILocal;
var
  ArquivoINI_Local: TIniFile;
begin

   ArquivoINI_Local      := TIniFile.Create( TIWAppInfo.GetAppPath+'Configuracao.ini');

  try

   try

    Result.Servidor   := Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'Server', '127.0.0.1') );
    Result.Usuario    := Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'User_name', 'postegres'));
    Result.Senha      := Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'Password', '123456') );
    Result.Database   := Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'Database', 'whaticket'));
    Result.Porta      := StrToIntDef(Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'Port', '5432') ), 5432);
    Result.Driver     := Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'DriverID', 'PG'));
    Result.UseSSL     := Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'UseSSL', 'True') ) = 'True';
    Result.PortaAPI   := ArquivoINI_Local.ReadInteger('CONFIG_LOCAL', 'PortaAPI',4001);
    Result.LibDll     := Trim(ArquivoINI_Local.ReadString('CONFIG_LOCAL', 'LibDll', '') );

   except on E: Exception do begin
         DiscordLogger.SendLog('Error','userSession','IWUserSessionBaseCreate - LerConfiguracoesINI_Local',E.Message);
         raise;
         end;
   end;

  finally

  ArquivoINI_Local.Free;
  end;

end;

procedure TIWUserSession.IWUserSessionBaseDestroy(Sender: TObject);
var
  SL: TStringList;
begin

   // libera todas as TStringLists internas
  for SL in FChatHtmlByContact.Values do
    SL.Free;
  FChatHtmlByContact.Free;
  FLastMsgIdByContact.Free;
  DiscordLogger.Free;
end;

function TIWUserSession.LerConfiguracoesINI_Evolution: TConfiguracoesINIEvolution;
var
  ArquivoINI_Evolution: TIniFile;
begin

   ArquivoINI_Evolution      := TIniFile.Create( TIWAppInfo.GetAppPath+'Configuracao.ini');

  try

   try

    Result.Servidor   := Trim(ArquivoINI_Evolution.ReadString('CONFIG_EVOLUTION', 'Server', '127.0.0.1') );
    Result.Usuario    := Trim(ArquivoINI_Evolution.ReadString('CONFIG_EVOLUTION', 'User_name', 'postegres'));
    Result.Senha      := Trim(ArquivoINI_Evolution.ReadString('CONFIG_EVOLUTION', 'Password', '123456') );
    Result.Database   := Trim(ArquivoINI_Evolution.ReadString('CONFIG_EVOLUTION', 'Database', 'whaticket'));
    Result.Porta      := StrToIntDef(Trim(ArquivoINI_Evolution.ReadString('CONFIG_EVOLUTION', 'Port', '5432') ), 5432);
    Result.Driver     := Trim(ArquivoINI_Evolution.ReadString('CONFIG_EVOLUTION', 'DriverID', 'PG'));
    Result.UseSSL     := Trim(ArquivoINI_Evolution.ReadString('CONFIG_EVOLUTION', 'UseSSL', 'True') ) = 'True';
    Result.PortaAPI   := ArquivoINI_Evolution.ReadInteger('CONFIG_EVOLUTION', 'PortaAPI',4001);
    Result.LibDll     := Trim(ArquivoINI_Evolution.ReadString('CONFIG_EVOLUTION', 'LibDll', '') );

   except on E: Exception do begin
      DiscordLogger.SendLog('Error','userSession','IWUserSessionBaseCreate - LerConfiguracoesINI_Evolution',E.Message);
      raise;

     end;
   end;

  finally

  ArquivoINI_Evolution.Free;
  end;
end;

procedure TIWUserSession.SetAppName(const Value: String);
begin
  FAppName := Value;
end;

procedure TIWUserSession.SetChatHtmlByContact(
  const Value: TDictionary<string, TStringList>);
begin
  FChatHtmlByContact := Value;
end;

Procedure TIWUserSession.SetChave_PK(const Value: String);
begin
  FChave_PK := Value;
end;

procedure TIWUserSession.SetCompanyId(const Value: Integer);
begin
  FCompanyId := Value;
end;
procedure TIWUserSession.SetCompanyName(const Value: String);
begin
  FCompanyName := Value;
end;

procedure TIWUserSession.SetContadorUpdate(const Value: Integer);
begin
  FContadorUpdate := Value;
end;

procedure TIWUserSession.SetDueDate(const Value: TDateTime);
begin
  FDueDate := Value;
end;

procedure TIWUserSession.SetIDUser(const Value: Integer);
begin
  FIDUser := Value;
end;

Procedure TIWUserSession.SetID_Cadastro(const Value: LongInt);
begin
  FID_Cadastro := Value;
end;
procedure TIWUserSession.SetInstanceName(const Value: String);
begin
  FInstanceName := Value;
end;

procedure TIWUserSession.SetLastMsgIdByContact(
  const Value: TDictionary<string, String>);
begin
  FLastMsgIdByContact := Value;
end;

procedure TIWUserSession.SetProfile(const Value: TUserType);
begin
  FProfile := Value;
end;

procedure TIWUserSession.SetSuper(const Value: TSuperUser);
begin
  FSuper := Value;
end;

procedure TIWUserSession.SetToken(const Value: String);
begin
  FToken := Value;
end;
procedure TIWUserSession.SetUserEmail(const Value: String);
begin
  FUserEmail := Value;
end;

procedure TIWUserSession.SetUsername(const Value: String);
begin
  FUsername := Value;
end;

procedure TIWUserSession.SetUserType(const Value: TUserType);
begin
  FUserType := Value;
end;


end.
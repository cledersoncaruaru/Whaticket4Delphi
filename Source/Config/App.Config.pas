unit App.Config;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  IW.Common.AppInfo;

type
  TAppConfig = class
  private
    FIni: TIniFile;
    FDescricaoSistema: String;
    // Helpers
    function GetStr(const Section, Ident, Default: string): string;
    function GetInt(const Section, Ident: string; Default: Integer): Integer;
    function GetBool(const Section, Ident: string; Default: Boolean): Boolean;

    // Getters [Geral]
    function GetCodigoInterno: string;
    function GetDominio: string;
    function GetDominioWhats: string;
    function GetViewLogin: Integer;
    function GetUrlRedirect: string;
    function GetVersaoFontes: Integer;

    // Getters [Ambiente]
    function GetModoDesenvolvimento: string;
    function GetHttpBindingsHomolog: string;
    function GetHttpBindings: string;
    function GetHttpsBindings: string;

    // Getters [App]
    function GetAppName: string;
    function GetDescription: string;
    function GetDisplayName: string;
    function GetUpdateTabelas: Boolean;
    function GetLogExcepts: string;
    function GetNomeAplicacao: string;
    function GetVersaoAplicacao: string;
    function GetDateUpdate: string;


    // Getters [Discord]
    function GetDiscordUrl: string;
    function GetDiscordToken: string;

    // Getters [Outros]
    function GetGoogleAnalytics: string;
    function GetNomeSoftHouse: string;
    function GetCNPJSoftHouse: string;
    function GetIntervNotSangria: string;
    function GetWhatsappRenov: string;
    function GetRightReserved: string;
    function GetReservedAno: string;
    function GetNomeSistema: String;
    function GetDescricaoSistema: String;


  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;

    // Properties [Geral]
    property CodigoInterno: string read GetCodigoInterno;
    property Dominio: string read GetDominio;
    property Dominio_ERP: string read GetDominioWhats;
    property ViewLogin: Integer read GetViewLogin;
    property UrlRedirect: string read GetUrlRedirect;
    property VersaoFontes: Integer read GetVersaoFontes;

    // Properties [Ambiente]
    property ModoDesenvolvimento: string read GetModoDesenvolvimento;
    property Config_aHttpBindings_Homologacao: string read GetHttpBindingsHomolog;
    property Config_aHttpBindings: string read GetHttpBindings;
    property Config_aHttpsBindings: string read GetHttpsBindings;

    // Properties [App]
    property AppName: string read GetAppName;
    property Description: string read GetDescription;
    property DisplayName: string read GetDisplayName;
    property UpdateTabelas: Boolean read GetUpdateTabelas;
    property cLogExcepts: string read GetLogExcepts;
    property cNome_Aplicacao: string read GetNomeAplicacao;
    property cVersao_Aplicacao: string read GetVersaoAplicacao;
    property cDateUpdate: string read GetDateUpdate;

    // Properties [Discord]
    property CDiscordUrl: string read GetDiscordUrl;
    property CDiscordToken: string read GetDiscordToken;

    // Properties [Outros]
    property cGoogle_Analitics: string read GetGoogleAnalytics;
    property NomeSoftHouse: string read GetNomeSoftHouse;
    property CNPJSoftHouse: string read GetCNPJSoftHouse;
    property IntervevaloNotificacaoSangria: string read GetIntervNotSangria;
    property Whatsapp_Renovacao: string read GetWhatsappRenov;
    property cRightReserved: string read GetRightReserved;
    property cReserved_Ano: string read GetReservedAno;
    Property NomeSistema:String read GetNomeSistema;
    Property DescricaoSistema : String read GetDescricaoSistema;
  end;

var
  AppConfig: TAppConfig;

implementation

{ TAppConfig }

constructor TAppConfig.Create(const AFileName: string);
begin
  FIni := TIniFile.Create(AFileName);
end;

destructor TAppConfig.Destroy;
begin
  FIni.Free;
  inherited;
end;



function TAppConfig.GetStr(const Section, Ident, Default: string): string;
begin
  Result := FIni.ReadString(Section, Ident, Default);
end;

function TAppConfig.GetInt(const Section, Ident: string; Default: Integer): Integer;
begin
  Result := FIni.ReadInteger(Section, Ident, Default);
end;

function TAppConfig.GetBool(const Section, Ident: string; Default: Boolean): Boolean;
begin
  Result := FIni.ReadBool(Section, Ident, Default);
end;

// [Geral]
function TAppConfig.GetCodigoInterno: string;
begin
  Result := GetStr('Geral', 'CodigoInterno', '00000');
end;

function TAppConfig.GetDominio: string;
begin
  Result := GetStr('Geral', 'Dominio', '');
end;

function TAppConfig.GetDominioWhats: string;
begin
  Result := GetStr('Geral', 'Dominio_ERP', '');
end;


function TAppConfig.GetViewLogin: Integer;
begin
  Result := GetInt('Geral', 'ViewLogin', 1);
end;


function TAppConfig.GetUrlRedirect: string;
begin
  Result := GetStr('Geral', 'UrlRedirect', '');
end;

function TAppConfig.GetVersaoFontes: Integer;
begin
  Result := GetInt('Geral', 'VersaoFontes', 1);
end;

// [Ambiente]
function TAppConfig.GetModoDesenvolvimento: string;
begin
  Result := GetStr('Ambiente', 'ModoDesenvolvimento', 'NÃO');
end;

function TAppConfig.GetHttpBindingsHomolog: string;
begin
  Result := GetStr('Ambiente', 'Config_aHttpBindings_Homologacao', '');
end;

function TAppConfig.GetHttpBindings: string;
begin
  Result := GetStr('Ambiente', 'Config_aHttpBindings', '');
end;

function TAppConfig.GetHttpsBindings: string;
begin
  Result := GetStr('Ambiente', 'Config_aHttpsBindings', '');
end;

// [App]
function TAppConfig.GetAppName: string;
begin
  Result := GetStr('App', 'AppName', '');
end;

function TAppConfig.GetDescricaoSistema: String;
begin
 Result := GetStr('App', 'DescricaoSistema', '');
end;

function TAppConfig.GetDescription: string;
begin
  Result := GetStr('App', 'Description', '');
end;

function TAppConfig.GetDisplayName: string;
begin
  Result := GetStr('App', 'DisplayName', '');
end;

function TAppConfig.GetUpdateTabelas: Boolean;
begin
  Result := GetBool('App', 'UpdateTabelas', False);
end;

function TAppConfig.GetLogExcepts: string;
begin
  Result := GetStr('App', 'cLogExcepts', '');
end;

function TAppConfig.GetNomeAplicacao: string;
begin
  Result := GetStr('App', 'cNome_Aplicacao', '');
end;

function TAppConfig.GetVersaoAplicacao: string;
begin
  Result := GetStr('App', 'cVersao_Aplicacao', '');
end;

function TAppConfig.GetDateUpdate: string;
begin
  Result := GetStr('App', 'cDateUpdate', '');
end;

// [Discord]
function TAppConfig.GetDiscordUrl: string;
begin
  Result := GetStr('Discord', 'CDiscordUrl', '');
end;

function TAppConfig.GetDiscordToken: string;
begin

   {$IFDEF DEBUG}
    Result := GetStr('Discord', 'CDiscordTokenHomolog', '');
   {$ELSE}
   Result := GetStr('Discord', 'CDiscordTokenProduc', '');

   {$ENDIF}
end;


function TAppConfig.GetGoogleAnalytics: string;
begin
  Result := GetStr('Outros', 'cGoogle_Analitics', '');
end;

function TAppConfig.GetNomeSistema: String;
begin
   Result := GetStr('App', 'NomeSistema', '');
end;

function TAppConfig.GetNomeSoftHouse: string;
begin
  Result := GetStr('Outros', 'NomeSoftHouse', '');
end;

function TAppConfig.GetCNPJSoftHouse: string;
begin
  Result := GetStr('Outros', 'CNPJSoftHouse', '');
end;

function TAppConfig.GetIntervNotSangria: string;
begin
  Result := GetStr('Outros', 'IntervevaloNotificacaoSangria', '');
end;

function TAppConfig.GetWhatsappRenov: string;
begin
  Result := GetStr('Outros', 'Whatsapp_Renovacao', '');
end;

function TAppConfig.GetRightReserved: string;
begin
  Result := GetStr('Outros', 'cRightReserved', '');
end;

function TAppConfig.GetReservedAno: string;
begin
  Result := GetStr('Outros', 'cReserved_Ano', '');
end;



initialization
  AppConfig := TAppConfig.Create(TIWAppInfo.GetAppPath + 'Configuracao.ini');

finalization
  AppConfig.Free;

end.


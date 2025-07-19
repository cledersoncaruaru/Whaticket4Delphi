unit Integracao.API.Evolution;

interface

uses

  functions.Strings,
  App.Config,
  System.JSON,
  Integracao.Discord,
  System.Classes,
  System.netEncoding,
  RESTRequest4D,
  System.StrUtils,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  Data.DB,
  System.SysUtils,
  IW.Common.Strings,
  System.IniFiles,
  IW.Common.AppInfo;

  Type

  TEvolutionAPI = class

  DiscordLogger   : TDiscordLogger;

  Constructor Create; overload;
  Constructor Create(ApiKey:String); overload;
  Constructor Create(AConexao: TFDConnection); overload;
  destructor  Destroy; override;

  Var
  LResponse        : IResponse;
  FConexao         : TFDConnection;
  Body             : String;
  ApiKey           : String;
  ArquivoINI_Local : TIniFile;
  BaseUrl          : String;
  GlobalApiKey     : String;
  WebHookURL       : String;


   Private

   Public

    function Set_CriateInstance(InstanceName,Number:String;  var Msg:String):Boolean;
    function DeleteInstance(InstanceName:String;  var Msg:String):Boolean;
    function Status_Conexao(InstanceName:String;  var Status:String):Boolean;
    function Logout_Conexao(InstanceName:String;  var Msg:String):Boolean;
    function Conect_Conexao(InstanceName:String;  var Msg,QrCode,PairingCode:String):Boolean;
    function Envia_Message(InstanceName: String; Numero:String; Msg:String; var Json:String): Boolean;
    function Envia_Media(InstanceName: String; Numero:String; Msg:String; FileName:String; var Json:String): Boolean;
    function Envia_Filas(InstanceName: String; Numero:String; Msg:String): Boolean;
    function Get_ProfileContact(InstanceName, Numero,ApiKey: String; var ProfilePicUrl,ProfileName:String): Boolean;
    function Envia(InstanceName: String; Numero:String; Msg:String; Lista:TStringList; var Json:String): Boolean;
    function StreamToBase64(Stream: TMemoryStream): string;
    function FileToBase64(Arquivo: string): string;
    function LeituraIni:Boolean;
  end;

implementation


function TEvolutionAPI.FileToBase64(Arquivo: string): string;
Var sTream : tMemoryStream;
begin
  if (Trim(Arquivo) <> '') then
  begin
     sTream := TMemoryStream.Create;
     Try
       sTream.LoadFromFile(Arquivo);
       result := StreamToBase64(sTream);
     Finally
       Stream.Free;
       Stream:=nil;
     End;
  end else
     result := '';
end;

function TEvolutionAPI.StreamToBase64(Stream: TMemoryStream): string;
Var Base64 : tBase64Encoding;
begin
  Try
    Stream.Position := 0; {ANDROID 64 e 32 Bits}
//    Stream.Seek(0, 0); {ANDROID 32 Bits}
    Base64 := TBase64Encoding.Create;
    Result := Base64.EncodeBytesToString(sTream.Memory, sTream.Size);
  Finally
    Base64.Free;
    Base64:=nil;
  End;
end;

function TEvolutionAPI.Conect_Conexao(InstanceName: String;
  var Msg,QrCode,PairingCode: String): Boolean;
begin

Result  := False;


  try
      LResponse   := TRequest.New.BaseURL(BaseUrl+'/instance/connect/'+Trim(InstanceName))
      .ContentType('application/json')
      .AddHeader('apikey', globalApikey)
      .Get;

    if LResponse.StatusCode = 200 then begin
       Result        := True;
       Msg           := LResponse.Content;
       QrCode        := LResponse.JSONValue.GetValue<string>('base64');
       PairingCode   := LResponse.JSONValue.GetValue<string>('pairingCode');
    end
    else
    begin
       Msg     := TextToJsonString(LResponse.Content);
       QrCode  := '';
    end;

  except on E: Exception do
    DiscordLogger.SendLog('Criação da Instancia','Integracao.API.Evolution','CreateInstance',LResponse.Content);
  end;

end;

constructor TEvolutionAPI.Create(AConexao: TFDConnection);
begin
FConexao  := AConexao;
LeituraIni;
end;

constructor TEvolutionAPI.Create;
begin

  DiscordLogger   := TDiscordLogger.Create;
  LeituraIni;
end;

function TEvolutionAPI.Set_CriateInstance(InstanceName,Number:String; var Msg:String):Boolean;
begin

 Result  := False;
 Number  := Trim(RemoverMascaras(Number) );



   Var Body :=

 '    {                                                   '+
 '   "instanceName": "'+Trim(InstanceName)+'",            '+
 '   "number": "'+Number+'",                              '+
 '   "qrcode": true,                                      '+
 '   "integration": "WHATSAPP-BAILEYS",                   '+
 '    "groupsIgnore": true,                               '+
 '    "webhook": {                                        '+
 '       "url": "'+WebHookURL+'",                         '+
 '       "byEvents": false,                               '+
 '      "base64": true,                                   '+
 '       "headers": {                                     '+
 '           "autorization": "Bearer TOKEN",              '+
 '           "Content-Type": "application/json"           '+
 '       },                                               '+
 '        "events": [                                     '+
 '            "MESSAGES_SET",                             '+
 '            "MESSAGES_UPSERT"                           '+
 '                                                        '+
 '       ]                                                '+
 '      }                                                 '+
 '    }                                                   ';

    try
        LResponse   := TRequest.New.BaseURL(BaseUrl+'/instance/create')
        .ContentType('application/json')
        .AddHeader('apikey', globalApikey)
        .AddBody(Body)
        .Post;

      if LResponse.StatusCode = 201 then begin
         Result        := True;
         Msg           := LResponse.Content;
      end
      else
      begin
         Msg   := TextToJsonString(LResponse.Content);
      end;


    except on E: Exception do
      DiscordLogger.SendLog('Criação da Instancia','Integracao.API.Evolution','CreateInstance',LResponse.Content);
    end;
end;

function TEvolutionAPI.Status_Conexao(InstanceName: String;
  var Status: String): Boolean;
begin

   Result  := False;

    try
        LResponse   := TRequest.New.BaseURL(BaseUrl+'/instance/connectionState/'+Trim(InstanceName))
        .ContentType('application/json')
        .AddHeader('apikey', globalApikey)
        .Get;


      if LResponse.StatusCode = 200 then begin
         Result  := True;
         Status  := LResponse.JSONValue.GetValue<string>('instance.state');

         if Status = 'open' then begin
            Status := 'Conectado';

         end
         else
         begin
           Status   := 'Desconectado';
         end;

      end
      else
      begin
           Status   := 'Error';
      end;


    except on E: Exception do
      DiscordLogger.SendLog('Criação da Instancia','Integracao.API.Evolution','Status_Conexao',LResponse.Content);
    end;

end;

constructor TEvolutionAPI.Create(ApiKey: String);
begin
   LeituraIni;
   ApiKey   := ApiKey;
end;

function TEvolutionAPI.DeleteInstance(InstanceName: String;
  var Msg: String): Boolean;
begin

    Result  := False;

    Logout_Conexao(InstanceName,Msg);

    try
        LResponse   := TRequest.New.BaseURL(BaseUrl+'/instance/delete/'+Trim(InstanceName))
        .ContentType('application/json')
        .AddHeader('apikey', globalApikey)
        .Delete;

      if LResponse.StatusCode = 200 then begin
         Result  := True;
         Msg     := LResponse.Content;
      end
      else
      begin
         Msg   := TextToJsonString(LResponse.Content);
      end;


    except on E: Exception do
      DiscordLogger.SendLog('Criação da Instancia','Integracao.API.Evolution','Set_DeleteInstance',LResponse.Content);
    end;

end;

destructor TEvolutionAPI.Destroy;
begin
  inherited;
  DiscordLogger.Free;
  ArquivoINI_Local.Free;
end;

function TEvolutionAPI.Envia(InstanceName, Numero, Msg: String;
  Lista: TStringList; var Json: String): Boolean;
  var
  I    :Integer;
begin

   Result := False;

   if Lista.Count >= 1 then begin

    for I := 0 to Lista.Count -1  do
    begin

      Envia_Media(InstanceName,Numero,Msg,Lista.ValueFromIndex[i],Json);

    end;

    Result := True;

   end
   else begin

    Result := Envia_Message(InstanceName,Numero,Msg,Json);

   end;

end;

function TEvolutionAPI.Envia_Filas(InstanceName, Numero, Msg: String): Boolean;
var
 Obj:TJSONObject;
 Jv: TJSONValue;
aResponse:String;
begin
   Obj := nil;
 try

    try

     Result   := False;


     Msg := StringReplace(Msg, '/n ', '', [rfReplaceAll]);
     Msg := StringReplace(Msg, #13#10, '\n', [rfReplaceAll]);


      Body   :=


     '   {                                             '+
     '   "number": "'+Trim(SomenteNumero(Numero))+'",  '+
     '   "text": "'+Trim(Base64Invalids(Msg) )+'"      '+
     '   }                                             ';

      LResponse := TRequest.New.BaseURL(BaseUrl+'/message/sendText/'+Trim(InstanceName))
      .ContentType('application/json')
      .Accept('application/json')
      .AddHeader('apikey',ApiKey)
      .addbody(Body)
      .Post;

      Obj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes( LResponse.Content), 0) as TJSONObject;

      if LResponse.StatusCode in [200,201] then begin

        aResponse    := LResponse.Content;
        Result       := True;
      end else begin

        aResponse    := LResponse.Content;

      end;
   except on E: Exception do

    DiscordLogger.SendLog('Erro-','Integracao.API.Evolution','Envia_Message - Instancia'+InstanceName,e.Message);

   end;

 finally

  Obj.Free;

 end;

end;

function TEvolutionAPI.Envia_Message(InstanceName: String; Numero:String; Msg:String; var Json:String): Boolean;
var
 Obj                : TJSONObject;
 Jv                 : TJSONValue;
aResponse           : String;
begin
   Obj := nil;


 try

    try

     Result   := False;

      Body   :=


     '   {                                             '+
     '   "number": "'+Trim(SomenteNumero(Numero))+'",  '+
     '   "text": "'+Trim(Base64Invalids(Msg) )+'"      '+
     '   }                                             ';

      LResponse := TRequest.New.BaseURL(BaseUrl+'/message/sendText/'+Trim(InstanceName))
      .ContentType('application/json')
      .Accept('application/json')
      .AddHeader('apikey',ApiKey)
      .addbody(Body)
      .Post;

      Obj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes( LResponse.Content), 0) as TJSONObject;

      if LResponse.StatusCode in [200,201] then begin

        aResponse    := LResponse.Content;
        Result       := True;
        Json         := aResponse;
      end else begin

        aResponse    := LResponse.Content;

      end;
    except on E: Exception do

     DiscordLogger.SendLog('Erro-','Integracao.API.Evolution','Envia_Message - Instancia'+InstanceName,e.Message);

    end;

 finally
      Obj.Free;
 end;

end;

function TEvolutionAPI.Envia_Media(InstanceName: String; Numero:String; Msg:String; FileName:String; var Json:String): Boolean;
var
 Obj                : TJSONObject;
 aResponse          : String;
 b64                : String;
 NomeArquivo        : String;
begin
   Obj := nil;

 try

    try

     Result      := False;
     b64         := Base64Invalids( FileToBase64(FileName));
     NomeArquivo := ExtractFileName(FileName);

      Body   :=

     '   {                                                  '+
     '   "number": "'+Trim(SomenteNumero(Numero))+'",       '+
     '   "mediatype": "'+GetMediaTypeClass(FileName)+'",    '+
     '   "mimetype": "'+GetMimeType(FileName)+'",           '+
     '   "caption": "'+Trim(Base64Invalids(Msg) )+'" ,      '+
     '   "media": "'+b64+'",                                '+
     '   "fileName": "'+Trim(NomeArquivo )+'",              '+
     '   "linkPreview": "true",                             '+
     '   "mentionsEveryOne": "false"                        '+
     '   }                                                  ';


      LResponse := TRequest.New.BaseURL(BaseUrl+'/message/sendMedia/'+Trim(InstanceName))
      .ContentType('application/json')
      .Accept('application/json')
      .AddHeader('apikey',ApiKey)
      .addbody(Body)
      .Post;

      Obj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes( LResponse.Content), 0) as TJSONObject;

      if LResponse.StatusCode in [200,201] then begin

        aResponse    := LResponse.Content;
        Result       := True;
        Json         := aResponse;
      end else begin

        aResponse    := LResponse.Content;

      end;

    except on E: Exception do

     DiscordLogger.SendLog('Erro-','Integracao.API.Evolution','Envia_Media - Instancia'+InstanceName,e.Message);

    end;

 finally

  if Assigned(Obj) then
     Obj.Free;

 end;

end;


function TEvolutionAPI.Get_ProfileContact(InstanceName, Numero,ApiKey: String; var ProfilePicUrl,ProfileName:String): Boolean;
var
 Obj          : TJSONObject;
 JsonValue    : TJSONValue;
aResponse     : String;
name,picture  : string;
begin

 Obj := nil;

  try

   try

     Result   := False;

      Body   :=


     '   {                                             '+
     '   "number": "'+Trim(SomenteNumero(Numero))+'"   '+
     '   }                                             ';

      LResponse := TRequest.New.BaseURL(BaseUrl+'/chat/fetchProfilePictureUrl/'+Trim(InstanceName))
      .ContentType('application/json')
      .Accept('application/json')
      .AddHeader('apikey',ApiKey)
      .addbody(Body)
      .Timeout(8000)
      .Post;

      Obj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes( LResponse.Content), 0) as TJSONObject;

      if LResponse.StatusCode in [200,201] then begin

        aResponse    := LResponse.Content;
        if Obj.TryGetValue<string>('profilePictureUrl', picture) then
           ProfilePicUrl   := picture;
        if Obj.TryGetValue<string>('name', name) then
            ProfileName   := name;

      end else begin

        aResponse    := LResponse.Content;

      end;

   except on E: Exception do

    DiscordLogger.SendLog('Erro-','Integracao.API.Evolution','Get_ProfilePicute - Instancia'+InstanceName,e.Message);

   end;

  finally

   Obj.Free;

  end;


end;

function TEvolutionAPI.LeituraIni: Boolean;
begin
  ArquivoINI_Local := TIniFile.Create(TIWAppInfo.GetAppPath +'Configuracao.ini');
  GlobalApiKey     := Trim(ArquivoINI_Local.ReadString('EVOLUTION', 'GlobalApiKey', '') );
  BaseUrl          := Trim(ArquivoINI_Local.ReadString('EVOLUTION', 'BaseUrl', '') );
  WebHookURL       := Trim(ArquivoINI_Local.ReadString('EVOLUTION', 'WebHookURL', '') );
end;

function TEvolutionAPI.Logout_Conexao(InstanceName: String;
  var Msg: String): Boolean;
begin

     Result  := False;


    try
        LResponse   := TRequest.New.BaseURL(BaseUrl+'/instance/logout/'+Trim(InstanceName))
        .ContentType('application/json')
        .AddHeader('apikey', globalApikey)
        .Delete;


      if LResponse.StatusCode = 200 then begin
         Result  := True;
         Msg     := LResponse.Content;
      end
      else
      begin
         Msg   := TextToJsonString(LResponse.Content);
      end;


    except on E: Exception do
      DiscordLogger.SendLog('Criação da Instancia','Integracao.API.Evolution','Logout_Conexao',LResponse.Content);
    end;

end;

end.

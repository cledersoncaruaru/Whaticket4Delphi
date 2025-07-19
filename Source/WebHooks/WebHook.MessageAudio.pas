unit WebHook.MessageAudio;

interface

uses
  System.JSON, Rest.JSON, System.SysUtils, System.Classes;

type

  TContextInfo = class
  public
    entryPointConversionSource: string;
    entryPointConversionApp: string;
    entryPointConversionDelaySeconds: Integer;
  end;

  TDeviceListMetadata = class
  public
    senderKeyHash: string;
    senderTimestamp: string;
    recipientKeyHash: string;
    recipientTimestamp: string;
  end;

  TMessageContextInfo = class
  public
    deviceListMetadata: TDeviceListMetadata;
    deviceListMetadataVersion: Integer;
    messageSecret: string;
  end;

  TAudioMessage = class
  public
    url: string;
    mimetype: string;
    fileSha256: string;
    fileLength: string;
    seconds: Integer;
    ptt: Boolean;
    mediaKey: string;
    fileEncSha256: string;
    directPath: string;
    mediaKeyTimestamp: string;
    contextInfo: TContextInfo;
    waveform: string;
  end;

  TMessage = class
  public
    audioMessage: TAudioMessage;
    messageContextInfo: TMessageContextInfo;
    mediaUrl: string;
  end;

  TKey = class
  public
    remoteJid: string;
    fromMe: Boolean;
    id: string;
  end;

  TDataItem = class
  public
    key: TKey;
    pushName: string;
    status: string;
    message: TMessage;
    contextInfo: TContextInfo;
    messageType: string;
    messageTimestamp: Int64;
    instanceId: string;
    source: string;
  end;

  TWebHookMessageAudio = class
  public
    event: string;
    instance: string;
    data: TDataItem;
    destination: string;
    date_time: string;
    sender: string;
    server_url: string;
    apikey: string;
    constructor CreateFromJSON(const AJSON: string);
    destructor Destroy; override;
  end;

implementation

constructor TWebHookMessageAudio.CreateFromJSON(const AJSON: string);
var
  JSONObject: TJSONObject;
begin
  inherited Create;
  JSONObject := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  if not Assigned(JSONObject) then
    raise Exception.Create('Invalid JSON format');
  try
    TJson.JsonToObject(Self, JSONObject);
  finally
    JSONObject.Free;
  end;
end;

destructor TWebHookMessageAudio.Destroy;
begin
  data.Free;
  inherited;
end;

end.


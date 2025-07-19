unit WebHook.MessageText;

interface

uses
  System.JSON, Rest.JSON, System.SysUtils, System.Classes;

type

  TDeviceListMetadata = class
  public
    senderKeyHash: string;
    senderTimestamp: string;
    senderAccountType: string;
    receiverAccountType: string;
    recipientKeyHash: string;
    recipientTimestamp: string;
  end;

  TMessageContextInfo = class
  public
    deviceListMetadata: TDeviceListMetadata;
    deviceListMetadataVersion: Integer;
    messageSecret: string;
  end;

  TMessage = class
  public
    conversation: string;
    messageContextInfo: TMessageContextInfo;
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
    messageType: string;
    messageTimestamp: Int64;
    instanceId: string;
    source: string;
  end;

  TWebHookMessageText = class
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

{ TWebHookMessageText }

constructor TWebHookMessageText.CreateFromJSON(const AJSON: string);
var
  JSONObject: TJSONObject;
begin
  inherited Create;
  JSONObject := TJSONObject.ParseJSONValue(AJSON) as TJSONObject;
  if JSONObject = nil then
    raise Exception.Create('Invalid JSON format');
  try
    TJson.JsonToObject(Self, JSONObject);
  finally
    JSONObject.Free;
  end;
end;

destructor TWebHookMessageText.Destroy;
begin
  data.Free;
  inherited;
end;

end.


unit WebHook.MessageArquivos;

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

  TDocumentMessage = class
  public
    url: string;
    mimetype: string;
    title: string;
    fileSha256: string;
    fileLength: string;
    mediaKey: string;
    fileName: string;
    fileEncSha256: string;
    directPath: string;
    mediaKeyTimestamp: string;
    caption: string;
    pageCount: Integer;
    contactVcard: Boolean;
  end;

  TMessage = class
  public
    documentMessage: TDocumentMessage;
    messageContextInfo: TMessageContextInfo;
    mediaUrl: string;
    base64: string;
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
    contextInfo: TObject;
    messageType: string;
    messageTimestamp: Int64;
    instanceId: string;
    source: string;
  end;

  TWebHookMessageArquivos = class
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

constructor TWebHookMessageArquivos.CreateFromJSON(const AJSON: string);
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

destructor TWebHookMessageArquivos.Destroy;
begin
  data.Free;
  inherited;
end;

end.


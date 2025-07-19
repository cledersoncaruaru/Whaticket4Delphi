unit WebHook.MessageProfileUpdate;

interface

uses
  System.JSON, System.SysUtils, System.Classes, System.Generics.Collections;

type

  TContactData = class
  public
    remoteJid: string;
    profilePicUrl: string;
    instanceId: string;
  end;

  TBody = class
  public
    event: string;
    instance: string;
    data: TList<TContactData>;
    destination: string;
    date_time: string;
    sender: string;
    server_url: string;
    apikey: string;
    constructor Create;
    destructor Destroy; override;
  end;

  TWebHookContactsUpdate = class
  public
    headers: TJSONObject;
    params: TJSONObject;
    query: TJSONObject;
    body: TBody;
    webhookUrl: string;
    executionMode: string;
    constructor CreateFromJSON(const AJSON: string);
    destructor Destroy; override;
  end;

implementation

{ TBody }

constructor TBody.Create;
begin
  inherited Create;
  data := TList<TContactData>.Create;
end;

destructor TBody.Destroy;
var
  Contact: TContactData;
begin
  for Contact in data do
    Contact.Free;
  data.Free;
  inherited;
end;

{ TWebHookContactsUpdate }

constructor TWebHookContactsUpdate.CreateFromJSON(const AJSON: string);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  JSONValue: TJSONValue;
  BodyObj, ContactObj: TJSONObject;
  DataArray: TJSONArray;
  I: Integer;
  ContactDataItem: TContactData;
begin
  inherited Create;

  headers := TJSONObject.Create;
  params  := TJSONObject.Create;
  query   := TJSONObject.Create;
  body    := TBody.Create;

  JSONArray := TJSONObject.ParseJSONValue(AJSON) as TJSONArray;
  if JSONArray = nil then
    raise Exception.Create('Invalid JSON format');
  try
    if JSONArray.Count > 0 then
    begin
      JSONObject := JSONArray.Items[0] as TJSONObject;

      JSONValue := JSONObject.Values['headers'];
      if JSONValue is TJSONObject then
        headers := TJSONObject(JSONValue.Clone as TJSONObject);

      JSONValue := JSONObject.Values['params'];
      if JSONValue is TJSONObject then
        params := TJSONObject(JSONValue.Clone as TJSONObject);

      JSONValue := JSONObject.Values['query'];
      if JSONValue is TJSONObject then
        query := TJSONObject(JSONValue.Clone as TJSONObject);

      JSONValue := JSONObject.Values['webhookUrl'];
      if JSONValue is TJSONString then
        webhookUrl := JSONValue.Value;

      JSONValue := JSONObject.Values['executionMode'];
      if JSONValue is TJSONString then
        executionMode := JSONValue.Value;

      JSONValue := JSONObject.Values['body'];
      if JSONValue is TJSONObject then
      begin
        BodyObj := TJSONObject(JSONValue);

        JSONValue := BodyObj.Values['event'];
        if JSONValue is TJSONString then
          body.event := JSONValue.Value;

        JSONValue := BodyObj.Values['instance'];
        if JSONValue is TJSONString then
          body.instance := JSONValue.Value;

        JSONValue := BodyObj.Values['data'];
        if JSONValue is TJSONArray then
        begin
          DataArray := TJSONArray(JSONValue);
          for I := 0 to DataArray.Count - 1 do
          begin
            JSONValue := DataArray.Items[I];
            if JSONValue is TJSONObject then
            begin
              ContactObj := TJSONObject(JSONValue);
              ContactDataItem := TContactData.Create;

              JSONValue := ContactObj.Values['remoteJid'];
              if JSONValue is TJSONString then
                ContactDataItem.remoteJid := JSONValue.Value;

              JSONValue := ContactObj.Values['profilePicUrl'];
              if JSONValue is TJSONString then
                ContactDataItem.profilePicUrl := JSONValue.Value;

              JSONValue := ContactObj.Values['instanceId'];
              if JSONValue is TJSONString then
                ContactDataItem.instanceId := JSONValue.Value;

              body.data.Add(ContactDataItem);
            end;
          end;
        end;

        JSONValue := BodyObj.Values['destination'];
        if JSONValue is TJSONString then
          body.destination := JSONValue.Value;

        JSONValue := BodyObj.Values['date_time'];
        if JSONValue is TJSONString then
          body.date_time := JSONValue.Value;

        JSONValue := BodyObj.Values['sender'];
        if JSONValue is TJSONString then
          body.sender := JSONValue.Value;

        JSONValue := BodyObj.Values['server_url'];
        if JSONValue is TJSONString then
          body.server_url := JSONValue.Value;

        JSONValue := BodyObj.Values['apikey'];
        if JSONValue is TJSONString then
          body.apikey := JSONValue.Value;
      end;
    end
    else
      raise Exception.Create('JSON array is empty');
  finally
    JSONArray.Free;
  end;
end;

destructor TWebHookContactsUpdate.Destroy;
begin
  headers.Free;
  params.Free;
  query.Free;
  body.Free;
  inherited;
end;

end.


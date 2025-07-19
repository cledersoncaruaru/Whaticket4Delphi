unit Integracao.Evolution.CreateInstance;

interface

uses
  System.JSON, System.Rtti, System.SysUtils, System.TypInfo;

type
  TInstance = class
  public
    InstanceName: string;
    InstanceId: string;
    Integration: string;
    WebhookWaBusiness: string;
    AccessTokenWaBusiness: string;
    Status: string;
  end;

  TWebhookConfig = class(TObject)
  public

  end;

  TWebSocketConfig = class(TObject)
  public

  end;

  TRabbitMQConfig = class(TObject)
  public

  end;

  TSQSConfig = class(TObject)
  public

  end;

  TSettings = class
  public
    RejectCall: Boolean;
    MsgCall: string;
    GroupsIgnore: Boolean;
    AlwaysOnline: Boolean;
    ReadMessages: Boolean;
    ReadStatus: Boolean;
    SyncFullHistory: Boolean;
    WavoipToken: string;
  end;

  TQRCode = class
  public
    PairingCode: string;
    Code: string;
    Base64: string;
    Count: Integer;
  end;

  TIntegracaoEvolution = class
  public
    Instance: TInstance;
    Hash: string;
    Webhook: TWebhookConfig;
    Websocket: TWebSocketConfig;
    Rabbitmq: TRabbitMQConfig;
    Sqs: TSQSConfig;
    Settings: TSettings;
    QRCode: TQRCode;
    constructor Create;
    destructor Destroy; override;
  end;

  TCreateInstanceHelper = class
  public

  end;

implementation

{ TIntegracaoEvolution }

constructor TIntegracaoEvolution.Create;
begin
  inherited;
  Instance   := TInstance.Create;
  Webhook    := TWebhookConfig.Create;
  Websocket  := TWebSocketConfig.Create;
  Rabbitmq   := TRabbitMQConfig.Create;
  Sqs        := TSQSConfig.Create;
  Settings   := TSettings.Create;
  QRCode     := TQRCode.Create;
end;

destructor TIntegracaoEvolution.Destroy;
begin
  Instance.Free;
  Webhook.Free;
  Websocket.Free;
  Rabbitmq.Free;
  Sqs.Free;
  Settings.Free;
  QRCode.Free;
  inherited;
end;

{ TCreateInstanceHelper }


end.


unit Entidade.Conexao;

interface

uses

ServerController,
System.SysUtils,System.Generics.Collections, System.Classes,

FireDAC.Stan.Intf, FireDAC.Stan.Option,FireDAC.Comp.Client,
FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
Data.DB,FireDAC.Stan.Param, FireDAC.DatS,
FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Phys.FBDef,
FireDAC.Phys.IBBase, FireDAC.Phys.FB;


type

  TConexao = class
  private
    FfacebookPageUserId: String;
    Fname: String;
    Fbattery: String;
    FrestrictToQueues: Boolean;
    Fprovider: String;
    FfacebookUserId: String;
    Fapikey: String;
    FfacebookUserToken: String;
    FoutOfHoursMessage: String;
    FcomplationMessage: String;
    FtransferToNewTicket: Boolean;
    FisDefault: Boolean;
    Fchannel: String;
    FtokenMeta: String;
    Fplugged: Boolean;
    Fid: LongInt;
    FtransferMessage: String;
    Ftoken: String;
    Fstatus: String;
    Fnumber: String;
    FgreetingMessage: String;
    FfarewellMessage: String;
    FratingMessage: String;
    Fqrcode: String;
    FcompanyId: LongInt;
    FproxyConfig: String;
    Fsession: String;
    FupdatedAt: TDateTime;
    FcreatedAt: TDateTime;
    Fretries: LongInt;
    Finstanceid: String;
    Fintegration: String;
    Fqueueid: Integer;
    procedure Setapikey(const Value: String);
    procedure Setbattery(const Value: String);
    procedure Setchannel(const Value: String);
    procedure SetcompanyId(const Value: LongInt);
    procedure SetcomplationMessage(const Value: String);
    procedure SetfacebookPageUserId(const Value: String);
    procedure SetfacebookUserId(const Value: String);
    procedure SetfacebookUserToken(const Value: String);
    procedure SetfarewellMessage(const Value: String);
    procedure SetgreetingMessage(const Value: String);
    procedure Setid(const Value: LongInt);
    procedure SetisDefault(const Value: Boolean);
    procedure Setname(const Value: String);
    procedure Setnumber(const Value: String);
    procedure SetoutOfHoursMessage(const Value: String);
    procedure Setplugged(const Value: Boolean);
    procedure Setprovider(const Value: String);
    procedure SetproxyConfig(const Value: String);
    procedure Setqrcode(const Value: String);
    procedure SetratingMessage(const Value: String);
    procedure SetrestrictToQueues(const Value: Boolean);
    procedure Setsession(const Value: String);
    procedure Setstatus(const Value: String);
    procedure Settoken(const Value: String);
    procedure SettokenMeta(const Value: String);
    procedure SettransferMessage(const Value: String);
    procedure SettransferToNewTicket(const Value: Boolean);
    procedure SetcreatedAt(const Value: TDateTime);
    procedure SetupdatedAt(const Value: TDateTime);
    procedure Setretries(const Value: LongInt);
    procedure Setinstanceid(const Value: String);
    procedure Setintegration(const Value: String);
    procedure Setqueueid(const Value: Integer);





{ private declarations }
protected
 { protected declarations }
Public

      Property id : LongInt read Fid write Setid;
      Property session : String read Fsession write Setsession;
      Property qrcode : String read Fqrcode write Setqrcode;
      Property status : String read Fstatus write Setstatus;
      Property battery : String read Fbattery write Setbattery;
      Property plugged : Boolean read Fplugged write Setplugged;
      Property createdAt : TDateTime read FcreatedAt write SetcreatedAt;
      Property updatedAt : TDateTime read FupdatedAt write SetupdatedAt;
      Property name : String read Fname write Setname;
      Property isDefault : Boolean read FisDefault write SetisDefault;
      Property retries  : LongInt read Fretries write Setretries;
      Property greetingMessage : String read FgreetingMessage write SetgreetingMessage;
      Property companyId : LongInt read FcompanyId write SetcompanyId;
      Property complationMessage : String read FcomplationMessage write SetcomplationMessage;
      Property outOfHoursMessage : String read FoutOfHoursMessage write SetoutOfHoursMessage;
      Property ratingMessage : String read FratingMessage write SetratingMessage;
      Property token : String read Ftoken write Settoken;
      Property farewellMessage : String read FfarewellMessage write SetfarewellMessage;
      Property provider : String read Fprovider write Setprovider;
      Property channel : String read Fchannel write Setchannel;
      Property facebookUserToken : String read FfacebookUserToken write SetfacebookUserToken;
      Property tokenMeta : String read FtokenMeta write SettokenMeta;
      Property facebookPageUserId : String read FfacebookPageUserId write SetfacebookPageUserId;
      Property facebookUserId : String read FfacebookUserId write SetfacebookUserId;
      Property transferMessage : String read FtransferMessage write SettransferMessage;
      Property restrictToQueues : Boolean read FrestrictToQueues write SetrestrictToQueues;
      Property transferToNewTicket : Boolean read FtransferToNewTicket write SettransferToNewTicket;
      Property proxyConfig : String read FproxyConfig write SetproxyConfig;
      Property apikey : String read Fapikey write Setapikey;
      Property number : String read Fnumber write Setnumber;
      Property instanceid : String read Finstanceid write Setinstanceid;
      Property integration:String read Fintegration write Setintegration;
      Property queueid    : Integer read Fqueueid write Setqueueid;


 { public declarations }
published
{ published declarations }

  end;

implementation


{ TConexao }

procedure TConexao.Setapikey(const Value: String);
begin
  Fapikey := Value;
end;

procedure TConexao.Setbattery(const Value: String);
begin
  Fbattery := Value;
end;

procedure TConexao.Setchannel(const Value: String);
begin
  Fchannel := Value;
end;

procedure TConexao.SetcompanyId(const Value: LongInt);
begin
  FcompanyId := Value;
end;

procedure TConexao.SetcomplationMessage(const Value: String);
begin
  FcomplationMessage := Value;
end;

procedure TConexao.SetcreatedAt(const Value: TDateTime);
begin
  FcreatedAt := Value;
end;

procedure TConexao.SetfacebookPageUserId(const Value: String);
begin
  FfacebookPageUserId := Value;
end;

procedure TConexao.SetfacebookUserId(const Value: String);
begin
  FfacebookUserId := Value;
end;

procedure TConexao.SetfacebookUserToken(const Value: String);
begin
  FfacebookUserToken := Value;
end;

procedure TConexao.SetfarewellMessage(const Value: String);
begin
  FfarewellMessage := Value;
end;

procedure TConexao.SetgreetingMessage(const Value: String);
begin
  FgreetingMessage := Value;
end;

procedure TConexao.Setid(const Value: LongInt);
begin
  Fid := Value;
end;

procedure TConexao.Setinstanceid(const Value: String);
begin
  Finstanceid := Value;
end;

procedure TConexao.Setintegration(const Value: String);
begin
  Fintegration := Value;
end;

procedure TConexao.SetisDefault(const Value: Boolean);
begin
  FisDefault := Value;
end;

procedure TConexao.Setname(const Value: String);
begin
  Fname := Value;
end;

procedure TConexao.Setnumber(const Value: String);
begin
  Fnumber := Value;
end;

procedure TConexao.SetoutOfHoursMessage(const Value: String);
begin
  FoutOfHoursMessage := Value;
end;

procedure TConexao.Setplugged(const Value: Boolean);
begin
  Fplugged := Value;
end;

procedure TConexao.Setprovider(const Value: String);
begin
  Fprovider := Value;
end;

procedure TConexao.SetproxyConfig(const Value: String);
begin
  FproxyConfig := Value;
end;

procedure TConexao.Setqrcode(const Value: String);
begin
  Fqrcode := Value;
end;

procedure TConexao.Setqueueid(const Value: Integer);
begin
  Fqueueid := Value;
end;

procedure TConexao.SetratingMessage(const Value: String);
begin
  FratingMessage := Value;
end;

procedure TConexao.SetrestrictToQueues(const Value: Boolean);
begin
  FrestrictToQueues := Value;
end;

procedure TConexao.Setretries(const Value: LongInt);
begin
  Fretries := Value;
end;

procedure TConexao.Setsession(const Value: String);
begin
  Fsession := Value;
end;

procedure TConexao.Setstatus(const Value: String);
begin
  Fstatus := Value;
end;

procedure TConexao.Settoken(const Value: String);
begin
  Ftoken := Value;
end;

procedure TConexao.SettokenMeta(const Value: String);
begin
  FtokenMeta := Value;
end;

procedure TConexao.SettransferMessage(const Value: String);
begin
  FtransferMessage := Value;
end;

procedure TConexao.SettransferToNewTicket(const Value: Boolean);
begin
  FtransferToNewTicket := Value;
end;

procedure TConexao.SetupdatedAt(const Value: TDateTime);
begin
  FupdatedAt := Value;
end;

end.


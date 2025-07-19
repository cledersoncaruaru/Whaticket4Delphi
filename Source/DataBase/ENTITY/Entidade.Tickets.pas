unit Entidade.Tickets;

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

  TTickets = class
  private

    Fid: LongInt;
    FStatus: string;   {TWideStringField}
    FLastmessage: string;   {TWideMemoField}
    FContactid: LongInt;
    FUserid: LongInt;
    FCreatedat: TDateTime;   {TSQLTimeStampOffsetField}
    FUpdatedat: TDateTime;   {TSQLTimeStampOffsetField}
    FWhatsappid: LongInt;
    FUnreadmessages: LongInt;
    FQueueid: LongInt;
    FCompanyid: LongInt;
    FUuid: string;   {TGuidField}
    FChatbot: Boolean;   {TBooleanField}
    FQueueoptionid: LongInt;
    FChannel: string;
    FIsgroup: Boolean;   {TWideMemoField}

    Procedure Setid(const Value: LongInt);
    Procedure SetStatus(const Value: string);
    Procedure SetLastmessage(const Value: string);
    Procedure SetContactid(const Value: LongInt);
    Procedure SetUserid(const Value: LongInt);
    Procedure SetCreatedat(const Value: TDateTime);
    Procedure SetUpdatedat(const Value: TDateTime);
    Procedure SetWhatsappid(const Value: LongInt);
    Procedure SetUnreadmessages(const Value: LongInt);
    Procedure SetQueueid(const Value: LongInt);
    Procedure SetCompanyid(const Value: LongInt);
    Procedure SetUuid(const Value: string);
    Procedure SetChatbot(const Value: Boolean);
    Procedure SetQueueoptionid(const Value: LongInt);
    Procedure SetChannel(const Value: string);
    procedure SetIsgroup(const Value: Boolean);


{ private declarations }
protected
 { protected declarations }
Public

      Property id: LongInt read Fid write Setid;
      Property Status: string read FStatus write SetStatus;
      Property Lastmessage: string read FLastmessage write SetLastmessage;
      Property Contactid: LongInt read FContactid write SetContactid;
      Property Userid: LongInt read FUserid write SetUserid;
      Property Createdat: TDateTime read FCreatedat write SetCreatedat;
      Property Updatedat: TDateTime read FUpdatedat write SetUpdatedat;
      Property Whatsappid: LongInt read FWhatsappid write SetWhatsappid;
      Property Isgroup: Boolean read FIsgroup write SetIsgroup;
      Property Unreadmessages: LongInt read FUnreadmessages write SetUnreadmessages;
      Property Queueid: LongInt read FQueueid write SetQueueid;
      Property Companyid: LongInt read FCompanyid write SetCompanyid;
      Property Uuid: string read FUuid write SetUuid;
      Property Chatbot: Boolean read FChatbot write SetChatbot;
      Property Queueoptionid: LongInt read FQueueoptionid write SetQueueoptionid;
      Property Channel: string read FChannel write SetChannel;


 { public declarations }
published
{ published declarations }

  end;

implementation



 { TTickets}
Procedure TTickets.Setid(const Value: LongInt);
begin
  Fid  := Value;
end;


procedure TTickets.SetIsgroup(const Value: Boolean);
begin
  FIsgroup := Value;
end;

Procedure TTickets.SetStatus(const Value: string);
begin
  FStatus  := Value;
end;


Procedure TTickets.SetLastmessage(const Value: string);
begin
  FLastmessage  := Value;
end;


Procedure TTickets.SetContactid(const Value: LongInt);
begin
  FContactid  := Value;
end;


Procedure TTickets.SetUserid(const Value: LongInt);
begin
  FUserid  := Value;
end;


Procedure TTickets.SetCreatedat(const Value: TDateTime);
begin
  FCreatedat  := Value;
end;


Procedure TTickets.SetUpdatedat(const Value: TDateTime);
begin
  FUpdatedat  := Value;
end;


Procedure TTickets.SetWhatsappid(const Value: LongInt);
begin
  FWhatsappid  := Value;
end;

Procedure TTickets.SetUnreadmessages(const Value: LongInt);
begin
  FUnreadmessages  := Value;
end;


Procedure TTickets.SetQueueid(const Value: LongInt);
begin
  FQueueid  := Value;
end;


Procedure TTickets.SetCompanyid(const Value: LongInt);
begin
  FCompanyid  := Value;
end;


Procedure TTickets.SetUuid(const Value: string);
begin
  FUuid  := Value;
end;


Procedure TTickets.SetChatbot(const Value: Boolean);
begin
  FChatbot  := Value;
end;


Procedure TTickets.SetQueueoptionid(const Value: LongInt);
begin
  FQueueoptionid  := Value;
end;


Procedure TTickets.SetChannel(const Value: string);
begin
  FChannel  := Value;
end;


end.


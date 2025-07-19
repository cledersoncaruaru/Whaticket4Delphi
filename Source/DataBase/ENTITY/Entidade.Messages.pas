unit Entidade.Messages;

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

  TMessages = class
  private

    Fid: string;   {TWideStringField}
    FBody: string;   {TWideMemoField}
    FAck: LongInt;
    FRead: string;   {TBooleanField}
    FMediatype: string;   {TWideStringField}
    FMediaurl: string;   {TWideStringField}
    FTicketid: LongInt;
    FCreatedat: string;   {TSQLTimeStampOffsetField}
    FUpdatedat: string;   {TSQLTimeStampOffsetField}
    FFromme: string;   {TBooleanField}
    FIsdeleted: string;   {TBooleanField}
    FContactid: LongInt;
    FQuotedmsgid: string;   {TWideStringField}
    FCompanyid: LongInt;
    FRemotejid: string;   {TWideMemoField}
    FDatajson: string;   {TWideMemoField}
    FParticipant: string;   {TWideMemoField}
    FQueueid: LongInt;

    Procedure Setid(const Value: string);
    Procedure SetBody(const Value: string);
    Procedure SetAck(const Value: LongInt);
    Procedure SetRead(const Value: string);
    Procedure SetMediatype(const Value: string);
    Procedure SetMediaurl(const Value: string);
    Procedure SetTicketid(const Value: LongInt);
    Procedure SetCreatedat(const Value: string);
    Procedure SetUpdatedat(const Value: string);
    Procedure SetFromme(const Value: string);
    Procedure SetIsdeleted(const Value: string);
    Procedure SetContactid(const Value: LongInt);
    Procedure SetQuotedmsgid(const Value: string);
    Procedure SetCompanyid(const Value: LongInt);
    Procedure SetRemotejid(const Value: string);
    Procedure SetDatajson(const Value: string);
    Procedure SetParticipant(const Value: string);
    Procedure SetQueueid(const Value: LongInt);


{ private declarations }
protected
 { protected declarations }
Public

      Property id: string read Fid write Setid;
      Property Body: string read FBody write SetBody;
      Property Ack: LongInt read FAck write SetAck;
      Property Read: string read FRead write SetRead;
      Property Mediatype: string read FMediatype write SetMediatype;
      Property Mediaurl: string read FMediaurl write SetMediaurl;
      Property Ticketid: LongInt read FTicketid write SetTicketid;
      Property Createdat: string read FCreatedat write SetCreatedat;
      Property Updatedat: string read FUpdatedat write SetUpdatedat;
      Property Fromme: string read FFromme write SetFromme;
      Property Isdeleted: string read FIsdeleted write SetIsdeleted;
      Property Contactid: LongInt read FContactid write SetContactid;
      Property Quotedmsgid: string read FQuotedmsgid write SetQuotedmsgid;
      Property Companyid: LongInt read FCompanyid write SetCompanyid;
      Property Remotejid: string read FRemotejid write SetRemotejid;
      Property Datajson: string read FDatajson write SetDatajson;
      Property Participant: string read FParticipant write SetParticipant;
      Property Queueid: LongInt read FQueueid write SetQueueid;


 { public declarations }
published
{ published declarations }

  end;

implementation



 { TMessages}
Procedure TMessages.Setid(const Value: string);
begin
  Fid  := Value;
end;


Procedure TMessages.SetBody(const Value: string);
begin
  FBody  := Value;
end;


Procedure TMessages.SetAck(const Value: LongInt);
begin
  FAck  := Value;
end;


Procedure TMessages.SetRead(const Value: string);
begin
  FRead  := Value;
end;


Procedure TMessages.SetMediatype(const Value: string);
begin
  FMediatype  := Value;
end;


Procedure TMessages.SetMediaurl(const Value: string);
begin
  FMediaurl  := Value;
end;


Procedure TMessages.SetTicketid(const Value: LongInt);
begin
  FTicketid  := Value;
end;


Procedure TMessages.SetCreatedat(const Value: string);
begin
  FCreatedat  := Value;
end;


Procedure TMessages.SetUpdatedat(const Value: string);
begin
  FUpdatedat  := Value;
end;


Procedure TMessages.SetFromme(const Value: string);
begin
  FFromme  := Value;
end;


Procedure TMessages.SetIsdeleted(const Value: string);
begin
  FIsdeleted  := Value;
end;


Procedure TMessages.SetContactid(const Value: LongInt);
begin
  FContactid  := Value;
end;


Procedure TMessages.SetQuotedmsgid(const Value: string);
begin
  FQuotedmsgid  := Value;
end;


Procedure TMessages.SetCompanyid(const Value: LongInt);
begin
  FCompanyid  := Value;
end;


Procedure TMessages.SetRemotejid(const Value: string);
begin
  FRemotejid  := Value;
end;


Procedure TMessages.SetDatajson(const Value: string);
begin
  FDatajson  := Value;
end;


Procedure TMessages.SetParticipant(const Value: string);
begin
  FParticipant  := Value;
end;


Procedure TMessages.SetQueueid(const Value: LongInt);
begin
  FQueueid  := Value;
end;


end.


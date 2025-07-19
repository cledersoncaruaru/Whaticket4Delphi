unit Entidade.Usuarios;

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

  TUsuarios = class
  private

    Fid: LongInt;
    FName: string;   {TWideStringField}
    FEmail: string;   {TWideStringField}
    FPasswordhash: string;   {TWideStringField}
    FProfile: string;   {TWideStringField}
    FTokenversion: LongInt;
    FCompanyid: LongInt;
    FUpdatedat: TDateTime;
    FCreatedat: TDateTime;
    FSuper: Boolean;
    FOnline: Boolean;   {TBooleanField}

    Procedure Setid(const Value: LongInt);
    Procedure SetName(const Value: string);
    Procedure SetEmail(const Value: string);
    Procedure SetPasswordhash(const Value: string);
    Procedure SetProfile(const Value: string);
    Procedure SetTokenversion(const Value: LongInt);
    Procedure SetCompanyid(const Value: LongInt);
    procedure SetCreatedat(const Value: TDateTime);
    procedure SetUpdatedat(const Value: TDateTime);
    procedure SetOnline(const Value: Boolean);
    procedure SetSuper(const Value: Boolean);


{ private declarations }
protected
 { protected declarations }
Public

      Property id: LongInt read Fid write Setid;
      Property Name: string read FName write SetName;
      Property Email: string read FEmail write SetEmail;
      Property Passwordhash: string read FPasswordhash write SetPasswordhash;
      Property Createdat: TDateTime read FCreatedat write SetCreatedat;
      Property Updatedat: TDateTime read FUpdatedat write SetUpdatedat;
      Property Profile: string read FProfile write SetProfile;
      Property Tokenversion: LongInt read FTokenversion write SetTokenversion;
      Property Companyid: LongInt read FCompanyid write SetCompanyid;
      Property Super: Boolean read FSuper write SetSuper;
      Property Online: Boolean read FOnline write SetOnline;


 { public declarations }
published
{ published declarations }

  end;

implementation



 { TUsers}
Procedure TUsuarios.Setid(const Value: LongInt);
begin
  Fid  := Value;
end;


Procedure TUsuarios.SetName(const Value: string);
begin
  FName  := Value;
end;


procedure TUsuarios.SetOnline(const Value: Boolean);
begin
  FOnline := Value;
end;

procedure TUsuarios.SetCreatedat(const Value: TDateTime);
begin
  FCreatedat := Value;
end;

Procedure TUsuarios.SetEmail(const Value: string);
begin
  FEmail  := Value;
end;

Procedure TUsuarios.SetPasswordhash(const Value: string);
begin
  FPasswordhash  := Value;
end;

Procedure TUsuarios.SetProfile(const Value: string);
begin
  FProfile  := Value;
end;


procedure TUsuarios.SetSuper(const Value: Boolean);
begin
  FSuper := Value;
end;

Procedure TUsuarios.SetTokenversion(const Value: LongInt);
begin
  FTokenversion  := Value;
end;


procedure TUsuarios.SetUpdatedat(const Value: TDateTime);
begin
  FUpdatedat := Value;
end;

Procedure TUsuarios.SetCompanyid(const Value: LongInt);
begin
  FCompanyid  := Value;
end;



end.


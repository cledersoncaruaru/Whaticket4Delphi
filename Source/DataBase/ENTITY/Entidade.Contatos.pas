unit Entidade.Contatos;

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

  TContatos = class
  private
    Femail: String;
    Fchannel: String;
    FupdatedAt: TDateTime;
    FprofileHiresPictureUrl: String;
    FprofilePicUrl: String;
    FdisableBot: Boolean;
    Fnumber: String;
    FcreatedAt: TDateTime;
    FisGroup: Boolean;
    FcompanyId: Integer;
    Fpresence: String;
    Fname: String;
    Fid: Integer;
    procedure Setchannel(const Value: String);
    procedure SetcompanyId(const Value: Integer);
    procedure SetcreatedAt(const Value: TDateTime);
    procedure SetdisableBot(const Value: Boolean);
    procedure Setemail(const Value: String);
    procedure SetisGroup(const Value: Boolean);
    procedure Setnumber(const Value: String);
    procedure Setpresence(const Value: String);
    procedure SetprofileHiresPictureUrl(const Value: String);
    procedure SetprofilePicUrl(const Value: String);
    procedure SetupdatedAt(const Value: TDateTime);
    procedure Setname(const Value: String);
    procedure Setid(const Value: Integer);

{ private declarations }
protected
 { protected declarations }
Public

      Property id : Integer read Fid write Setid;
      Property name :String read Fname write Setname;
      Property number :String read Fnumber write Setnumber;
      Property profilePicUrl :String read FprofilePicUrl write SetprofilePicUrl;
      Property createdAt :TDateTime read FcreatedAt write SetcreatedAt;
      Property updatedAt :TDateTime read FupdatedAt write SetupdatedAt;
      Property email :String read Femail write Setemail;
      Property isGroup : Boolean read FisGroup write SetisGroup;
      Property companyId :Integer read FcompanyId write SetcompanyId;
      Property channel :String read Fchannel write Setchannel;
      Property disableBot : Boolean read FdisableBot write SetdisableBot;
      Property presence :String read Fpresence write Setpresence;
      Property profileHiresPictureUrl :String read FprofileHiresPictureUrl write SetprofileHiresPictureUrl;


 { public declarations }
published
{ published declarations }

  end;

implementation



{ TContatos }

procedure TContatos.Setchannel(const Value: String);
begin
  Fchannel := Value;
end;

procedure TContatos.SetcompanyId(const Value: Integer);
begin
  FcompanyId := Value;
end;

procedure TContatos.SetcreatedAt(const Value: TDateTime);
begin
  FcreatedAt := Value;
end;

procedure TContatos.SetdisableBot(const Value: Boolean);
begin
  FdisableBot := Value;
end;

procedure TContatos.Setemail(const Value: String);
begin
  Femail := Value;
end;

procedure TContatos.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TContatos.SetisGroup(const Value: Boolean);
begin
  FisGroup := Value;
end;

procedure TContatos.Setname(const Value: String);
begin
  Fname := Value;
end;

procedure TContatos.Setnumber(const Value: String);
begin
  Fnumber := Value;
end;

procedure TContatos.Setpresence(const Value: String);
begin
  Fpresence := Value;
end;

procedure TContatos.SetprofileHiresPictureUrl(const Value: String);
begin
  FprofileHiresPictureUrl := Value;
end;

procedure TContatos.SetprofilePicUrl(const Value: String);
begin
  FprofilePicUrl := Value;
end;

procedure TContatos.SetupdatedAt(const Value: TDateTime);
begin
  FupdatedAt := Value;
end;

end.


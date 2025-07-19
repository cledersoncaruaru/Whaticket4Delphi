unit Entidade.Tasks;

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

  TTasks = class
  private
    Fname: string;
    FuserId: Integer;
    FupdatedAt: TDateTime;
    FmediaPath: string;
    FmediaName: string;
    Fid: LongInt;
    FcreatedAt: TDateTime;
    FcompanyId: LongInt;
    FStatus: integer;
    procedure SetcompanyId(const Value: LongInt);
    procedure SetcreatedAt(const Value: TDateTime);
    procedure Setid(const Value: LongInt);
    procedure SetmediaName(const Value: string);
    procedure SetmediaPath(const Value: string);
    procedure Setname(const Value: string);
    procedure SetupdatedAt(const Value: TDateTime);
    procedure SetuserId(const Value: Integer);
    procedure SetStatus(const Value: integer);


{ private declarations }
protected


 { protected declarations }
Public



      Property id: LongInt read Fid write Setid;
      Property name: string read Fname write Setname;
      Property companyId: LongInt read FcompanyId write SetcompanyId;
      Property createdAt: TDateTime read FcreatedAt write SetcreatedAt;
      Property updatedAt: TDateTime read FupdatedAt write SetupdatedAt;
      Property userId : Integer read FuserId write SetuserId;
      Property mediaName : string read FmediaName write SetmediaName;
      Property mediaPath :string read FmediaPath write SetmediaPath;
      Property Status    : integer read Fstatus write Setstatus;

 { public declarations }
published
{ published declarations }

  end;

implementation



{ TTasks }

procedure TTasks.SetcompanyId(const Value: LongInt);
begin
  FcompanyId := Value;
end;

procedure TTasks.SetcreatedAt(const Value: TDateTime);
begin
  FcreatedAt := Value;
end;

procedure TTasks.Setid(const Value: LongInt);
begin
  Fid := Value;
end;

procedure TTasks.SetmediaName(const Value: string);
begin
  FmediaName := Value;
end;

procedure TTasks.SetmediaPath(const Value: string);
begin
  FmediaPath := Value;
end;

procedure TTasks.Setname(const Value: string);
begin
  Fname := Value;
end;

procedure TTasks.SetStatus(const Value: integer);
begin
  FStatus := Value;
end;

procedure TTasks.SetupdatedAt(const Value: TDateTime);
begin
  FupdatedAt := Value;
end;

procedure TTasks.SetuserId(const Value: Integer);
begin
  FuserId := Value;
end;

end.


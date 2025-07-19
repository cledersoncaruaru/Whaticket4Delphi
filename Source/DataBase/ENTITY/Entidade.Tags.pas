unit Entidade.Tags;

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

  TTags = class
  private
    Fkanban: LongInt;
    Fname: string;
    Fcolor: string;
    FupdatedAt: TDateTime;
    Fid: LongInt;
    FcreatedAt: TDateTime;
    FcompanyId: LongInt;
    procedure Setcolor(const Value: string);
    procedure SetcompanyId(const Value: LongInt);
    procedure SetcreatedAt(const Value: TDateTime);
    procedure Setid(const Value: LongInt);
    procedure Setkanban(const Value: LongInt);
    procedure Setname(const Value: string);
    procedure SetupdatedAt(const Value: TDateTime);





{ private declarations }
protected






 { protected declarations }
Public



      Property id: LongInt read Fid write Setid;
      Property name: string  read Fname write Setname;
      Property color: string  read Fcolor write Setcolor;
      Property companyId: LongInt  read FcompanyId write SetcompanyId;
      Property createdAt: TDateTime read FcreatedAt write SetcreatedAt;
      Property updatedAt: TDateTime  read FupdatedAt write SetupdatedAt;
      Property kanban: LongInt read Fkanban write Setkanban;


 { public declarations }
published
{ published declarations }

  end;

implementation



{ TTags }

procedure TTags.Setcolor(const Value: string);
begin
  Fcolor := Value;
end;

procedure TTags.SetcompanyId(const Value: LongInt);
begin
  FcompanyId := Value;
end;

procedure TTags.SetcreatedAt(const Value: TDateTime);
begin
  FcreatedAt := Value;
end;

procedure TTags.Setid(const Value: LongInt);
begin
  Fid := Value;
end;

procedure TTags.Setkanban(const Value: LongInt);
begin
  Fkanban := Value;
end;

procedure TTags.Setname(const Value: string);
begin
  Fname := Value;
end;

procedure TTags.SetupdatedAt(const Value: TDateTime);
begin
  FupdatedAt := Value;
end;

end.


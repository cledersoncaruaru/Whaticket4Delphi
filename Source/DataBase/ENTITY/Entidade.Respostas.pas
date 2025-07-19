unit Entidade.Respostas;

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

  TRespostas = class
  private
    Fmessage: string;
    FuserId: LongInt;
    FupdatedAt: TDateTime;
    FmediaPath: string;
    FmediaName: string;
    Fid: LongInt;
    FcreatedAt: TDateTime;
    Fshortcode: string;
    FcompanyId: LongInt;
    procedure SetcompanyId(const Value: LongInt);
    procedure SetcreatedAt(const Value: TDateTime);
    procedure Setid(const Value: LongInt);
    procedure SetmediaName(const Value: string);
    procedure SetmediaPath(const Value: string);
    procedure Setmessage(const Value: string);
    procedure Setshortcode(const Value: string);
    procedure SetupdatedAt(const Value: TDateTime);
    procedure SetuserId(const Value: LongInt);

{ private declarations }
protected
 { protected declarations }
Public

      Property id: LongInt read Fid write Setid;
      Property shortcode: string read Fshortcode write Setshortcode;
      Property message: string read Fmessage write Setmessage;
      Property companyId: LongInt read FcompanyId write SetcompanyId;
      Property createdAt: TDateTime read FcreatedAt write SetcreatedAt;
      Property updatedAt: TDateTime read FupdatedAt write SetupdatedAt;
      Property userId: LongInt read FuserId write SetuserId;
      Property mediaName : string read FmediaName write SetmediaName;
      Property mediaPath : string read FmediaPath write SetmediaPath;


 { public declarations }
published
{ published declarations }

  end;

implementation



{ TRespostas }

procedure TRespostas.SetcompanyId(const Value: LongInt);
begin
  FcompanyId := Value;
end;

procedure TRespostas.SetcreatedAt(const Value: TDateTime);
begin
  FcreatedAt := Value;
end;

procedure TRespostas.Setid(const Value: LongInt);
begin
  Fid := Value;
end;

procedure TRespostas.SetmediaName(const Value: string);
begin
  FmediaName := Value;
end;

procedure TRespostas.SetmediaPath(const Value: string);
begin
  FmediaPath := Value;
end;

procedure TRespostas.Setmessage(const Value: string);
begin
  Fmessage := Value;
end;

procedure TRespostas.Setshortcode(const Value: string);
begin
  Fshortcode := Value;
end;

procedure TRespostas.SetupdatedAt(const Value: TDateTime);
begin
  FupdatedAt := Value;
end;

procedure TRespostas.SetuserId(const Value: LongInt);
begin
  FuserId := Value;
end;

end.


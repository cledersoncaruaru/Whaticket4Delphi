unit Entidade.Filas;

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

  TFilas = class
  private
    Fname: string;
    Fschedules: string;
    FoutOfHoursMessage: string;
    Fcolor: string;
    FupdatedAt: TDateTime;
    FmediaPath: string;
    FmediaName: string;
    Fid: LongInt;
    FgreetingMessage: string;
    FcreatedAt: TDateTime;
    FcompanyId: LongInt;
    FwhatsappId: LongInt;
    FisDefault: Boolean;
    FStatus: Integer;
    procedure Setcolor(const Value: string);
    procedure SetcompanyId(const Value: LongInt);
    procedure SetcreatedAt(const Value: TDateTime);
    procedure SetgreetingMessage(const Value: string);
    procedure Setid(const Value: LongInt);
    procedure SetmediaName(const Value: string);
    procedure SetmediaPath(const Value: string);
    procedure Setname(const Value: string);
    procedure SetoutOfHoursMessage(const Value: string);
    procedure Setschedules(const Value: string);
    procedure SetupdatedAt(const Value: TDateTime);
    procedure SetwhatsappId(const Value: LongInt);
    procedure SetisDefault(const Value: Boolean);
    procedure SetStatus(const Value: Integer);


{ private declarations }
protected
 { protected declarations }
Public

      Property id: LongInt read Fid write Setid;
      Property name: string read Fname write Setname;
      Property color: string read Fcolor write Setcolor;
      Property greetingMessage: string read FgreetingMessage write SetgreetingMessage;
      Property createdAt: TDateTime  read FcreatedAt write SetcreatedAt;
      Property updatedAt: TDateTime  read FupdatedAt write SetupdatedAt;
      Property companyId: LongInt read FcompanyId write SetcompanyId;
      Property schedules: string read Fschedules write Setschedules;
      Property outOfHoursMessage: string read FoutOfHoursMessage write SetoutOfHoursMessage;
      Property mediaName  : string read FmediaName write SetmediaName;
      Property mediaPath : string read FmediaPath write SetmediaPath;
      Property whatsappId :LongInt read FwhatsappId write SetwhatsappId;
      Property isDefault  : Boolean read FisDefault write SetisDefault;
      Property Status     : Integer read FStatus write SetStatus;


 { public declarations }
published
{ published declarations }

  end;

implementation






{ TFilas }


{ TFilas }

procedure TFilas.Setcolor(const Value: string);
begin
  Fcolor := Value;
end;

procedure TFilas.SetcompanyId(const Value: LongInt);
begin
  FcompanyId := Value;
end;

procedure TFilas.SetcreatedAt(const Value: TDateTime);
begin
  FcreatedAt := Value;
end;

procedure TFilas.SetgreetingMessage(const Value: string);
begin
  FgreetingMessage := Value;
end;

procedure TFilas.Setid(const Value: LongInt);
begin
  Fid := Value;
end;

procedure TFilas.SetisDefault(const Value: Boolean);
begin
  FisDefault := Value;
end;

procedure TFilas.SetmediaName(const Value: string);
begin
  FmediaName := Value;
end;

procedure TFilas.SetmediaPath(const Value: string);
begin
  FmediaPath := Value;
end;

procedure TFilas.Setname(const Value: string);
begin
  Fname := Value;
end;

procedure TFilas.SetoutOfHoursMessage(const Value: string);
begin
  FoutOfHoursMessage := Value;
end;

procedure TFilas.Setschedules(const Value: string);
begin
  Fschedules := Value;
end;

procedure TFilas.SetStatus(const Value: Integer);
begin
  FStatus := Value;
end;

procedure TFilas.SetupdatedAt(const Value: TDateTime);
begin
  FupdatedAt := Value;
end;

procedure TFilas.SetwhatsappId(const Value: LongInt);
begin
  FwhatsappId := Value;
end;

end.


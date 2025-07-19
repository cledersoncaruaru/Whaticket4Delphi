unit Entidade.Informativo;

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

  TInformativo = class
  private

    Fid: LongInt;
    FPriority: LongInt;
    FTitle: string;   {TWideStringField}
    FText: string;   {TWideMemoField}
    FMediapath: string;   {TWideMemoField}
    FMedianame: string;   {TWideMemoField}
    FCompanyid: LongInt;
    FStatus: string;   {TBooleanField}
    FCreatedat: string;   {TSQLTimeStampOffsetField}
    FUpdatedat: string;   {TSQLTimeStampOffsetField}

    Procedure Setid(const Value: LongInt);
    Procedure SetPriority(const Value: LongInt);
    Procedure SetTitle(const Value: string);
    Procedure SetText(const Value: string);
    Procedure SetMediapath(const Value: string);
    Procedure SetMedianame(const Value: string);
    Procedure SetCompanyid(const Value: LongInt);
    Procedure SetStatus(const Value: string);
    Procedure SetCreatedat(const Value: string);
    Procedure SetUpdatedat(const Value: string);


{ private declarations }
protected
 { protected declarations }
Public

      Property id: LongInt read Fid write Setid;
      Property Priority: LongInt read FPriority write SetPriority;
      Property Title: string read FTitle write SetTitle;
      Property Text: string read FText write SetText;
      Property Mediapath: string read FMediapath write SetMediapath;
      Property Medianame: string read FMedianame write SetMedianame;
      Property Companyid: LongInt read FCompanyid write SetCompanyid;
      Property Status: string read FStatus write SetStatus;
      Property Createdat: string read FCreatedat write SetCreatedat;
      Property Updatedat: string read FUpdatedat write SetUpdatedat;


 { public declarations }
published
{ published declarations }

  end;

implementation



 { TAnnouncements}
Procedure TInformativo.Setid(const Value: LongInt);
begin
  Fid  := Value;
end;


Procedure TInformativo.SetPriority(const Value: LongInt);
begin
  FPriority  := Value;
end;


Procedure TInformativo.SetTitle(const Value: string);
begin
  FTitle  := Value;
end;


Procedure TInformativo.SetText(const Value: string);
begin
  FText  := Value;
end;


Procedure TInformativo.SetMediapath(const Value: string);
begin
  FMediapath  := Value;
end;


Procedure TInformativo.SetMedianame(const Value: string);
begin
  FMedianame  := Value;
end;


Procedure TInformativo.SetCompanyid(const Value: LongInt);
begin
  FCompanyid  := Value;
end;


Procedure TInformativo.SetStatus(const Value: string);
begin
  FStatus  := Value;
end;


Procedure TInformativo.SetCreatedat(const Value: string);
begin
  FCreatedat  := Value;
end;


Procedure TInformativo.SetUpdatedat(const Value: string);
begin
  FUpdatedat  := Value;
end;


end.


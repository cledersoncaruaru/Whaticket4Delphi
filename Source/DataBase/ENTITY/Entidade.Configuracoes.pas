unit Entidade.Configuracoes;

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

  TConfiguracoes = class
  private

    FKey: string;   {TWideStringField}
    FValue: string;   {TWideMemoField}
    FCreatedat: string;   {TSQLTimeStampOffsetField}
    FUpdatedat: string;   {TSQLTimeStampOffsetField}
    FCompanyid: LongInt;
    Fid: LongInt;

    Procedure SetKey(const Value: string);
    Procedure SetValue(const Value: string);
    Procedure SetCreatedat(const Value: string);
    Procedure SetUpdatedat(const Value: string);
    Procedure SetCompanyid(const Value: LongInt);
    Procedure Setid(const Value: LongInt);


{ private declarations }
protected
 { protected declarations }
Public

      Property Key: string read FKey write SetKey;
      Property Value: string read FValue write SetValue;
      Property Createdat: string read FCreatedat write SetCreatedat;
      Property Updatedat: string read FUpdatedat write SetUpdatedat;
      Property Companyid: LongInt read FCompanyid write SetCompanyid;
      Property id: LongInt read Fid write Setid;


 { public declarations }
published
{ published declarations }

  end;

implementation



 { TSettings}
Procedure TConfiguracoes.SetKey(const Value: string);
begin
  FKey  := Value;
end;


Procedure TConfiguracoes.SetValue(const Value: string);
begin
  FValue  := Value;
end;


Procedure TConfiguracoes.SetCreatedat(const Value: string);
begin
  FCreatedat  := Value;
end;


Procedure TConfiguracoes.SetUpdatedat(const Value: string);
begin
  FUpdatedat  := Value;
end;


Procedure TConfiguracoes.SetCompanyid(const Value: LongInt);
begin
  FCompanyid  := Value;
end;


Procedure TConfiguracoes.Setid(const Value: LongInt);
begin
  Fid  := Value;
end;


end.


unit Dao.Dashboard;

interface

uses
  System.Classes,
  System.StrUtils,
  Buttons.Icons,
  Functions.Strings,
  Integracao.Discord,
  Tipos.Types,
  uPopulaCrud,
  Entidade.Tags,
  Functions.DataBase,
  DateUtils;

  function Get_Total_Atendimentos(CompanyID,IDUsuario: Longint; DataIni,DataFim:TDateTime; TpUsuario:TUserType; var TotalEmAtendimento,TotalAguardando,TotalResolvidos:String): Boolean;

implementation

uses
  FireDAC.Comp.Client, ServerController, System.SysUtils, System.TypInfo;


function Get_Total_Atendimentos(CompanyID,IDUsuario: Longint; DataIni,DataFim:TDateTime; TpUsuario:TUserType; var TotalEmAtendimento,TotalAguardando,TotalResolvidos:String): Boolean;
var
  Qry: TFDQuery;
begin


  Result         := False;

  Qry            := TFDQuery.Create(nil);
  Qry.Connection := UserSession.Conexao;


  try

    try

      Qry.SQL.Text   :=
             ' SELECT                                                                      '+
             ' SUM(CASE WHEN status = ''pending'' THEN 1 ELSE 0 END) AS TotalAguardando,   '+
             ' SUM(CASE WHEN status = ''open'' THEN 1 ELSE 0 END) AS TotalEmAtendimento,   '+
             ' SUM(CASE WHEN status = ''close'' THEN 1 ELSE 0 END) AS TotalResolvidos      '+
             ' FROM "Tickets" t                                                            '+
             ' WHERE t."companyId" = :companyId                                            '+
             ' AND t."createdAt" >= :dataInicial                                           '+
             ' AND t."createdAt" <= :dataFinal                                             ';

      Qry.ParamByName('companyId').AsInteger     := CompanyID;
      Qry.ParamByName('dataInicial').AsDateTime  := StartOfTheDay(DataIni);
      Qry.ParamByName('dataFinal').AsDateTime    := EndOfTheDay(DataFim);
      Qry.Open;

      if not Qry.IsEmpty then begin

        TotalEmAtendimento   := IntToStr(Qry.FieldByName('TotalEmAtendimento').AsInteger);
        TotalAguardando      := IntToStr(Qry.FieldByName('TotalAguardando').AsInteger);
        TotalResolvidos      := IntToStr(Qry.FieldByName('TotalResolvidos').AsInteger);

      end
      else begin

        TotalEmAtendimento   := '0';
        TotalAguardando      := '0';
        TotalResolvidos      := '0';

      end;

    except on E: Exception do

      UserSession.DiscordLogger.SendLog(
            'Erro ao Careegar Dados Cards',
            'Dao.DashBoard',
            'Get_Total_Atendimentos',
            '- Erro : '+ e.Message);
    end;
  finally
    Qry.Free;
  end;

end;

end.


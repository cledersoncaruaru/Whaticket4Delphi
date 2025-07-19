unit uFrmDashboard;

interface

uses
  ServerController,
  BootsTrap.Cards,
  Dao.Dashboard,
  System.SysUtils,
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, System.Classes, Vcl.Controls,
  IWCompEdit;

type
  TFrmDashboard = class(TFrmBase)
    CADATENDIMENTOSEMATENDIMENTOS: TIWLabel;
    CADATENDIMENTOSFINALIZADOS: TIWLabel;
    CADATENDIMENTOSAGUARDANDO: TIWLabel;
    CARDCONTATOS: TIWLabel;
    CARDAGENDAMENTOS: TIWLabel;
    CARDTEMPOMEDOATENDIMENTO: TIWLabel;
    CARDTEMPOMEDIOESPERA: TIWLabel;
    DATAINI: TIWEdit;
    DATAFIM: TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormShow(Sender: TObject);
    procedure DATAINIAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure DATAFIMAsyncChange(Sender: TObject; EventParams: TStringList);
  private
    { Private declarations }
    vDATAINI,vDATAFIM     : TDate;

    Procedure ExecuteDashBoard;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmDashboard.DATAFIMAsyncChange(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
  vDATAFIM        := StrToDate(DATAFIM.Text);
  ExecuteDashBoard;
end;

procedure TFrmDashboard.DATAINIAsyncChange(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
  vDATAINI        := StrToDate(DATAINI.Text);
  ExecuteDashBoard;
end;

procedure TFrmDashboard.ExecuteDashBoard;
var
TotalEmAtendimento,TotalAguardando,TotalResolvidos:String;
begin

  Get_Total_Atendimentos(UserSession.CompanyId,
                         UserSession.IDUser,
                         vDATAINI,
                         vDATAFIM,
                         UserSession.UserType,
                         TotalEmAtendimento,
                         TotalAguardando,
                         TotalResolvidos);

   CADATENDIMENTOSEMATENDIMENTOS.Text   := Get_Card('Em Atendimento',TotalEmAtendimento,'bg-info','fa-brands fa-whatsapp fa-4x');
   CADATENDIMENTOSAGUARDANDO.Text       := Get_Card('Atendimentos Aguardando',TotalAguardando,'bg-warning','fa-regular fa-clipboard fa-4x');
   CADATENDIMENTOSFINALIZADOS.Text      := Get_Card('Atendimentos Finalizados',TotalResolvidos,'bg-success','fa-solid fa-square-xmark fa-4x');

//  CARDCONTATOS.Text
//  CARDAGENDAMENTOS.Text
//  CARDTEMPOMEDOATENDIMENTO.Text
//  CARDTEMPOMEDIOESPERA.Text

end;

procedure TFrmDashboard.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmDashboard.html') then
       TPS.Templates.Default := 'FrmDashboard.html';

    Title                     := 'Dashboard';
    Subtitulo.Caption         := 'Dashboard /';

    DATAINI.Text       := DateToStr(Now);
    DATAFIM.Text       := DateToStr(Now);

    vDATAINI           := StrToDate(DATAINI.Text);
    vDATAFIM           := StrToDate(DATAFIM.Text);

end;

procedure TFrmDashboard.IWAppFormShow(Sender: TObject);
begin
  inherited;
      ExecuteDashBoard;
end;

end.

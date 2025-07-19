unit uFrmInformativo;

interface

uses
  ServerController,
  Dao.Informativo,
  Entidade.Informativo,
  System.SysUtils, System.Variants, System.Classes,
   uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, Vcl.Controls;

type
  TFrmInformativo = class(TFrmBase)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }

    Procedure  Get_Liste(aParams: TStrings; out aResult: String);
    Procedure  Actions(EventParams: TStringList);

  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFrmInformativo.Actions(EventParams: TStringList);
begin
//
end;

procedure TFrmInformativo.Get_Liste(aParams: TStrings; out aResult: String);
begin
GetAll(UserSession.CompanyId, aParams, aResult, UserSession.UserType);
end;

procedure TFrmInformativo.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmInformativo.html') then
       TPS.Templates.Default := 'FrmInformativo.html';

    Title                     := 'Informativo';
    Subtitulo.Caption         := 'Informativo /';

    RegisterCallBack('ListaInformativo', Get_Liste);
    RegisterCallBack('Actions', Actions );


end;

end.

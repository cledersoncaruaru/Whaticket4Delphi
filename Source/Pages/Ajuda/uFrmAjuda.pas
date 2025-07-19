unit uFrmAjuda;

interface

uses
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, System.Classes, Vcl.Controls;

type
  TFrmAjuda = class(TFrmBase)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmAjuda.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmAjuda.html') then
       TPS.Templates.Default := 'FrmAjuda.html';

    Title                     := 'Ajuda';
    Subtitulo.Caption         := 'Ajuda ';
end;

end.

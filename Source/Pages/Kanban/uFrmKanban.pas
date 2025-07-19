unit uFrmKanban;

interface

uses
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, System.Classes, Vcl.Controls;

type
  TFrmKanban = class(TFrmBase)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmKanban.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmKanban.html') then
       TPS.Templates.Default := 'FrmKanban.html';

    Title                     := 'Kanban';
    Subtitulo.Caption         := 'Kanban /';


end;

end.

unit uFrmSettings;

interface

uses
 uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompButton, IWCompLabel, System.Classes, Vcl.Controls;

type
  TFrmSettings = class(TFrmBase)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFrmSettings.IWAppFormCreate(Sender: TObject);
begin
  inherited;

    if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmSettings.html') then
         TPS.Templates.Default := 'FrmSettings.html';
        Title                     := 'Settings';
        Subtitulo.Caption         := 'Settings';

end;

end.

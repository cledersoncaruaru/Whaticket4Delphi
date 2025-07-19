unit uFrmChat;

interface

uses
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, System.Classes, Vcl.Controls;

type
  TFrmChat = class(TFrmBase)
    procedure IWAppFormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFrmChat.IWAppFormCreate(Sender: TObject);
begin
  inherited;
  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmChat.html') then
       TPS.Templates.Default := 'FrmChat.html';

    Title                     := 'Chat Interno';
    Subtitulo.Caption         := 'Chat Interno /';
end;

end.

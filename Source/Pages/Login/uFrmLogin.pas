unit uFrmLogin;
interface
uses
      Integracao.Discord,
      Dao.Usuario,
      Bootstrap.SweetAlert2,
      IWApplication,
      System.SysUtils, System.Variants, System.Classes,
      uBase, IWVCLComponent,
      IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
      IWTemplateProcessorHTML, IWCompButton, IWVCLBaseControl, IWBaseControl,
      IWBaseHTMLControl, IWControl, IWCompEdit, IWCompLabel, Vcl.Controls,
  IWCompListbox;
type
  TFrmLogin = class(TFrmBase)
    EMAIL: TIWEdit;
    SENHA: TIWEdit;
    BTN_LOGIN: TIWButton;
    ID_SESSAO: TIWEdit;
    BTN_SESSAO: TIWButton;
    procedure BTN_LOGINAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormShow(Sender: TObject);
  private
    { Private declarations }
    Function Validacao:Boolean;

  public
    { Public declarations }
  end;


implementation
{$R *.dfm}
uses  ServerController, uFrmSettings;


procedure TFrmLogin.BTN_LOGINAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

  if Validacao then begin

   if Autentica_Usuario(EMAIL.Text,SENHA.Text) then begin
     ExecuteJS('ajaxCall(''Menu'',''page=FRMDASHBOARD'')');

   end
   else
   begin
     ExecuteJS(swalAlert('A T E N Ç Ã O',
                                        'Usuario ou Senha Inválidos, Verifique ...',
                                        'EMAIL',350,Tperror));
                                        exit;
   end;

  end;

end;

procedure TFrmLogin.IWAppFormCreate(Sender: TObject);
var mensagem : sTRING;
begin
 inherited;

end;

procedure TFrmLogin.IWAppFormShow(Sender: TObject);
var
  Encerrar : String;
begin
  inherited;

end;

Function TFrmLogin.Validacao: Boolean;
begin

 Result := False;

    if EMAIL.Text = '' then begin

       ExecuteJS(swalAlert('A T E N Ç Ã O',
                                        'Email Não Pode Ser Vazio, Verifique...',
                                        'EMAIL',350,Tperror));
                                         exit;

   end;

   if SENHA.Text = '' then begin
      ExecuteJS(swalAlert('A T E N Ç Ã O',
                                        'Senha Não Pode Ser Vazio, Verifique...',
                                        'SENHA',350,Tperror));
                                        exit;
   end;

   Result := True;

end;

initialization
  TFrmLogin.SetAsMainForm;

end.

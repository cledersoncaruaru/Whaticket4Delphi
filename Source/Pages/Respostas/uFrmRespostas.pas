unit uFrmRespostas;

interface

uses

  ServerController,
  Dao.Respostas,
  Entidade.Respostas,
  Tipos.Types,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, Vcl.Controls, IWCompEdit,
  IWCompMemo,
  uPopulaCrud,
  Bootstrap.SweetAlert2;

type
  TFrmRespostas = class(TFrmBase)
    BTN_ADICONAR: TIWButton;
    MESSAGE: TIWMemo;
    SHORTCODE: TIWEdit;
    BTN_EXCLUIR: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure BTN_ADICONARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTN_POSTAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTN_EXCLUIRAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject;
      EventParams: TStringList);
  private
    { Private declarations }

    Respostas  : TRespostas;
    vResult    : String;
    Carregou   :Boolean;

    procedure  Get_Liste(aParams: TStrings; out aResult: String);
    procedure  Actions(EventParams: TStringList);

    function Salvar:Boolean;
    function ValidarCampos:Boolean;

  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

{ TFrmRespostas }

procedure TFrmRespostas.Actions(EventParams: TStringList);
var
ID:Integer;
begin

  if (StrToIntDef(EventParams.Values['Edit'],0) > 0 )then begin

    if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
    end;

      ExecuteJS('document.querySelector(''h2.card-header.bg-primary.text-white'').textContent = ''Alterando Respostas Rápidas'';');
      Get_QuickMessages(StrToIntDef(EventParams.Values['Edit'],0),Respostas,vResult);
      TPopulateFromScreen<TRespostas>.PopulateScreenFromObject(Respostas, Self);
      ExecuteJS('$(''#modal_adicionar_resposta'').modal(''show'');');

  end;


  if (StrToIntDef(EventParams.Values['Delete'],0) > 0 )then begin

     if UserSession.Profile = tpUser then begin
        ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Excluir',false,'',350,Tpinfo);
        Exit;
     end;

      ID   := StrToIntDef(EventParams.Values['Delete'],0);
      UserSession.Clipboard.Put('Excluir',ID);
      ExecuteJS(swalConfirm( 'EXCLUIR Resposta Rápida',
                               'Prezado Usuário Deseja EXCLUIR a Resposta Rápida Agora?',
                               'error',
                               'EXCLUIR',
                               'NÃO',
                               'BTN_EXCLUIR',
                               'BTN_CANCEL'));
  end;


end;

procedure TFrmRespostas.BTN_ADICONARAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
   end;

  Get_QuickMessages(0,Respostas,vResult);
  ExecuteJS('$(''#modal_adicionar_resposta'').modal(''show'');');
end;

procedure TFrmRespostas.BTN_EXCLUIRAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
ID:Integer;
begin
  inherited;
  UserSession.Clipboard.Get('Excluir',ID);
  Delete_Resposta(ID);
  ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');

end;

procedure TFrmRespostas.BTN_POSTAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
  Salvar;
  ExecuteJS('$(''#modal_adicionar_resposta'').modal(''hide'');');
  ExecuteJS('document.querySelector(''h2.card-header.bg-primary.text-white'').textContent = ''Mensagem Rápida'';');

end;

procedure TFrmRespostas.Get_Liste(aParams: TStrings; out aResult: String);
begin

   GetAll(UserSession.CompanyId, aParams, aResult, UserSession.UserType);

end;

procedure TFrmRespostas.IWAppFormAsyncPageLoaded(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
  Carregou := True;
end;

procedure TFrmRespostas.IWAppFormCreate(Sender: TObject);
begin
  inherited;

    if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmRespostas.html') then
      TPS.Templates.Default := 'FrmRespostas.html';

    Title                     := 'Respostas Rápidas';
    Subtitulo.Caption         := 'Respostas Rápidas';
    RegisterCallBack('ListaRespostas', Get_Liste);
    RegisterCallBack('Actions', Actions );

    Respostas  := TRespostas.Create;

end;

procedure TFrmRespostas.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
Respostas.Free;
end;

function TFrmRespostas.Salvar: Boolean;
begin
  Result := False;

  TPopulateFromScreen<TRespostas>.PopulaObjeto(Respostas, Self);

  if Set_QuickMessages(Respostas.id,Respostas,vResult) then begin
     Result := True;
     ExecuteJS(swalAutoClose('Registro Salvo Com Sucesso',1000,Tpsuccess) );
     ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
     SHORTCODE.Clear;
     MESSAGE.Clear;
  end;

end;

function TFrmRespostas.ValidarCampos: Boolean;
begin

 Result  := False;

 if ( Trim(SHORTCODE.Text) = '') then begin

   ExecuteJS(swalAlert('A T E N Ç Ã O',
                            'Campo de Atalho, Não Informado, Verifique ... ',
                            'SHORTCODE',350,Tpwarning));
                            Exit;

 end;

  if ( Trim(MESSAGE.Text) = '') then begin

   ExecuteJS(swalAlert('A T E N Ç Ã O',
                            'Campo de Atalho, Não Informado, Verifique ... ',
                            'MESSAGE',350,Tpwarning));
                            Exit;
 end;

 Result := True;

end;

end.

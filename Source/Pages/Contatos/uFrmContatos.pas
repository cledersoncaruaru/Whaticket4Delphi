unit uFrmContatos;

interface

uses
    Dao.Contatos,
    ServerController,
    Entidade.Contatos,
    System.SysUtils,
    System.Variants,
    System.Classes,
    Tipos.Types,
    uBase, IWVCLComponent,
    IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
    IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
    IWBaseHTMLControl, IWControl, IWCompButton, IWCompEdit,
    IWCompListbox,
    uPopulaCrud,
    Bootstrap.SweetAlert2,
    Functions.Strings, IWDBStdCtrls, Data.DB, Vcl.Controls, IWCompMemo;

type
  TFrmContatos = class(TFrmBase)
    BTN_IMPORTAR: TIWButton;
    BTN_ADICONAR: TIWButton;
    BTN_EXPORTAR: TIWButton;
    NAME: TIWEdit;
    NUMBER: TIWEdit;
    EMAIL: TIWEdit;
    ADICIONAIS: TIWEdit;
    IWButton4: TIWButton;
    BTN_MODAL_CANCEL: TIWButton;
    BTN_MODAL_ADICIONAR: TIWButton;
    FILAS: TIWComboBox;
    IWLabel1: TIWLabel;
    Ds: TDataSource;
    procedure IWAppFormCreate(Sender: TObject);
    procedure BTN_ADICONARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTN_POSTAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    { Private declarations }

    Contatos : TContatos;
    vResult : String;

    procedure  Get_Liste(aParams: TStrings; out aResult: String);
    procedure  Actions(EventParams: TStringList);

    function Salvar:Boolean;
    function ValidarCampos:Boolean;

  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFrmContatos.Actions(EventParams: TStringList);
begin


  if (StrToIntDef(EventParams.Values['Edit'],0) > 0 )then begin

     if UserSession.Profile = tpUser then begin
        ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
        Exit;
     end;

     UserSession.Clipboard.Put('contact_id',StrToIntDef(EventParams.Values['Edit'],0));
     Get_Contacts(StrToIntDef(EventParams.Values['Edit'],0), Contatos, vResult);

     NAME.Text        := Contatos.NAME;
     NUMBER.Text      := Contatos.NUMBER;
     EMAIL.Text       := Contatos.EMAIL;


     ADICIONAIS.Text  := '';
     WebApplication.ExecuteJS('$(''#modal_adicionar_contato'').modal(''show'');');

  end;

  if (StrToIntDef(EventParams.Values['ticket'],0) > 0 )then begin

      WebApplication.ExecuteJS('$(''#modal_ticket'').modal(''show'');');

  end;


end;

procedure TFrmContatos.BTN_ADICONARAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
   end;

  NAME.Clear;
  NUMBER.Clear;
  EMAIL.Clear;
  ADICIONAIS.Clear;
  WebApplication.ExecuteJS('$(''#modal_adicionar_contato'').modal(''show'');');
end;

procedure TFrmContatos.BTN_POSTAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   if ValidarCampos then begin

    Salvar;
    WebApplication.ExecuteJS('$(''#modal_adicionar_contato'').modal(''hide'');');

   end;


end;

procedure TFrmContatos.Get_Liste(aParams: TStrings; out aResult: String);
begin
GetAll(UserSession.CompanyId, aParams, aResult,UserSession.UserType);
end;

procedure TFrmContatos.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmContatos.html') then
       TPS.Templates.Default     := 'FrmContatos.html';
       Title                     := 'Contatos';
       Subtitulo.Caption         := 'Contatos /';

    RegisterCallBack('ListaContatos', Get_Liste);
    RegisterCallBack('Actions', Actions );

    Contatos := TContatos.Create;

end;

procedure TFrmContatos.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
Contatos.Free;
end;

function TFrmContatos.Salvar: Boolean;
begin
  Result := False;

  if Get_Existe_Contato(NUMBER.Text,Contatos.ID) then begin
     ExecuteJS(swalAlert('A T E N Ç Ã O ','Atenção ,Contato Já Existente,Verifique !!!','NUMBER',350,Tpwarning));
     exit;

  end;


  TPopulateFromScreen<TContatos>.PopulaObjeto(Contatos, Self);

  if Set_Contacts(Contatos.id,Contatos,vResult) then begin
     Result := True;
     ExecuteJS(swalAutoClose('Registro Salvo Com Sucesso',1000,Tpsuccess) );
     ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
     NAME.Clear;
     NUMBER.Clear;
  end;
end;

function TFrmContatos.ValidarCampos: Boolean;
begin

    Result  := False;

   if ( Trim(NAME.Text) = '') then begin

     WebApplication.ExecuteJS(swalAlert('A T E N Ç Ã O',
                              'Campo de Nome do Contato, Não Informado, Verifique ... ',
                              'NAME',350,Tpwarning));
                              Exit;

   end;

   if ( ( Trim(NUMBER.Text) = '' ) or (Length(SomenteNumeros(NUMBER.Text)) < 13 ) ) then begin

     ExecuteJS(swalAlert('A T E N Ç Ã O',
                              'Número do WhatsApp, Não Informado ou Com Erros, Não Informado, Verifique ... ',
                              'MESSAGE',350,Tpwarning));
                              Exit;

   end;


 Result := True;

end;

end.

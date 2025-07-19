unit uFrmConfiguracoes;

interface

uses

  ServerController,
  Entidade.Configuracoes,
  Dao.Configuracoes,

  System.SysUtils, System.Variants, System.Classes,
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, Vcl.Controls, IWCompListbox,
  IWCompEdit,
  uPopulaCrud,
  Bootstrap.SweetAlert2;

type
  TFrmConfiguracoes = class(TFrmBase)
    USERQUEUES: TIWComboBox;
    IPIXC: TIWEdit;
    IWComboBox1: TIWComboBox;
    IWComboBox2: TIWComboBox;
    IWComboBox3: TIWComboBox;
    IWComboBox4: TIWComboBox;
    IWComboBox5: TIWComboBox;
    IWComboBox6: TIWComboBox;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    TOKENIXC: TIWEdit;
    IWLabel3: TIWLabel;
    IWLabel4: TIWLabel;
    IPMKAUTH: TIWEdit;
    CLIENTIDMKAUTH: TIWEdit;
    CLIENTSECRETMKAUTH: TIWEdit;
    IWLabel5: TIWLabel;
    ASAAS: TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
  private
    { Private declarations }
    Configuracao : TConfiguracoes;
    vResult      : String;

    Procedure  Get_Liste(aParams: TStrings; out aResult: String);
    Procedure  Actions(EventParams: TStringList);
    Function   Salvar:Boolean;

  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmConfiguracoes.Actions(EventParams: TStringList);
begin

  if StrToIntDef(EventParams.Values['Edit'],0) > 0 then begin

   UserSession.Clipboard.Put('CHAVE_PK',StrToIntDef(EventParams.Values['Edit'],0) );
   Get_Settings( StrToIntDef(EventParams.Values['Edit'],0), Configuracao, vResult);
   TPopulateFromScreen<TConfiguracoes>.PopulateScreenFromObject(Configuracao, Self);
  end;


end;

procedure TFrmConfiguracoes.Get_Liste(aParams: TStrings; out aResult: String);
begin
 //GetAll(UserSession.CompanyId, aParams, aResult,UserSession.UserType);
end;

procedure TFrmConfiguracoes.IWAppFormCreate(Sender: TObject);
begin
  inherited;

 if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmConfiguracoes.html') then
      TPS.Templates.Default     := 'FrmConfiguracoes.html';

      Title                     := 'Configurações do Sistema';
      Subtitulo.Caption         := 'Configurações do Sistema';

      RegisterCallBack('Actions', Actions );
      Configuracao := TConfiguracoes.Create;

      Get_Settings(UserSession.CompanyId,Configuracao,vResult);


end;

procedure TFrmConfiguracoes.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
Configuracao.Free;
end;

function TFrmConfiguracoes.Salvar: Boolean;
begin
 Result := False;

  TPopulateFromScreen<TConfiguracoes>.PopulaObjeto(Configuracao, Self);

  if Set_Settings(Configuracao.id,Configuracao,vResult) then begin
     Result := True;
     ExecuteJS(swalAutoClose('Registro Salvo Com Sucesso',1000,Tpsuccess) );
     ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');

  end;
end;

end.

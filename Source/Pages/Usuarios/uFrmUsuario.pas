unit uFrmUsuario;

interface

uses
  ServerController,
  Dao.Usuario,
  Entidade.Usuarios,
  uPopulaCrud,
  Tipos.Types,
  Functions.DataBase,
  Bootstrap.SweetAlert2,
  System.SysUtils,
  System.Variants,
  System.Classes,
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, Vcl.Controls, IWCompEdit,
  IWCompListbox, BCrypt, BCrypt.Types;

type
  TFrmUsuario = class(TFrmBase)
    BTN_ADICIONAR: TIWButton;
    USERQUEUES: TIWSelect;
    PROFILE: TIWSelect;
    EMAIL: TIWEdit;
    NAME: TIWEdit;
    PASSWORDHASH: TIWEdit;
    procedure IWAppFormCreate(Sender: TObject);
    procedure BTN_ADICIONARAsyncClick(Sender: TObject;
      EventParams: TStringList);
    procedure BTN_POSTAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormShow(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure PASSWORDHASHAsyncExit(Sender: TObject; EventParams: TStringList);
  private
    { Private declarations }

      Usuarios : TUsuarios;
      vResult  : String;
      IsHash   : Boolean;
      Procedure  Get_Liste(aParams: TStrings; out aResult: String);
      Procedure  Actions(EventParams: TStringList);

      Function Gravar:Boolean;
      Function GetDados:Boolean;

  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TFrmUsuario.Actions(EventParams: TStringList);
begin

  if (StrToIntDef(EventParams.Values['Edit'],0) > 0 )then begin

      if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
      end;

      UserSession.Clipboard.Put('ID_USUARIO',StrToIntDef(EventParams.Values['Edit'],0));
      GetDados;
      WebApplication.ExecuteJS('$(''#modal_adicionar_usuario'').modal(''show'');');
  end;

end;

procedure TFrmUsuario.BTN_ADICIONARAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
   end;

  NAME.Clear;
  PASSWORDHASH.Clear;
  EMAIL.Clear;
  WebApplication.ExecuteJS('$(''#modal_adicionar_usuario'').modal(''show'');');
end;

procedure TFrmUsuario.BTN_POSTAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
    Gravar;
end;

function TFrmUsuario.GetDados: Boolean;
var
id  :Integer;
begin

  UserSession.Clipboard.Get('ID_USUARIO',id);
  Get_Users(id,Usuarios,vResult);
  TPopulateFromScreen<TUsuarios>.PopulateScreenFromObject(Usuarios, Self);
  PROFILE.SelectedValue     := Usuarios.Profile;
  USERQUEUES.SelectedValue  := Get_Users_Queues(Usuarios.id);
end;

procedure TFrmUsuario.Get_Liste(aParams: TStrings; out aResult: String);
begin
GetAll(UserSession.CompanyId,aParams, aResult, UserSession.UserType);
end;

function TFrmUsuario.Gravar: Boolean;
var
  Lista: TStringList;
begin

    Result                 := False;
    Lista                  := TStringList.Create;
    Lista.Delimiter        := ',';
    Lista.StrictDelimiter  := True;
    Lista.DelimitedText    := USERQUEUES.SelectedValue;

  try

    TPopulateFromScreen<TUsuarios>.PopulaObjeto(Usuarios, Self);
    Usuarios.Companyid := UserSession.CompanyId;


    if Set_Users(UserSession.CompanyId,Usuarios, vResult,IsHash,Lista) then begin
     WebApplication.ExecuteJS('$(''#modal_adicionar_usuario'').modal(''hide'');');
     WebApplication.ExecuteJS(swalAlert('SUCESSO','Registro Gravado Com Sucesso','BTN_NOVO',350,Tpsuccess));
     WebApplication.ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
    end;


  finally
   Lista.Free;
  end;

end;

procedure TFrmUsuario.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmUsuario.html') then
       TPS.Templates.Default  := 'FrmUsuario.html';

  Title                     := 'Usuarios';
  Subtitulo.Caption         := 'Usuarios /';

  RegisterCallBack('ListaUsuarios', Get_Liste);
  RegisterCallBack('Actions', Actions );

  Usuarios := TUsuarios.Create;

  USERQUEUES.MultiSelect := False;
  USERQUEUES.SelectMinInputLength := 0;
  USERQUEUES.SelectOptions := USERQUEUES.SelectOptions + [soAllowClear];

end;

procedure TFrmUsuario.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
   Usuarios.Free;
end;

procedure TFrmUsuario.IWAppFormShow(Sender: TObject);
begin
  inherited;
   Load_Combobox_Filas(UserSession.CompanyId,USERQUEUES);
end;

procedure TFrmUsuario.PASSWORDHASHAsyncExit(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   if ( Trim(PASSWORDHASH.Text) <>  Usuarios.Passwordhash   ) and ( Trim(PASSWORDHASH.Text) <> '' )   then begin
       IsHash                  := True;
       Usuarios.Passwordhash   := TBCrypt.GenerateHash(Trim(PASSWORDHASH.Text)) ;
   end;

end;

end.

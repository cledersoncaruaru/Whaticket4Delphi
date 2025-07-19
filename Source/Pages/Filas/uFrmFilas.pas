unit uFrmFilas;

interface

uses
  ServerController,
  Dao.Filas,
  Functions.IW,
  Bootstrap.SweetAlert2,
  Entidade.Filas,
  uPopulaCrud,
  Functions.DataBase,
  Tipos.Types,

  System.SysUtils, System.Variants, System.Classes,
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, Vcl.Controls, IWCompMemo,
  IWCompEdit,IWHTMLTag, IWCompListbox, IWCompCheckbox;

type
  TFrmFilas = class(TFrmBase)
    name: TIWEdit;
    color: TIWEdit;
    greetingMessage: TIWMemo;
    BTN_OP_ADICIONAR: TIWButton;
    BTN_ADICONAR: TIWButton;
    whatsappId: TIWComboBox;
    isDefault: TIWCheckBox;
    STATUS: TIWComboBox;
    BTN_DELETE: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure BTN_ADICONARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure nameHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure BTN_POSTAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWAppFormShow(Sender: TObject);
    procedure BTN_DELETEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure STATUSAsyncChange(Sender: TObject; EventParams: TStringList);
  private
    { Private declarations }

    Filas      : TFilas;
    vResult    : String;

    Procedure  Get_Liste(aParams: TStrings; out aResult: String);
    Procedure  Actions(EventParams: TStringList);

  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

{ TFrmFilas }

procedure TFrmFilas.Actions(EventParams: TStringList);
begin

  if StrToIntDef(EventParams.Values['Edit'],0) > 0 then begin

   if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
   end;

   UserSession.Clipboard.Put('CHAVE_PK',StrToIntDef(EventParams.Values['Edit'],0) );
   Get_Queues( StrToIntDef(EventParams.Values['Edit'],0), Filas, vResult);
   TPopulateFromScreen<TFilas>.PopulateScreenFromObject(Filas, Self);
   whatsappId.SelectedValue    := IntToStr(Filas.whatsappId);
   STATUS.SelectedValue        := IntToStr(Filas.Status);
   ExecuteJS('$(''#modal_adicionar_fila'').modal(''show'');');


    if CheckDefault(Filas.id) then begin
        isDefault.Caption  := '( Já Existe Padrão )';
        ExecuteJS(
          'let el = document.getElementById("ISDEFAULT");' +
          'el.disabled = true;' +
          'el.onclick = function(e) { e.preventDefault(); return false; };' +
          'if(el.parentElement) el.parentElement.style.pointerEvents = "none";'
        );
    end
    else begin
        isDefault.Caption  := 'Default';
    end;
  end;

  if StrToIntDef(EventParams.Values['Deletar'],0) > 0 then begin

     if UserSession.Profile = tpUser then begin
        ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Excluir',false,'',350,Tpinfo);
        Exit;
     end;

     UserSession.Clipboard.Put('CHAVE_PK',StrToIntDef(EventParams.Values['Deletar'],0) );
     ExecuteJS(swalConfirm( 'EXCLUSÃO DE REGISTRO',
                       'Prezado Usuário Deseja EXCLUIR Este REGISTRO Agora?',
                       'error',
                       'SIM',
                       'NÃO',
                       'BTN_DELETE',
                       'BTNCANCELAR'));
  end;

 end;

procedure TFrmFilas.BTN_ADICONARAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
   end;

  ExecuteJS('$(''#modal_adicionar_fila'').modal(''show'');');
end;

procedure TFrmFilas.BTN_DELETEAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
ID:Integer;
begin
  inherited;

   UserSession.Clipboard.Get('CHAVE_PK',ID);

   if Delete_Fila(ID) then begin
      ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
   end;
end;

procedure TFrmFilas.BTN_POSTAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

  if StrToIntDef(STATUS.SelectedValue,-1) < 0 then begin
      ShowMessage(WebApplication,'Atenção ',' Informe o Status do Cadastro',true,'STATUS',350,Tperror);
      Exit;
  end;


  if not ValidarCampo(Self, 'NAME', 0, False) then begin
         ShowMessage(WebApplication,'Atenção ',' O Campo Descrição, Deve Ser Preenchido',true,'NAME',350,Tperror);
         Exit;
  end;

   TPopulateFromScreen<TFilas>.PopulaObjeto(Filas, Self);
    Filas.whatsappId   := StrToIntDef(whatsappId.SelectedValue,-1);

   if Set_Queues(Filas.id,Filas,vResult) then begin
      ExecuteJS('$(''#modal_adicionar_fila'').modal(''hide'');');
      ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
   end;


end;

procedure TFrmFilas.Get_Liste(aParams: TStrings; out aResult: String);
begin
GetAll(UserSession.CompanyId,StrToIntDef(STATUS.SelectedValue,-1), aParams, aResult,UserSession.UserType);
end;

procedure TFrmFilas.IWAppFormCreate(Sender: TObject);
begin
  inherited;

   if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmFilas.html') then
    TPS.Templates.Default := 'FrmFilas.html';

    Title                     := 'Filas e ChatBots';
    Subtitulo.Caption         := 'Filas e ChatBots';

    Filas := TFilas.Create;

    RegisterCallBack('ListaFilas', Get_Liste);
    RegisterCallBack('Actions', Actions );


end;

procedure TFrmFilas.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
   Filas.Free;
end;

procedure TFrmFilas.IWAppFormShow(Sender: TObject);
begin
  inherited;
   Load_Combobox_Conexoes(UserSession.CompanyId,whatsappId);
   Load_Combobox_Status(STATUS,True);
end;

procedure TFrmFilas.nameHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  inherited;
Atag.Add('placeholder=" Informe o Nome da Fila "');
end;

procedure TFrmFilas.STATUSAsyncChange(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
  ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
end;

end.

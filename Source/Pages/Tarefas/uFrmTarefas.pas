unit uFrmTarefas;

interface

uses
  Entidade.Tasks,
  Functions.DataBase,
  Dao.Tasks,
  uPopulaCrud,
  Functions.IW,
  Tipos.Types,
  Bootstrap.SweetAlert2,
  ServerController,
  System.SysUtils, System.Variants, System.Classes,
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, IWCompEdit, Vcl.Controls,
  IWCompListbox;

type
  TFrmTarefas = class(TFrmBase)
    NAME: TIWEdit;
    BTN_ADICONAR: TIWButton;
    id: TIWEdit;
    BTN_DELETE: TIWButton;
    STATUS: TIWComboBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTN_POSTAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTN_ADICONARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTN_DELETEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure STATUSAsyncChange(Sender: TObject; EventParams: TStringList);
  private
    { Private declarations }
    Tasks : TTasks;
    vResult : String;

    Procedure  Get_Liste(aParams: TStrings; out aResult: String);
    Procedure  Actions(EventParams: TStringList);

  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFrmTarefas.Actions(EventParams: TStringList);
begin


  if StrToIntDef(EventParams.Values['Edit'],0) > 0 then begin

     if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
     end;

     UserSession.Clipboard.Put('CHAVE_PK',StrToIntDef(EventParams.Values['Edit'],0) );
     Get_Tasks( StrToIntDef(EventParams.Values['Edit'],0), Tasks, vResult);
     TPopulateFromScreen<TTasks>.PopulateScreenFromObject(Tasks, Self);
     WebApplication.ExecuteJS('$(''#modal_adicionar'').modal(''show'');');
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

procedure TFrmTarefas.BTN_ADICONARAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
   end;

   ClearFields(Self);
   WebApplication.ExecuteJS('$(''#modal_adicionar'').modal(''show'');');

end;

procedure TFrmTarefas.BTN_DELETEAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
ID:Integer;
begin
  inherited;

   UserSession.Clipboard.Get('CHAVE_PK',ID);

   if Delete_Tasks(ID) then begin
      ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
   end;

end;

procedure TFrmTarefas.BTN_POSTAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

  if not ValidarCampo(Self, 'NAME', 0, False) then begin
         ShowMessage(WebApplication,'Atenção ',' O Campo Descrição, Deve Ser Preenchido',true,'NAME',350,Tperror);
         Exit;
  end;

 TPopulateFromScreen<TTasks>.PopulaObjeto(Tasks, Self);

 if Set_Tasks(Tasks.id,Tasks,vResult) then begin
    NAME.Clear;
    WebApplication.ExecuteJS('$(''#modal_adicionar'').modal(''hide'');');
    ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
 end;


end;

procedure TFrmTarefas.Get_Liste(aParams: TStrings; out aResult: String);
begin
 GetAll(UserSession.CompanyId, aParams,StrToIntDef(STATUS.SelectedValue,-1), aResult,UserSession.UserType);
end;

procedure TFrmTarefas.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmTarefas.html') then
       TPS.Templates.Default := 'FrmTarefas.html';

    Title                     := 'Tarefas';
    Subtitulo.Caption         := 'Tarefas /';


  RegisterCallBack('ListaTasks', Get_Liste);
  RegisterCallBack('Actions', Actions );

  Tasks := TTasks.Create;
  Load_Combobox_Status(STATUS,True);



end;

procedure TFrmTarefas.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
Tasks.Free;
end;

procedure TFrmTarefas.STATUSAsyncChange(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
end;

end.

unit uFrmAgendamentos;

interface

uses
    ServerController,
    Dao.Agendamentos,
    Entidade.Agendamentos,
    Tipos.Types,
    uBase,
    Functions.Strings,
    Functions.DataBase,
    IWVCLComponent,
    Bootstrap.SweetAlert2,
    Functions.IW,
    uPopulaCrud,
    IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
    IWTemplateProcessorHTML, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
    IWControl, IWCompButton, IWCompLabel, System.Classes, Vcl.Controls,
    IWCompMemo, IWCompEdit, IWCompListbox, IWCompCheckbox, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, IWCompExtCtrls;

type
  TFrmAgendamentos = class(TFrmBase)
    BTN_ADICONAR: TIWButton;
    descricao: TIWEdit;
    id: TIWEdit;
    body: TIWMemo;
    sentAt: TIWEdit;
    saveMessage: TIWCheckBox;
    BTN_DELETE: TIWButton;
    COMBO_ContactId: TIWSelect;
    STATUS: TIWSelect;
    procedure IWAppFormCreate(Sender: TObject);
    procedure BTN_ADICONARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTN_POSTAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure IWAppFormShow(Sender: TObject);
    procedure BTN_DELETEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure STATUS_oldAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure MONITORAENVIOAsyncEvent(Sender: TObject;
      EventParams: TStringList);
  private
    { Private declarations }
    Agendamentos:TAgendamentos;
    vResult      : String;
    Procedure  Get_Liste(aParams: TStrings; out aResult: String);
    Procedure  Actions(EventParams: TStringList);

  public
    { Public declarations }
  end;


implementation

uses
  System.SysUtils;

{$R *.dfm}

procedure TFrmAgendamentos.Actions(EventParams: TStringList);
begin

  if StrToIntDef(EventParams.Values['Edit'],0) > 0 then begin

     if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
     end;

   UserSession.Clipboard.Put('CHAVE_PK',StrToIntDef(EventParams.Values['Edit'],0) );
   Get_Agendamentos( StrToIntDef(EventParams.Values['Edit'],0), Agendamentos, vResult);
   TPopulateFromScreen<TAgendamentos>.PopulateScreenFromObject(Agendamentos, Self);
   sentAt.Text                     := FormatDateTime('dd/mm/yyyy HH:mm:ss',Agendamentos.sendAt);
   COMBO_ContactId.SelectedValue   := Agendamentos.contactId;
   WebApplication.ExecuteJS('$(''#modal_adicionar'').modal(''show'');');

  end;

  if StrToIntDef(EventParams.Values['Deletar'],0) > 0 then begin

     if UserSession.Profile = tpUser then begin
        ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Excluir',false,'',350,Tpinfo);
        Exit;
     end;

     UserSession.Clipboard.Put('Deletar',StrToIntDef(EventParams.Values['Edit'],0) );
     ExecuteJS(swalConfirm( 'EXCLUSÃO DE REGISTRO',
                       'Prezado Usuário Deseja EXCLUIR Este REGISTRO Agora?',
                       'error',
                       'SIM',
                       'NÃO',
                       'BTN_DELETE',
                       'BTNCANCELAR'));
  end;

end;

procedure TFrmAgendamentos.BTN_ADICONARAsyncClick(Sender: TObject;
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

procedure TFrmAgendamentos.BTN_DELETEAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
ID:Integer;
begin
  inherited;

   UserSession.Clipboard.Get('CHAVE_PK',ID);

   if Delete_Agendamentos(ID) then begin
      ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
   end;
end;

procedure TFrmAgendamentos.BTN_POSTAsyncClick(Sender: TObject;
  EventParams: TStringList);
  var
     DataAgendada: TDateTime;
begin
  inherited;

  if not ValidarCampo(Self, 'schedule_name', 0, False) then begin
         ShowMessage(WebApplication,'Atenção ',' O Campo Nome do Agendamento,Deve Ser Preenchido',true,'schedule_name',350,Tperror);
         Exit;
  end;

  if not ValidarCampo(Self, 'body', 0, False) then begin
         ShowMessage(WebApplication,'Atenção ',' O Campo Descrição, Deve Ser Preenchido',true,'body',350,Tperror);
         Exit;
  end;

  if not ValidarCampo(Self, 'sentAt', 0, False) then begin
         ShowMessage(WebApplication,'Atenção ',' O Campo Data do Agendamento, Deve Ser Preenchido',true,'SENTAT',350,Tperror);
         Exit;
  end;


  DataAgendada := StrToDateTimeDef(sentAt.Text, 0);

  if DataAgendada <= Now then begin
      ShowMessage(WebApplication,'Atenção ',' Preencha com uma Data e Maior que a Data /Hora Atual',true,'SENTAT',350,Tperror);
      Exit;
  end;

    TPopulateFromScreen<TAgendamentos>.PopulaObjeto(Agendamentos, Self);
    Agendamentos.contactId   := COMBO_CONTACTID.SelectedValue;
    Agendamentos.sendAt      := ParseBrazilianDateTime(sentAt.Text,Now);

  if Set_Agendamento(Agendamentos.id,Agendamentos,vResult) then begin
      WebApplication.ExecuteJS('$(''#modal_adicionar'').modal(''hide'');');
      ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
   end;


end;

procedure TFrmAgendamentos.Get_Liste(aParams: TStrings; out aResult: String);
begin
Get_Agendamento(UserSession.CompanyId,StrToIntDef(STATUS.SelectedValue,-1), aParams, aResult,UserSession.Profile);
end;

procedure TFrmAgendamentos.IWAppFormCreate(Sender: TObject);
begin
  inherited;

 if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmAgendamentos.html') then
  TPS.Templates.Default := 'FrmAgendamentos.html';

  Title                     := 'Agendamento';
  Subtitulo.Caption         := 'Agendamento /';
  RegisterCallBack('ListaAgendamentos', Get_Liste);
  RegisterCallBack('Actions', Actions );

  Agendamentos := TAgendamentos.Create;

 end;

procedure TFrmAgendamentos.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
Agendamentos.Free;
end;

procedure TFrmAgendamentos.IWAppFormShow(Sender: TObject);
begin
  inherited;
  Load_ComboboxContact(UserSession.CompanyId,COMBO_ContactId);
  Load_Combobox_Status_Select(STATUS,False);
end;

procedure TFrmAgendamentos.MONITORAENVIOAsyncEvent(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
 //ExecuteJS('$(''#Lista'').DataTable().ajax.reload(null, false);');
 //MONITORAENVIO.Enabled  := True;
end;

procedure TFrmAgendamentos.STATUS_oldAsyncChange(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
end;

end.

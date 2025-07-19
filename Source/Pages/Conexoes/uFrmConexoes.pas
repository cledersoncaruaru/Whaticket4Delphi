unit uFrmConexoes;

interface

uses
  ServerController,
  IWJsonDataObjects,
  Integracao.Evolution.CreateInstance,
  Dao.Conexao,
  Entidade.Conexao,
  Integracao.API.Evolution,
  Functions.Strings,
  uPopulaCrud,
  Tipos.Types,
  Bootstrap.SweetAlert2,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Functions.IW,
  Functions.Rest,
  uBase, IWVCLComponent,
  Functions.DataBase,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, Vcl.Controls, IWCompEdit,
  IWCompMemo, IWCompListbox, IWCompCheckbox, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, IWCompExtCtrls;

type
  TFrmConexoes = class(TFrmBase)
    NAME: TIWEdit;
    GREETINGMESSAGE: TIWMemo;
    OUTOFHOURSMESSAGE: TIWMemo;
    RATINGMESSAGE: TIWMemo;
    instanceid: TIWEdit;
    SENDIDQUEUE: TIWComboBox;
    TIMESENDQUEUE: TIWComboBox;
    ISDEFAULT: TIWCheckBox;
    BTN_ADICIONAR: TIWButton;
    NUMBER: TIWEdit;
    QRCODE: TIWLabel;
    BTN_DELETE: TIWButton;
    CONTADOR: TIWLabel;
    PAIRINGCODE: TIWLabel;
    IWQrCode: TIWTimer;
    COMPLATIONMESSAGE: TIWMemo;
    BTN_MODAL_FECHAR: TIWButton;
    FILAS: TIWSelect;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTN_ADICIONARAsyncClick(Sender: TObject;
      EventParams: TStringList);
    procedure BTN_POSTAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTN_DELETEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWQrCodeAsyncTimer(Sender: TObject; EventParams: TStringList);
    procedure BTN_MODAL_FECHARAsyncClick(Sender: TObject;
      EventParams: TStringList);
    procedure IWAppFormShow(Sender: TObject);

  private
    { Private declarations }

      Conexao       : TConexao;
      vResult       : String;
      EvolutionAPI  : TEvolutionAPI;
      Instancia     : TIntegracaoEvolution;
      Status,Msg,vQrCode:String;
      vName: String;
      vPairingCode:String;
      vContador:Integer;


      Procedure  Get_Liste(aParams: TStrings; out aResult: String);
      Procedure  Actions(EventParams: TStringList);

      Function Salvar:Boolean;


  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFrmConexoes.Actions(EventParams: TStringList);
var
  I: Integer;

begin

  if StrToIntDef(EventParams.Values['Edit'],0) > 0 then begin

     if UserSession.Profile = tpUser then begin
        ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
        Exit;
     end;

      Conexao.id        := StrToIntDef(EventParams.Values['Edit'],0);
      Get_Whatsapps(Conexao.id,Conexao,vResult);
      TPopulateFromScreen<TConexao>.PopulateScreenFromObject(Conexao, Self);
      NAME.Enabled        := False;
      NUMBER.Enabled      := False;
      instanceid.Enabled  := False;
      ExecuteJS('$(''#modal_adicionar_conexao'').modal(''show'');');

      FILAS.SelectedValue    := Get_Whatsapps_Queues(Conexao.id);

   end;

  if StrToIntDef(EventParams.Values['Excluir'],0) > 0 then begin

     if UserSession.Profile = tpUser then begin
        ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Excluir',false,'',350,Tpinfo);
        Exit;
     end;

     UserSession.Clipboard.Put('ID_CONEXAO', StrToIntDef(EventParams.Values['Excluir'],0)) ;
     UserSession.Clipboard.Put('NAME',EventParams.Values['Name']) ;

     ExecuteJS(swalConfirm( 'EXCLUSÃO DE REGISTRO',
                           'Prezado Usuário Deseja EXCLUIR Este REGISTRO Agora?',
                           'error',
                           'SIM',
                           'NÃO',
                           'BTN_DELETE',
                           'BTNCANCELAR'));
  end;

  if StrToIntDef(EventParams.Values['Status'],0) > 0 then begin
      UserSession.Clipboard.Put('ID_CONEXAO', StrToIntDef(EventParams.Values['Excluir'],0)) ;
      vName  := EventParams.Values['Name'];

    if EvolutionAPI.Status_Conexao(vName,Status) then begin
       UpdateSuatus_Whatsapps(vName,Status, Msg);
       ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
    end;

  end;

  if StrToIntDef(EventParams.Values['QrCode'],0) > 0 then begin
      UserSession.Clipboard.Put('NameInstancia',EventParams.Values['Name']);
      vName  := EventParams.Values['Name'];
      IWQrCode.Enabled  := True;

  end;

end;

procedure TFrmConexoes.BTN_ADICIONARAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
   end;

  Conexao.id  := 0;
  ClearFields(Self);
  ExecuteJS('$(''#modal_adicionar_conexao'').modal(''show'');');
end;

procedure TFrmConexoes.BTN_DELETEAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
ID_Exclusao       : Integer;
Msg,NameInstance  : String;
begin
  inherited;

  UserSession.Clipboard.Get('ID_CONEXAO', ID_Exclusao,True) ;
  UserSession.Clipboard.Get('NAME',NameInstance,True) ;

  if EvolutionAPI.DeleteInstance(NameInstance,Msg) then  begin

  Delete_Whatsapps(ID_Exclusao,Msg);
  ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
  end;

end;

procedure TFrmConexoes.BTN_MODAL_FECHARAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
   IWQrCode.Enabled  := False;
end;

procedure TFrmConexoes.BTN_POSTAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
   Salvar;
end;

procedure TFrmConexoes.Get_Liste(aParams: TStrings; out aResult: String);
begin
 GetAll(UserSession.CompanyId, aParams, aResult,UserSession.UserType);
end;

procedure TFrmConexoes.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmConexoes.html') then
       TPS.Templates.Default := 'FrmConexoes.html';

        Title                     := 'Conexões';
        Subtitulo.Caption         := 'Conexões /';

        RegisterCallBack('ListaConexoes', Get_Liste);
        RegisterCallBack('Actions', Actions );

        Conexao       := TConexao.Create;
        EvolutionAPI  := TEvolutionAPI.Create(UserSession.Conexao);
        Instancia     := TIntegracaoEvolution.Create;
end;

procedure TFrmConexoes.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
   Conexao.Free;
   EvolutionAPI.Free;
   Instancia.Free;
end;

procedure TFrmConexoes.IWAppFormShow(Sender: TObject);
begin
  inherited;
  Load_Combobox_Filas(UserSession.CompanyId,FILAS);
end;

procedure TFrmConexoes.IWQrCodeAsyncTimer(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
  Inc(vContador);

  UserSession.Clipboard.Get('NameInstancia',vName,False);
  EvolutionAPI.Status_Conexao(vName,Status);
  WebApplication.ExecuteJS('HoldOn.close();');
  CONTADOR.Text  := vContador.ToString;

  if Status = 'Desconectado' then begin
     WebApplication.ExecuteJS('$(''#modal_qrcode'').modal(''show'');');

    if EvolutionAPI.Conect_Conexao(vName,Msg,vQrCode,vPairingCode) then begin

        if vPairingCode <> '' then begin
         PAIRINGCODE.Visible  := True;
       end
       else
       begin
         PAIRINGCODE.Visible  := True;
       end;

        QRCODE.Text   :=   '<img src='+vQrCode+' alt="QrCode" />';
    end;

  end
  else if Status = 'Conectado' then
  begin
    UpdateSuatus_Whatsapps(vName,Status, Msg);
    WebApplication.ExecuteJS('$(''#modal_qrcode'').modal(''hide'');');
  end;

end;

function TFrmConexoes.Salvar: Boolean;
var
Content,Temp            : String;
Msg,Status,vPairingCode : String;
Root                    : TJsonObject;
Lista                   : TStringList;
begin

  Result := False;

  TPopulateFromScreen<TConexao>.PopulaObjeto(Conexao, Self);
  Conexao.Companyid      := UserSession.CompanyId;
  Conexao.queueid        := StrToIntDef(Filas.SelectedValue,-1);
  Root                   := nil;
  Lista                  := TStringList.Create;
  Lista.Delimiter        := ',';
  Lista.StrictDelimiter  := True;
  Lista.DelimitedText    := FILAS.SelectedValue;


 try

    if Conexao.id > 0 then begin

       if Set_Whatsapps(Conexao.id,Conexao, vResult,Lista) then begin
        Result := True;
        WebApplication.ExecuteJS('HoldOn.close();');
        WebApplication.ExecuteJS(swalAlert('SUCESSO','Registro Gravado Com Sucesso','BTN_NOVO',350,Tpsuccess));
        WebApplication.ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
        WebApplication.ExecuteJS('$(''#modal_adicionar_conexao'').modal(''hide'');');

       end
       else
       begin
         WebApplication.ExecuteJS(swalAlert('Error',vResult,'BTN_NOVO',350,Tperror));
         exit;
       end;

    end
    else
    begin

      if EvolutionAPI.Set_CriateInstance(Conexao.Name,Conexao.NUMBER,Content) then begin

        Root                  := TJsonObject.Parse(Content) as TJsonObject;

        Conexao.Session       := Content;
        Conexao.name          := Root.O['instance'].S['instanceName'];
        Conexao.instanceid    := Root.O['instance'].S['instanceId'];
        Conexao.apikey        := Root.S['hash'];
        Conexao.token         := Root.S['hash'];
        Conexao.integration   := Root.O['instance'].S['integration'];
        PAIRINGCODE.Text      := Root.O['qrcode'].S['pairingCode'];
        Conexao.qrcode        := Root.O['qrcode'].S['base64'];
        Conexao.status        := Root.O['qrcode'].S['status'];

       if Set_Whatsapps(Conexao.id,Conexao, vResult,Lista) then begin
         Result := True;
         UserSession.Clipboard.Put('NameInstancia',Conexao.name);

         UserSession.InstanceName           := Conexao.name ;
         UserSession.Token                  := Conexao.token;
         WebApplication.ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
         QRCODE.Text    := '<img src='+Conexao.qrcode+' alt="QrCode" />';
         WebApplication.ExecuteJS('$(''#modal_adicionar_conexao'').modal(''hide'');');
         IWQrCode.Enabled   := True;
         WebApplication.ExecuteJS('HoldOn.close();');
       end;

      end
      else
      begin
       WebApplication.ExecuteJS(swalAlert('ERROR',TratarMensagemSweetAlert(Content),'BTN_NOVO',450,Tperror));
      end;

    end;

   if EvolutionAPI.Status_Conexao(Conexao.Name,Status) then begin

      UpdateSuatus_Whatsapps(Conexao.Name,Status, Msg);
      if Status = 'Desconectado' then begin
       ExecuteJS('$(''#modal_qrcode'').modal(''show'');');
      end;

   end;

   ExecuteJS('HoldOn.close();');

 finally
 Root.Free;
 Lista.Free;
 end;

end;

end.

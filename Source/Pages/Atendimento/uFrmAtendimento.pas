unit uFrmAtendimento;

interface

uses
  Dao.Messages,
  ServerController,
  System.SysUtils,
  Integracao.API.Evolution,
  Dao.Conexao,
  uBase, IWVCLComponent,
  IWBaseForm,
  IW.IWP.Content,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompButton, IWCompLabel, IWCompEdit, IWCompListbox, IWCompMemo,
  System.Classes, Controls, IWBaseComponent, IWBaseHTMLComponent,
  IWBaseHTML40Component, IWCompExtCtrls,
  IWAppForm, IWApplication,Winapi.Windows,IdContext,Data.DB,
  Datasnap.DBClient, Datasnap.Win.MConnect, Datasnap.Win.SConnect,
  Dao.ProcessaMensagem,
  functions.Rest,
  Tipos.Types,
  system.JSON, IWCompFileUploader,
  IW.Common.AppInfo,
  System.Generics.Collections;

type
  TFrmAtendimento = class(TFrmBase)
    MEMOCHAT: TIWMemo;
    BTN_CRIAR: TIWButton;
    COMBO_FILAS: TIWComboBox;
    IWLabel1: TIWLabel;
    IWEdit1: TIWEdit;
    IWComboBox1: TIWComboBox;
    IWComboBox2: TIWComboBox;
    IWComboBox3: TIWComboBox;
    ATENDIMENTO_COUNT: TIWLabel;
    AGUARDANDO_COUNT: TIWLabel;
    CARDATENDIMENTO: TIWLabel;
    CARDAGUARDANDO: TIWLabel;
    CAR_CHAT_TOP: TIWLabel;
    LABEL_CHAT: TIWLabel;
    BTN_RETORNA: TIWButton;
    BTN_RESOLVER: TIWButton;
    BTN_OPCOES: TIWButton;
    BTN_ENVIAR: TIWButton;
    MONITORAMENSAGEM: TIWMonitor;
    EDT_MESSAGE_: TIWEdit;
    EDT_MESSAGE: TIWMemo;
    BTN_ATUALIZAR_MENSAGENS: TIWButton;
    MENSAGEM_UPDATE: TIWLabel;
    SocketConnection1: TSocketConnection;
    UPFILE: TIWFileUploader;
    LISTA_UPLOAD: TIWLabel;
    CARDRESOLVIDOS: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormShow(Sender: TObject);
    procedure BTN_RETORNAAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure Btn_EnviarAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure MONITORAMENSAGEMAsyncEvent(Sender: TObject;
      EventParams: TStringList);
    procedure EDT_MESSAGE_AsyncKeyPress(Sender: TObject;
      EventParams: TStringList);
    procedure EDT_MESSAGEAsyncKeyPress(Sender: TObject;
      EventParams: TStringList);
    procedure IWAppFormRender(Sender: TObject);
    procedure IWAppFormAsyncPageLoaded(Sender: TObject;
      EventParams: TStringList);
    procedure UPFILEAsyncUploadCompleted(Sender: TObject; var DestPath,
      FileName: string; var SaveFile, Overwrite: Boolean);
    procedure UPFILEAsyncUploadSuccess(Sender: TObject;
      EventParams: TStringList);

  private
    { Private declarations }
    var
    TotalAtendimento,TotalAguardando  : String;
    vCardAtendimento,vCardAguardando  : String;
    vCardResolvidos                   : String;
    RemoteJID                         : String;
    ContactId                         : String;
    DaoMessages                       : TDaoMessages;
    EvolutionAPI                      : TEvolutionAPI;
    FMsgThread                        : TThread;
    NomeArquivo                       : String;
    CurDir                            : string;
    ListaUploads                      : TStringList;
    TabIndex                          : Integer;


    Procedure  Actions(EventParams: TStringList);
    function   Get_Dados:Boolean;
    function   Get_Mensagem(ContactId:String):Boolean;
    Procedure  AjustaCampoMensagem;
    procedure  ProcessaMensagemAtualizacao(EventParams: TStringList);
    function   MontaListaArquivos:String;
    function   EnviarMensagem:Boolean;


  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TFrmAtendimento.Actions(EventParams: TStringList);
var
UserId      : Integer;
NomeArquivo : String;
begin

  if StrToIntDef(EventParams.Values['Aceitar'],0) > 0 then begin
        UserSession.Clipboard.Get('Loguin_id',UserId,False);
        DaoMessages.Set_Aceita_Ticket(StrToIntDef(EventParams.Values['Aceitar'],0), UserId);
        Get_Dados;
        WebApplication.ExecuteJS('$(''button[data-bs-target="#_dm-pillsAtendimento"]'').click();')
  end;

  if StrToIntDef(EventParams.Values['Finalizar'],0) > 0 then begin
       UserSession.Clipboard.Get('Loguin_id',UserId,False);
       DaoMessages.Set_Finaliza_Ticket(StrToIntDef(EventParams.Values['Finalizar'],0),UserId );
       Get_Dados;
  end;

   if EventParams.Values['Atualizar'] = 'Sim' then begin
      Get_Dados;
  end;


  if StrToIntDef(EventParams.Values['SelecionaCard'],0) > 0 then begin

   ContactId              := EventParams.Values['SelecionaCard'];
   Get_Mensagem(ContactId);

  end;

  if EventParams.Values['ExcluiArquivo'] <> '' then begin
     NomeArquivo:= ListaUploads.ValueFromIndex[StrToIntDef(EventParams.Values['ExcluiArquivo'],0)] ;
     ListaUploads.Delete(StrToIntDef(EventParams.Values['ExcluiArquivo'],0));
     if FileExists(NomeArquivo) then begin
         System.SysUtils.DeleteFile(NomeArquivo);
     end;
     MontaListaArquivos;
  end;

  if EventParams.Values['TabIndex'] <> '' then begin

     TabIndex   := StrToIntDef(EventParams.Values['TabIndex'],0);

     case TabIndex of

     1 : begin
            ExecuteJS('document.getElementById(''barra-inferior'').style.pointerEvents = ''auto'';') ;
            ExecuteJS('document.getElementById(''barra-inferior'').style.opacity = ''1'';');
         end;

      2,3,5 : begin
              ExecuteJS('document.getElementById(''barra-inferior'').style.pointerEvents = ''none'';') ;
              ExecuteJS('document.getElementById(''barra-inferior'').style.opacity = ''0.5'';');

              end;
     end;
  end;


end;

procedure TFrmAtendimento.AjustaCampoMensagem;
 var
  JS: string;
begin

    if Trim(EDT_MESSAGE.Text) = '' then begin

      JS :=
      'var ta = document.getElementById("EDT_MESSAGE");' +
      'if (ta) {' +
      '  ta.value = "";' +       // limpa o conteúdo
      '  ta.rows = 1;' +         // volta pra 1 linha
      '  ta.style.height = "";' +// remove o height inline
      '}';

     WebApplication.ExecuteJS( JS );

    end
    else begin


      JS :=
    'var ta = document.getElementById("EDT_MESSAGE");' +
    'if (ta) {' +
    '  ta.style.overflow = "hidden";' +
    '  ta.style.resize = "none";' +
    '  ta.oninput = function() {' +
    '    this.style.height = "auto";' +
    '    this.style.height = this.scrollHeight + "px";' +
    '  };' +
    '}';


    end;

   ExecuteJS(JS);

end;

procedure TFrmAtendimento.Btn_EnviarAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
    EnviarMensagem;
end;

procedure TFrmAtendimento.BTN_RETORNAAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
ContactId : Integer;
begin
  inherited;
   UserSession.Clipboard.Get('ContactId',ContactId,True);
   DaoMessages.Set_Retorna_Ticket(ContactId);
   Get_Dados;
end;



procedure TFrmAtendimento.EDT_MESSAGEAsyncKeyPress(Sender: TObject;
  EventParams: TStringList);
  var
 Key :Integer;
  ShiftMask: String;
  ShiftPressed: Boolean;
begin
  inherited;

  Key := StrToIntDef(EventParams.Values['which'],0);

  ShiftMask     := EventParams.Values['modifiers'];
  if ( ShiftMask = 'SHIFT_MASK' ) and ( key = 13 ) then begin
      AjustaCampoMensagem;

  end
  else if ( ShiftMask = '' ) and ( key = 13 ) then begin
      Btn_EnviarAsyncClick(Sender,EventParams);

  end;

end;

procedure TFrmAtendimento.EDT_MESSAGE_AsyncKeyPress(Sender: TObject;
  EventParams: TStringList);
  var
  Key          : Integer;
  ShiftMask    : String;
  ShiftPressed : Boolean;
begin
  inherited;

  Key := StrToIntDef(EventParams.Values['which'],0);

  if key > 0 then
   begin
     WebApplication.ShowMessage(key.tostring+' - Detectei Shift+Enter no KeyUp');
   end;

    ShiftMask     := EventParams.Values['modifiers'];
    if ( ShiftMask = 'SHIFT_MASK' ) and ( key = 13 ) then
        WebApplication.ShowMessage('Shift está pressionado');

end;


function TFrmAtendimento.EnviarMensagem: Boolean;
var
Number            : String;
ProcessaMensagem  : TProcessaMensagem;
Json              : String;
begin
  inherited;

  if Trim(EDT_MESSAGE.Text) <> '' then begin
     Number  := Trim( StringReplace(RemoteJID,'@s.whatsapp.net','',[rfReplaceAll]) );

     if Number = '' then begin
        // iwtosatnotification
        exit;
     end;

    if EvolutionAPI.Envia(UserSession.InstanceName,Number,Trim(EDT_MESSAGE.Text),ListaUploads,Json) then begin

       EDT_MESSAGE.Clear;
       ListaUploads.Clear;
       Get_Mensagem(ContactId);

       try

        ProcessaMensagem             := TProcessaMensagem.Create(Json);

        ProcessaMensagem.Set_Envio_Zap(Json);
        AjustaCampoMensagem;
        ExecuteJS('$(''#uploadModal'').modal(''hide'');');
       finally
       ProcessaMensagem.Free;
       MontaListaArquivos;
       end;

    end;

  end;

end;

function TFrmAtendimento.Get_Dados: Boolean;
var
vATENDIMENTO_COUNT,vAGUARDANDO_COUNT:Integer;
sATENDIMENTO_COUNT,sAGUARDANDO_COUNT:String;
begin

  DaoMessages.Get_Total_Tickets(sATENDIMENTO_COUNT,sAGUARDANDO_COUNT);
  DaoMessages.Get_Monta_Card_Aguardando(vCardAtendimento,vCardAguardando, vCardResolvidos);

  UserSession.Clipboard.Get('remoteJid',RemoteJID,True);
  UserSession.Clipboard.Get('ContactId',ContactId,True);



  ATENDIMENTO_COUNT.Text    := sATENDIMENTO_COUNT;
  AGUARDANDO_COUNT.Text     := sAGUARDANDO_COUNT;
  CARDATENDIMENTO.Text      := vCardAtendimento;
  CARDAGUARDANDO.Text       := vCardAguardando;
  CARDRESOLVIDOS.Text       := vCardResolvidos;
  CAR_CHAT_TOP.Text         := DaoMessages.Get_Card_Dados_Top('',RemoteJID);

end;

function TFrmAtendimento.Get_Mensagem(ContactId:String): Boolean;
begin

   UserSession.Clipboard.Put('ContactId',StrToIntDef(ContactId,0));
   CAR_CHAT_TOP.Text      := DaoMessages.Get_Card_Dados_Top(ContactId,RemoteJID);
   LABEL_CHAT.Text        := DaoMessages.Get_ChatByContactId(RemoteJID);

end;

procedure TFrmAtendimento.IWAppFormAsyncPageLoaded(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   DaoMessages.Update_Mensagens_Servidor(Get_TokenByIDCompany(UserSession.CompanyId));
   ExecuteJS('HoldOn.close();');
   MONITORAMENSAGEM.Enabled  := True;
   WebApplication.Status.Value := 100;
end;

procedure TFrmAtendimento.IWAppFormCreate(Sender: TObject);
var
 companyId : Integer;
begin
  inherited;

  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmAtendimento.html') then
      TPS.Templates.Default     := 'FrmAtendimento.html';
      Title                     := 'Atendimento';
      Subtitulo.Caption         := 'Atendimento /';
      RegisterCallBack('Action', Actions );

      EvolutionAPI          := TEvolutionAPI.Create(UserSession.Conexao);
      EvolutionAPI.ApiKey   := UserSession.Token;
      MENSAGEM_UPDATE.Text  := '';

      UserSession.Clipboard.Get('companyId',companyId,False );
      DaoMessages               := TDaoMessages.Create(companyId);
//      MONITORAMENSAGEM.Enabled  := True;
//      WebApplication.Status.Value := 100;

      RegisterCallBack('ProcessMessages',ProcessaMensagemAtualizacao);

      LABEL_CHAT.Caption           := '';
      LISTA_UPLOAD.Text            := '';
      ListaUpLoads                 := TStringList.Create;

end;

procedure TFrmAtendimento.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
  DaoMessages.Free;
  EvolutionAPI.Free;
  ListaUpLoads.Free;

end;

procedure TFrmAtendimento.IWAppFormRender(Sender: TObject);
begin
  inherited;
AjustaCampoMensagem;

end;

procedure TFrmAtendimento.IWAppFormShow(Sender: TObject);
begin
  inherited;
  ExecuteJS('chamaMsgHoldon(''Aguarde,Sincronizando as Mensagens com o Servidor...'')');
  Get_Dados;
end;


procedure TFrmAtendimento.MONITORAMENSAGEMAsyncEvent(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;
 Get_Mensagem(ContactId);
 MONITORAMENSAGEM.Enabled  := True;
end;

function TFrmAtendimento.MontaListaArquivos: String;
var
Lista:TStringList;
I:integer;
begin


  Lista:= TStringList.Create;

  try

     for i := 0 to ListaUpLoads.Count -1  do
    begin

      Lista.Add(


      '<div class="LISTA_UPLOADCSS" id="LISTA_UPLOAD" title="" style="display: flex; align-items: center; ">   '+
      '  <div class="file-icon">                                                                                        '+
      '    <i class="fa-solid fa-folder-open"></i>                                                                      '+
      '  </div>                                                                                                         '+
      '  <button class="remove-file" onclick="ajaxCall(''Action'', ''ExcluiArquivo='+I.ToString+''')">                  '+
      '    <i class="fa-solid fa-trash-can"></i>                                                                        '+
      '  </button>                                                                                                      '+
      '  <div class="file-info">                                                                                        '+
      '    <div class="file-name">'+ListaUploads.Names[i]+'</div>                                                       '+
      '  </div>                                                                                                         '+
      '</div>                                                                                                           '

      )

    end;

    LISTA_UPLOAD.Text   :=  Lista.Text;

  finally
  Lista.Free;
  end;

end;

procedure TFrmAtendimento.ProcessaMensagemAtualizacao(EventParams: TStringList);
begin
     MENSAGEM_UPDATE.Text    := Params.Values['contador'];
end;

procedure TFrmAtendimento.UPFILEAsyncUploadCompleted(Sender: TObject;
  var DestPath, FileName: string; var SaveFile, Overwrite: Boolean);
begin
  inherited;

  CurDir        := TIWAppInfo.GetAppPath + 'Files\Cliente\'+UserSession.InstanceName+'\'+ContactId+'\';

  if not DirectoryExists(CurDir) then
         ForceDirectories(CurDir);

  UPFILE.StartUpload;
  UPFILE.SaveToFile(FileName, CurDir + FileName, True);
  NomeArquivo         := FileName;
  SaveFile            := True;

end;

procedure TFrmAtendimento.UPFILEAsyncUploadSuccess(Sender: TObject;
  EventParams: TStringList);
var
I:Integer;
begin
  inherited;
  ListaUploads.Values[NomeArquivo] := CurDir + NomeArquivo;
  MontaListaArquivos;
end;

end.

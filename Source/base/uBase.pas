unit uBase;

interface

uses
  App.Config,
  Bootstrap.SweetAlert2,
  ServerController,
  Functions.IW,
  Integracao.Discord,
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML,System.StrUtils, Vcl.Controls, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompButton, IWCompLabel;

type
  TFrmBase = class(TIWAppForm)
    TPS: TIWTemplateProcessorHTML;
    BTN_POST: TIWButton;
    BTN_CANCEL: TIWButton;
    Subtitulo: TIWLabel;
    TITULO: TIWLabel;
    BTNENCERRAR: TIWButton;
    procedure IWAppFormCreate(Sender: TObject);
    procedure TPSUnknownTag(const AName: string; var VValue: string);
    procedure BTNENCERRARAsyncClick(Sender: TObject; EventParams: TStringList);
  public

  Procedure Menu(EventParams: TStringList);
  procedure GetSessionList;

  end;

implementation

{$R *.dfm}

uses  uFrmLogin, uFrmSettings, Database.DAO.Menu, Tipos.Types,
  uFrmAgendamentos, uFrmAtendimento, uFrmContatos, uFrmTags, uFrmFilas,
  uFrmRespostas, uFrmKanban, uFrmTarefas, uFrmChat, uFrmAjuda, uFrmDashboard,
  uFrmInformativo, uFrmConexoes, uFrmUsuario, uFrmConfiguracoes;


procedure TFrmBase.BTNENCERRARAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
UserSession.Conexao.Connected            := False;
UserSession.ConexaoEvolution.Connected   := True;
Self.Release;
WebApplication.Terminate;
end;

procedure TFrmBase.GetSessionList;
var
  LSessionList  : TStringList;
  i             : Integer;
  Msg           : String;
begin

  LSessionList := TStringList.Create;

  try
    gSessions.GetList(LSessionList);

    Msg := 'Qte:'+LSessionList.Count.ToString +slineBreak;


    for i := 0 to LSessionList.Count - 1 do begin
      gSessions.Execute(LSessionList[i],
        procedure(aSession: TObject)
        var
          LSession: TIWApplication absolute aSession;
        begin


            Msg := Msg +
            'Session ID: ' + LSession.AppId +slineBreak+
            'Last access time: ' + DateTimeToStr(LSession.LastAccess)+slineBreak+
            'Clique no link para encerrar http://localhost:3001/?encerrar='+LSession.AppId;

        end
      );
    end;


   UserSession.DiscordLogger.SendLog('titulo','padrao','encerrar a sessão - ',Msg);

  finally

    LSessionList.Free;
  end;

end;

procedure TFrmBase.IWAppFormCreate(Sender: TObject);
begin

  RegisterCallBack('Menu',Menu);

  if self.Name = 'FrmLogin' then begin

     TPS.Templates.Default := '/FrmLogin.html';

  end else begin

    TPS.MasterTemplate          := '/master.html';
    TPS.Templates.Default       := '/'+self.Name+'.html';

  end;

  GetSessionList;

end;

procedure TFrmBase.Menu(EventParams: TStringList);
var
 vFormname, Page : string;
begin


  Page  := UpperCase(EventParams.Values['page']);


     case AnsiIndexStr(Page,['FRMLOGIN',
                             'FRMATENDIMENTO',         //1
                             'FRMRESPOSTAS',           //2
                             'FRMKANBAN',              //3
                             'FRMTAREFAS',             //4
                             'FRMCONTATOS',            //5
                             'FRMAGENDAMENTOS',        //6
                             'FRMTAGS',                 //7
                             'FRMCHAT',                //8
                             'FRMAJUDA',               //9
                             'FRMDASHBOARD',           //10
                             'FRMINFORMATIVO',        //11
                             'FRMCONEXOES',          //12
                             'FRMFILAS',               //13
                             'FRMUSUARIO',           //14
                             'API',                //15
                             'FINANCEIRO',            //16
                             'FRMCONFIGURACOES']) of  //17



     0  : WebApplication.ShowForm(TFrmLogin,True,True);
     1  : WebApplication.ShowForm(TFrmAtendimento,True,True);
     2  : WebApplication.ShowForm(TFrmRespostas,True,True);
     3  : WebApplication.ShowForm(TFrmKanban,True,True);
     4  : WebApplication.ShowForm(TFrmTarefas,True,True);
     5  : WebApplication.ShowForm(TFrmContatos,True,True);
     6  : WebApplication.ShowForm(TFrmAgendamentos,True,True);
     7  : WebApplication.ShowForm(TFrmTags,True,True);
     8  : WebApplication.ShowForm(TFrmChat,True,True);
     //9  : WebApplication.ShowForm(TFrmAjuda,True,True);
     10 : WebApplication.ShowForm(TFrmDashboard,True,True);
     11 : WebApplication.ShowForm(TFrmInformativo,True,True);
     12 : WebApplication.ShowForm(TFrmConexoes,True,True);
     13 : WebApplication.ShowForm(TFrmFilas,True,True);
     14 : WebApplication.ShowForm(TFrmUsuario,True,True);
     17 : WebApplication.ShowForm(TFrmConfiguracoes,True,True);

    end;

end;

procedure TFrmBase.TPSUnknownTag(const AName: string; var VValue: string);
begin
   {$region 'Globais'}

  if UpperCase(AName) = UpperCase('Menu') then
     VValue := Get_Menu(Self.Name, UserSession.UserType);

  if UpperCase(AName) = UpperCase('TITLEHEADER') then
     VValue := 'Olá '+UserSession.Username+' ,'+' Bem Vindo a Empresa  '+UserSession.CompanyName+' ( Ativo até '+DateTimeToStr(UserSession.DueDate)+' )';

  if AName = 'NOME_USUARIO' then
     VValue := UserSession.Username;

  if AName = 'EMAIL_USUARIO' then
     VValue := UserSession.UserEmail;

  if AName = 'AppName' then
     VValue := UserSession.AppName;

  if AName = 'NOMESISTEMA' then
     VValue := AppConfig.NomeSistema;

  if AName = 'DESCRICAOSISTEMA' then
     VValue := AppConfig.DescricaoSistema;

  {$endregion}

end;

end.

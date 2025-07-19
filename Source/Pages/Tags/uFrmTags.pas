unit uFrmTags;

interface

uses
  ServerController,
  Entidade.Tags,
  Dao.Tags,
  Tipos.Types,
  uPopulaCrud,
  Functions.DataBase,
  Functions.IW,
  Bootstrap.SweetAlert2,
  System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  uBase, IWVCLComponent,
  IWBaseLayoutComponent, IWBaseContainerLayout, IWContainerLayout,
  IWTemplateProcessorHTML, IWCompLabel, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompButton, Vcl.Controls, IWCompCheckbox,
  IWCompEdit,IWHTMLTag, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client,system.JSON, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, IWCompExtCtrls, IWCompListbox;

type
  TFrmTags = class(TFrmBase)
    BTN_ADICONAR: TIWButton;
    color: TIWEdit;
    kanban: TIWCheckBox;
    name: TIWEdit;
    id: TIWEdit;
    BTN_DELETE: TIWButton;
    STATUS: TIWComboBox;
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTN_ADICONARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure nameHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
    procedure BTN_POSTAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormShow(Sender: TObject);
    procedure BTN_DELETEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure STATUSAsyncChange(Sender: TObject; EventParams: TStringList);
  private
    { Private declarations }
    Tags    : TTags;
    vResult : String;

    Procedure  Get_Liste(aParams: TStrings; out aResult: String);
    Procedure  Actions(EventParams: TStringList);

  public
    { Public declarations }
  end;

implementation



{$R *.dfm}

procedure TFrmTags.Actions(EventParams: TStringList);
begin

  if StrToIntDef(EventParams.Values['Edit'],0) > 0 then begin

     if UserSession.Profile = tpUser then begin
        ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
        Exit;
     end;

   UserSession.Clipboard.Put('CHAVE_PK',StrToIntDef(EventParams.Values['Edit'],0) );
   Get_Tags( StrToIntDef(EventParams.Values['Edit'],0), Tags, vResult);
   TPopulateFromScreen<TTags>.PopulateScreenFromObject(Tags, Self);
   ExecuteJS('$(''#modal_adicionar_tags'').modal(''show'');');
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

procedure TFrmTags.BTN_ADICONARAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

   if UserSession.Profile = tpUser then begin
      ShowMessage(WebApplication,'ATENÇÃO','Você Não Tem Permisão de Alterar/Modificar/Criar',false,'',350,Tpinfo);
      Exit;
   end;

   ClearFields(Self);
   ExecuteJS('$(''#modal_adicionar_tags'').modal(''show'');');
end;

procedure TFrmTags.BTN_DELETEAsyncClick(Sender: TObject;
  EventParams: TStringList);
var
ID:Integer;
begin
  inherited;

   UserSession.Clipboard.Get('CHAVE_PK',ID);

   if Delete_Tags(ID) then begin
      ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
   end;

end;

procedure TFrmTags.BTN_POSTAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  inherited;

  if not ValidarCampo(Self, 'NAME', 0, False) then begin
         ShowMessage(WebApplication,'Atenção ',' O Campo Descrição, Deve Ser Preenchido',true,'NAME',350,Tperror);
         Exit;
  end;

   TPopulateFromScreen<TTags>.PopulaObjeto(Tags, Self);

  if Set_Tags(Tags.id,Tags,vResult) then begin
      ExecuteJS('$(''#modal_adicionar_tags'').modal(''hide'');');
      ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
   end;

end;

procedure TFrmTags.Get_Liste(aParams: TStrings; out aResult: String);
begin
GetAll(UserSession.CompanyId, StrToIntDef(STATUS.SelectedValue,-1), aParams,aResult,UserSession.UserType);
end;

procedure TFrmTags.IWAppFormCreate(Sender: TObject);
begin
  inherited;

  if ( TPS.Templates.Default ='') or (TPS.Templates.Default<> 'FrmTags.html') then
       TPS.Templates.Default     := 'FrmTags.html';
       Title                     := 'Tags';
       Subtitulo.Caption         := 'Tags /';

    RegisterCallBack('ListaTags', Get_Liste);
    RegisterCallBack('Actions', Actions );

    Tags := TTags.Create;

end;

procedure TFrmTags.IWAppFormDestroy(Sender: TObject);
begin
  inherited;
Tags.Free;
end;


procedure TFrmTags.IWAppFormShow(Sender: TObject);
begin
  inherited;
  Load_Combobox_Status(STATUS,True);
end;

procedure TFrmTags.nameHTMLTag(ASender: TObject; ATag: TIWHTMLTag);
begin
  inherited;
Atag.Add('placeholder=" Informe o Nome da Tag "');
end;

procedure TFrmTags.STATUSAsyncChange(Sender: TObject; EventParams: TStringList);
begin
  inherited;
   ExecuteJS('$(''#Lista'').dataTable().api().ajax.reload();');
end;

end.

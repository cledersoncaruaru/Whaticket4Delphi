unit Bootstrap.SweetAlert2;


interface

uses
  System.SysUtils, System.Classes, System.StrUtils,IW.Common.Strings,
    ServerController,
  Integracao.Discord,
  IWApplication;



type

  TIconMensagem            = (TpDefault,Tpsuccess,Tperror,Tpwarning,Tpinfo,Tpquestion);


  function swalPrompt(pTitulo, pTexto, pEditDest : String; pBotaoSim : String = 'Sim'; pBotaoNao : String = 'Não'; pEventoSim : String = 'BTNFAZERLOGOUT'): String;
  function swalConfirm(pTitulo, pTexto : String; pTipo: String = 'success'; pBotaoSim : String = 'Sim'; pBotaoNao : String = 'Não'; pEventoSim : String = 'BTNCONFIRMAR'; pEventoNao : String = 'BTNCANCELAR'): String;
  function swalAlert(pTitulo, pTexto: String;  pFoco:String = ''; TimeFoco:Integer = 350; Icone:TIconMensagem = Tpwarning ): String;
  function swalAutoCloseTime(pTitulo, pHtml: String; pTempo: Integer = 2): String;
  function swalError(pTitulo, pTexto: String): String;
  function swalSuccess(pTitulo, pTexto: String): String;
  function swalAutoClose(pHtml: String; pTempo: Integer = 1000; Icone:TIconMensagem = Tpwarning): String;
  function swalError_HTML(pTitulo, pTexto: String): String;
  function swalErrorTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String): String;
  function swalSucessTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String): String;
  function swalAlertTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String): String;
  function Get_Icone_Alerta(Icone:TIconMensagem):String;
  function ShowMessage(WebApplication: TIWApplication; pTitulo, pTexto: String; IsHtml:Boolean = False;  pFoco:String = ''; TimeFoco:Integer = 350; Icone:TIconMensagem = Tpwarning ): String;


implementation




function ShowMessage(WebApplication: TIWApplication; pTitulo, pTexto: String; IsHtml:Boolean = False;  pFoco:String = ''; TimeFoco:Integer = 350; Icone:TIconMensagem = Tpwarning ): String;
var
  StringList : TStringList;
begin

   StringList := TStringlist.Create;

   try


      if TimeFoco < 350 then begin

       TimeFoco  := 350;

      end;

      StringList.Add( 'swal.fire({                                                       ');

      if IsHtml then begin

       StringList.Add(     '    title: "'+pTitulo+'",                                         ');
       StringList.Add(      ' html: `  '+pTexto+'      `,');

      end
      else begin

        StringList.Add( '   title:         "' + TextToJsonString(pTitulo) + '", ');
        StringList.Add( '   text:         "' + TextToHTML(pTexto,False) + '", ');
      end;


     StringList.Add(          '    icon: "'+Get_Icone_Alerta(Icone)+'"                           ');
     StringList.Add(          '}).then(function() {                                              ');
     StringList.Add(          '        swal.close();                                             ');
     StringList.Add(          ' setTimeout(() => $("#'+UpperCase(pFoco)+'").focus(),'+TimeFoco.ToString+'); ');
     StringList.Add(          '});                                                               ');

     WebApplication.ExecuteJS(StringList.Text);

   finally
    StringList.Free;
   end;


end;

function Get_Icone_Alerta(Icone:TIconMensagem):String;
begin

  case Icone of
    TpDefault : Result := 'info' ;
    Tpsuccess : Result := 'success' ;
    Tperror   : Result := 'error' ;
    Tpwarning : Result := 'warning' ;
    Tpinfo    : Result := 'info' ;
    Tpquestion: Result := 'question' ;
  end;

end;

function swalPrompt(pTitulo, pTexto, pEditDest : String; pBotaoSim : String = 'Sim'; pBotaoNao : String = 'Não'; pEventoSim : String = 'BTNFAZERLOGOUT'): String;
var
  strAux : String;
begin

  strAux := 'swal.fire({ ';
  strAux := strAux + '    title: "' + pTitulo + '", ';
  strAux := strAux + '    text: "' + pTexto + '", ';
  strAux := strAux + '    type: "input", ';
  strAux := strAux + '    showCancelButton: true, ';
  strAux := strAux + '    closeOnConfirm: true,';
  strAux := strAux + '    confirmButtonText: "' + pBotaoSim + '", ';
  strAux := strAux + '    cancelButtonText: "' + pBotaoNao + '", ';
  strAux := strAux + '    inputPlaceholder: "Digite algo"';
  strAux := strAux + '  }, function (inputValue) {';
  strAux := strAux + 'if (inputValue === false) return false;';
  strAux := strAux + 'if (inputValue === "") {';
  strAux := strAux + '  swal("Atenção", "Digite alguma coisa!","error");';
  strAux := strAux + '  return false';
  strAux := strAux + '}';
  strAux := strAux + 'document.getElementById(''' +   pEditDest + ''').value= inputValue;';
  strAux := strAux + 'AddChangedControl(''' + pEditDest + ''');';

  strAux := strAux + '});';

  Result := strAux;
end;

function swalConfirm(pTitulo, pTexto : String; pTipo: String = 'success'; pBotaoSim : String = 'Sim'; pBotaoNao : String = 'Não'; pEventoSim : String = 'BTNCONFIRMAR'; pEventoNao : String = 'BTNCANCELAR'): String;
var
  strAux : String;
begin

    strAux := 'swal.fire({ ';
    strAux := strAux + '   title:        "' + pTitulo + '", ';
    strAux := strAux + '   text:         "' + pTexto + '", ';
    strAux := strAux + '   icon:         "' + pTipo+'", ';
    strAux := strAux + '   showCancelButton:   ';
    if (pBotaoNao = '') then
      strAux := strAux + '     false, '
    else
      strAux := strAux + '     true, ';
    strAux := strAux + '   confirmButtonColor:   "#135893", ';
    strAux := strAux + '   cancelButtonColor:   "#d92e29", ';
    strAux := strAux + '   confirmButtonText:   "' + pBotaoSim + '", ';
    strAux := strAux + '   cancelButtonText:   "' + pBotaoNao + '", ';
    strAux := strAux + ' closeOnConfirm: false, ';
    strAux := strAux + ' closeOnCancel: false   ';
    strAux := strAux + ' }).then((result) => { ';
    strAux := strAux + '   if (result.value) { ';
    strAux := strAux + '     '+ pEventoSim + '.click(); }';
    strAux := strAux + '   else if (result.dismiss === "cancel") { ';
    strAux := strAux + '     '+ pEventoNao + '.click(); }';
    strAux := strAux + '  }); ';

    Result := strAux;
end;

function swalAlert(pTitulo, pTexto: String;  pFoco:String = ''; TimeFoco:Integer = 350; Icone:TIconMensagem = Tpwarning ): String;
var
  strAux : String;
begin

   if TimeFoco < 350 then begin

    TimeFoco  := 350;

   end;


   strAux :=  'swal.fire({                                                       '+
              '    title: "'+pTitulo+'",                                         '+
              '    text: "'+pTexto+'",                                           '+
              '    icon: "'+Get_Icone_Alerta(Icone)+'"                           '+
              '}).then(function() {                                              '+
              '        swal.close();                                             '+
              ' setTimeout(() => $("#'+UpperCase(pFoco)+'").focus(),'+TimeFoco.ToString+'); '+
              '});                                                               ';


 Result := strAux;

end;
function swalAutoClose(pHtml: String; pTempo: Integer = 1000; Icone:TIconMensagem = Tpwarning): String;
begin

     if pTempo < 1000 then
        pTempo := 1000;

      Result :=
                'Swal.fire({                           '+
                'position: "top",                      '+
                'icon: "'+Get_Icone_Alerta(Icone)+'",  '+
                'title: "'+pHtml+'",                   '+
                'showConfirmButton: false,             '+
                'timer: '+pTempo.ToString               +
                '});                                   ';

end;

function swalAutoCloseTime(pTitulo, pHtml: String; pTempo: Integer = 2): String;
var
  strAux: String;
begin

// Converter segundos para milissegundos
  pTempo := pTempo * 100;

  strAux := 'let timerInterval;' + sLineBreak +
            'Swal.fire({' + sLineBreak +
            '  title: "' + pTitulo + '",' + sLineBreak +
            '  html: "' + pHtml + ' <b></b> seconds.",' + sLineBreak +
            '  timer: ' + pTempo.ToString + ',' + sLineBreak +
            '  timerProgressBar: true,' + sLineBreak +
            '  didOpen: () => {' + sLineBreak +
            '    Swal.showLoading();' + sLineBreak +
            '    const timer = Swal.getHtmlContainer().querySelector("b");' + sLineBreak +
            '    timer.textContent = Math.ceil(' + pTempo.ToString + ' / 1000);' + sLineBreak +
            '    timerInterval = setInterval(() => {' + sLineBreak +
            '      timer.textContent = Math.ceil(Swal.getTimerLeft() / 1000);' + sLineBreak +
            '    }, 100);' + sLineBreak + // Atualiza a cada segundo
            '  },' + sLineBreak +
            '  willClose: () => {' + sLineBreak +
            '    clearInterval(timerInterval);' + sLineBreak +
            '  }' + sLineBreak +
            '}).then((result) => {' + sLineBreak +
            '  if (result.dismiss === Swal.DismissReason.timer) {' + sLineBreak +
            '    console.log("I was closed by the timer");' + sLineBreak +
            '  }' + sLineBreak +
            '});';

  Result := strAux;
end;


function swalSucessTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String): String;
var
  strAux : String;
begin

  strAux := strAux + ' Swal.fire({                                               ';
  strAux := strAux + '   title: "' + pTitulo + '",                          ';
  strAux := strAux + '   text: "'+pTexto+'",                                ';
  strAux := strAux + '   type: ''success'',                                   ';
  strAux := strAux + '   timer: '+IntToStr(Timer)+',                        ';
  strAux := strAux + '   showConfirmButton: false                           ';
  strAux := strAux + ' }).then(function() {                                 ';
  strAux := strAux + ' });                                                  ';

  Result := strAux;

end;

function swalAlertTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String): String;
var
  strAux : String;
begin

  strAux := strAux + ' Swal.fire({                                               ';
  strAux := strAux + '   title: "' + pTitulo + '",                          ';
  strAux := strAux + '   text: "'+pTexto+'",                                ';
  strAux := strAux + '   type: ''warning'',                                   ';
  strAux := strAux + '   timer: '+IntToStr(Timer)+',                        ';
  strAux := strAux + '   showConfirmButton: false                           ';
  strAux := strAux + ' }).then(function() {                                 ';
  strAux := strAux + ' });                                                  ';

  Result := strAux;
end;

function swalErrorTimer(pTitulo, pTexto: String; Timer:Longint; SetFocus:String): String;
var
  strAux : String;
begin

  strAux := strAux + ' Swal.fire({                                               ';
  strAux := strAux + '   title: "' + pTitulo + '",                          ';
  strAux := strAux + '   text: "'+pTexto+'",                                ';
  strAux := strAux + '   type: ''error'',                                   ';
  strAux := strAux + '   timer: '+IntToStr(Timer)+',                        ';
  strAux := strAux + '   showConfirmButton: false                           ';
  strAux := strAux + ' }).then(function() {                                 ';
  strAux := strAux + ' });                                                  ';

  Result := strAux;

end;

function swalError(pTitulo, pTexto: String): String;
var
  strAux : String;
begin

  strAux := 'swal.fire("' + pTitulo + '", "' + pTexto + '", "error");';

  Result := strAux;

end;

function swalError_HTML(pTitulo, pTexto: String): String;
var
  strAux : String;
begin

  strAux := strAux + ' Swal.fire({                                                    ';
  strAux := strAux + '  title: ''<strong>'+pTitulo+'</strong>'',                      ';
  strAux := strAux + '  icon: ''error'',                                              ';
  strAux := strAux + '  html:                                                         ';
  strAux := strAux + '    '+pTexto+',                                                 ';
  strAux := strAux + '  showCancelButton: true,                                       ';
  strAux := strAux + '  focusConfirm: false,                                          ';
  strAux := strAux + '  confirmButtonText:                                            ';
  strAux := strAux + '    ''<i class="fa fa-thumbs-up"></i> OK'',                     ';
  strAux := strAux + '  confirmButtonAriaLabel: ''OK'',                               ';
  strAux := strAux + '})                                                              ';

  Result := strAux;
end;

function swalSuccess(pTitulo, pTexto: String): String;
var
  strAux : String;
begin

  strAux := 'swal.fire("' + pTitulo + '", "' + pTexto + '", "success");';

  Result := strAux;
end;

end.


unit Database.DAO.Menu;

interface

uses
  Tipos.Types;

 function Get_Menu(Page_Active:String; TipoAcesso : TUserType):String;

implementation

function Get_Menu(Page_Active:String; TipoAcesso : TUserType):String;
begin


  case TipoAcesso of

    tpAdmin:      begin;


                   Result :=

                        ' <li class="nav-item">                                                                                                   '+
                        '     <a href="#" onclick="ajaxCall(''Menu'',''page=FRMATENDIMENTO'');"                                                   '+
                        '     class="nav-link mininav-toggle"><i class="fa-brands fa-whatsapp fa-2x"></i>                                         '+
                        '         <span class="nav-label mininav-content ms-1">Atendimento</span>                                                 '+
                        '     </a>                                                                                                                '+
                        ' </li>                                                                                                                   '+



                        ' <li class="nav-item">                                                                                                   '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMRESPOSTAS'');"                           '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-bolt fa-2x"></i>                    '+
                        '                                   <span class="nav-label mininav-content ms-1">Respostas Rápidas</span>                 '+
                        '                               </a>                                                                                      '+
                        ' </li>                                                                                                                   '+

                        ' <li class="nav-item">                                                                                                   '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMKANBAN'');"                              '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-house-laptop fa-2x"></i>            '+
                        '                                   <span class="nav-label mininav-content ms-1">Kanban</span>                            '+
                        '                               </a>                                                                                      '+
                        '  </li>                                                                                                                  '+


                        ' <li class="nav-item">                                                                                                   '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMTAREFAS'');"                             '+
                        '                               class="nav-link mininav-toggle"><i class="fa-regular fa-pen-to-square fa-2x"></i>         '+
                        '                                   <span class="nav-label mininav-content ms-1">Tarefas</span>                           '+
                        '                               </a>                                                                                      '+
                        ' </li>                                                                                                                   '+

                        ' <li class="nav-item">                                                                                                   '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMCONTATOS'');"                            '+
                        '                               class="nav-link mininav-toggle"><i class="fa-regular fa-address-card fa-2x"></i>          '+
                        '                                   <span class="nav-label mininav-content ms-1">Contatos</span>                          '+
                        '                               </a>                                                                                      '+
                        ' </li>                                                                                                                   '+

                        ' <li class="nav-item">                                                                                                   '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMAGENDAMENTOS'');"                        '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-calendar-days fa-2x"></i>           '+
                        '                                   <span class="nav-label mininav-content ms-1">Agendamentos</span>                      '+
                        '                               </a>                                                                                      '+
                        ' </li>                                                                                                                   '+


                        ' <li class="nav-item">                                                                                                   '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMTAGS'');"                                '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-tags fa-2x"></i>                    '+
                        '                                   <span class="nav-label mininav-content ms-1">Tags</span>                              '+
                        '                               </a>                                                                                      '+
                        ' </li>                                                                                                                   '+

                        ' <li class="nav-item">                                                                                                   '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMCHAT'');"                                '+
                        '                               class="nav-link mininav-toggle"><i class="fa-regular fa-comments fa-2x"></i>              '+
                        '                                   <span class="nav-label mininav-content ms-1">Chat Interno</span>                      '+
                        '                               </a>                                                                                      '+
                        ' </li>                                                                                                                   '+

                        ' <li class="nav-item">                                                                                                   '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=AFRMAJUDA'');"                              '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-circle-question fa-2x"></i>         '+
                        '                                   <span class="nav-label mininav-content ms-1">Ajuda</span>                             '+
                        '                               </a>                                                                                      '+
                        ' </li>                                                                                                                   '+


                        ' <div class="mainnav__categoriy py-3">                                                                                    '+
                        '    <h6 class="mainnav__caption mt-0 fw-bold">Gerência</h6>                                                               '+
                        '  <ul class="mainnav__menu nav flex-column">                                                                              '+
                        '   <li class="nav-item">                                                                                                  '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMDASHBOARD'');"                            '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-chart-line fa-2x"></i>               '+
                        '                                   <span class="nav-label mininav-content ms-1">Dashboard</span>                          '+
                        '                               </a>                                                                                       '+
                        '   </li>                                                                                                                  '+
                        '  </ul>                                                                                                                   '+
                       ' </div>                                                                                                                    '+

                        ' <div class="mainnav__categoriy py-3">                                                                                    '+
                        '   <h6 class="mainnav__caption mt-0 px-3 fw-bold">Administração</h6>'+
                        '  <ul class="mainnav__menu nav flex-column">                                                                              '+
                        '   <li class="nav-item">                                                                                                  '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMINFORMATIVO'');"                          '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-circle-info fa-2x"></i>              '+
                        '                                   <span class="nav-label mininav-content ms-1">Informativos</span>                       '+
                        '                               </a>                                                                                       '+
                        '   </li>                                                                                                                  '+
                        '  </ul> '+
                        ' </div>                                                                                                                   '+

                        ' <li class="nav-item">                                                                                                     '+
                        '     <a href="#" onclick="ajaxCall(''Menu'',''page=FRMCONEXOES'');"                                                        '+
                        '     class="nav-link mininav-toggle"><i class="fa-brands fa-whatsapp fa-2x"></i>                                           '+
                        '         <span class="nav-label mininav-content ms-1">Conexões</span>                                                      '+
                        '     </a>                                                                                                                  '+
                        ' </li>                                                                                                                     '+




                        ' <li class="nav-item">                                                                                                     '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMFILAS'');"                                 '+
                        '                               class="nav-link mininav-toggle"><i class="fa-brands fa-bots fa-2x"></i>                     '+
                        '                                   <span class="nav-label mininav-content ms-1">Filas & Chatbot</span>                     '+
                        '                               </a>                                                                                        '+
                        ' </li>                                                                                                                     '+


                        ' <li class="nav-item">                                                                                                      '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMUSUARIO'');"                                '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-users-gear fa-2x"></i>                 '+
                        '                                   <span class="nav-label mininav-content ms-1">Usuários</span>                             '+
                        '                               </a>                                                                                         '+
                        ' </li>                                                                                                                      '+


                        ' <li class="nav-item">                                                                                                      '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMAPI'');"                                    '+
                        '                               class="nav-link mininav-toggle"><i class="fa-brands fa-cloudflare fa-2x"></i>                '+
                        '                                   <span class="nav-label mininav-content ms-1">API</span>                                  '+
                        '                               </a>                                                                                         '+
                        ' </li>                                                                                                                      '+


                        ' <li class="nav-item">                                                                                                       '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMFINANCEIRO'');"                              '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-cash-register fa-2x"></i>               '+
                        '                                   <span class="nav-label mininav-content ms-1">Financeiro</span>                            '+
                        '                               </a>                                                                                          '+
                        ' </li>                                                                                                                       '+

                        ' <li class="nav-item">                                                                                                       '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''page=FRMCONFIGURACOES'');"                           '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-screwdriver-wrench fa-2x"></i>          '+
                        '                                   <span class="nav-label mininav-content ms-1">Configurações</span>                         '+
                        '                               </a>                                                                                          '+
                        ' </li>                                                                                                                       ';

                  end;


    tpRevenda:  begin;

                          Result := Result +



                        '       <li class="nav-item">                                                                                   '+
                        '                               <a href="#" onclick="ajaxCall(''Menu'',''menu=listaprestador'');"               '+
                        '                               class="nav-link mininav-toggle"><i class="fa-solid fa-user-tie fa-2x"></i>      '+
                        '                                   <span class="nav-label mininav-content ms-1">Clientes</span>                '+
                        '                               </a>                                                                            '+
                        '                           </li>                                                                               '+

  '        <li class="nav-item has-sub">                                                                                                '+
 '                               <a href="#" class="mininav-toggle nav-link collapsed"><i                                               '+
 '                                       class="fa-solid fa-file-invoice fa-2x"></i>                                                    '+
 '                                   <span class="nav-label ms-1">Financeiro</span>                                                     '+
 '                               </a>                                                                                                   '+
 '                               <ul class="mininav-content nav collapse">                                                              '+
  '                                  <li class="nav-item">                                                                              '+
  '                                      <a href="#" onclick="ajaxCall(''Menu'',''menu=nfse'');"                                        '+
  '                                class="nav-link">Gestão a Receber</a>                                                                '+
 '                                   </li>                                                                                              '+
  '                                  <li class="nav-item">                                                                              '+
 '                                       <a href="#" onclick="ajaxCall(''Menu'',''menu=listanfse'');"                                   '+
 '                                    class="nav-link">Gerenciador de                                                                   '+
 '                                           Planos</a>                                                                                 '+
 '                                   </li>                                                                                              '+
 '                               </ul>                                                                                                  '+
 '                           </li>                                                                                                      ';




    end;

  end;

end;

end.

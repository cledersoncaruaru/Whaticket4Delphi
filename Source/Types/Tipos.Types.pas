unit Tipos.Types;

interface

type

 TUserType      = (tpAdmin,tpUser, tpRevenda);
 TSuperUser     = ( TpSuper, TpNotSuper);
 TModeCadastro  = (tpNavegate, tpInsert, tpEdit);
 TPage          = (tpHome,tpLista);
 TColorCard     = (TPbg_primary,TPbg_secondary,TPbg_success,TPbg_danger,TPbg_warning,TPbg_info,TPbg_light,TPbg_dark);
 TMensagemType  = (TpNFSe,TpEnvioWhatsApp,TpEnvioEmail,TpEnvioAutomatico,TpCadastro);
 TpMensagemZap  = (TpMsgMensagem, TpMsgBase64, TpMsgProfile, TpMsgDesconhecido,TpMsgAudio,TpMsgImage,TpMsgArquivos,TpMsgContact,TpMsgContextInfo,TpMsgVideo,TpConversation,TpMensagemDelete);

implementation

end.

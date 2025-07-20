# Whaticket4Delphi

**Whaticket4Delphi** é uma reescrita em **Delphi + IntraWeb** do projeto [Whaticket Community](https://github.com/canove/whaticket-community), originalmente desenvolvido com **Node.js e React**.  
Este projeto tem como objetivo fornecer uma alternativa 100% Delphi para integração com o WhatsApp, utilizando a [Evolution API](https://github.com/EvolutionAPI/evolution-api).

## ✨ Principais Características

- ✅ Desenvolvido com **Delphi + IntraWeb**
- ✅ Interface baseada no **Template Bootstrap Nifty Admin**
- ✅ Integração com banco de dados **PostgreSQL**
- ✅ Comunicação com a **Evolution API** para envio/recebimento de mensagens
- ✅ Suporte a **Webhooks** para receber mensagens automaticamente
- ✅ Configuração via arquivo `.ini` para definir:
  - Dados da Evolution API
  - Parâmetros do banco de dados local
  - Nome da aplicação e outras opções locais
- ✅ Interface moderna com uso de:
  - HTML, JavaScript, CSS
- ✅ Testado com Delphi nas versões:
  - **11.0**, **12.0**, **12.1**, **12.2**, **12.3**
  - ✅ Teste com Intraweb: Todas as Versões 16. alguma 15. pode pegar, dúvidas baixe a versão trial sem limitações do Intraweb 
       https://www.atozed.com/intraweb/download/v16/

## 🧩 Tecnologias Utilizadas

- [Delphi](https://www.embarcadero.com/br/products/delphi)
- [IntraWeb](https://www.atozed.com/intraweb/)
- [Bootstrap Nifty Admin](https://wrapbootstrap.com/theme/nifty-bootstrap-5-admin-template-WB0048JF7)
- [Evolution API](https://github.com/EvolutionAPI/evolution-api)
- [PostgreSQL](https://www.postgresql.org/)

## Dependencias
   - "https://github.com/viniciussanchez/bcrypt": "^1.0.8",
   - "https://github.com/viniciussanchez/restrequest4delphi": "^v4.0.19"

## Script de Criação do Banco de dados 
BackupBancodeDados-whaticket4delphi.sql
 - Execute ou restaure,e seu banco será criado
 - no Banco da Evolution na tabela "Message" Crie o Campo "sicronizado" bool NULL, para o Whaticket4Delphi Sicronizar as mensagens com ele


## Usuario e Senha Padrão 

Usuario:admin@admin.com
Senha:123456

## Exe Atualizado para Rodar Como Serviço
 - Abra o prompt de Comando na Pasta a onde está o exe 
 - e Rode o Comando WhaticketIW.exe /install
 - Abra o Serviço marque Tipo de Inicialização para "Automatico", Clique em Iniciar, e pronto o serviço rodando 


## Screenshots

<img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Agendamentos.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Atendimento.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Atendimento2.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Codigo.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Codigo2.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Comando.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Conexões.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Contato.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/DashBoard.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Kanban.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Loguin.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Servico2.png" width="350"> <img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Serviço.png" width="350"><img src="https://github.com/cledersoncaruaru/Whaticket4Delphi/tree/main/images/Tarefas.png" width="350">


## 🗂 Estrutura do Projeto

```text
/
├── Source/                       # Código-fonte principal em Delphi
├── Bin/                          # Local a Onde fica o Binario,Dlls e todos os Arquivos Necessarios para rodar o Sistema
├── Bin/wwwroot/                  # Arquivos JS, CSS e HTML do frontend (Bootstrap + Nifty)
├── Bin/Configuracao.ini          # Arquivo de configuração local
├── Bin/Configuracao.ini          # Arquivo de configuração de Portas de SSL para Aplicação
├── README.md
└── ...


## Projetos
- Esse Projeto pode ser utilizado com base para outros Projetos
- Você tem o Demo de como trabalhar com Menus, chamando apartir de um FormBase
- Você tem Demos de como Utilizar Modais
- Você tem Demo de Como Abrir outros Forms 
- Exemplo de Crud
- Exemplos de Chamadas a APis com o RestRequest3Delphi
- Exemplo de WebHook em uma Aplicação Intrawqeb
- Exemplos de Utilização das Classes de Thread do Intraweb 
- Mensageria
- Criação de Componentes Html no Delphi e Passando para o renderizar no Html 
- Pequenos Exemplos de JavaScript
- Pequenos Exemplos de Css e Manipulação do DOM

## Convite
- Convido todos a participal do Projetos, fazer PullRequest,
Melhorias no Código, melhorias no sistema em Geral, Ficarei contente em apontar falhas em codigos e Bugs 
e um pedido de desculpas aos amantes do Programadores que tem seu código formatado rsrsrs, conveso que não aplico isso nos meus projetos
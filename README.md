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

## 🧩 Tecnologias Utilizadas

- [Delphi](https://www.embarcadero.com/br/products/delphi)
- [IntraWeb](https://www.atozed.com/intraweb/)
- [Bootstrap Nifty Admin](https://wrapbootstrap.com/theme/nifty-bootstrap-5-admin-template-WB0048JF7)
- [Evolution API](https://github.com/EvolutionAPI/evolution-api)
- [PostgreSQL](https://www.postgresql.org/)

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

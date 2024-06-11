# A melhor imagem Docker para CodeIgniter 4 em produção

### **SEU PROJETO CI4 DO GIT DIRETO NO SEU CONTÊINER** 😍
**Descrição Geral:**

Link no Docker Hub: [multideskio/ci4](https://hub.docker.com/r/multideskio/ci4)

Este é um contêiner Docker configurado para PHP 7.4 e PHP 8.2 com Apache, projetado para aplicações baseadas no CodeIgniter 4 (CI4). Inclui diversas extensões e dependências essenciais para o desenvolvimento e execução de aplicações web. Além disso, há um script de inicialização que realiza a clonagem de um repositório Git específico ou utiliza um repositório padrão se a variável `CI4_GIT_REPO` não estiver definida.

**Especificações:**
-  **Imagens Base:**  `php:7.4-apache` e `php:8.2-apache`

-  **Extensões PHP Instaladas:**  `intl`, `pdo_mysql`, `zip`, `gd`, `mysqli`, `redis`

-  **Dependências Adicionadas:**  `libicu-dev`, `libzip-dev`, `zip`, `unzip`, `git`, `libpng-dev`, `libgd-dev`, `libfreetype6-dev`, `libjpeg-dev`, `libmagickwand-dev`

-  **Ferramentas Adicionadas:**  `Composer`

**Utilização:**
1. Clone este repositório.
2. Construa a imagem do Docker usando o Dockerfile fornecido.
3. Execute o contêiner com as variáveis de ambiente necessárias.

**Uso das Variáveis:**
O script `docker-entrypoint.sh` é responsável por configurar e inicializar o ambiente. Ele verifica a existência da variável `CI4_GIT_REPO`. Se definida, o repositório é clonado; caso contrário, um repositório padrão é utilizado.

Variáveis de ambiente relevantes (pode adicionar outras conforme necessário):
-  `CI_ENVIRONMENT`: Ambiente do CodeIgniter (desenvolvimento, produção, etc.).
-  `app_baseURL`: URL base da aplicação.
-  `app_forceGlobalSecureRequests`: Força requisições seguras.
-  `database_default_hostname`: Hostname do banco de dados.
-  `database_default_database`: Nome do banco de dados.
-  `database_default_username`: Usuário do banco de dados.
-  `database_default_password`: Senha do banco de dados.
-  `database_default_DBDriver`: Driver do banco de dados.
-  `database_default_DBPrefix`: Prefixo das tabelas do banco de dados.
-  `database_default_port`: Porta do banco de dados.
-  `session_driver`: Driver da sessão.
-  `session_cookieName`: Nome do cookie da sessão.
-  `session_expiration`: Tempo de expiração da sessão.
-  `session_savePath`: Caminho de salvamento da sessão.
-  `session_matchIP`: Correspondência de IP da sessão.
-  `session_timeToUpdate`: Tempo para atualizar a sessão.
-  `session_regenerateDestroy`: Destruir sessão ao regenerar.
-  `logger_threshold`: Nível de log.
-  `curlrequest_shareOptions`: Opções compartilhadas de requisição cURL.

```env

- CI4_GIT_REPO= # https://github.com/codeigniter4/CodeIgniter4.git
- CI_ENVIRONMENT= # development, production, testing
- app_baseURL=
- app_forceGlobalSecureRequests=
- database_default_hostname=
- database_default_database=
- database_default_username=
- database_default_password=
- database_default_DBDriver=
- database_default_DBPrefix=
- database_default_port=3306
- session_driver=
- session_cookieName=
- session_expiration=
- session_savePath=
- session_matchIP=
- session_timeToUpdate=
- session_regenerateDestroy=
- logger_threshold=
- curlrequest_shareOptions=

```
**Observações:**
- O Composer é instalado, e as dependências são atualizadas durante a construção.
- O Apache é configurado para usar o diretório `/var/www/html/public` como DocumentRoot.

- O script de entrada (`docker-entrypoint.sh`) automatiza tarefas comuns, como migrações do CodeIgniter e ajustes de permissões.

**Instruções de Execução local:**
```bash

docker  build  -t  nome-da-imagem  .
docker  run  -e  CI4_GIT_REPO=URL-do-seu-repositorio  -p  8080:80  nome-da-imagem
```
## Avisos
- Certifique-se de ajustar as variáveis de ambiente conforme necessário.
- Este contêiner é destinado principalmente a fins de desenvolvimento.
- Licença: GNU GPL (consulte o arquivo LICENSE).

### Sinta-se à vontade para ajustar conforme necessário!

❤️Curta esse repositório
---
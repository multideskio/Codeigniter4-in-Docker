#!/bin/bash
set -e

echo "Iniciando o script de configuração do contêiner..."

# ----------------------------------------------------------------------
# Clonagem do repositório
# ----------------------------------------------------------------------
if [ -n "${CI4_GIT_REPO}" ]; then
    echo "Clonando repositório Git a partir de ${CI4_GIT_REPO}..."

    # Verificar se GIT_USER e GIT_TOKEN foram configurados para repositórios privados
    if [ -n "${GIT_USER}" ] && [ -n "${GIT_TOKEN}" ]; then
        echo "Usando autenticação com token para repositório privado..."
        git clone https://${GIT_USER}:${GIT_TOKEN}@${CI4_GIT_REPO} /var/www/html || {
            echo "Falha ao clonar o repositório privado. Verifique suas credenciais."
            exit 1
        }
    else
        echo "Clonando repositório público..."
        git clone "${CI4_GIT_REPO}" /var/www/html || {
            echo "Falha ao clonar o repositório público."
            exit 1
        }
    fi

    # Remover arquivo .env existente no repositório
    rm -f /var/www/html/.env || true
else
    echo "A variável CI4_GIT_REPO não está definida. Usando o valor padrão."
    git clone https://github.com/codeigniter4/CodeIgniter4.git /var/www/html || {
        echo "Falha ao clonar o repositório padrão."
        exit 1
    }
    rm -f /var/www/html/.env || true
fi

# ----------------------------------------------------------------------
# Instalação de dependências com Composer
# ----------------------------------------------------------------------
echo "Executando composer install..."
if [ -n "${CI_ENVIRONMENT}" ] && [ "${CI_ENVIRONMENT}" == "production" ]; then
    composer install --working-dir=/var/www/html --no-dev || {
        echo "Falha ao executar o Composer no modo produção."
        exit 1
    }
else
    composer install --working-dir=/var/www/html || {
        echo "Falha ao executar o Composer no modo de desenvolvimento."
        exit 1
    }
fi

# ----------------------------------------------------------------------
# Configuração do arquivo .env
# ----------------------------------------------------------------------
echo "Criando arquivo .env com variáveis de ambiente..."
{
    echo "# Arquivo gerado automaticamente"
    echo "CI_ENVIRONMENT=${CI_ENVIRONMENT:-production}"
    for var in $(printenv | awk -F= '{print $1}'); do
        # Ignorar variáveis do sistema ou não relacionadas
        if [[ "$var" =~ ^(PATH|HOME|PWD|TERM|SHLVL|_|HOSTNAME|GIT_USER|GIT_TOKEN)$ ]]; then
            continue
        fi
        value=$(printenv "$var")
        echo "${var}=${value}"
    done
} > /var/www/html/.env

# ----------------------------------------------------------------------
# Permissões no diretório
# ----------------------------------------------------------------------
echo "Ajustando permissões no diretório /var/www/html..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# ----------------------------------------------------------------------
# Iniciar Supervisor
# ----------------------------------------------------------------------
echo "Iniciando Supervisor para gerenciar os serviços..."
exec "$@"
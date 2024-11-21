#!/bin/bash
set -e

echo "Iniciando o script de configuração do contêiner..."

# ----------------------------------------------------------------------
# Clonagem do repositório
# ----------------------------------------------------------------------
clone_repository() {
    local repo_url=$1
    local target_dir=$2

    echo "Clonando repositório Git a partir de ${repo_url}..."

    # Verificar se GIT_USER e GIT_TOKEN foram configurados para repositórios privados
    if [ -n "${GIT_USER}" ] && [ -n "${GIT_TOKEN}" ]; then
        echo "Usando autenticação com token para repositório privado..."
        git clone https://${GIT_USER}:${GIT_TOKEN}@${repo_url} ${target_dir} || {
            echo "Falha ao clonar o repositório privado. Verifique suas credenciais."
            exit 1
        }
    else
        echo "Clonando repositório público..."
        git clone "${repo_url}" ${target_dir} || {
            echo "Falha ao clonar o repositório público."
            exit 1
        }
    fi

    # Remover arquivo .env existente no repositório
    rm -f ${target_dir}/.env || true
}

if [ -n "${CI4_GIT_REPO}" ]; then
    clone_repository "${CI4_GIT_REPO}" "/var/www/html"
else
    echo "A variável CI4_GIT_REPO não está definida. Usando o valor padrão."
    clone_repository "https://github.com/codeigniter4/CodeIgniter4.git" "/var/www/html"
fi

# ----------------------------------------------------------------------
# Instalação de dependências com Composer
# ----------------------------------------------------------------------
echo "Executando composer install..."
COMPOSER_OPTIONS="--working-dir=/var/www/html"
[ -n "${CI_ENVIRONMENT}" ] && [ "${CI_ENVIRONMENT}" == "production" ] && COMPOSER_OPTIONS+=" --no-dev"

composer install ${COMPOSER_OPTIONS} || {
    echo "Falha ao executar o Composer."
    exit 1
}

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
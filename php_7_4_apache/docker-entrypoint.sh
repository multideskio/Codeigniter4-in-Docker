#!/bin/bash
set -e

# Verificar se CI4_GIT_REPO está definido; se não, usar o valor padrão
if [ -n "${CI4_GIT_REPO}" ]; then
    echo "Clonando repositório Git a partir de ${CI4_GIT_REPO}..."
    git clone "${CI4_GIT_REPO}" /var/www/html && rm -f /var/www/html/.env || true
else
    echo "A variável CI4_GIT_REPO não está definida. Usando o valor padrão."
    git clone https://github.com/codeigniter4/CodeIgniter4.git /var/www/html && rm -f /var/www/html/.env || true
fi

# Executar o composer update
echo "Executando composer install em /var/www/html..."

# Verificar a variável CI_ENVIRONMENT e executar o comando correspondente
if [ "${CI_ENVIRONMENT}" == "production" ]; then
    composer install --working-dir=/var/www/html --no-dev
elif [ "${CI_ENVIRONMENT}" == "development" ]; then
    composer install --working-dir=/var/www/html
elif [ "${CI_ENVIRONMENT}" == "testing" ]; then
    composer install --working-dir=/var/www/html
else
    echo "Variável CI_ENVIRONMENT não definida ou valor desconhecido."
fi

# Verificar se MIGRATIONS está definido
if [ -n "${MIGRATIONS}" ]; then
    echo "Executando migrations..."
    php spark migrate --working-dir=/var/www/html

    # Dar permissões de escrita ao diretório "writable"
    echo "Dando permissões de escrita ao diretório /var/www/html/writable..."
    chown -R www-data:www-data /var/www/html/writable
else
    echo "Instalação PHP comum, mas é preciso ter uma instalação de app com a pasta public..."
    echo "Dando permissões de escrita ao diretório /var/www/html"
    chown -R www-data:www-data /var/www/html/
fi

echo "Verificando variáveis..."

# Função para criar o arquivo .env com todas as variáveis de ambiente
create_env_file() {
    cat > /var/www/html/.env <<EOF
#--------------------------------------------------------------------
# ENVIRONMENT
#--------------------------------------------------------------------
EOF

    for var in $(compgen -v); do
        if [[ "$var" == "CI_"* || "$var" == "app_"* || "$var" == "database_"* || "$var" == "contentsecuritypolicy_"* || "$var" == "cookie_"* || "$var" == "encryption_"* || "$var" == "honeypot_"* || "$var" == "security_"* || "$var" == "session_"* || "$var" == "logger_"* || "$var" == "curlrequest_"* ]]; then
            echo "$var = '${!var}'" >> /var/www/html/.env
        fi
    done
}

echo "Criando variáveis..."

# Executar a função para criar o arquivo .env
create_env_file

# Iniciar o serviço
echo "Iniciando o serviço..."

# Executar outros comandos ou iniciar seu serviço aqui
exec "$@"
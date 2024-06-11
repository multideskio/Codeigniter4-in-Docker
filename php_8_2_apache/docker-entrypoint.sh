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

create_env_file() {
    cat > /var/www/html/.env <<EOF
#--------------------------------------------------------------------
# ENVIRONMENT
#--------------------------------------------------------------------
EOF

    if [ -n "${CI_ENVIRONMENT}" ]; then 
        echo "CI_ENVIRONMENT = ${CI_ENVIRONMENT}" >> /var/www/html/.env
    fi
    if [ -n "${app_baseURL}" ]; then 
        echo "app.baseURL = '${app_baseURL}'" >> /var/www/html/.env
    fi
    if [ -n "${app_forceGlobalSecureRequests}" ]; then 
        echo "app.forceGlobalSecureRequests = '${app_forceGlobalSecureRequests}'" >> /var/www/html/.env
    fi
    if [ -n "${app_CSPEnabled}" ]; then 
        echo "app.CSPEnabled = '${app_CSPEnabled}'" >> /var/www/html/.env
    fi

    if [ -n "${database_default_hostname}" ]; then 
        echo "database.default.hostname = ${database_default_hostname}" >> /var/www/html/.env
    fi
    if [ -n "${database_default_database}" ]; then 
        echo "database.default.database = ${database_default_database}" >> /var/www/html/.env
    fi
    if [ -n "${database_default_username}" ]; then 
        echo "database.default.username = ${database_default_username}" >> /var/www/html/.env
    fi
    if [ -n "${database_default_password}" ]; then 
        echo "database.default.password = ${database_default_password}" >> /var/www/html/.env
    fi
    if [ -n "${database_default_DBDriver}" ]; then 
        echo "database.default.DBDriver = ${database_default_DBDriver}" >> /var/www/html/.env
    fi
    if [ -n "${database_default_DBPrefix}" ]; then 
        echo "database.default.DBPrefix = ${database_default_DBPrefix}" >> /var/www/html/.env
    fi
    if [ -n "${database_default_port}" ]; then 
        echo "database.default.port = ${database_default_port}" >> /var/www/html/.env
    fi

    if [ -n "${database_tests_hostname}" ]; then 
        echo "database.tests.hostname = '${database_tests_hostname}'" >> /var/www/html/.env
    fi
    if [ -n "${database_tests_database}" ]; then 
        echo "database.tests.database = '${database_tests_database}'" >> /var/www/html/.env
    fi
    if [ -n "${database_tests_username}" ]; then 
        echo "database.tests.username = '${database_tests_username}'" >> /var/www/html/.env
    fi
    if [ -n "${database_tests_password}" ]; then 
        echo "database.tests.password = '${database_tests_password}'" >> /var/www/html/.env
    fi
    if [ -n "${database_tests_DBDriver}" ]; then 
        echo "database.tests.DBDriver = '${database_tests_DBDriver}'" >> /var/www/html/.env
    fi
    if [ -n "${database_tests_DBPrefix}" ]; then 
        echo "database.tests.DBPrefix = '${database_tests_DBPrefix}'" >> /var/www/html/.env
    fi
    if [ -n "${database_tests_port}" ]; then 
        echo "database.tests.port = '${database_tests_port}'" >> /var/www/html/.env
    fi

    if [ -n "${contentsecuritypolicy_reportOnly}" ]; then 
        echo "contentsecuritypolicy.reportOnly = '${contentsecuritypolicy_reportOnly}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_defaultSrc}" ]; then 
        echo "contentsecuritypolicy.defaultSrc = '${contentsecuritypolicy_defaultSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_scriptSrc}" ]; then 
        echo "contentsecuritypolicy.scriptSrc = '${contentsecuritypolicy_scriptSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_styleSrc}" ]; then 
        echo "contentsecuritypolicy.styleSrc='${contentsecuritypolicy_styleSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_imageSrc}" ]; then 
        echo "contentsecuritypolicy.imageSrc='${contentsecuritypolicy_imageSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_baseURI}" ]; then 
        echo "contentsecuritypolicy.baseURI='${contentsecuritypolicy_baseURI}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_childSrc}" ]; then 
        echo "contentsecuritypolicy.childSrc='${contentsecuritypolicy_childSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_connectSrc}" ]; then 
        echo "contentsecuritypolicy.connectSrc='${contentsecuritypolicy_connectSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_fontSrc}" ]; then 
        echo "contentsecuritypolicy.fontSrc='${contentsecuritypolicy_fontSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_formAction}" ]; then 
        echo "contentsecuritypolicy.formAction='${contentsecuritypolicy_formAction}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_frameAncestors}" ]; then 
        echo "contentsecuritypolicy.frameAncestors='${contentsecuritypolicy_frameAncestors}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_frameSrc}" ]; then 
        echo "contentsecuritypolicy.frameSrc='${contentsecuritypolicy_frameSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_mediaSrc}" ]; then 
        echo "contentsecuritypolicy.mediaSrc='${contentsecuritypolicy_mediaSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_objectSrc}" ]; then 
        echo "contentsecuritypolicy.objectSrc='${contentsecuritypolicy_objectSrc}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_pluginTypes}" ]; then 
        echo "contentsecuritypolicy.pluginTypes='${contentsecuritypolicy_pluginTypes}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_reportURI}" ]; then 
        echo "contentsecuritypolicy.reportURI='${contentsecuritypolicy_reportURI}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_sandbox}" ]; then 
        echo "contentsecuritypolicy.sandbox='${contentsecuritypolicy_sandbox}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_upgradeInsecureRequests}" ]; then 
        echo "contentsecuritypolicy.upgradeInsecureRequests='${contentsecuritypolicy_upgradeInsecureRequests}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_styleNonceTag}" ]; then 
        echo "contentsecuritypolicy.styleNonceTag='${contentsecuritypolicy_styleNonceTag}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_scriptNonceTag}" ]; then 
        echo "contentsecuritypolicy.scriptNonceTag='${contentsecuritypolicy_scriptNonceTag}'" >> /var/www/html/.env
    fi
    if [ -n "${contentsecuritypolicy_autoNonce}" ]; then 
        echo "contentsecuritypolicy.autoNonce='${contentsecuritypolicy_autoNonce}'" >> /var/www/html/.env
    fi

    if [ -n "${cookie_prefix}" ]; then 
        echo "cookie.prefix='${cookie_prefix}'" >> /var/www/html/.env
    fi
    if [ -n "${cookie_expires}" ]; then 
        echo "cookie.expires='${cookie_expires}'" >> /var/www/html/.env
    fi
    if [ -n "${cookie_path}" ]; then 
        echo "cookie.path='${cookie_path}'" >> /var/www/html/.env
    fi
    if [ -n "${cookie_domain}" ]; then 
        echo "cookie.domain='${cookie_domain}'" >> /var/www/html/.env
    fi
    if [ -n "${cookie_secure}" ]; then 
        echo "cookie.secure='${cookie_secure}'" >> /var/www/html/.env
    fi
    if [ -n "${cookie_httponly}" ]; then 
        echo "cookie.httponly='${cookie_httponly}'" >> /var/www/html/.env
    fi
    if [ -n "${cookie_samesite}" ]; then 
        echo "cookie.samesite='${cookie_samesite}'" >> /var/www/html/.env
    fi
    if [ -n "${cookie_raw}" ]; then 
        echo "cookie.raw='${cookie_raw}'" >> /var/www/html/.env
    fi

    if [ -n "${encryption_key}" ]; then 
        echo "encryption.key='${encryption_key}'" >> /var/www/html/.env
    fi
    if [ -n "${encryption_driver}" ]; then 
        echo "encryption.driver='${encryption_driver}'" >> /var/www/html/.env
    fi
    if [ -n "${encryption_blockSize}" ]; then 
        echo "encryption.blockSize='${encryption_blockSize}'" >> /var/www/html/.env
    fi
    if [ -n "${encryption_digest}" ]; then 
        echo "encryption.digest='${encryption_digest}'" >> /var/www/html/.env
    fi

    if [ -n "${honeypot_hidden}" ]; then 
        echo "honeypot.hidden='${honeypot_hidden}'" >> /var/www/html/.env
    fi
    if [ -n "${honeypot_label}" ]; then 
        echo "honeypot.label='${honeypot_label}'" >> /var/www/html/.env
    fi
    if [ -n "${honeypot_name}" ]; then 
        echo "honeypot.name='${honeypot_name}'" >> /var/www/html/.env
    fi
    if [ -n "${honeypot_template}" ]; then 
        echo "honeypot.template='${honeypot_template}'" >> /var/www/html/.env
    fi
    if [ -n "${honeypot_container}" ]; then 
        echo "honeypot.container='${honeypot_container}'" >> /var/www/html/.env
    fi

    if [ -n "${security_csrfProtection}" ]; then 
        echo "security.csrfProtection='${security_csrfProtection}'" >> /var/www/html/.env
    fi
    if [ -n "${security_tokenRandomize}" ]; then 
        echo "security.tokenRandomize='${security_tokenRandomize}'" >> /var/www/html/.env
    fi
    if [ -n "${security_tokenName}" ]; then 
        echo "security.tokenName='${security_tokenName}'" >> /var/www/html/.env
    fi
    if [ -n "${security_headerName}" ]; then 
        echo "security.headerName='${security_headerName}'" >> /var/www/html/.env
    fi
    if [ -n "${security_cookieName}" ]; then 
        echo "security.cookieName='${security_cookieName}'" >> /var/www/html/.env
    fi
    if [ -n "${security_expires}" ]; then 
        echo "security.expires='${security_expires}'" >> /var/www/html/.env
    fi
    if [ -n "${security_regenerate}" ]; then 
        echo "security.regenerate='${security_regenerate}'" >> /var/www/html/.env
    fi
    if [ -n "${security_redirect}" ]; then 
        echo "security.redirect='${security_redirect}'" >> /var/www/html/.env
    fi
    if [ -n "${security_samesite}" ]; then 
        echo "security.samesite='${security_samesite}'" >> /var/www/html/.env
    fi

    if [ -n "${session_driver}" ]; then 
        echo "session.driver='${session_driver}'" >> /var/www/html/.env
    fi
    if [ -n "${session_cookieName}" ]; then 
        echo "session.cookieName='${session_cookieName}'" >> /var/www/html/.env
    fi
    if [ -n "${session_expiration}" ]; then 
        echo "session.expiration='${session_expiration}'" >> /var/www/html/.env
    fi
    if [ -n "${session_savePath}" ]; then 
        echo "session.savePath='${session_savePath}'" >> /var/www/html/.env
    fi
    if [ -n "${session_matchIP}" ]; then 
        echo "session.matchIP='${session_matchIP}'" >> /var/www/html/.env
    fi
    if [ -n "${session_timeToUpdate}" ]; then 
        echo "session.timeToUpdate='${session_timeToUpdate}'" >> /var/www/html/.env
    fi
    if [ -n "${session_regenerateDestroy}" ]; then 
        echo "session.regenerateDestroy='${session_regenerateDestroy}'" >> /var/www/html/.env
    fi

    if [ -n "${logger_threshold}" ]; then 
        echo "logger.threshold=${logger_threshold}" >> /var/www/html/.env
    fi

    if [ -n "${curlrequest_shareOptions}" ]; then 
        echo "curlrequest.shareOptions='${curlrequest_shareOptions}'" >> /var/www/html/.env
    fi
}

echo "Criando variáveis..."

# Executar a função para criar o arquivo .env
create_env_file

# Iniciar o serviço
echo "Iniciando o serviço..."

# Executar outros comandos ou iniciar seu serviço aqui
exec "$@"

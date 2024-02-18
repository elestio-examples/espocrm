#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 90s;


if [ -e "./initialized" ]; then
    echo "Already initialized, skipping..."
else
    sed -i "s|'outboundEmailFromAddress' => '',|'outboundEmailFromAddress' => '${SMTP_FROM_EMAIL}',|g" ./espocrm/data/config.php
    sed -i "s|'smtpServer' => '',|'smtpServer' => '${SMTP_HOST}',|g" ./espocrm/data/config.php
    sed -i "s|'smtpPort' => 587,|'smtpPort' => ${SMTP_PORT},|g" ./espocrm/data/config.php
    sed -i "s|'smtpAuth' => true,|'smtpAuth' => false,|g" ./espocrm/data/config.php
    sed -i "s|'smtpSecurity' => 'TLS',|'smtpSecurity' => '',|g" ./espocrm/data/config.php
    sed -i '
        :a
        $!{N;ba;}
        s/\(.*\)\(}\)/\1  location \/wss {\n    proxy_pass http:\/\/172.17.0.1:8781;\n    proxy_http_version 1.1;\n    proxy_set_header Upgrade $http_upgrade;\n    proxy_set_header Connection $connection_upgrade;\n  }\n\2/
        ' /opt/elestio/nginx/conf.d/${DOMAIN}.conf
    docker exec elestio-nginx nginx -s reload;

    touch "./initialized"
fi
#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

sed -i "s|'outboundEmailFromAddress' => '',|'outboundEmailFromAddress' => '${SMTP_FROM_EMAIL}',|g" ./espocrm/data/config.php
sed -i "s|'smtpServer' => '',|'smtpServer' => '${SMTP_HOST}',|g" ./espocrm/data/config.php
sed -i "s|'smtpPort' => 587,|'smtpPort' => ${SMTP_PORT},|g" ./espocrm/data/config.php
sed -i "s|'smtpAuth' => true,|'smtpAuth' => false,|g" ./espocrm/data/config.php
sed -i "s|'smtpSecurity' => 'TLS',|'smtpSecurity' => '',|g" ./espocrm/data/config.php
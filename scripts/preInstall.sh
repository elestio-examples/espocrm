#set env vars
#set -o allexport; source .env; set +o allexport;

mkdir -p ./mysql
chown -R 1000:1000 ./mysql

mkdir -p ./espocrm
chown -R 1000:1000 ./espocrm
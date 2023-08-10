<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Espocrm, verified and packaged by Elestio

[Espocrm](https://github.com/espocrm/espocrm-docker) is a web application that allows users to see, enter and evaluate all your company relationships regardless of the type. People, companies, projects or opportunities — all in an easy and intuitive interface.

<img src="https://github.com/elestio-examples/espocrm/raw/main/espocrm.png" alt="espocrm" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/espocrm">fully managed espocrm</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

[![deploy](https://github.com/elestio-examples/espocrm/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/espocrm)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/espocrm.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Create data folders with correct permissions

    mkdir -p ./mysql
    chown -R 1000:1000 ./mysql

    mkdir -p ./espocrm
    chown -R 1000:1000 ./espocrm

Run the project with the following command

    docker-compose up -d

You can access the Web UI at: `http://your-domain:8686`

## Docker-compose

Here are some example snippets to help you get started creating a container.

    version: '3.3'
    services:
        mysql:
            image: mysql:${MYSQL_VERSION_TAG}
            command: --default-authentication-plugin=mysql_native_password
            environment:
                MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
                MYSQL_DATABASE: ${MYSQL_DATABASE}
                MYSQL_USER: ${MYSQL_USER}
                MYSQL_PASSWORD: ${MYSQL_PASSWORD}
            volumes:
                - ./mysql:/var/lib/mysql
            restart: always

        espocrm:
            image: elestio4test/espocrm:${SOFTWARE_VERSION_TAG}
            environment:
                ESPOCRM_DATABASE_HOST: ${ESPOCRM_DATABASE_HOST}
                ESPOCRM_DATABASE_USER: ${ESPOCRM_DATABASE_USER}
                ESPOCRM_DATABASE_PASSWORD: ${ESPOCRM_DATABASE_PASSWORD}
                ESPOCRM_ADMIN_USERNAME: ${ESPOCRM_ADMIN_USERNAME}
                ESPOCRM_ADMIN_PASSWORD: ${ESPOCRM_ADMIN_PASSWORD}
                ESPOCRM_SITE_URL: ${ESPOCRM_SITE_URL}
            volumes:
                - ./espocrm:/var/www/html
            restart: always
            ports:
                - 172.17.0.1:8686:80

        espocrm-daemon:
            image: espocrm/espocrm:${SOFTWARE_VERSION_TAG}
            volumes:
                - ./espocrm:/var/www/html
            restart: always
            entrypoint: docker-daemon.sh

        espocrm-websocket:
            image: espocrm/espocrm:${SOFTWARE_VERSION_TAG}
            environment:
                ESPOCRM_CONFIG_USE_WEB_SOCKET: ${ESPOCRM_CONFIG_USE_WEB_SOCKET}
                ESPOCRM_CONFIG_WEB_SOCKET_URL: ${ESPOCRM_CONFIG_WEB_SOCKET_URL}
                ESPOCRM_CONFIG_WEB_SOCKET_ZERO_M_Q_SUBSCRIBER_DSN: "tcp://*:7777"
                ESPOCRM_CONFIG_WEB_SOCKET_ZERO_M_Q_SUBMISSION_DSN: "tcp://espocrm-websocket:7777"
            volumes:
                - ./espocrm:/var/www/html
            restart: always
            entrypoint: docker-websocket.sh
            ports:
                - 172.17.0.1:8781:8080

### Environment variables

|           Variable            |     Value (example)     |
| :---------------------------: | :---------------------: |
|     SOFTWARE_VERSION_TAG      |         latest          |
|       MYSQL_VERSION_TAG       |         latest          |
|      MYSQL_ROOT_PASSWORD      |    your-db-password     |
|        MYSQL_DATABASE         |      your-db-name       |
|          MYSQL_USER           |        your-user        |
|        MYSQL_PASSWORD         |    your-db-password     |
|     ESPOCRM_DATABASE_HOST     |       mysql:3306        |
|     ESPOCRM_DATABASE_USER     |        your-user        |
|   ESPOCRM_DATABASE_PASSWORD   |    your-db-password     |
|    ESPOCRM_ADMIN_USERNAME     |          admin          |
|    ESPOCRM_ADMIN_PASSWORD     |      your-password      |
|       ESPOCRM_SITE_URL        | http://your-domain:8686 |
| ESPOCRM_CONFIG_USE_WEB_SOCKET |          true           |
| ESPOCRM_CONFIG_WEB_SOCKET_URL |  ws://your-domain:8781  |

# Maintenance

## Logging

The Elestio Espocrm Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://github.com/espocrm/espocrm-docker">Espocrm Github repository</a>

- <a target="_blank" href="https://docs.espocrm.com/">Espocrm documentation</a>

- <a target="_blank" href="https://github.com/elestio-examples/espocrm">Elestio/espocrm Github repository</a>

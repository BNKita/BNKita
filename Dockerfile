# Основываемся на Alpine Linux
FROM alpine:latest

# Обновляем пакеты и устанавливаем базовые зависимости
RUN apk update && \
    apk upgrade && \
    apk add openjdk17-jre tzdata curl wget ca-certificates unzip ttf-dejavu fontconfig && \
    apk add git && \
    rm -rf /var/cache/apk/*

# Загружаем и устанавливаем Jenkins
ARG JENKINS_VERSION=2.479.1
ARG USER_HOME_DIR="/home/jenkins"
ARG JENKINS_HOME=${USER_HOME_DIR}/.jenkins
ARG DOWNLOAD_URL="https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war"

RUN wget ${DOWNLOAD_URL} -O /opt/jenkins.war && \
    mkdir -p ${JENKINS_HOME}

# Настройки пользователей и групп
RUN addgroup -g 1000 jenkins && \
    adduser -D -h ${USER_HOME_DIR} -G jenkins -s /bin/sh -u 1000 jenkins && \
    chown -R jenkins:jenkins ${JENKINS_HOME}

# Меняем владельца
USER jenkins

# Раскрываем порт Jenkins
EXPOSE 8080

# Запускаем Jenkins с параметром headless
CMD ["java", "-Djava.awt.headless=true", "-jar", "/opt/jenkins.war"]

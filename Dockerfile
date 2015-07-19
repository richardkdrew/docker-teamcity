# DOCKER-VERSION 1.6.2
#
# TeamCity Build Server Dockerfile
#
# https://github.com/richardkdrew/docker-teamcity
#

FROM java:8-jre

MAINTAINER Richard Drew <richardkdrew@gmail.com>

# set up some environment variables
ENV TEAMCITY_DATA_PATH=/var/lib/teamcity \
    TEAMCITY_HOME=/opt/lib/teamcity \
    TEAMCITY_VERSION=9.1

# create user and group first
RUN groupadd -g 999 teamcity \
    && useradd -u 999 -g teamcity -d ${TEAMCITY_DATA_PATH} teamcity \
# install dependencies
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
# install TeamCity
    && mkdir -p ${TEAMCITY_HOME} \
    && mkdir -p ${TEAMCITY_DATA_PATH} \
    && curl -L -o /TeamCity-${TEAMCITY_VERSION}.tar.gz https://download.jetbrains.com/teamcity/TeamCity-${TEAMCITY_VERSION}.tar.gz \
    # https://download.jetbrains.com/teamcity/TeamCity-${TEAMCITY_VERSION}.tar.gz.sha256
    && tar zxf /TeamCity-${TEAMCITY_VERSION}.tar.gz -C /opt/lib \
    && rm -f /TeamCity-${TEAMCITY_VERSION}.tar.gz \
    && mv /opt/lib/TeamCity/* ${TEAMCITY_HOME} \
# do some clean-up
    && rm -fr ${TEAMCITY_HOME}/buildAgent \
    && rm -fr /opt/lib/TeamCity \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
# install gosu for easy step-down from root
    && curl -sSL -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
    	#&& curl -sSL -o /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
    	#&& gpg --verify /usr/local/bin/gosu.asc \
    	#&& rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

VOLUME ${TEAMCITY_DATA_PATH}

WORKDIR ${TEAMCITY_HOME}

EXPOSE 8111

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/opt/lib/teamcity/bin/teamcity-server.sh", "run"]
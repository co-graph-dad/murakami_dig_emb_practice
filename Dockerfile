FROM eclipse-temurin:8-jre

ARG DIGDAG_VERSION=0.10.5.1
ARG EMBULK_VERSION=0.10.5

ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY
ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTPS_PROXY}
ENV no_proxy=${NO_PROXY}
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}
ENV NO_PROXY=${NO_PROXY}

ENV JAVA_TOOL_OPTIONS="-Dhttps.protocols=TLSv1.2"

RUN set -eux; \
    apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    update-ca-certificates && \
    \
    curl -fsSL -o /usr/local/lib/digdag-${DIGDAG_VERSION}.jar \
      "https://github.com/treasure-data/digdag/releases/download/v${DIGDAG_VERSION}/digdag-${DIGDAG_VERSION}.jar" && \
    printf '#!/bin/sh\nexec java -jar /usr/local/lib/digdag-%s.jar "$@"\n' "${DIGDAG_VERSION}" \
      > /usr/local/bin/digdag && chmod +x /usr/local/bin/digdag && \
    \
    curl -fsSL -o /usr/local/lib/embulk.jar \
      "https://github.com/embulk/embulk/releases/download/v${EMBULK_VERSION}/embulk-${EMBULK_VERSION}.jar" && \
    printf '#!/bin/sh\nexec java -jar /usr/local/lib/embulk.jar \"$@\"\n' > /usr/local/bin/embulk && \
    chmod +x /usr/local/bin/embulk && \
    \
    mkdir -p /root/.embulk && chmod 700 /root/.embulk

ENV EMBULK_HOME=/root/.embulk

RUN mkdir -p "$EMBULK_HOME"

RUN set -eux;\
    mkdir -p "$EMBULK_HOME/lib/m2/repository/org/embulk/embulk-output-postgresql/0.10.6/";\
    mkdir -p "$EMBULK_HOME/lib/m2/repository/org/embulk/embulk-input-postgresql/0.13.2/";\
    mkdir -p "$EMBULK_HOME/lib/m2/repository/org/embulk/embulk-output-mysql/0.10.5/"

RUN set -eux;\
    curl -fsSL -o "$EMBULK_HOME/lib/m2/repository/org/embulk/embulk-output-postgresql/0.10.6/postgresql-42.7.3.jar" \
      "https://jdbc.postgresql.org/download/postgresql-42.7.3.jar";\
    curl -fsSL -o "$EMBULK_HOME/lib/m2/repository/org/embulk/embulk-input-postgresql/0.13.2/postgresql-42.7.3.jar" \
      "https://jdbc.postgresql.org/download/postgresql-42.7.3.jar";\
    curl -fsSL -o "$EMBULK_HOME/lib/m2/repository/org/embulk/embulk-output-mysql/0.10.5/mysql-connector-java-5.1.44.jar" \
      "https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.44/mysql-connector-java-5.1.44.jar"
ENV JAVA_OPTS="-Xmx1g"
WORKDIR /digdag
EXPOSE 65432
CMD ["digdag","server","--bind","0.0.0.0","--port","65432","--memory"]
FROM bluerain/zheckin:sam-runtime

ARG APP_HOME=/zheckin

RUN mkdir /data && \
    mkdir "$APP_HOME" && \
    mkdir "$APP_HOME/db" && \
    ln -s "$APP_HOME/sam" /usr/local/bin/sam

COPY bin/sam "$APP_HOME/sam"

WORKDIR $APP_HOME

ENV ZHECKIN_ENV=prod
ENV ZHECKIN_DATABASE_HOST=/data

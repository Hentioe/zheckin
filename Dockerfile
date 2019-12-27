FROM bluerain/zheckin:app-runtime

ARG APP_HOME=/home/zheckin

RUN mkdir "$APP_HOME" && \
    ln -s "$APP_HOME/zheckin" /usr/local/bin/zheckin && \
    mkdir /data && \
    ln -s /data "$APP_HOME/data"

COPY bin $APP_HOME

WORKDIR $APP_HOME

VOLUME ["/data"]

EXPOSE 8080

ENV ZHECKIN_ENV=prod
ENV ZHECKIN_DATABASE_HOST=/data

ENTRYPOINT zheckin --prod port=8080

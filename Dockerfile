FROM redis:4.0.9

MAINTAINER Jérémie Bordier <jeremie.bordier@gmail.com>

ARG GIDDYUP_VERSION=0.19.0

RUN apt-get update \
  && apt-get install -y curl openssl ca-certificates wget \
  && update-ca-certificates \
  && mkdir -p /usr/local/etc/redis \
  && cd /usr/local/etc/redis \
  && wget https://raw.githubusercontent.com/antirez/redis/4.0/redis.conf \
  && chown redis:redis /usr/local/etc/redis/redis.conf \
  && wget https://github.com/rancher/giddyup/releases/download/v${GIDDYUP_VERSION}/giddyup -P /usr/local/bin \
  && chmod +x /usr/local/bin/giddyup

RUN rm -rf ~/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD docker-entrypoint.sh /
RUN chown root:root /docker-entrypoint.sh
RUN chmod 4755 /docker-entrypoint.sh
WORKDIR /data

EXPOSE 6379 16379 26379

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]

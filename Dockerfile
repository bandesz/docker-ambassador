FROM debian:8

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq -y && \
    apt-get install -qq -y openssl socat supervisor && \
    apt-get clean

ADD /start-socat.sh /start-socat.sh
ADD /run.sh /run.sh

ADD /supervisord-socat.conf /etc/supervisor/conf.d/socat.conf
RUN chmod 755 /*.sh

CMD ["/run.sh"]

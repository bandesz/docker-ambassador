FROM debian:8

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq -y && \
    apt-get install -qq -y openssl socat supervisor && \
    apt-get clean

ADD /run.sh /run.sh
RUN chmod 755 /run.sh

CMD ["/run.sh"]

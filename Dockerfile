FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    supervisor \
    rsyslog \
    cron \
    htop \
    sudo \
    curl \
    tini \
    wget \
    net-tools \
    iputils-ping \
    ca-certificates \
    openssl \
    git \
    vim \
    unzip \
    zip \
    p7zip-full \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /panel
COPY panel.zip /panel
RUN 7z x -p"$PANEL_PASS" -o/panel /panel/panel.zip -y \
rm /panel/panel.zip \
npm install node-pty --production 
COPY entrypoint.sh /usr/local/bin/init.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisor.conf
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 10000

ENTRYPOINT ["tini", "--", "/usr/local/bin/init.sh"]
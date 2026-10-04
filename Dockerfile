FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    SSH_USER=ubuntu \
    SSH_PORT=22 \
    PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMWzSUJP9M/CdbyFJrvmcrVe83+4givFPry52NXl8Jxb Hrv Clan"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    zip \
    git \
    vim \
    cron \
    htop \
    sudo \
    curl \
    tini \
    wget \
    unzip \
    rsyslog \
    openssl \
    net-tools \
    p7zip-full \
    supervisor \
    iputils-ping \
    openssh-server \
    ca-certificates \
    && curl -fsSL https://tailscale.com/install.sh | sh \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd

WORKDIR /panel
COPY panel.zip /panel
COPY entrypoint.sh /usr/local/bin/init.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisor.conf
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 10000

ENTRYPOINT ["tini", "--"]
CMD ["/usr/local/bin/init.sh"]
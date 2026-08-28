#!/bin/bash
set -e

PANEL_USER=${PANEL_USER:-ubuntu}

if ! id "$PANEL_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$PANEL_USER"
    usermod -aG sudo "$PANEL_USER"
fi

echo 'root:123' | chpasswd
echo "$PANEL_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$PANEL_USER
chmod 440 /etc/sudoers.d/$PANEL_USER

7z x -p"$PANEL" -o/panel /panel/panel.zip -y && \
rm /panel/panel.zip && \
chown -R $PANEL_USER:$PANEL_USER /panel

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf

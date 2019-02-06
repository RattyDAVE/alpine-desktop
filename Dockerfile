FROM alpine:edge

RUN apk add \
 desktop-file-utils \
 gtk-engines \
 consolekit \
 gtk-murrine-engine \
 caja \
 caja-extensions \
 marco \
 dbus \
 dbus-x11 \
 udev \
 hicolor-icon-theme \
 sudo \
 desktop-file-utils \
 gtk-engines \
 consolekit \
 $(apk search mate -q | grep -v '\-dev' | grep -v '\-lang' | grep -v '\-doc') \
 $(apk search -q ttf- | grep -v '\-doc') \
 mc \
 x11vnc \
 xrdp \
 supervisor && \
apk del mate-screensaver && \
ln -s /usr/etc/xdg/menus/ /etc/xdg/menus && \
sed -i '/TerminalServerUsers/d' /etc/xrdp/sesman.ini && \
sed -i '/TerminalServerAdmins/d' /etc/xrdp/sesman.ini && \
xrdp-keygen xrdp auto  && \
mkdir -p /var/run/xrdp && \
chmod 2775 /var/run/xrdp  && \
mkdir -p /var/run/xrdp/sockdir && \
chmod 3777 /var/run/xrdp/sockdir && \
mkdir /etc/supervisor.d/ && \    
echo "[program:xrdp-sesman]" > /etc/supervisor.d/xrdp.ini && \
echo "command=/usr/sbin/xrdp-sesman --nodaemon" >> /etc/supervisor.d/xrdp.ini && \
echo "process_name = xrdp-sesman" >> /etc/supervisor.d/xrdp.ini && \
echo "[program:xrdp]" >> /etc/supervisor.d/xrdp.ini && \
echo "command=/usr/sbin/xrdp -nodaemon" >> /etc/supervisor.d/xrdp.ini && \
echo "process_name = xrdp" >> /etc/supervisor.d/xrdp.ini
adduser -Ds /bin/sh -G wheel dave && \
echo "dave:davep1"|chpasswd

EXPORT 3389

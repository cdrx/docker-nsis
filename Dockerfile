FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

# Need wine 1.7.xx for this all to work, so we'll use the PPA
RUN set -x \
    && dpkg --add-architecture i386 \
    && echo "deb http://ppa.launchpad.net/ubuntu-wine/ppa/ubuntu trusty main" >> /etc/apt/sources.list.d/wine.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5A9A06AEF9CB8DB0 \
    && apt-get update -qy \
    && apt-get install --no-install-recommends -qfy wine1.7 winetricks ca-certificates \
    && apt-get clean

# wine settings
ENV WINEARCH win32
ENV WINEDEBUG fixme-all
ENV WINEPREFIX /wine

# install nsis
RUN set -x \
    && wget -q -O nsis-setup.exe https://netix.dl.sourceforge.net/project/nsis/NSIS%203/3.03/nsis-3.03-setup.exe \
    && wine nsis-setup.exe /S \
    && while pgrep wineserver >/dev/null; do echo "Waiting for wineserver"; sleep 1; done \
    && rm -rf /tmp/.wine-* \
    && echo 'wine '\''C:\Program Files\NSIS\makensis.exe'\'' "$@"' > /usr/bin/makensis \
    && chmod +x /usr/bin/* \

VOLUME /wine/drive_c/src/
WORKDIR /wine/drive_c/src/

CMD makensis *.nsi

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

# wine settings
ENV WINEARCH win32
ENV WINEDEBUG fixme-all
ENV WINEPREFIX /wine

RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update -qy \
    && apt-get install --no-install-recommends -qfy wine32-development wine-development wget ca-certificates \
    && apt-get clean \
    && wget -q http://downloads.sourceforge.net/project/nsis/NSIS%203/3.03/nsis-3.03-setup.exe \
    && wine nsis-3.03-setup.exe /S \
    && while pgrep wineserver >/dev/null; do echo "Waiting for wineserver"; sleep 1; done \
    && rm -rf /tmp/.wine-* \
    && echo 'wine '\''C:\Program Files\NSIS\makensis.exe'\'' "$@"' > /usr/bin/makensis \
    && chmod +x /usr/bin/*

VOLUME /wine/drive_c/src/
WORKDIR /wine/drive_c/src/

CMD makensis *.nsi

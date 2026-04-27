# StreamSpace Altus with Selkies-GStreamer (WebRTC)
#
# Altus is a third-party WhatsApp Web desktop client (multiple
# accounts, themes, tray notifications). Distributed only as
# AppImage from amanharwara/altus GitHub releases (no .deb).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Altus"
LABEL org.opencontainers.image.description="Altus WhatsApp Web client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/amanharwara/altus/releases/latest \
        | jq -r '.assets[] | select(.name | test("^Altus-.*\\.AppImage$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve Altus AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o altus.AppImage "${img_url}"; \
    chmod +x altus.AppImage; \
    ./altus.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/altus; \
    else \
        mv AppDir /opt/altus; \
    fi; \
    rm -rf altus.AppImage AppDir squashfs-root

USER user
CMD ["/opt/altus/AppRun", "--no-sandbox"]

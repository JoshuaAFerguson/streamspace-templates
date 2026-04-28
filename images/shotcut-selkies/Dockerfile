# StreamSpace Shotcut with Selkies-GStreamer (WebRTC)
#
# Shotcut is a cross-platform non-linear video editor (joins
# kdenlive-selkies / openshot-selkies). Distributed as AppImage from
# mltframework/shotcut GitHub releases.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Shotcut"
LABEL org.opencontainers.image.description="Shotcut video editor with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/mltframework/shotcut/releases/latest \
        | jq -r '.assets[] | select(.name | test("^shotcut-linux-x86_64-.*\\.AppImage$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve Shotcut AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o shotcut.AppImage "${img_url}"; \
    chmod +x shotcut.AppImage; \
    ./shotcut.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/shotcut; \
    else \
        mv AppDir /opt/shotcut; \
    fi; \
    rm -rf shotcut.AppImage AppDir squashfs-root

USER user
CMD ["/opt/shotcut/AppRun"]

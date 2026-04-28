# StreamSpace Spotube with Selkies-GStreamer (WebRTC)
#
# Spotube is a third-party Spotify client that uses public APIs +
# YouTube Music as the audio backend (no Spotify Premium required).
# Distributed as AppImage on x86_64 (the .deb on GitHub Releases is
# aarch64-only). Standard --appimage-extract pattern.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Spotube"
LABEL org.opencontainers.image.description="Spotube Spotify client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/KRTirtho/spotube/releases/latest \
        | jq -r '.assets[] | select(.name == "Spotube-linux-x86_64.AppImage") | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve Spotube AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o spotube.AppImage "${img_url}"; \
    chmod +x spotube.AppImage; \
    ./spotube.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/spotube; \
    else \
        mv AppDir /opt/spotube; \
    fi; \
    rm -rf spotube.AppImage AppDir squashfs-root

USER user
CMD ["/opt/spotube/AppRun"]

# StreamSpace DuckStation (PlayStation 1 emulator) with Selkies-GStreamer
#
# AppImage from stenzek/duckstation GitHub releases (the "x64" variant —
# x64-SSE2 is for older CPUs without AVX2; we don't ship that).
#
# Bring your own PS1 BIOS dump and disc images at runtime.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace DuckStation"
LABEL org.opencontainers.image.description="DuckStation PS1 emulator with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.1"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/stenzek/duckstation/releases/latest \
        | jq -r '.assets[] | select(.name == "DuckStation-x64.AppImage") | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve DuckStation AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o duckstation.AppImage "${img_url}"; \
    chmod +x duckstation.AppImage; \
    ./duckstation.AppImage --appimage-extract >/dev/null; \
    mv squashfs-root /opt/duckstation; \
    rm -f duckstation.AppImage; \
    ln -s /opt/duckstation/AppRun /usr/local/bin/duckstation

USER user
CMD ["duckstation"]

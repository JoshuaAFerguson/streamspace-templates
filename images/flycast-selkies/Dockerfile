# StreamSpace Flycast (Dreamcast emulator) with Selkies-GStreamer (WebRTC)
#
# AppImage from flyinghead/flycast GitHub releases. Defensive
# AppImage-extract pattern. Bring your own Dreamcast BIOS and game
# images at runtime.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Flycast"
LABEL org.opencontainers.image.description="Flycast Dreamcast emulator with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/flyinghead/flycast/releases/latest \
        | jq -r '.assets[] | select(.name == "flycast-x86_64.AppImage") | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve Flycast AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o flycast.AppImage "${img_url}"; \
    chmod +x flycast.AppImage; \
    ./flycast.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/flycast; \
    else \
        mv AppDir /opt/flycast; \
    fi; \
    rm -rf flycast.AppImage AppDir squashfs-root

USER user
CMD ["/opt/flycast/AppRun"]

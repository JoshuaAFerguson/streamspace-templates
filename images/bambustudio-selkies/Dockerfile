# StreamSpace BambuStudio with Selkies-GStreamer (WebRTC)
#
# Bambu Lab's slicer (forked from PrusaSlicer). AppImage distribution
# from bambulab/BambuStudio GitHub releases — they ship distinct
# Ubuntu 22.04 and Ubuntu 24.04 builds; we pick the 24.04 one to
# match the base.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace BambuStudio"
LABEL org.opencontainers.image.description="Bambu Studio FDM 3D printer slicer with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/bambulab/BambuStudio/releases/latest \
        | jq -r '.assets[] | select(.name | test("ubuntu-24.04.*\\.AppImage$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve BambuStudio AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o bambustudio.AppImage "${img_url}"; \
    chmod +x bambustudio.AppImage; \
    ./bambustudio.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/bambustudio; \
    else \
        mv AppDir /opt/bambustudio; \
    fi; \
    rm -rf bambustudio.AppImage AppDir squashfs-root

USER user
CMD ["/opt/bambustudio/AppRun"]

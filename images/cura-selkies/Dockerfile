# StreamSpace UltiMaker Cura with Selkies-GStreamer (WebRTC)
#
# UltiMaker Cura is a 3D-printer slicer — joins our existing trio
# (PrusaSlicer, Bambu Studio, OrcaSlicer). Distributed as AppImage
# from Ultimaker/Cura GitHub releases.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace UltiMaker Cura"
LABEL org.opencontainers.image.description="UltiMaker Cura 3D-printer slicer with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/Ultimaker/Cura/releases/latest \
        | jq -r '.assets[] | select(.name | test("^UltiMaker-Cura-.*-linux-X64\\.AppImage$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve Cura AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o cura.AppImage "${img_url}"; \
    chmod +x cura.AppImage; \
    ./cura.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/cura; \
    else \
        mv AppDir /opt/cura; \
    fi; \
    rm -rf cura.AppImage AppDir squashfs-root

USER user
CMD ["/opt/cura/AppRun"]

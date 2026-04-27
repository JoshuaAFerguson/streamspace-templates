# StreamSpace OrcaSlicer with Selkies-GStreamer (WebRTC)
#
# Community-maintained slicer forked from BambuStudio (which is forked
# from PrusaSlicer). AppImage from SoftFever/OrcaSlicer — they ship
# the Ubuntu 24.04 build directly.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace OrcaSlicer"
LABEL org.opencontainers.image.description="OrcaSlicer FDM 3D printer slicer with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/SoftFever/OrcaSlicer/releases/latest \
        | jq -r '.assets[] | select(.name | test("Ubuntu2404.*\\.AppImage$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve OrcaSlicer AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o orcaslicer.AppImage "${img_url}"; \
    chmod +x orcaslicer.AppImage; \
    ./orcaslicer.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/orcaslicer; \
    else \
        mv AppDir /opt/orcaslicer; \
    fi; \
    rm -rf orcaslicer.AppImage AppDir squashfs-root

USER user
CMD ["/opt/orcaslicer/AppRun"]

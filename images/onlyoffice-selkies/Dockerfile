# StreamSpace OnlyOffice Desktop Editors with Selkies-GStreamer
#
# OnlyOffice's stable .deb redirect URL. Office suite alternative to
# LibreOffice (Word/Excel/PowerPoint compatible).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace OnlyOffice Desktop Editors"
LABEL org.opencontainers.image.description="OnlyOffice Desktop Editors with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    curl -fsSL -o /tmp/onlyoffice.deb \
        "https://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/onlyoffice.deb; \
    rm -f /tmp/onlyoffice.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["desktopeditors", "--no-sandbox"]

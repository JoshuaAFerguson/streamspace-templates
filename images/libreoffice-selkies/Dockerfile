# StreamSpace LibreOffice with Selkies-GStreamer (WebRTC)
#
# Installs the libreoffice meta-package (writer, calc, impress, draw,
# base, math) plus the GTK3 frontend so the apps don't render with
# the dated VCL look.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace LibreOffice"
LABEL org.opencontainers.image.description="LibreOffice productivity suite with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libreoffice \
        libreoffice-gtk3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# Default to the Start Center; users can pick a specific app from there.
CMD ["libreoffice", "--norestore"]

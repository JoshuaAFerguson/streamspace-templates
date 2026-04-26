# StreamSpace GIMP with Selkies-GStreamer (WebRTC)
#
# Streams a single GIMP (GNU Image Manipulation Program) instance via
# Selkies-GStreamer on port 8080. Ubuntu's `gimp` package is a real
# .deb (no snap stub), so this is the simplest possible derived image.
#
# Build:
#   docker build -t ghcr.io/streamspace-dev/gimp-selkies:latest .
#
# Run:
#   docker run -d --rm --shm-size=2g -p 8080:8080 \
#       ghcr.io/streamspace-dev/gimp-selkies:latest

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace GIMP"
LABEL org.opencontainers.image.description="GIMP image editor with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends gimp && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

CMD ["gimp"]

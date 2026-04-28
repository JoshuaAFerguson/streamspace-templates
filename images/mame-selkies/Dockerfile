# StreamSpace MAME with Selkies-GStreamer (WebRTC)
#
# Multiple Arcade Machine Emulator. Bring your own legally-acquired
# arcade ROM files at runtime.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace MAME"
LABEL org.opencontainers.image.description="MAME (Multiple Arcade Machine Emulator) with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends mame && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["mame"]

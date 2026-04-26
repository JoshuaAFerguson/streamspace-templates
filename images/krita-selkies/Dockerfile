# StreamSpace Krita with Selkies-GStreamer (WebRTC)
FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Krita"
LABEL org.opencontainers.image.description="Krita digital painting app with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends krita && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["krita"]

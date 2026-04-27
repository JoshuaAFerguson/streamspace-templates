# StreamSpace QDirStat with Selkies-GStreamer (WebRTC)
#
# Qt-based interactive directory statistics — what's eating your disk.
# Useful when running streamed and pointing it at a mounted volume to
# inspect remote disk usage.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace QDirStat"
LABEL org.opencontainers.image.description="QDirStat directory statistics tool with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends qdirstat && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["qdirstat"]

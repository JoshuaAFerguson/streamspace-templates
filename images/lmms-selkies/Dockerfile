# StreamSpace LMMS (Linux Multimedia Studio) with Selkies-GStreamer
#
# LMMS is an open-source music production app — beat/melody composition,
# instruments, samples, mixing, automation. Comparable to FL Studio.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace LMMS"
LABEL org.opencontainers.image.description="LMMS music production studio with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends lmms && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["lmms"]

# StreamSpace Pidgin with Selkies-GStreamer (WebRTC)
#
# Multi-protocol IM client (XMPP, IRC, etc). Plugins for additional
# protocols can be installed at runtime if needed.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Pidgin"
LABEL org.opencontainers.image.description="Pidgin multi-protocol IM client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends pidgin && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["pidgin"]

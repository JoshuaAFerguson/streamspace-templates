# StreamSpace VLC with Selkies-GStreamer (WebRTC)
#
# Universal media player. Useful as a streamed video viewer when you
# don't want to download remote media locally — point VLC at a network
# stream URL and watch via Selkies.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace VLC"
LABEL org.opencontainers.image.description="VLC media player with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends vlc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["vlc"]

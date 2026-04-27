# StreamSpace Double Commander with Selkies-GStreamer (WebRTC)
#
# Twin-panel file manager (Total Commander style). We pick the Qt5
# build (`doublecmd-qt`) over the GTK2 build (`doublecmd-gtk`) — Qt5
# integrates better with the base image's libraries and the GTK2 one
# is increasingly legacy.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Double Commander"
LABEL org.opencontainers.image.description="Double Commander twin-panel file manager with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends doublecmd-qt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["doublecmd"]

# StreamSpace DB Browser for SQLite with Selkies-GStreamer (WebRTC)
#
# GUI editor for SQLite databases. Mount your .db / .sqlite file at
# runtime to inspect/edit it.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace DB Browser for SQLite"
LABEL org.opencontainers.image.description="DB Browser for SQLite (sqlitebrowser) with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends sqlitebrowser && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["sqlitebrowser"]

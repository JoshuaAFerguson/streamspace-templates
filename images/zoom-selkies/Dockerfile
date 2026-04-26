# StreamSpace Zoom with Selkies-GStreamer (WebRTC)
#
# Zoom publishes a stable redirect URL that always 302s to the
# current .deb. Proprietary; no source.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Zoom"
LABEL org.opencontainers.image.description="Zoom video conferencing with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    curl -fsSL -o /tmp/zoom.deb "https://zoom.us/client/latest/zoom_amd64.deb"; \
    apt-get update; \
    # Zoom's .deb under-declares libopengl0 — install it explicitly so
    # /opt/zoom/zoom doesn't error with "libOpenGL.so.0: cannot open
    # shared object file".
    apt-get install -y --no-install-recommends /tmp/zoom.deb libopengl0; \
    rm -f /tmp/zoom.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["zoom"]

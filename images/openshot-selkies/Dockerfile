# StreamSpace OpenShot with Selkies-GStreamer (WebRTC)
#
# OpenShot is a non-linear video editor — alternative to kdenlive
# with a friendlier interface for casual use. Note the apt package is
# named `openshot-qt` (the older `openshot` package was the GTK1 build
# and is gone).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace OpenShot"
LABEL org.opencontainers.image.description="OpenShot video editor with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends openshot-qt && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["openshot-qt"]

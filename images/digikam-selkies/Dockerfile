# StreamSpace digiKam with Selkies-GStreamer (WebRTC)
#
# digiKam is the KDE photo manager — library management, RAW
# processing, tagging, batch operations. Mount your photo library at
# runtime (typically /home/user/Pictures or a mounted volume).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace digiKam"
LABEL org.opencontainers.image.description="digiKam KDE photo manager with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends digikam && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["digikam"]

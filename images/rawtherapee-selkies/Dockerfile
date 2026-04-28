# StreamSpace RawTherapee with Selkies-GStreamer (WebRTC)
#
# RawTherapee is a raw image converter and photo processor —
# alternative to darktable with a different feature set (e.g.
# RawTherapee has stronger noise reduction; darktable has stronger
# library management).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace RawTherapee"
LABEL org.opencontainers.image.description="RawTherapee RAW photo processor with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends rawtherapee && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["rawtherapee"]

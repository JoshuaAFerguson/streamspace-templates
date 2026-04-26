# StreamSpace OBS Studio with Selkies-GStreamer (WebRTC)
#
# OBS for recording/streaming from inside the streamed desktop. Useful
# for capturing demos, streaming from Selkies sessions, or transcoding.
# Software-encoded by default; on GPU hosts the base entrypoint sets up
# NVENC / VA-API for the *Selkies* encoder, but OBS will need separate
# configuration to use the GPU encoder for its own outputs.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace OBS Studio"
LABEL org.opencontainers.image.description="OBS Studio recording/streaming with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends obs-studio && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["obs"]

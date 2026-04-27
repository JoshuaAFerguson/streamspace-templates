# StreamSpace HandBrake with Selkies-GStreamer (WebRTC)
#
# Open-source video transcoder. CPU-bound by default; on GPU hosts
# the base entrypoint sets up NVENC/VA-API for the *streaming*
# encoder, but HandBrake's own encoders need separate config (Video
# tab → Hardware Encoder).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace HandBrake"
LABEL org.opencontainers.image.description="HandBrake video transcoder with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends handbrake && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["handbrake"]

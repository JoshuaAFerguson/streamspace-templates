# StreamSpace RetroArch with Selkies-GStreamer (WebRTC)
#
# Includes a small set of popular libretro cores so the image is
# usable out of the box (no manual core install needed). Add more
# from `apt search libretro-*` if you fork.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace RetroArch"
LABEL org.opencontainers.image.description="RetroArch frontend with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        retroarch \
        libretro-snes9x \
        libretro-genesisplusgx \
        libretro-mgba \
        libretro-nestopia && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["retroarch"]

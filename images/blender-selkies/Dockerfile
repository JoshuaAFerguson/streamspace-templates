# StreamSpace Blender with Selkies-GStreamer (WebRTC)
#
# Installs Ubuntu's `blender` apt package. It's an older release than
# what blender.org ships as a tarball, but it's the simplest install
# path and gets new versions on each Ubuntu LTS update. For bleeding-
# edge Blender, fork this image and pull blender.org's .tar.xz instead.
#
# GPU note: when this image is scheduled on a host with /dev/nvidia0
# or /dev/dri/renderD128, the base entrypoint auto-selects nvh264enc
# or vah264enc for the *streaming* encoder. Cycles render-engine GPU
# acceleration still requires --gpus all (Docker) or the NVIDIA / AMD
# device plugins (Kubernetes).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Blender"
LABEL org.opencontainers.image.description="Blender 3D suite with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends blender && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["blender"]

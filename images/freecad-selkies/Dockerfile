# StreamSpace FreeCAD with Selkies-GStreamer (WebRTC)
#
# FreeCAD was removed from Ubuntu 24.04's archives, so we install it
# from the freecad-maintainers PPA instead. We pull in
# software-properties-common just for `add-apt-repository`, then
# purge it after the install to keep the image lean.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace FreeCAD"
LABEL org.opencontainers.image.description="FreeCAD parametric 3D modeler with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:freecad-maintainers/freecad-stable && \
    apt-get update && \
    apt-get install -y --no-install-recommends freecad && \
    apt-get purge -y software-properties-common && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["freecad"]

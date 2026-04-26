# StreamSpace OpenSCAD with Selkies-GStreamer (WebRTC)
#
# OpenSCAD is "the programmer's solid 3D CAD modeler" — design via
# code (CSG) instead of an interactive modeling UI. Complementary to
# the more interactive freecad-selkies image.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace OpenSCAD"
LABEL org.opencontainers.image.description="OpenSCAD code-based 3D CAD modeler with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends openscad && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["openscad"]

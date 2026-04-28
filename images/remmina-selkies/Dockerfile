# StreamSpace Remmina with Selkies-GStreamer (WebRTC)
#
# Remmina is a GTK remote desktop client — RDP, VNC, SPICE, X2Go,
# SSH. Useful in the streaming-as-a-jump-host pattern: connect via
# Selkies in your browser, then use Remmina inside it to reach other
# remote desktops on a private network.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Remmina"
LABEL org.opencontainers.image.description="Remmina GTK remote desktop client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends remmina && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["remmina"]

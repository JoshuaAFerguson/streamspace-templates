# StreamSpace Devolutions Remote Desktop Manager with Selkies-GStreamer (WebRTC)
#
# Devolutions Remote Desktop Manager (RDM) is a multi-protocol remote
# connection manager (RDP, SSH, VNC, SPICE, ARD, web sessions, etc.)
# with credential vaulting. Distributed via Cloudsmith apt repo —
# slightly different keyring URL pattern from other vendor apt repos
# (Cloudsmith embeds the GPG fingerprint in the key URL).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Devolutions RDM"
LABEL org.opencontainers.image.description="Devolutions Remote Desktop Manager with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL "https://dl.cloudsmith.io/public/devolutions/rdm/gpg.FE7407ECB26FD2FE.key" \
        | gpg --dearmor -o /etc/apt/keyrings/devolutions-rdm-archive-keyring.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/devolutions-rdm-archive-keyring.gpg] https://dl.cloudsmith.io/public/devolutions/rdm/deb/ubuntu noble main" \
        > /etc/apt/sources.list.d/devolutions-rdm.list; \
    apt-get update && apt-get install -y --no-install-recommends remotedesktopmanager; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["remotedesktopmanager"]

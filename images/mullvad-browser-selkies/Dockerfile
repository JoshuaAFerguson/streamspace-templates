# StreamSpace Mullvad Browser with Selkies-GStreamer (WebRTC)
#
# Mullvad Browser is Tor Browser derivative collaboration between Tor
# Project and Mullvad VPN — designed to use without the Tor network
# (intended for users who want Tor's anti-fingerprinting against a
# regular VPN like Mullvad). Mullvad's apt repo at
# repository.mullvad.net/deb/stable also ships mullvad-vpn and the
# alpha browser variant.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Mullvad Browser"
LABEL org.opencontainers.image.description="Mullvad Browser (Tor-derived privacy browser) with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://repository.mullvad.net/deb/mullvad-keyring.asc \
        | gpg --dearmor -o /etc/apt/keyrings/mullvad-keyring.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/mullvad-keyring.gpg] https://repository.mullvad.net/deb/stable stable main" \
        > /etc/apt/sources.list.d/mullvad.list; \
    apt-get update && apt-get install -y --no-install-recommends mullvad-browser; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["mullvad-browser"]

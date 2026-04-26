# StreamSpace Thunderbird with Selkies-GStreamer (WebRTC)
#
# Mozilla's apt repo (packages.mozilla.org) only ships Firefox variants
# — no Thunderbird — so we install Thunderbird from the official Mozilla
# tarball. Ubuntu's `thunderbird` apt package is a snap-redirect stub
# on 24.04 (same problem as firefox), so apt-pinning won't help.
#
# Tarball is self-contained; the runtime libs it needs (gtk3, dbus,
# alsa, fonts) are already in selkies-base.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Thunderbird"
LABEL org.opencontainers.image.description="Mozilla Thunderbird email client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends xz-utils; \
    curl -fsSL -o /tmp/thunderbird.tar.xz \
        "https://download.mozilla.org/?product=thunderbird-latest&os=linux64&lang=en-US"; \
    install -d -m 0755 /opt; \
    tar xJf /tmp/thunderbird.tar.xz -C /opt; \
    rm /tmp/thunderbird.tar.xz; \
    ln -s /opt/thunderbird/thunderbird /usr/local/bin/thunderbird; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["thunderbird"]

# StreamSpace LibreWolf with Selkies-GStreamer (WebRTC)
#
# LibreWolf is a privacy-hardened Firefox fork. Their apt repo at
# repo.librewolf.net (note: deb.librewolf.net is a different host that
# 404s; repo.librewolf.net is the canonical one).
#
# Suite name is "librewolf" (not Ubuntu-codename-specific) — same
# packages work across noble/jammy/bookworm.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace LibreWolf"
LABEL org.opencontainers.image.description="LibreWolf privacy-hardened Firefox fork with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://repo.librewolf.net/pubkey.gpg \
        | gpg --dearmor -o /etc/apt/keyrings/librewolf.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/librewolf.gpg] https://repo.librewolf.net/ librewolf main" \
        > /etc/apt/sources.list.d/librewolf.list; \
    apt-get update && apt-get install -y --no-install-recommends librewolf; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["librewolf"]

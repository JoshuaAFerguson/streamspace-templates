# StreamSpace Brave with Selkies-GStreamer (WebRTC)
#
# Brave's official apt repo. Chromium-based; same Electron sandbox
# limitation as Chrome — needs --no-sandbox in unprivileged containers.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Brave"
LABEL org.opencontainers.image.description="Brave browser with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
        -o /etc/apt/keyrings/brave-browser-archive-keyring.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" \
        > /etc/apt/sources.list.d/brave-browser-release.list; \
    apt-get update && apt-get install -y --no-install-recommends brave-browser; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

CMD ["brave-browser", \
     "--no-sandbox", \
     "--disable-dev-shm-usage", \
     "--disable-gpu-sandbox", \
     "--start-maximized"]

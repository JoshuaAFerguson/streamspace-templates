# StreamSpace Vivaldi with Selkies-GStreamer (WebRTC)
#
# Vivaldi's official apt repo. Chromium-based; same --no-sandbox.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Vivaldi"
LABEL org.opencontainers.image.description="Vivaldi browser with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub \
        | gpg --dearmor -o /etc/apt/keyrings/vivaldi.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vivaldi.gpg] https://repo.vivaldi.com/archive/deb/ stable main" \
        > /etc/apt/sources.list.d/vivaldi.list; \
    apt-get update && apt-get install -y --no-install-recommends vivaldi-stable; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

CMD ["vivaldi", \
     "--no-sandbox", \
     "--disable-dev-shm-usage", \
     "--disable-gpu-sandbox", \
     "--start-maximized"]

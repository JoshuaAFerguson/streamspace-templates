# StreamSpace Opera with Selkies-GStreamer (WebRTC)
#
# Opera's official apt repo. Note the suite name is "stable" with
# component "non-free" (Opera is proprietary).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Opera"
LABEL org.opencontainers.image.description="Opera browser with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://deb.opera.com/archive.key \
        | gpg --dearmor -o /etc/apt/keyrings/opera.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/opera.gpg] https://deb.opera.com/opera-stable/ stable non-free" \
        > /etc/apt/sources.list.d/opera-stable.list; \
    apt-get update && apt-get install -y --no-install-recommends opera-stable; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

CMD ["opera", \
     "--no-sandbox", \
     "--disable-dev-shm-usage", \
     "--disable-gpu-sandbox", \
     "--start-maximized"]

# StreamSpace DBeaver Community with Selkies-GStreamer (WebRTC)
#
# DBeaver publishes a stable redirect URL that 302s through GitHub
# releases to the current .deb. Eclipse-based — needs a JRE which the
# .deb pulls in via apt deps.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace DBeaver Community"
LABEL org.opencontainers.image.description="DBeaver Community SQL/database client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    curl -fsSL -o /tmp/dbeaver.deb "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/dbeaver.deb; \
    rm -f /tmp/dbeaver.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["dbeaver"]

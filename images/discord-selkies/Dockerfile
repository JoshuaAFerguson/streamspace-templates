# StreamSpace Discord with Selkies-GStreamer (WebRTC)
#
# Discord publishes a stable redirect URL that always 302s to the
# current .deb. We pull it at build time, so rebuilds get the latest
# version automatically.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Discord"
LABEL org.opencontainers.image.description="Discord chat client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    curl -fsSL -o /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/discord.deb; \
    rm -f /tmp/discord.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# --no-sandbox: Electron sandbox limitation in unprivileged containers.
CMD ["discord", "--no-sandbox"]

# StreamSpace Signal Desktop with Selkies-GStreamer (WebRTC)
#
# Signal's official apt repo at updates.signal.org. The suite name
# "xenial" is upstream's choice and not Ubuntu-version-specific;
# the same packages work on noble.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Signal Desktop"
LABEL org.opencontainers.image.description="Signal Desktop messenger with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://updates.signal.org/desktop/apt/keys.asc \
        | gpg --dearmor -o /etc/apt/keyrings/signal-desktop-keyring.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main" \
        > /etc/apt/sources.list.d/signal-xenial.list; \
    apt-get update && apt-get install -y --no-install-recommends signal-desktop; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# --no-sandbox: Electron sandbox limitation in unprivileged containers.
CMD ["signal-desktop", "--no-sandbox"]

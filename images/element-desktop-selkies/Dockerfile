# StreamSpace Element Desktop with Selkies-GStreamer (WebRTC)
#
# Element's official apt repo at packages.element.io.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Element Desktop"
LABEL org.opencontainers.image.description="Element (Matrix) desktop client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://packages.element.io/debian/element-io-archive-keyring.gpg \
        -o /etc/apt/keyrings/element-io-archive-keyring.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" \
        > /etc/apt/sources.list.d/element-io.list; \
    apt-get update && apt-get install -y --no-install-recommends element-desktop; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# --no-sandbox: Electron sandbox limitation in unprivileged containers.
CMD ["element-desktop", "--no-sandbox"]

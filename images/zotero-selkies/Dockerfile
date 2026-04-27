# StreamSpace Zotero with Selkies-GStreamer (WebRTC)
#
# Zotero is an open-source research/citation manager. Distributed as
# a self-contained tar.xz from zotero.org (Mozilla-stack runtime
# bundled). The /download/client/dl?platform=linux-x86_64 URL is a
# stable redirect to the current versioned tarball.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Zotero"
LABEL org.opencontainers.image.description="Zotero research citation manager with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends xz-utils; \
    curl -fsSL -o /tmp/zotero.tar.xz \
        "https://www.zotero.org/download/client/dl?platform=linux-x86_64&channel=release"; \
    install -d -m 0755 /opt; \
    tar xJf /tmp/zotero.tar.xz -C /opt; \
    rm -f /tmp/zotero.tar.xz; \
    # Tarball extracts to a versioned dir like Zotero_linux-x86_64/.
    # Rename to /opt/zotero/ so the CMD path is stable across upgrades.
    mv /opt/Zotero_linux-x86_64 /opt/zotero; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["/opt/zotero/zotero"]

# StreamSpace Zen Browser with Selkies-GStreamer (WebRTC)
#
# Zen Browser is a Firefox fork focused on workflow features
# (workspaces, vertical tabs, split view, glance preview). Distributed
# as self-contained tar.xz from zen-browser/desktop GitHub releases —
# Firefox-based runtime is bundled.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Zen Browser"
LABEL org.opencontainers.image.description="Zen Browser (Firefox fork with workspaces/vertical tabs) with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends xz-utils; \
    tar_url="$(curl -fsSL https://api.github.com/repos/zen-browser/desktop/releases/latest \
        | jq -r '.assets[] | select(.name == "zen.linux-x86_64.tar.xz") | .browser_download_url' \
        | head -1)"; \
    if [ -z "${tar_url}" ]; then echo "Could not resolve Zen Browser tar.xz URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/zen.tar.xz "${tar_url}"; \
    install -d -m 0755 /opt; \
    tar xJf /tmp/zen.tar.xz -C /opt; \
    rm -f /tmp/zen.tar.xz; \
    ln -s /opt/zen/zen /usr/local/bin/zen; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["zen"]

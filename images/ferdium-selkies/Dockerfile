# StreamSpace Ferdium with Selkies-GStreamer (WebRTC)
#
# Ferdium is a multi-platform messenger aggregator (Franz successor).
# Electron-based; .deb from ferdium/ferdium-app GitHub releases.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Ferdium"
LABEL org.opencontainers.image.description="Ferdium multi-messenger aggregator with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    deb_url="$(curl -fsSL https://api.github.com/repos/ferdium/ferdium-app/releases/latest \
        | jq -r '.assets[] | select(.name | test("Ferdium-linux-.*-amd64\\.deb$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${deb_url}" ]; then echo "Could not resolve Ferdium .deb URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/ferdium.deb "${deb_url}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/ferdium.deb; \
    rm -f /tmp/ferdium.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["ferdium", "--no-sandbox"]

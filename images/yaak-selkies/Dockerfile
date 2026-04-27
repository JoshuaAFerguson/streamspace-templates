# StreamSpace Yaak with Selkies-GStreamer (WebRTC)
#
# Yaak is a desktop API client (Postman/Insomnia alternative). Vendor
# .deb from mountain-loop/yaak GitHub releases.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Yaak"
LABEL org.opencontainers.image.description="Yaak desktop API client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    deb_url="$(curl -fsSL https://api.github.com/repos/mountain-loop/yaak/releases/latest \
        | jq -r '.assets[] | select(.name | test("^yaak_.*_amd64\\.deb$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${deb_url}" ]; then echo "Could not resolve Yaak .deb URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/yaak.deb "${deb_url}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/yaak.deb; \
    rm -f /tmp/yaak.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# Tauri/Electron-style — needs --no-sandbox in unprivileged containers.
CMD ["yaak", "--no-sandbox"]

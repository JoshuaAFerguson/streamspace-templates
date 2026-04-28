# StreamSpace RustDesk with Selkies-GStreamer (WebRTC)
#
# RustDesk is an open-source remote desktop / TeamViewer alternative.
# Vendor .deb from rustdesk/rustdesk GitHub releases.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace RustDesk"
LABEL org.opencontainers.image.description="RustDesk remote desktop client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    deb_url="$(curl -fsSL https://api.github.com/repos/rustdesk/rustdesk/releases/latest \
        | jq -r '.assets[] | select(.name | test("^rustdesk-.*-x86_64\\.deb$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${deb_url}" ]; then echo "Could not resolve RustDesk .deb URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/rustdesk.deb "${deb_url}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/rustdesk.deb; \
    rm -f /tmp/rustdesk.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["rustdesk"]

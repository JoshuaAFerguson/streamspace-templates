# StreamSpace GitHub Desktop with Selkies-GStreamer (WebRTC)
#
# GitHub Inc. doesn't ship an official Linux client. shiftkey/desktop
# is the community-maintained Linux fork — it tracks upstream GitHub
# Desktop changes and ships .deb / .rpm / .AppImage builds for Linux.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace GitHub Desktop (shiftkey fork)"
LABEL org.opencontainers.image.description="GitHub Desktop Linux fork with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    deb_url="$(curl -fsSL https://api.github.com/repos/shiftkey/desktop/releases/latest \
        | jq -r '.assets[] | select(.name | test("linux-amd64-.*\\.deb$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${deb_url}" ]; then echo "Could not resolve GitHub Desktop .deb URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/github-desktop.deb "${deb_url}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/github-desktop.deb; \
    rm -f /tmp/github-desktop.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# Electron — needs --no-sandbox in unprivileged containers.
CMD ["github-desktop", "--no-sandbox"]

# StreamSpace WebCord with Selkies-GStreamer (WebRTC)
#
# WebCord is a privacy-focused unofficial Discord client (Electron
# wrapper around discord.com web app, with extra hardening). Useful
# alternative to discord-selkies for users avoiding Discord's native
# tracking.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace WebCord"
LABEL org.opencontainers.image.description="WebCord privacy-focused Discord client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    deb_url="$(curl -fsSL https://api.github.com/repos/SpacingBat3/WebCord/releases/latest \
        | jq -r '.assets[] | select(.name | test("^webcord_.*_amd64\\.deb$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${deb_url}" ]; then echo "Could not resolve WebCord .deb URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/webcord.deb "${deb_url}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/webcord.deb; \
    rm -f /tmp/webcord.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["webcord", "--no-sandbox"]

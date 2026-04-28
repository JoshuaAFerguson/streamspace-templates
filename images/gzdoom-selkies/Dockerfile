# StreamSpace GZDoom with Selkies-GStreamer (WebRTC)
#
# GZDoom is the modern Doom source port (Doom, Doom II, Heretic, Hexen,
# Strife, plus countless mods). Vendor .deb from ZDoom/gzdoom GitHub
# releases. Bring your own legally-acquired WAD files at runtime.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace GZDoom"
LABEL org.opencontainers.image.description="GZDoom Doom source port with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    deb_url="$(curl -fsSL https://api.github.com/repos/ZDoom/gzdoom/releases/latest \
        | jq -r '.assets[] | select(.name | test("^gzdoom_.*_amd64\\.deb$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${deb_url}" ]; then echo "Could not resolve GZDoom .deb URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/gzdoom.deb "${deb_url}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/gzdoom.deb; \
    rm -f /tmp/gzdoom.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["gzdoom"]

# StreamSpace Obsidian with Selkies-GStreamer (WebRTC)
#
# Obsidian is an Electron app distributed only as a .deb (no apt repo).
# We grab the latest amd64 .deb from the GitHub releases at build time.
# Rebuilds get the latest version automatically — that's the right
# tradeoff for a streaming-focused image since users expect "current".

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Obsidian"
LABEL org.opencontainers.image.description="Obsidian note-taking app with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

# Resolve the latest amd64 .deb from the GitHub releases API. The base
# image already has curl + jq.
RUN set -eux; \
    deb_url="$(curl -fsSL https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
        | jq -r '.assets[] | select(.name | endswith("_amd64.deb")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${deb_url}" ]; then echo "Could not resolve Obsidian .deb URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/obsidian.deb "${deb_url}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/obsidian.deb; \
    rm -f /tmp/obsidian.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# --no-sandbox: Electron sandbox limitation in unprivileged containers.
CMD ["obsidian", "--no-sandbox"]

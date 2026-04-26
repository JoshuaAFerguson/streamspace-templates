# StreamSpace VSCodium Editor with Selkies-GStreamer (WebRTC)
#
# Streams a single VSCodium (community-driven, freely-licensed VS Code
# build) instance via Selkies-GStreamer on port 8080. Everything except
# the VSCodium .deb install lives in selkies-base.
#
# Why VSCodium and not VS Code: VSCodium ships under the MIT license
# without Microsoft's telemetry/branding additions. Same editor surface,
# different build.
#
# Build:
#   docker build -t ghcr.io/streamspace-dev/vscodium-selkies:latest .
#
# Run:
#   docker run -d --rm --shm-size=2g -p 8080:8080 \
#       ghcr.io/streamspace-dev/vscodium-selkies:latest

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace VSCodium"
LABEL org.opencontainers.image.description="VSCodium editor with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    wget -qO- https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
        | gpg --dearmor -o /etc/apt/keyrings/vscodium.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/vscodium.gpg] https://download.vscodium.com/debs vscodium main" \
        > /etc/apt/sources.list.d/vscodium.list; \
    apt-get update && apt-get install -y --no-install-recommends codium; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# --no-sandbox: same reason as Chrome — no CAP_SYS_ADMIN for the
# Electron sandbox inside an unprivileged container.
CMD ["codium", "--no-sandbox"]

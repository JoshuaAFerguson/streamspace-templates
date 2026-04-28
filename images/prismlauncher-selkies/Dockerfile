# StreamSpace PrismLauncher with Selkies-GStreamer (WebRTC)
#
# PrismLauncher is the community-maintained Minecraft launcher
# (continuation of MultiMC). Manages multiple instances, mod loaders
# (Forge/Fabric/Quilt/NeoForge), accounts (Microsoft/offline), and
# resource packs. AppImage from PrismLauncher/PrismLauncher GitHub
# releases.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace PrismLauncher"
LABEL org.opencontainers.image.description="PrismLauncher Minecraft launcher with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

# OpenJDK runtime — Minecraft needs Java 17+ for modern versions.
# PrismLauncher's AppImage doesn't bundle a JRE; users typically
# install one via the launcher itself, but pre-installing avoids the
# first-launch delay.
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends openjdk-21-jre; \
    img_url="$(curl -fsSL https://api.github.com/repos/PrismLauncher/PrismLauncher/releases/latest \
        | jq -r '.assets[] | select(.name == "PrismLauncher-Linux-x86_64.AppImage") | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve PrismLauncher AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o prismlauncher.AppImage "${img_url}"; \
    chmod +x prismlauncher.AppImage; \
    ./prismlauncher.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/prismlauncher; \
    else \
        mv AppDir /opt/prismlauncher; \
    fi; \
    rm -rf prismlauncher.AppImage AppDir squashfs-root; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["/opt/prismlauncher/AppRun"]

# StreamSpace PCSX2 (PlayStation 2 emulator) with Selkies-GStreamer
#
# AppImage from the PCSX2/pcsx2 GitHub releases — there's no apt
# package on Ubuntu 24.04. We use --appimage-extract because FUSE
# doesn't work in unprivileged containers; AppImage's offline
# extraction tooling is built into the runtime so no extra deps
# beyond what the base provides.
#
# Bring your own PS2 BIOS dump and game ISOs at runtime. PCSX2 won't
# run anything without a valid SCPH-* BIOS in ~/.config/PCSX2/bios/.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace PCSX2"
LABEL org.opencontainers.image.description="PCSX2 PS2 emulator with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

# libopengl0: AppImages don't bundle system OpenGL — same fix as zoom.
# Without this, /opt/pcsx2/AppRun → pcsx2 binary errors with
# "libOpenGL.so.0: cannot open shared object file".
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends libopengl0; \
    img_url="$(curl -fsSL https://api.github.com/repos/PCSX2/pcsx2/releases/latest \
        | jq -r '.assets[] | select(.name | test("linux-appimage-x64-Qt\\.AppImage$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve PCSX2 AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o pcsx2.AppImage "${img_url}"; \
    chmod +x pcsx2.AppImage; \
    ./pcsx2.AppImage --appimage-extract >/dev/null; \
    mv squashfs-root /opt/pcsx2; \
    rm -f pcsx2.AppImage; \
    ln -s /opt/pcsx2/AppRun /usr/local/bin/pcsx2; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["pcsx2"]

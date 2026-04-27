# StreamSpace RPCS3 (PlayStation 3 emulator) with Selkies-GStreamer
#
# AppImage from RPCS3/rpcs3-binaries-linux. Same --appimage-extract
# pattern as PCSX2.
#
# Bring your own PS3 firmware (PS3UPDAT.PUP) and game files at runtime.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace RPCS3"
LABEL org.opencontainers.image.description="RPCS3 PS3 emulator with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

# libopengl0: AppImages don't bundle system OpenGL — same fix as
# zoom/pcsx2/duckstation. Without this, RPCS3 errors with
# "libOpenGL.so.0: cannot open shared object file".
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends libopengl0; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    img_url="$(curl -fsSL https://api.github.com/repos/RPCS3/rpcs3-binaries-linux/releases/latest \
        | jq -r '.assets[] | select(.name | endswith("_linux64.AppImage")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve RPCS3 AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o rpcs3.AppImage "${img_url}"; \
    chmod +x rpcs3.AppImage; \
    ./rpcs3.AppImage --appimage-extract >/dev/null; \
    # RPCS3's AppImage extracts to AppDir/ as the real dir and creates
    # squashfs-root as a symlink to it (other AppImages do the opposite).
    # `mv squashfs-root` would move the symlink, not the contents — we
    # explicitly target AppDir so we get the real directory tree.
    mv AppDir /opt/rpcs3; \
    rm -f rpcs3.AppImage squashfs-root

USER user

# RPCS3's AppRun computes its data paths from $0 without following
# symlinks — invoking via /usr/local/bin/rpcs3 (a symlink) breaks the
# apprun-hooks lookup. Use the absolute path to the real script.
CMD ["/opt/rpcs3/AppRun"]

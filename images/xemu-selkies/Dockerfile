# StreamSpace xemu (original Xbox emulator) with Selkies-GStreamer (WebRTC)
#
# AppImage from xemu-project/xemu GitHub releases. Pick the non-dbg
# variant (the dbg one is bigger with debug symbols). Bring your own
# Xbox MCPX BIOS dump + HDD image + game files at runtime.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace xemu"
LABEL org.opencontainers.image.description="xemu original Xbox emulator with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/xemu-project/xemu/releases/latest \
        | jq -r '.assets[] | select(.name | test("^xemu-[0-9.]+-x86_64\\.AppImage$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve xemu AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o xemu.AppImage "${img_url}"; \
    chmod +x xemu.AppImage; \
    ./xemu.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/xemu; \
    else \
        mv AppDir /opt/xemu; \
    fi; \
    rm -rf xemu.AppImage AppDir squashfs-root

USER user
CMD ["/opt/xemu/AppRun"]

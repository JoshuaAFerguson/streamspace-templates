# StreamSpace Joplin with Selkies-GStreamer (WebRTC)
#
# Joplin is an open-source notes app with sync. Distributed as an
# AppImage from laurent22/joplin GitHub releases. Standard
# --appimage-extract pattern.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Joplin"
LABEL org.opencontainers.image.description="Joplin note-taking app with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL https://api.github.com/repos/laurent22/joplin/releases/latest \
        | jq -r '.assets[] | select(.name | test("^Joplin-.*\\.AppImage$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve Joplin AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o joplin.AppImage "${img_url}"; \
    chmod +x joplin.AppImage; \
    ./joplin.AppImage --appimage-extract >/dev/null; \
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/joplin; \
    else \
        mv AppDir /opt/joplin; \
    fi; \
    rm -rf joplin.AppImage AppDir squashfs-root

USER user
CMD ["/opt/joplin/AppRun", "--no-sandbox"]

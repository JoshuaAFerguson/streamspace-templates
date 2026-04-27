# StreamSpace PrusaSlicer with Selkies-GStreamer (WebRTC)
#
# Slicer for FDM 3D printers (.stl/.3mf in, G-code out). Pinned via
# "find the most recent release with a Linux AppImage asset" — Prusa
# stopped attaching AppImages to GitHub releases after 2.8.1 (they
# now distribute newer versions only via prusa3d.com), but the API
# query auto-picks up future versions if they ever re-add them.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace PrusaSlicer"
LABEL org.opencontainers.image.description="PrusaSlicer FDM 3D printer slicer with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    img_url="$(curl -fsSL 'https://api.github.com/repos/prusa3d/PrusaSlicer/releases?per_page=20' \
        | jq -r '.[] | .assets[]? | select(.name | test("linux-x64-newer-distros-GTK3.*\\.AppImage$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${img_url}" ]; then echo "Could not resolve PrusaSlicer AppImage URL" >&2; exit 1; fi; \
    cd /tmp; \
    curl -fsSL -o prusaslicer.AppImage "${img_url}"; \
    chmod +x prusaslicer.AppImage; \
    ./prusaslicer.AppImage --appimage-extract >/dev/null; \
    # Some AppImages extract to AppDir/ as the real dir + squashfs-root
    # as a symlink to it; others do the opposite. Handle both.
    if [ -d squashfs-root ] && [ ! -L squashfs-root ]; then \
        mv squashfs-root /opt/prusaslicer; \
    else \
        mv AppDir /opt/prusaslicer; \
    fi; \
    rm -rf prusaslicer.AppImage AppDir squashfs-root

USER user

# Use the absolute AppRun path — relying on a /usr/local/bin symlink
# breaks AppImages whose AppRun script computes data paths from $0
# without following symlinks (we hit this with RPCS3).
CMD ["/opt/prusaslicer/AppRun"]

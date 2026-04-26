# StreamSpace Xournal++ with Selkies-GStreamer (WebRTC)
#
# Xournal++ is a handwritten-notes / PDF-annotation app. Selkies's
# input handling forwards stylus / pen events from the browser if the
# client supports them, so this image is useful from a tablet.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Xournal++"
LABEL org.opencontainers.image.description="Xournal++ handwritten notes / PDF annotation with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

# yaru-theme-icon: Ubuntu's default GTK icon theme is "Yaru", so xournalpp
# looks up icons there by name. Without the theme installed, the lookup
# for 'image-missing' fails and GTK SIGABRTs (it doesn't fall back to
# Adwaita gracefully — installing adwaita-icon-theme alone does not fix
# this; the theme name match is what matters).
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        xournalpp \
        yaru-theme-icon && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["xournalpp"]

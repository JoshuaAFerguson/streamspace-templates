# StreamSpace Calligra with Selkies-GStreamer (WebRTC)
#
# Calligra is the KDE productivity & creative suite (Words, Sheets,
# Stage, Karbon, Plan). The `calligra` meta-package pulls all the
# core apps in. Heavyweight install (~600 MB) but covers an entire
# office workflow in one image.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Calligra"
LABEL org.opencontainers.image.description="Calligra KDE productivity suite with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends calligra && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
# calligra meta-package doesn't ship a single launcher — open the
# Words app by default; users can launch other Calligra apps from
# inside it or via the menu.
CMD ["calligrawords"]

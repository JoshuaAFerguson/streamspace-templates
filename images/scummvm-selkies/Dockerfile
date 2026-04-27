# StreamSpace ScummVM with Selkies-GStreamer (WebRTC)
#
# Engine for classic point-and-click adventure games (Day of the
# Tentacle, Monkey Island, Beneath a Steel Sky, ...).
# Bring your own legally-acquired game data, mounted at runtime.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace ScummVM"
LABEL org.opencontainers.image.description="ScummVM adventure game engine with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
# Ubuntu installs game binaries to /usr/games/ which isn't on the
# default PATH. Symlink so CMD ["scummvm"] resolves.
RUN apt-get update && \
    apt-get install -y --no-install-recommends scummvm && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/games/scummvm /usr/local/bin/scummvm

USER user
CMD ["scummvm"]

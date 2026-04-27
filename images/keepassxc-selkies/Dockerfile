# StreamSpace KeePassXC with Selkies-GStreamer (WebRTC)
#
# Cross-platform password manager. Mount your .kdbx vault at runtime
# (e.g. -v /path/to/vault.kdbx:/home/user/Documents/vault.kdbx).

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace KeePassXC"
LABEL org.opencontainers.image.description="KeePassXC password manager with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends keepassxc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["keepassxc"]

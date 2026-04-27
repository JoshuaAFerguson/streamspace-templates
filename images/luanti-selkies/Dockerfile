# StreamSpace Luanti (formerly Minetest) with Selkies-GStreamer (WebRTC)
#
# Voxel sandbox / multiplayer game engine. Renamed from Minetest to
# Luanti in September 2024, but Ubuntu noble's apt package still ships
# under the old `minetest` name (rename happened after the Ubuntu
# freeze date). Symlink to /usr/local/bin/luanti so users can invoke
# either name.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Luanti"
LABEL org.opencontainers.image.description="Luanti (formerly Minetest) voxel sandbox with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends minetest && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/games/minetest /usr/local/bin/luanti

USER user
CMD ["luanti"]

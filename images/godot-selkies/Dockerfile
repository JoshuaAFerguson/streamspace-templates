# StreamSpace Godot Engine with Selkies-GStreamer (WebRTC)
#
# Godot ships as a .zip containing a single statically-linked binary,
# so we extract to /opt/godot and symlink the binary into /usr/local/bin.
# The mono (C# scripting) variant is left out — bigger and most users
# don't need it. Fork the image and swap the asset selector if you do.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Godot Engine"
LABEL org.opencontainers.image.description="Godot game engine with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends unzip; \
    zip_url="$(curl -fsSL https://api.github.com/repos/godotengine/godot/releases/latest \
        | jq -r '.assets[] | select(.name | test("^Godot_v[0-9.]+-stable_linux\\.x86_64\\.zip$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${zip_url}" ]; then echo "Could not resolve Godot .zip URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/godot.zip "${zip_url}"; \
    install -d -m 0755 /opt/godot; \
    unzip -q /tmp/godot.zip -d /opt/godot; \
    rm -f /tmp/godot.zip; \
    chmod +x /opt/godot/Godot_v*-stable_linux.x86_64; \
    ln -s "$(ls /opt/godot/Godot_v*-stable_linux.x86_64)" /usr/local/bin/godot; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["godot"]

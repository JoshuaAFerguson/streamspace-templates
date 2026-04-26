# StreamSpace Chrome Browser with Selkies-GStreamer (WebRTC)
#
# Streams a single Chrome instance via Selkies-GStreamer on port 8080.
# All the heavy lifting (Xvfb, PulseAudio, Selkies, GStreamer, encoder
# auto-detection, non-root user, entrypoint) lives in selkies-base.
# This image only adds the Chrome apt repo + google-chrome-stable.
#
# Build:
#   docker build -t ghcr.io/streamspace-dev/chrome-selkies:latest .
#
# Run:
#   docker run -d --rm --shm-size=2g -p 8080:8080 \
#       ghcr.io/streamspace-dev/chrome-selkies:latest
#   open http://localhost:8080

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Chrome Browser"
LABEL org.opencontainers.image.description="Chrome browser with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.1.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root

ARG DEBIAN_FRONTEND=noninteractive

# Google Chrome stable channel (amd64 only — Chrome doesn't publish arm64
# .deb packages, and selkies-base is amd64-only anyway).
RUN set -eux; \
    wget -q -O /usr/share/keyrings/google-chrome.gpg.asc "https://dl.google.com/linux/linux_signing_key.pub"; \
    gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg /usr/share/keyrings/google-chrome.gpg.asc; \
    rm -f /usr/share/keyrings/google-chrome.gpg.asc; \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google-chrome.list; \
    apt-get update && apt-get install -y --no-install-recommends google-chrome-stable; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# Chrome inside an unprivileged container needs --no-sandbox (no
# CAP_SYS_ADMIN for the namespace sandbox), --disable-dev-shm-usage
# (containers default to 64 MB /dev/shm; --shm-size=2g at run time
# is the other half of this fix), and --disable-gpu-sandbox (the
# GPU process sandbox doesn't work without /dev/dri).
CMD ["google-chrome-stable", \
     "--no-sandbox", \
     "--disable-dev-shm-usage", \
     "--disable-gpu-sandbox", \
     "--start-maximized"]

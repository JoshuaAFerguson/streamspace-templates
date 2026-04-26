# StreamSpace Firefox Browser with Selkies-GStreamer (WebRTC)
#
# Streams a single Firefox instance via Selkies-GStreamer on port 8080.
# All the Selkies / Xvfb / PulseAudio / encoder plumbing lives in
# selkies-base; this image only adds Firefox from Mozilla's apt repo.
#
# Why Mozilla's apt repo and not Ubuntu's `firefox` package:
#   Ubuntu 24.04 ships `firefox` as a snap-redirect stub that prints
#   "Unable to install Firefox: snap doesn't run inside containers"
#   and exits. Installing it gives you a 5 KB shell script, not a
#   browser. Mozilla's apt repo ships the real .deb.
#
# Build:
#   docker build -t ghcr.io/streamspace-dev/firefox-selkies:latest .
#
# Run:
#   docker run -d --rm --shm-size=2g -p 8080:8080 \
#       ghcr.io/streamspace-dev/firefox-selkies:latest

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Firefox Browser"
LABEL org.opencontainers.image.description="Firefox browser with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root

ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    wget -qO- https://packages.mozilla.org/apt/repo-signing-key.gpg \
        | gpg --dearmor -o /etc/apt/keyrings/packages.mozilla.org.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.mozilla.org.gpg] https://packages.mozilla.org/apt mozilla main" \
        > /etc/apt/sources.list.d/mozilla.list; \
    # Force Mozilla's `firefox` over Ubuntu's snap-stub of the same name.
    printf 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n' \
        > /etc/apt/preferences.d/mozilla; \
    apt-get update && apt-get install -y --no-install-recommends firefox; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

CMD ["firefox", "--no-remote"]

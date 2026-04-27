# StreamSpace Google Antigravity with Selkies-GStreamer (WebRTC)
#
# Google Antigravity is an AI-agent-first IDE (VS Code fork with deep
# Gemini integration). Distributed via Google Cloud Artifact Registry's
# apt repo — a different pattern from Chrome's dl.google.com / Mozilla's
# packages.mozilla.org. The "antigravity-debian" suite name applies on
# Ubuntu noble too.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Google Antigravity"
LABEL org.opencontainers.image.description="Google Antigravity AI IDE with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg \
        | gpg --dearmor -o /etc/apt/keyrings/antigravity-repo-key.gpg; \
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" \
        > /etc/apt/sources.list.d/antigravity.list; \
    apt-get update && apt-get install -y --no-install-recommends antigravity; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# Electron — needs --no-sandbox in unprivileged containers.
CMD ["antigravity", "--no-sandbox"]

# StreamSpace Slack with Selkies-GStreamer (WebRTC)
#
# Slack ships through their packagecloud apt repo. The "jessie main"
# suite name is what they use upstream — it's not actually
# Debian-jessie-specific (despite the name); same packages work on
# Ubuntu noble.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Slack"
LABEL org.opencontainers.image.description="Slack desktop client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    install -d -m 0755 /etc/apt/keyrings; \
    curl -fsSL https://packagecloud.io/slacktechnologies/slack/gpgkey \
        | gpg --dearmor -o /etc/apt/keyrings/slack.gpg; \
    echo "deb [signed-by=/etc/apt/keyrings/slack.gpg] https://packagecloud.io/slacktechnologies/slack/debian/ jessie main" \
        > /etc/apt/sources.list.d/slack.list; \
    apt-get update && apt-get install -y --no-install-recommends slack-desktop; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user

# --no-sandbox: Electron sandbox limitation in unprivileged containers.
CMD ["slack", "--no-sandbox"]

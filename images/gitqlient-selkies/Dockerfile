# StreamSpace GitQlient with Selkies-GStreamer (WebRTC)
#
# GitQlient is a Qt-based git GUI. Vendor .deb from francescmm/GitQlient
# GitHub releases.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace GitQlient"
LABEL org.opencontainers.image.description="GitQlient Qt-based git GUI with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    deb_url="$(curl -fsSL https://api.github.com/repos/francescmm/GitQlient/releases/latest \
        | jq -r '.assets[] | select(.name | test("^gitqlient_.*_amd64\\.deb$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${deb_url}" ]; then echo "Could not resolve GitQlient .deb URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/gitqlient.deb "${deb_url}"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/gitqlient.deb; \
    rm -f /tmp/gitqlient.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["gitqlient"]

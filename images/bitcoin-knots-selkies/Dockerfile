# StreamSpace Bitcoin Knots with Selkies-GStreamer (WebRTC)
#
# Bitcoin Knots is a derivative of Bitcoin Core with additional
# features, frequently rebased. Distributed as a self-contained
# tar.gz from bitcoinknots/bitcoin GitHub releases — extract to
# /opt/bitcoin-knots/ and symlink the GUI binary.
#
# Mount your data dir at runtime (e.g. -v /host/bitcoin:/home/user/.bitcoin)
# to avoid re-downloading the blockchain on every container start.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace Bitcoin Knots"
LABEL org.opencontainers.image.description="Bitcoin Knots full-node + GUI wallet with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    tar_url="$(curl -fsSL https://api.github.com/repos/bitcoinknots/bitcoin/releases/latest \
        | jq -r '.assets[] | select(.name | test("^bitcoin-.*-x86_64-linux-gnu\\.tar\\.gz$")) | .browser_download_url' \
        | head -1)"; \
    if [ -z "${tar_url}" ]; then echo "Could not resolve Bitcoin Knots tarball URL" >&2; exit 1; fi; \
    curl -fsSL -o /tmp/bitcoin-knots.tar.gz "${tar_url}"; \
    install -d -m 0755 /opt; \
    tar xzf /tmp/bitcoin-knots.tar.gz -C /opt; \
    rm -f /tmp/bitcoin-knots.tar.gz; \
    # Tarball extracts to a versioned dir (e.g. bitcoin-29.3.knots20260210).
    # Rename to /opt/bitcoin-knots/ for a stable CMD path.
    mv /opt/bitcoin-* /opt/bitcoin-knots; \
    ln -s /opt/bitcoin-knots/bin/bitcoin-qt /usr/local/bin/bitcoin-qt

USER user
CMD ["bitcoin-qt"]

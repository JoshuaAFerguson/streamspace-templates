# StreamSpace FileZilla with Selkies-GStreamer (WebRTC)
#
# FTP/FTPS/SFTP client. Useful as a streamed sandboxed client when you
# don't want to install desktop software locally to access remote files.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace FileZilla"
LABEL org.opencontainers.image.description="FileZilla FTP/FTPS/SFTP client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends filezilla && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["filezilla"]

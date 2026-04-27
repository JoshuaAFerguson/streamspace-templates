# StreamSpace MySQL Workbench with Selkies-GStreamer (WebRTC)
#
# MySQL Workbench is not in Ubuntu noble's apt archives. Oracle ships
# it as a versioned .deb from dev.mysql.com (which 302s to cdn.mysql.com).
# We pin to a known-working version. Bump MYSQL_WORKBENCH_VERSION to
# upgrade — there's no "latest" symlink.

FROM ghcr.io/streamspace-dev/selkies-base:latest

LABEL org.opencontainers.image.title="StreamSpace MySQL Workbench"
LABEL org.opencontainers.image.description="MySQL Workbench DBA / SQL client with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

USER root
ARG DEBIAN_FRONTEND=noninteractive
ARG MYSQL_WORKBENCH_VERSION=8.0.42

RUN set -eux; \
    curl -fsSL -o /tmp/mysql-workbench.deb \
        "https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community_${MYSQL_WORKBENCH_VERSION}-1ubuntu24.04_amd64.deb"; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/mysql-workbench.deb; \
    rm -f /tmp/mysql-workbench.deb; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER user
CMD ["mysql-workbench"]

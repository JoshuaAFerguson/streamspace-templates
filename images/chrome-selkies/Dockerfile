# StreamSpace Chrome Browser with Selkies WebRTC
#
# !!! THIS DOCKERFILE DOES NOT BUILD !!!
# !!! TRACKED BY ISSUE #3              !!!
#
# The base image `ghcr.io/selkies-project/selkies-gstreamer:24.04` does
# NOT exist in the upstream registry. Pulling it returns 403 Forbidden.
#
# The Selkies project (https://github.com/selkies-project/selkies)
# distributes the runtime as release tarballs (currently v1.6.2),
# not as a base container image. To make this image build, the
# Dockerfile must be rewritten to:
#
#   1. FROM ubuntu:24.04
#   2. Download + unpack `gstreamer-selkies_gpl_<v>_ubuntu24.04_amd64.tar.gz`
#      from https://github.com/selkies-project/selkies/releases
#   3. pip install the `selkies_gstreamer-<v>-py3-none-any.whl` wheel
#   4. Unpack the `selkies-gstreamer-web_<v>.tar.gz` web assets
#   5. Install Chrome (the apt-get block below is fine)
#   6. Update entrypoint.sh to launch the installed selkies-gstreamer
#
# See the upstream `docker-nvidia-egl-desktop` Dockerfile as the
# canonical reference for steps 1-4:
#   https://github.com/selkies-project/docker-nvidia-egl-desktop/blob/main/Dockerfile
#
# Once fixed, the build/run flow will be:
#   docker build -t ghcr.io/streamspace-dev/chrome-selkies:latest .
#   docker run -p 8080:8080 ghcr.io/streamspace-dev/chrome-selkies:latest

FROM ghcr.io/selkies-project/selkies-gstreamer:24.04

# Metadata
LABEL org.opencontainers.image.title="StreamSpace Chrome Browser"
LABEL org.opencontainers.image.description="Chrome browser with Selkies WebRTC streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace"

# Environment variables for Selkies
ENV DISPLAY=:0
ENV DISPLAY_SIZEW=1920
ENV DISPLAY_SIZEH=1080
ENV DISPLAY_DPI=96
ENV DISPLAY_REFRESH=60
ENV DISPLAY_CDEPTH=24

# Selkies configuration
ENV SELKIES_ENABLE_RESIZE=true
ENV SELKIES_ENABLE_BASIC_AUTH=false
ENV SELKIES_ENCODER=x264enc
ENV SELKIES_ENABLE_AUDIO=true
ENV SELKIES_AUDIO_BITRATE=128000

# Chrome-specific settings
ENV CHROME_FLAGS="--no-sandbox --disable-dev-shm-usage --disable-gpu-sandbox"

# Streaming port
ENV WEBRTC_PORT=8080
EXPOSE 8080

# User configuration
ENV PUID=1000
ENV PGID=1000
ENV HOME=/home/user
ENV USER=user

# Install Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create user and directories
RUN groupadd -g ${PGID} ${USER} || true \
    && useradd -u ${PUID} -g ${PGID} -m -s /bin/bash ${USER} || true \
    && mkdir -p ${HOME}/.config/google-chrome \
    && chown -R ${PUID}:${PGID} ${HOME}

# Copy startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working directory
WORKDIR ${HOME}

# Switch to non-root user
USER ${USER}

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:${WEBRTC_PORT}/ || exit 1

# Start Selkies with Chrome
ENTRYPOINT ["/entrypoint.sh"]
CMD ["google-chrome-stable", "--start-maximized"]

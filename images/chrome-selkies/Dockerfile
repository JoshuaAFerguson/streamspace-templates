# StreamSpace Chrome Browser with Selkies-GStreamer (WebRTC)
#
# Streams a single Chrome instance via Selkies-GStreamer on port 8080.
# Software-encoded (x264enc) — no GPU required. Hardware encoders
# (NVENC, VA-API) are auto-detected by entrypoint.sh when available.
#
# This image is built from scratch on ubuntu:24.04 and installs Selkies
# from the upstream release tarballs at
#   https://github.com/selkies-project/selkies/releases
# (the upstream project ships its runtime as tarballs, not as a base
# container image).
#
# Build:
#   docker build -t ghcr.io/streamspace-dev/chrome-selkies:latest .
#
# Run:
#   docker run -d --rm --shm-size=2g -p 8080:8080 \
#       ghcr.io/streamspace-dev/chrome-selkies:latest
#   open http://localhost:8080

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG SELKIES_VERSION=1.6.2
ARG TARGETARCH

LABEL org.opencontainers.image.title="StreamSpace Chrome Browser"
LABEL org.opencontainers.image.description="Chrome browser with Selkies-GStreamer (WebRTC) streaming for StreamSpace"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

# ---------------------------------------------------------------------------
# System deps: Xvfb display server, PulseAudio, GStreamer plugins, Python,
# and the bits needed by the apt step that adds Chrome.
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        gnupg2 \
        jq \
        tzdata \
        locales \
        sudo \
        python3 \
        python3-pip \
        python3-wheel \
        python3-setuptools \
        # GLib / GObject Introspection bindings — selkies-gstreamer
        # uses `gi.require_version('Gst', '1.0')` at startup; without
        # python3-gi it fails with "module 'gi' has no attribute".
        python3-gi \
        python3-gi-cairo \
        gir1.2-gtk-3.0 \
        # Build tools needed by the pip install step below — the
        # selkies_gstreamer wheel pulls in `evdev`, which compiles
        # native code against linux/input.h.
        build-essential \
        python3-dev \
        linux-libc-dev \
        xvfb \
        x11-xserver-utils \
        x11-utils \
        xauth \
        # `xsel` is needed for clipboard sync — selkies-gstreamer
        # shells out to it to read X11 clipboard contents.
        xsel \
        dbus-x11 \
        pulseaudio \
        pulseaudio-utils \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-libav \
        gstreamer1.0-pulseaudio \
        gstreamer1.0-pipewire \
        gstreamer1.0-libcamera \
        libgstreamer1.0-0 \
        libgstreamer-plugins-base1.0-0 \
        libgstreamer-plugins-bad1.0-0 \
        # Chrome runtime deps
        fonts-liberation \
        libasound2t64 \
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
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# ---------------------------------------------------------------------------
# Install Selkies-GStreamer (https://github.com/selkies-project/selkies)
# Pinned to ${SELKIES_VERSION}. The architecture-suffixed tarballs only
# exist for amd64 + arm64.
# ---------------------------------------------------------------------------
RUN set -eux; \
    arch="${TARGETARCH:-$(dpkg --print-architecture)}"; \
    case "${arch}" in \
        amd64|arm64) ;; \
        *) echo "Unsupported architecture: ${arch}"; exit 1 ;; \
    esac; \
    cd /opt && \
    curl -fsSL "https://github.com/selkies-project/selkies/releases/download/v${SELKIES_VERSION}/gstreamer-selkies_gpl_v${SELKIES_VERSION}_ubuntu24.04_${arch}.tar.gz" \
        | tar -xzf -; \
    cd /tmp && \
    curl -fsSLO "https://github.com/selkies-project/selkies/releases/download/v${SELKIES_VERSION}/selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl" && \
    pip3 install --no-cache-dir --break-system-packages --force-reinstall \
        "selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl" \
        "websockets<14.0" && \
    rm -f "selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl"; \
    cd /opt && \
    curl -fsSL "https://github.com/selkies-project/selkies/releases/download/v${SELKIES_VERSION}/selkies-gstreamer-web_v${SELKIES_VERSION}.tar.gz" \
        | tar -xzf -; \
    cd /tmp && \
    curl -fsSLO "https://github.com/selkies-project/selkies/releases/download/v${SELKIES_VERSION}/selkies-js-interposer_v${SELKIES_VERSION}_ubuntu24.04_${arch}.deb" && \
    apt-get update && \
    apt-get install --no-install-recommends -y "./selkies-js-interposer_v${SELKIES_VERSION}_ubuntu24.04_${arch}.deb" && \
    rm -f "selkies-js-interposer_v${SELKIES_VERSION}_ubuntu24.04_${arch}.deb" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add the Selkies GStreamer install to the library + binary search paths.
# The arch-specific lib dir (x86_64-linux-gnu / aarch64-linux-gnu) is set
# in entrypoint.sh because Docker's ENV directive doesn't run shell
# substitution like $(uname -m).
ENV GSTREAMER_PATH=/opt/gstreamer
ENV PATH=${GSTREAMER_PATH}/bin:${PATH}
ENV PYTHONPATH=${GSTREAMER_PATH}/lib/python3/dist-packages

# ---------------------------------------------------------------------------
# Install Google Chrome (stable channel)
# ---------------------------------------------------------------------------
RUN set -eux; \
    arch="${TARGETARCH:-$(dpkg --print-architecture)}"; \
    if [ "${arch}" = "amd64" ]; then \
        wget -q -O /usr/share/keyrings/google-chrome.gpg.asc "https://dl.google.com/linux/linux_signing_key.pub"; \
        gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg /usr/share/keyrings/google-chrome.gpg.asc; \
        rm -f /usr/share/keyrings/google-chrome.gpg.asc; \
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
            > /etc/apt/sources.list.d/google-chrome.list; \
        apt-get update && apt-get install -y --no-install-recommends google-chrome-stable; \
    else \
        # Chrome doesn't publish arm64 .deb; use Chromium from Ubuntu archives.
        apt-get update && apt-get install -y --no-install-recommends chromium-browser; \
        ln -s /usr/bin/chromium-browser /usr/local/bin/google-chrome-stable; \
    fi; \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Non-root user
# ---------------------------------------------------------------------------
ENV USER=user \
    HOME=/home/user \
    PUID=1000 \
    PGID=1000

RUN set -eux; \
    # Ubuntu 24.04 ships with a default `ubuntu` user/group at 1000:1000.
    # Drop it cleanly so our user can take that uid without collisions.
    if getent passwd 1000 >/dev/null; then userdel -r ubuntu 2>/dev/null || true; fi; \
    if getent group  1000 >/dev/null; then groupdel ubuntu 2>/dev/null || true; fi; \
    groupadd -g ${PGID} ${USER}; \
    useradd -u ${PUID} -g ${PGID} -m -s /bin/bash ${USER}; \
    usermod -aG audio,video ${USER}; \
    mkdir -p ${HOME}/.config/google-chrome ${HOME}/.cache; \
    chown -R ${PUID}:${PGID} ${HOME}

# ---------------------------------------------------------------------------
# Selkies + display config (sane defaults; entrypoint can override)
# ---------------------------------------------------------------------------
ENV DISPLAY=:0 \
    DISPLAY_SIZEW=1920 \
    DISPLAY_SIZEH=1080 \
    DISPLAY_REFRESH=60 \
    DISPLAY_DPI=96 \
    DISPLAY_CDEPTH=24 \
    SELKIES_ENCODER=x264enc \
    SELKIES_ENABLE_RESIZE=true \
    SELKIES_ENABLE_BASIC_AUTH=false \
    SELKIES_ENABLE_AUDIO=true \
    SELKIES_AUDIO_BITRATE=128000 \
    WEBRTC_PORT=8080 \
    CHROME_FLAGS="--no-sandbox --disable-dev-shm-usage --disable-gpu-sandbox"

EXPOSE 8080

COPY --chown=${PUID}:${PGID} entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${USER}
WORKDIR ${HOME}

HEALTHCHECK --interval=30s --timeout=10s --start-period=45s --retries=3 \
    CMD curl -fsS "http://localhost:${WEBRTC_PORT}/" >/dev/null || exit 1

ENTRYPOINT ["/entrypoint.sh"]
CMD ["google-chrome-stable", "--start-maximized"]

# StreamSpace Selkies Base Image
#
# Provides everything per-app images need to stream a single GUI
# application via Selkies-GStreamer (WebRTC) on port 8080:
#
#   - Ubuntu 24.04 base + system deps (Xvfb, PulseAudio, GStreamer
#     plugins, GLib/GI bindings, Chrome runtime libraries)
#   - Selkies-GStreamer GStreamer/web/.deb tarballs from the StreamSpace
#     fork at streamspace-dev/selkies (${SELKIES_FORK_TAG}). The fork
#     adds linux/arm64 to the GStreamer release matrix; upstream
#     selkies-project only ships amd64.
#   - Python wheel still pulled from upstream selkies-project (the
#     fork didn't change the Python sources, only the build pipeline).
#   - The standard `user` (uid/gid 1000) with audio+video group
#     membership; ubuntu:24.04's default `ubuntu` user/group is
#     dropped first to avoid the uid collision
#   - entrypoint.sh: env block, encoder auto-detection, Xvfb,
#     PulseAudio, app launch, then exec selkies-gstreamer in the
#     foreground so PID 1 is the streamer
#   - HEALTHCHECK on port 8080
#
# Per-app images derive from this:
#
#   FROM ghcr.io/streamspace-dev/selkies-base:1.6.2
#   USER root
#   RUN apt-get update && apt-get install -y --no-install-recommends \
#         <my-app-package> && \
#       apt-get clean && rm -rf /var/lib/apt/lists/*
#   USER user
#   CMD ["my-app", "--my-flags"]
#
# Build:
#   docker build -t ghcr.io/streamspace-dev/selkies-base:latest .
#
# Run (the base image is launchable on its own — runs an empty desktop
# you can connect to; useful for diagnosing the streaming pipeline):
#   docker run -d --rm --shm-size=2g -p 8080:8080 \
#     ghcr.io/streamspace-dev/selkies-base:latest
#   open http://localhost:8080

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
# SELKIES_VERSION = upstream Python wheel version (selkies-project/selkies).
# The wheel is unchanged in our fork, so it still comes from upstream.
ARG SELKIES_VERSION=1.6.2
# SELKIES_FORK_TAG = streamspace-dev/selkies release tag, used for the
# GStreamer / gst-web / js-interposer artifacts that DO differ from
# upstream (the fork adds arm64 to the build matrix).
ARG SELKIES_FORK_TAG=v1.6.2-streamspace.1
ARG TARGETARCH

LABEL org.opencontainers.image.title="StreamSpace Selkies Base"
LABEL org.opencontainers.image.description="Selkies-GStreamer base image for StreamSpace per-app images"
# Image version is independent of Selkies upstream version (still 1.6.2);
# bumps only when our base configuration changes (added system deps,
# entrypoint changes, etc.).
LABEL org.opencontainers.image.version="1.6.4"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"

# ---------------------------------------------------------------------------
# System deps. Each block is documented inline because the cause of
# adding it was a real failure mode during chrome-selkies bring-up.
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
        # Python runtime + GI bindings — selkies-gstreamer uses
        # gi.require_version('Gst', '1.0') at startup; without
        # python3-gi it fails with "module 'gi' has no attribute".
        python3 \
        python3-pip \
        python3-wheel \
        python3-setuptools \
        python3-gi \
        python3-gi-cairo \
        gir1.2-gtk-3.0 \
        # Build tools — the selkies_gstreamer wheel pulls in `evdev`,
        # which compiles native code against linux/input.h. Without
        # these, pip install returns exit 0 but evdev silently fails
        # to build, leaving selkies-gstreamer not installed.
        build-essential \
        python3-dev \
        linux-libc-dev \
        # Display server.
        xvfb \
        x11-xserver-utils \
        x11-utils \
        xauth \
        dbus-x11 \
        # Clipboard sync — selkies-gstreamer shells out to xsel
        # for X11 clipboard reads.
        xsel \
        # Diagnostic shell for the base image — the default CMD
        # launches xterm so the base is launchable on its own
        # for streaming-pipeline troubleshooting.
        xterm \
        # Audio.
        pulseaudio \
        pulseaudio-utils \
        # GStreamer plugins.
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
        # Common GUI runtime libraries — most desktop apps need
        # at least GTK/Qt/audio/X libraries. Pre-installing them
        # in the base saves repeated layers in per-app images.
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
        # libopengl0 — the OpenGL ICD loader, distinct from the Mesa
        # GL implementation (libgl1-mesa-dri). AppImages and Qt apps
        # treat libOpenGL.so.0 as a system dep and don't bundle it;
        # without this we hit "libOpenGL.so.0: cannot open shared
        # object file" at runtime. Surfaced via zoom + 3 emulators.
        libopengl0 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxkbcommon0 \
        libxrandr2 \
        xdg-utils \
        # yaru-theme-icon — Ubuntu's default GTK icon theme is "Yaru".
        # GTK apps that look up icons by name (e.g. 'image-missing')
        # SIGABRT when the named theme isn't present rather than
        # falling back to Adwaita. Surfaced via xournalpp.
        yaru-theme-icon \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# ---------------------------------------------------------------------------
# Install Selkies-GStreamer.
#
# GStreamer / gst-web / js-interposer come from the streamspace-dev/selkies
# fork at ${SELKIES_FORK_TAG} — that fork's release matrix includes
# linux/arm64 (built on native arm64 runners), which upstream
# selkies-project/selkies doesn't ship.
#
# The Python wheel is unchanged from upstream so it still pulls from
# selkies-project at ${SELKIES_VERSION}.
# ---------------------------------------------------------------------------
RUN set -eux; \
    arch="${TARGETARCH:-$(dpkg --print-architecture)}"; \
    case "${arch}" in \
        amd64|arm64) ;; \
        *) echo "Unsupported architecture: ${arch}"; exit 1 ;; \
    esac; \
    cd /opt && \
    curl -fsSL "https://github.com/streamspace-dev/selkies/releases/download/${SELKIES_FORK_TAG}/gstreamer-selkies_gpl_${SELKIES_FORK_TAG}_ubuntu24.04_${arch}.tar.gz" \
        | tar -xzf -; \
    cd /tmp && \
    curl -fsSLO "https://github.com/selkies-project/selkies/releases/download/v${SELKIES_VERSION}/selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl" && \
    pip3 install --no-cache-dir --break-system-packages --force-reinstall \
        "selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl" \
        "websockets<14.0" && \
    rm -f "selkies_gstreamer-${SELKIES_VERSION}-py3-none-any.whl"; \
    cd /opt && \
    curl -fsSL "https://github.com/streamspace-dev/selkies/releases/download/${SELKIES_FORK_TAG}/selkies-gstreamer-web_${SELKIES_FORK_TAG}.tar.gz" \
        | tar -xzf -; \
    cd /tmp && \
    curl -fsSLO "https://github.com/streamspace-dev/selkies/releases/download/${SELKIES_FORK_TAG}/selkies-js-interposer_${SELKIES_FORK_TAG}_ubuntu24.04_${arch}.deb" && \
    apt-get update && \
    apt-get install --no-install-recommends -y "./selkies-js-interposer_${SELKIES_FORK_TAG}_ubuntu24.04_${arch}.deb" && \
    rm -f "selkies-js-interposer_${SELKIES_FORK_TAG}_ubuntu24.04_${arch}.deb" && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Selkies install paths. Arch-specific lib dirs go in entrypoint.sh
# because Docker doesn't shell-substitute $(uname -m) in ENV.
ENV GSTREAMER_PATH=/opt/gstreamer
ENV PATH=${GSTREAMER_PATH}/bin:${PATH}
ENV PYTHONPATH=${GSTREAMER_PATH}/lib/python3/dist-packages

# ---------------------------------------------------------------------------
# Non-root user. ubuntu:24.04 ships with `ubuntu`/1000:1000 by default;
# drop it first so groupadd doesn't collide.
# ---------------------------------------------------------------------------
ENV USER=user \
    HOME=/home/user \
    PUID=1000 \
    PGID=1000

RUN set -eux; \
    if getent passwd 1000 >/dev/null; then userdel -r ubuntu 2>/dev/null || true; fi; \
    if getent group  1000 >/dev/null; then groupdel ubuntu 2>/dev/null || true; fi; \
    groupadd -g ${PGID} ${USER}; \
    useradd -u ${PUID} -g ${PGID} -m -s /bin/bash ${USER}; \
    usermod -aG audio,video ${USER}; \
    mkdir -p ${HOME}/.cache; \
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
    WEBRTC_PORT=8080

EXPOSE 8080

COPY --chown=${PUID}:${PGID} entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER ${USER}
WORKDIR ${HOME}

HEALTHCHECK --interval=30s --timeout=10s --start-period=45s --retries=3 \
    CMD curl -fsS "http://localhost:${WEBRTC_PORT}/" >/dev/null || exit 1

ENTRYPOINT ["/entrypoint.sh"]
# Default to xterm so the base image is launchable on its own for
# pipeline diagnosis. Per-app images override this with their own CMD.
CMD ["xterm"]

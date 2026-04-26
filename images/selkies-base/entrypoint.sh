#!/bin/bash
# StreamSpace Selkies-base entrypoint
#
# Boot order:
#   0. Set the arch-specific Selkies library paths (Docker ENV
#      directives don't shell-substitute, so this lives in the script)
#   1. Encoder auto-detect: NVENC → VA-API → x264enc fallback
#   2. Start Xvfb on $DISPLAY, wait for ready
#   3. Start PulseAudio (user mode, no network listener)
#   4. Launch the user's command (whatever the per-app image's CMD is)
#      on $DISPLAY in the background
#   5. exec selkies-gstreamer in the foreground so PID 1 is the
#      streaming process — signals propagate, container exits cleanly
#      when Selkies dies

set -euo pipefail

log() { printf '[entrypoint] %s\n' "$*" >&2; }

# ---------------------------------------------------------------------------
# 0. Arch-specific library paths. Mirrors the env block selkies-gstreamer
#    prints when it can't find its install.
# ---------------------------------------------------------------------------
ARCH_TRIPLE="$(uname -m)-linux-gnu"
export GSTREAMER_PATH="${GSTREAMER_PATH:-/opt/gstreamer}"
export PATH="${GSTREAMER_PATH}/bin${PATH:+:${PATH}}"
export LD_LIBRARY_PATH="${GSTREAMER_PATH}/lib/${ARCH_TRIPLE}${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
export GST_PLUGIN_PATH="${GSTREAMER_PATH}/lib/${ARCH_TRIPLE}/gstreamer-1.0${GST_PLUGIN_PATH:+:${GST_PLUGIN_PATH}}"
export GST_PLUGIN_SYSTEM_PATH="${HOME}/.local/share/gstreamer-1.0/plugins:/usr/lib/${ARCH_TRIPLE}/gstreamer-1.0${GST_PLUGIN_SYSTEM_PATH:+:${GST_PLUGIN_SYSTEM_PATH}}"
export GI_TYPELIB_PATH="${GSTREAMER_PATH}/lib/${ARCH_TRIPLE}/girepository-1.0:/usr/lib/${ARCH_TRIPLE}/girepository-1.0${GI_TYPELIB_PATH:+:${GI_TYPELIB_PATH}}"
export PYTHONPATH="${GSTREAMER_PATH}/lib/python3/dist-packages${PYTHONPATH:+:${PYTHONPATH}}"

# ---------------------------------------------------------------------------
# 1. Encoder selection.
# ---------------------------------------------------------------------------
configure_encoder() {
    if [ -n "${SELKIES_ENCODER:-}" ] && [ "${SELKIES_ENCODER}" != "auto" ]; then
        log "Using pinned encoder: ${SELKIES_ENCODER}"
        return
    fi
    if [ -e /dev/nvidia0 ]; then
        log "NVIDIA device detected — using nvh264enc"
        export SELKIES_ENCODER=nvh264enc
    elif [ -e /dev/dri/renderD128 ]; then
        log "VA-API device detected — using vah264enc"
        export SELKIES_ENCODER=vah264enc
    else
        log "No GPU — falling back to x264enc (software encoding)"
        export SELKIES_ENCODER=x264enc
    fi
}
configure_encoder

# ---------------------------------------------------------------------------
# 2. Xvfb
# ---------------------------------------------------------------------------
log "Starting Xvfb on ${DISPLAY} at ${DISPLAY_SIZEW}x${DISPLAY_SIZEH}@${DISPLAY_REFRESH}"
Xvfb "${DISPLAY}" \
    -screen 0 "${DISPLAY_SIZEW}x${DISPLAY_SIZEH}x${DISPLAY_CDEPTH}" \
    -dpi "${DISPLAY_DPI}" \
    +extension RANDR +extension GLX +extension Composite \
    -nolisten tcp \
    >/tmp/xvfb.log 2>&1 &
XVFB_PID=$!

for _ in $(seq 1 30); do
    if xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1; then
        log "Xvfb is ready"
        break
    fi
    sleep 0.2
done
if ! xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1; then
    log "ERROR: Xvfb did not become ready"
    cat /tmp/xvfb.log >&2 || true
    exit 1
fi

# ---------------------------------------------------------------------------
# 3. PulseAudio
# ---------------------------------------------------------------------------
if [ "${SELKIES_ENABLE_AUDIO:-true}" = "true" ]; then
    log "Starting PulseAudio (user mode)"
    mkdir -p "${HOME}/.config/pulse"
    pulseaudio --start --exit-idle-time=-1 --disallow-exit \
        --log-target=file:/tmp/pulseaudio.log >/dev/null 2>&1 || \
        log "WARN: pulseaudio start failed — audio will be unavailable"
fi

# ---------------------------------------------------------------------------
# 4. Launch the per-app command
# ---------------------------------------------------------------------------
APP_CMD=( "$@" )
if [ "${#APP_CMD[@]}" -eq 0 ]; then
    log "WARN: no command supplied; falling back to xterm"
    APP_CMD=( xterm )
fi

log "Launching app: ${APP_CMD[*]}"
DISPLAY="${DISPLAY}" "${APP_CMD[@]}" >/tmp/app.log 2>&1 &
APP_PID=$!

# ---------------------------------------------------------------------------
# 5. Selkies-GStreamer in the foreground
# ---------------------------------------------------------------------------
log "================================================"
log "StreamSpace Selkies"
log "  Display:     ${DISPLAY_SIZEW}x${DISPLAY_SIZEH}@${DISPLAY_REFRESH}Hz"
log "  Encoder:     ${SELKIES_ENCODER}"
log "  Audio:       ${SELKIES_ENABLE_AUDIO}"
log "  Port:        ${WEBRTC_PORT}"
log "  App PID:     ${APP_PID}"
log "  Xvfb PID:    ${XVFB_PID}"
log "================================================"

# v1.6.2 doesn't accept --enable_audio; audio is always on when present.
exec selkies-gstreamer \
    --addr=0.0.0.0 \
    --port="${WEBRTC_PORT}" \
    --enable_basic_auth="${SELKIES_ENABLE_BASIC_AUTH}" \
    --encoder="${SELKIES_ENCODER}" \
    --enable_resize="${SELKIES_ENABLE_RESIZE}"

# StreamSpace Container Images

Source for the container images that back StreamSpace templates. Each
subdirectory is a single image; the build workflow at
`.github/workflows/build-images.yml` discovers them automatically and
publishes to `ghcr.io/streamspace-dev/<image-name>`.

## Available images

| Image | Base | Notes |
|---|---|---|
| `chrome-selkies` | `ghcr.io/selkies-project/selkies-gstreamer:24.04` | Google Chrome streamed via Selkies-GStreamer (WebRTC). |

## Standards every image must follow

**Streaming protocol.** Selkies-GStreamer (WebRTC). VNC paths were removed
in mid-2026; do not introduce a Dockerfile that exposes anything other
than the Selkies HTTP/WebRTC endpoint on port `8080`.

**Port.** Always `8080`. The control plane's HTTP proxy expects this.

**Environment knobs.** Every image must accept these so users can resize
the desktop without rebuilding:

| Variable | Default | Purpose |
|---|---|---|
| `DISPLAY_SIZEW` | `1920` | Display width |
| `DISPLAY_SIZEH` | `1080` | Display height |
| `DISPLAY_DPI` | `96` | Display DPI |
| `SELKIES_ENCODER` | auto-detected | Override the GStreamer encoder |
| `SELKIES_ENABLE_AUDIO` | `true` | Toggle audio pipeline |
| `TZ` | `UTC` | Container timezone |

**OCI labels.** Required so the supply-chain attestations land cleanly:

```dockerfile
LABEL org.opencontainers.image.title="StreamSpace <App Name>"
LABEL org.opencontainers.image.description="<Description>"
LABEL org.opencontainers.image.vendor="StreamSpace"
LABEL org.opencontainers.image.source="https://github.com/streamspace-dev/streamspace-templates"
```

**Health check.** The control plane treats the absence of one as a
session that never becomes ready:

```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1
```

## Building locally

```bash
cd images/chrome-selkies
docker build -t ghcr.io/streamspace-dev/chrome-selkies:dev .
docker run -d -p 8080:8080 --name chrome-selkies-test \
    ghcr.io/streamspace-dev/chrome-selkies:dev
# Open http://localhost:8080 in a browser
docker rm -f chrome-selkies-test
```

## CI / release

The workflow builds every image whose Dockerfile changed in the PR and
publishes on push to `main` or on tagged releases. It produces multi-arch
images (`linux/amd64`, `linux/arm64`), signs them with cosign, and
attaches a SPDX SBOM.

Tag conventions (per `docker/metadata-action`):
- `latest` — only on default branch
- `<branch>` — branch name (e.g. `main`)
- `pr-<num>` — pull request builds
- `sha-<short>` — commit SHA fallback
- `<semver>` / `<major>.<minor>` / `<major>` — when a `vX.Y.Z` tag is pushed

## Adding a new image

1. Create `images/<name>/` with a `Dockerfile` and any helper scripts.
2. Add a row to the table above.
3. Add a corresponding template manifest under the matching category
   directory (e.g. `selkies/<name>.yaml`) so the catalog can serve it.
4. Open the PR — CI will build the image automatically and the workflow
   will fail loudly if the standards above aren't met.

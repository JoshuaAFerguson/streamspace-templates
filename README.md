# StreamSpace Templates

Application template repository for [StreamSpace](https://github.com/streamspace-dev/streamspace) — also home to the source + multi-arch build pipeline for first-party container images.

## What this repo owns

1. **Template manifests** — `stream.space/v1alpha1 Template` CRDs that the StreamSpace control plane consumes to know which apps users can launch.
2. **Container image source + build pipeline** — `images/<name>/Dockerfile` + the workflow at `.github/workflows/build-images.yml` that publishes signed multi-arch images to `ghcr.io/streamspace-dev/<image>` with cosign signatures and SPDX SBOM attestations.

## Curation principle

The catalog is **only desktop GUI applications** that genuinely benefit from being streamed via Selkies-GStreamer (WebRTC). Server apps with their own web UI (media servers, download daemons, dashboards, wikis, reverse proxies, RSS aggregators, …) are intentionally excluded — those don't need StreamSpace; they just need to be deployed somewhere accessible.

If you're tempted to add Plex, Jellyfin, Sonarr, Radarr, Heimdall, Nextcloud, Home Assistant, or anything else that's already a web app: don't. They run fine on their own, and StreamSpace adds nothing to that workflow.

## Repository structure

```
streamspace-templates/
├── browsers/        # web browsers (Brave, Chrome family, Firefox family, …)
├── communication/   # desktop chat clients (WhatsApp/Discord wrappers, Pidgin)
├── design/          # image, vector, 3D, CAD, EDA tools
├── audio-video/     # audio + video editors and music players
├── development/     # desktop IDEs, git clients, DB tools, API testing
├── productivity/    # office suites, note-taking, e-book readers
├── gaming/          # game emulators and standalone games
├── utilities/       # file managers, FTP clients, disk tools
├── security/        # password managers
├── remote-desktop/  # RDP/VNC client apps (for tunneling out from a session)
├── desktops/        # full Linux desktop environments (KDE/XFCE/i3, Kali)
├── selkies/         # first-party reference templates
├── images/          # Dockerfile sources for first-party images
├── catalog.yaml     # category metadata
└── .github/workflows/
    ├── build-images.yml   # multi-arch build, cosign sign, SBOM attest
    └── validate.yaml      # YAML lint + Template schema check
```

## Streaming protocol — Selkies-only

Every template must stream via **Selkies-GStreamer (WebRTC) on port 8080**. The dual VNC/Selkies code path was retired in April 2026; templates that referenced KasmVNC on port 3000 have been removed.

When adding a Template manifest:

```yaml
apiVersion: stream.space/v1alpha1
kind: Template
metadata:
  name: <name>
  namespace: workspaces
spec:
  displayName: <Human Name>
  description: <One-liner>
  category: <category>
  baseImage: ghcr.io/streamspace-dev/<image>:latest
  streamingProtocol: selkies
  defaultResources:
    requests:
      memory: 2Gi
      cpu: 1000m
  ports:
    - name: selkies
      containerPort: 8080
      protocol: TCP
```

## Currently published images

| Image | Platforms | Status |
|---|---|---|
| `ghcr.io/streamspace-dev/chrome-selkies` | linux/amd64 | published |

The 70+ template manifests in this repo currently reference upstream images (e.g. `lscr.io/linuxserver/<app>`) inherited from the previous catalog. Migrating each to a Selkies-native first-party image (`ghcr.io/streamspace-dev/<app>-selkies`) is iterative work — see [`images/README.md`](images/README.md) for the build standards and [`images/chrome-selkies/`](images/chrome-selkies/) for the canonical pattern.

## Adding a new image

1. Create `images/<name>/Dockerfile` (and `entrypoint.sh` if you need encoder auto-detection or other startup logic — copy from `images/chrome-selkies/`)
2. Add `images/<name>/PLATFORMS` if your image isn't multi-arch (defaults to `linux/amd64,linux/arm64`)
3. Add `<category>/<name>.yaml` with the Template manifest above
4. Open a PR — CI will build the image (PR event = no push, just verify) and validate the YAML
5. On merge to `main`: image publishes to `ghcr.io/streamspace-dev/<name>:latest` + `:sha-<short>`, signed and SBOM-attested

## Verifying a published image

```bash
cosign verify ghcr.io/streamspace-dev/chrome-selkies:latest \
  --certificate-identity-regexp '^https://github.com/streamspace-dev/streamspace-templates/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com

cosign download attestation ghcr.io/streamspace-dev/chrome-selkies:latest \
  --predicate-type https://spdx.dev/Document
```

## Related repos

- [`streamspace-dev/streamspace`](https://github.com/streamspace-dev/streamspace) — Control Plane API, agents, Web UI, Helm chart
- [`streamspace-dev/streamspace-plugins`](https://github.com/streamspace-dev/streamspace-plugins) — Optional plugins
- [`streamspace-dev/streamspace.wiki`](https://github.com/streamspace-dev/streamspace.wiki) — End-user documentation

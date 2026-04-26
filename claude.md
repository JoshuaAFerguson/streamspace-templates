# StreamSpace Templates Repository — Context for AI Assistants

## What this repo owns

This is the [`streamspace-templates`](https://github.com/streamspace-dev/streamspace-templates) sibling of [`streamspace-dev/streamspace`](https://github.com/streamspace-dev/streamspace). It owns **two** things:

1. **Application template manifests** (`stream.space/v1alpha1 Template` CRDs) that the StreamSpace control plane consumes to know what apps users can launch.
2. **Container image source + multi-arch build pipeline** for the custom images those templates reference. The pipeline publishes signed images with SBOM attestations to `ghcr.io/streamspace-dev/<image>`.

## Streaming protocol — Selkies-only

Since April 2026 the StreamSpace platform is **Selkies-GStreamer (WebRTC) only**. The old VNC code path was retired. Any new template you add must:

- Set `spec.streamingProtocol: selkies`
- Expose the streaming endpoint on **port 8080**
- Either use one of our published images under `ghcr.io/streamspace-dev/` or a third-party Selkies-compatible image

Templates that reference KasmVNC images on port 3000 (the inherited LinuxServer.io catalog under `browsers/`, `webtop/`, `development/`, etc.) **are not currently usable** with the live control plane. They remain in the repo as a reference set for the catalog migration; replacing them with Selkies-native equivalents is tracked work.

## Repository structure

```
streamspace-templates/
├── images/                        # Dockerfile sources for custom images
│   ├── README.md                  # Standards every image must follow
│   └── chrome-selkies/            # First custom Selkies-native image
│       ├── Dockerfile
│       └── entrypoint.sh
├── selkies/                       # Selkies-native template manifests
│   └── chrome-selkies.yaml
├── browsers/, development/, webtop/, …    # Inherited LinuxServer-based templates (legacy)
├── catalog.yaml                   # Catalog metadata
├── CONTRIBUTING.md                # Submission workflow
├── README.md                      # User-facing readme
└── .github/workflows/
    ├── validate.yaml              # YAML / required-field validation
    └── build-images.yml           # Multi-arch build, cosign sign, SBOM attest
```

## Image standards (`images/README.md`)

Every image must:

- Stream over **Selkies-GStreamer on port 8080**
- Honor the standard env knobs: `DISPLAY_SIZEW`, `DISPLAY_SIZEH`, `SELKIES_ENCODER`, `SELKIES_ENABLE_AUDIO`, `TZ`
- Carry the OCI labels — `title`, `description`, `vendor=StreamSpace`, `source=https://github.com/streamspace-dev/streamspace-templates`
- Include a `HEALTHCHECK` against `:8080/`
- Run as a non-root user inside the container

The build workflow auto-discovers any subdirectory of `images/` that contains a `Dockerfile`, builds it for `linux/amd64,linux/arm64`, signs with cosign keyless via the GitHub Actions OIDC identity, and attaches a SPDX-JSON SBOM. PR builds skip the push step.

## Template manifest spec

Selkies-native template (current canonical pattern):

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
  baseImage: ghcr.io/streamspace-dev/<name>:latest
  streamingProtocol: selkies
  defaultResources:
    requests:
      memory: 2Gi
      cpu: 1000m
  ports:
    - name: selkies
      containerPort: 8080
      protocol: TCP
  env:
    - name: TZ
      value: UTC
  capabilities:
    - Network
    - Audio
    - Clipboard
  tags:
    - <category-tag>
    - selkies
```

Legacy LinuxServer-style entries (in `browsers/`, `webtop/`, etc.) use a different shape with a `kasmvnc:` block on port 3000. Don't add new templates in that style.

## Adding a new image + template

1. Create `images/<name>/Dockerfile` (and `entrypoint.sh` if you need encoder auto-detection or other startup logic — copy the pattern from `images/chrome-selkies/`).
2. Add `selkies/<name>.yaml` with the manifest above.
3. Open a PR. CI will:
   - Build the image (PR event → no push, just verify)
   - Validate the YAML and required CRD fields
4. On merge to `main`: image publishes as `ghcr.io/streamspace-dev/<name>:latest` and `:sha-<short>`, signed and SBOM-attested.
5. Tag the repo `vX.Y.Z` to publish semver tags.

## Verifying a published image

```bash
cosign verify ghcr.io/streamspace-dev/chrome-selkies:latest \
  --certificate-identity-regexp '^https://github.com/streamspace-dev/streamspace-templates/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com

cosign download attestation ghcr.io/streamspace-dev/chrome-selkies:latest \
  --predicate-type https://spdx.dev/Document
```

## What NOT to do

- Don't add new templates pointing at `lscr.io/linuxserver/...` images. Those use KasmVNC on port 3000 and don't work with the Selkies-only control plane.
- Don't reintroduce the `kasmvnc:` template block.
- Don't bake credentials, license keys, or org-specific config into image layers.
- Don't pin upstream base images to `:latest` — use `selkies-gstreamer:24.04` style explicit tags.
- Don't write commit messages or PRs that reference the old wave-based dev workflow (`Wave 28`, `agent3-validator`, etc.); that workflow was retired in April 2026.

## Related repos

- [`streamspace-dev/streamspace`](https://github.com/streamspace-dev/streamspace) — Control Plane API, K8s/Docker agents, Web UI, Helm chart
- [`streamspace-dev/streamspace-plugins`](https://github.com/streamspace-dev/streamspace-plugins) — Optional plugins
- [`streamspace-dev/streamspace.wiki`](https://github.com/streamspace-dev/streamspace.wiki) — End-user documentation

## Working with Claude Code

When you make changes here, the things that usually matter:

- **One image change → one matrix entry** in CI. The discover step in `build-images.yml` only rebuilds images whose subdirectory changed in the diff. If you add a new image, you don't have to wait for the entire fleet to rebuild.
- **catalog.yaml** should stay in sync with what's in the repo, but the platform's primary template-discovery path now reads templates directly from category dirs via the `repositories.templates` Helm config — the catalog file is documentation, not source of truth.
- **The validate workflow** runs `kubectl apply --dry-run=client` against every YAML; broken manifests fail the PR.
- **Sample template** to copy: `selkies/chrome-selkies.yaml`.

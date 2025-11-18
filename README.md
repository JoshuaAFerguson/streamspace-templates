# StreamSpace Templates

Official application template repository for [StreamSpace](https://github.com/JoshuaAFerguson/streamspace).

## Overview

This repository contains Kubernetes CRD manifests for StreamSpace application templates. Templates define containerized applications that users can launch as streaming sessions.

**Current Status**: 195 templates across 50 categories, all sourced from the [LinuxServer.io](https://www.linuxserver.io/) catalog.

## Repository Structure

```
streamspace-templates/
├── browsers/         # Web browsers (Firefox, Chromium, Brave, LibreWolf)
├── development/      # Development tools (VS Code, GitHub Desktop)
├── productivity/     # Office suites (LibreOffice, Calligra)
├── design/           # Design tools (GIMP, Krita, Inkscape, Blender)
├── media/            # Media editing (Audacity, Kdenlive)
├── gaming/           # Game emulators (DuckStation, Dolphin)
├── webtop/           # Full desktop environments
├── catalog.yaml      # Template discovery metadata
└── README.md         # This file
```

## Template Categories

This repository now includes **195 templates** across **50 categories**. See [TEMPLATES.md](TEMPLATES.md) for the complete catalog.

### Popular Categories

- **Web Browsers** (14): Firefox, Chrome, Chromium, Brave, LibreWolf, Opera, Vivaldi, and more
- **Development** (10): VS Code, VSCodium, GitHub Desktop, MariaDB, MySQL Workbench
- **Productivity** (22): LibreOffice, OnlyOffice, Calibre, Joplin, Obsidian, Zotero
- **Design & Graphics** (21): GIMP, Krita, Inkscape, Blender, FreeCAD, KiCad, Darktable
- **Audio & Video** (15): Audacity, Kdenlive, Ardour, Shotcut, FFmpeg
- **Gaming** (13): DuckStation, Dolphin, RetroArch, PCSX2, RPCS3, MAME
- **Media** (14): Sonarr, Radarr, Bazarr, Jellyfin, Plex, Emby
- **File Management** (9): qBittorrent, Deluge, FileZilla, SABnzbd
- **Desktop Environments** (3): Ubuntu (XFCE/KDE), Alpine (i3)

See [TEMPLATES.md](TEMPLATES.md) for the complete list of all templates.

## Usage

### Deploy All Templates

```bash
kubectl apply -f https://raw.githubusercontent.com/JoshuaAFerguson/streamspace-templates/main/catalog.yaml
```

### Deploy Specific Category

```bash
# Browsers only
kubectl apply -f https://raw.githubusercontent.com/JoshuaAFerguson/streamspace-templates/main/browsers/

# Development tools
kubectl apply -f https://raw.githubusercontent.com/JoshuaAFerguson/streamspace-templates/main/development/
```

### Deploy Individual Template

```bash
kubectl apply -f https://raw.githubusercontent.com/JoshuaAFerguson/streamspace-templates/main/browsers/firefox.yaml
```

## Automatic Syncing

StreamSpace can automatically sync templates from this repository. Configure in your Helm values:

```yaml
repositories:
  templates:
    enabled: true
    url: https://github.com/JoshuaAFerguson/streamspace-templates
    branch: main
    syncInterval: "1h"
```

## Template Specification

Each template follows the `stream.space/v1alpha1` API:

```yaml
apiVersion: stream.space/v1alpha1
kind: Template
metadata:
  name: firefox-browser
  namespace: streamspace
spec:
  displayName: Firefox Web Browser
  description: Modern, privacy-focused web browser
  category: Web Browsers
  icon: https://example.com/firefox-icon.png
  baseImage: lscr.io/linuxserver/firefox:latest
  defaultResources:
    memory: 2Gi
    cpu: 1000m
  ports:
    - name: vnc
      containerPort: 3000
      protocol: TCP
  env:
    - name: PUID
      value: "1000"
    - name: PGID
      value: "1000"
  volumeMounts:
    - name: user-home
      mountPath: /config
  vnc:
    enabled: true
    port: 3000
  capabilities:
    - Network
    - Audio
    - Clipboard
  tags:
    - browser
    - web
    - privacy
```

## Contributing

We welcome contributions! To add a new template:

1. Fork this repository
2. Create a new YAML file in the appropriate category directory
3. Follow the template specification above
4. Add entry to `catalog.yaml`
5. Test with: `kubectl apply -f your-template.yaml`
6. Submit a pull request

### Template Guidelines

- **Naming**: Use lowercase with hyphens (e.g., `firefox-browser.yaml`)
- **Resources**: Set reasonable defaults (2Gi RAM, 1 CPU typical)
- **Images**: Prefer official or LinuxServer.io images
- **VNC**: Port 3000 for LinuxServer.io, 5900 for standard VNC
- **Tags**: Add relevant tags for discovery
- **Description**: Clear, concise description of the application

### Validation

Templates are automatically validated on PR:

```bash
# Validate template syntax
kubectl apply --dry-run=client -f your-template.yaml

# Validate against CRD
kubectl apply --server-dry-run -f your-template.yaml
```

## Template Generation

This repository uses automated scripts to generate templates from the LinuxServer.io catalog:

```bash
# Generate all templates from LinuxServer.io API
python3 scripts/generate-templates.py

# Generate from curated popular apps list
python3 scripts/generate-from-catalog.py
```

See [scripts/README.md](scripts/README.md) for detailed documentation.

## Current Images Status

⚠️ **Note**: All templates use LinuxServer.io images. StreamSpace may migrate to native container images with TigerVNC + noVNC in future releases for complete open source independence.

## License

MIT License - see [LICENSE](https://github.com/JoshuaAFerguson/streamspace/blob/main/LICENSE)

## Links

- **Main Project**: [StreamSpace](https://github.com/JoshuaAFerguson/streamspace)
- **Plugin Repository**: [streamspace-plugins](https://github.com/JoshuaAFerguson/streamspace-plugins)
- **Documentation**: [StreamSpace Docs](https://github.com/JoshuaAFerguson/streamspace/tree/main/docs)
- **Issues**: [GitHub Issues](https://github.com/JoshuaAFerguson/streamspace-templates/issues)

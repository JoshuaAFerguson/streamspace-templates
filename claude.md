# StreamSpace Templates Repository

## Overview

This repository hosts application templates for [StreamSpace](https://github.com/JoshuaAFerguson/streamspace), a Kubernetes-native platform for streaming containerized desktop applications and development environments to the web browser.

## Purpose

StreamSpace Templates are Kubernetes Custom Resources (CRDs) that define containerized applications ready for streaming. Each template includes:

- Application metadata (name, description, category, icon)
- Container image reference (primarily LinuxServer.io images)
- Resource requirements (CPU, memory)
- Port configurations (KasmVNC or HTTP)
- Environment variables
- Volume mounts for persistent storage
- Capabilities (network, audio, clipboard)

## Repository Structure

```
streamspace-templates/
├── scripts/                    # Template generation scripts
│   ├── generate-templates.py      # Generate from LinuxServer.io API
│   ├── generate-from-catalog.py   # Generate from curated catalog
│   ├── popular-apps.json          # Curated app list
│   └── README.md                  # Scripts documentation
├── web-browsers/               # Browser templates
├── development/                # Development tools
├── productivity/               # Office & productivity apps
├── design-graphics/            # Design & graphics tools
├── audio-video/                # Media editing tools
├── gaming/                     # Game emulators
├── desktop-environments/       # Full Linux desktops
├── communication/              # Chat & messaging
├── file-management/            # File transfer tools
├── remote-access/              # Remote desktop clients
├── catalog.yaml                # Template discovery metadata
├── README.md                   # User-facing documentation
├── CONTRIBUTING.md             # Contribution guidelines
└── claude.md                   # This file (AI context)
```

## Template Format

Templates use the StreamSpace Template CRD specification:

```yaml
apiVersion: stream.space/v1alpha1
kind: Template
metadata:
  name: application-name
  namespace: workspaces
spec:
  displayName: Application Display Name
  description: Application description
  category: Category Name
  icon: https://url-to-icon.png
  baseImage: lscr.io/linuxserver/app:latest
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
    - name: TZ
      value: "America/New_York"
  volumeMounts:
    - name: user-home
      mountPath: /config
  kasmvnc:
    enabled: true
    port: 3000
  capabilities:
    - Network
    - Clipboard
    - Audio
  tags:
    - tag1
    - tag2
```

### Key Fields

- **apiVersion**: Always `stream.space/v1alpha1`
- **namespace**: Always `workspaces`
- **baseImage**: Container image (prefer LinuxServer.io)
- **defaultResources**: CPU/memory defaults
- **ports**: Container ports (3000 for KasmVNC, 8080 for HTTP)
- **kasmvnc.enabled**: true for GUI apps, false for web apps
- **capabilities**: Network, Audio, Clipboard support
- **volumeMounts**: Persist data to `/config`

## Template Generation

### From LinuxServer.io API

Generate all available LinuxServer.io images:

```bash
python3 scripts/generate-templates.py
```

This fetches the complete catalog from https://api.linuxserver.io/api/v1/images and generates templates for all compatible images.

### From Curated Catalog

Generate from the curated popular apps list:

```bash
python3 scripts/generate-from-catalog.py
```

This uses `scripts/popular-apps.json` to generate templates for hand-picked, popular applications.

### Workflow

1. **Generate templates** using the Python scripts
2. **Review generated YAML files** in category directories
3. **Update catalog.yaml** with new template metadata
4. **Test templates** by deploying to a Kubernetes cluster
5. **Commit and push** to make available to StreamSpace users

## Categories

Templates are organized by category:

- **Web Browsers**: Firefox, Chromium, Brave, LibreWolf, Opera
- **Development**: VS Code, IDEs, text editors
- **Productivity**: LibreOffice, office suites
- **Design & Graphics**: GIMP, Krita, Inkscape, Blender, FreeCAD
- **Audio & Video**: Audacity, Kdenlive, OBS
- **Gaming**: DuckStation, Dolphin emulator
- **Desktop Environments**: Webtop (Ubuntu, Alpine, Fedora)
- **Communication**: Telegram, Element, messaging apps
- **File Management**: FileZilla, torrent clients
- **Remote Access**: Remmina, remote desktop clients
- **Security**: Password managers, security tools
- **AI & ML**: Machine learning tools
- **Automation**: Home automation, web tools
- **System Utilities**: Monitoring, admin tools

## Image Sources

Templates primarily use LinuxServer.io images:

- **Base Registry**: `lscr.io/linuxserver/`
- **Icon URLs**: `https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/`
- **KasmVNC**: Built-in for GUI applications (port 3000)

LinuxServer.io provides:
- Consistent image structure
- Regular updates and security patches
- KasmVNC integration for browser-based access
- Standardized environment variables (PUID, PGID, TZ)
- Volume persistence at `/config`

## Common Tasks

### Generate All Templates

```bash
cd /home/user/streamspace-templates
python3 scripts/generate-templates.py
```

### List Available Categories

```bash
python3 scripts/generate-templates.py --list-categories
```

### Generate Specific Category

```bash
python3 scripts/generate-templates.py --category "Web Browsers"
```

### Add Custom Template

1. Create YAML file in appropriate category directory
2. Follow the template format specification
3. Add entry to `catalog.yaml`
4. Test: `kubectl apply -f your-template.yaml`

### Update Catalog

After generating new templates, update `catalog.yaml`:

1. Add category to `spec.categories` if new
2. Add template entries to `spec.templates`
3. Update `spec.stats.totalTemplates` count
4. Update `spec.stats.lastUpdated` date

## Testing

Deploy template to Kubernetes cluster:

```bash
kubectl apply -f browsers/firefox.yaml
```

Verify template created:

```bash
kubectl get templates -n workspaces
```

Create a session from the template (via StreamSpace UI or API).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:

- Adding new templates
- Template naming conventions
- Resource allocation guidelines
- Testing requirements
- Pull request process

## Links

- **Main Project**: https://github.com/JoshuaAFerguson/streamspace
- **Template Repository**: https://github.com/JoshuaAFerguson/streamspace-templates
- **LinuxServer.io**: https://www.linuxserver.io/
- **LinuxServer.io API**: https://api.linuxserver.io/api/v1/images
- **Docker Templates**: https://github.com/linuxserver/docker-templates

## Notes for AI Assistants

When working with this repository:

1. **Template Format**: Always use `apiVersion: stream.space/v1alpha1` and `namespace: workspaces`
2. **Generation**: Use the Python scripts to generate templates from LinuxServer.io
3. **Organization**: Templates go in category-based directories
4. **Resources**: Follow category-based defaults (browsers: 2Gi/1CPU, development: 4Gi/2CPU, etc.)
5. **KasmVNC**: Enable for GUI apps (port 3000), disable for web apps (port 8080)
6. **Testing**: Always verify templates can be applied to Kubernetes cluster
7. **Catalog**: Keep catalog.yaml in sync with generated templates
8. **Commits**: Commit templates with clear messages about what was added/updated

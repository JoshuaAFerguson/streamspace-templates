# StreamSpace Templates Generation Scripts

This directory contains scripts for generating StreamSpace application templates from the LinuxServer.io catalog.

## Scripts

### generate-from-catalog.py

Generates templates from a curated list of popular applications defined in `popular-apps.json`.

**Usage:**
```bash
python3 scripts/generate-from-catalog.py
```

**Options:**
- `--catalog`: Path to catalog JSON file (default: `scripts/popular-apps.json`)
- `--output-dir`: Output directory for templates (default: `.` - repository root)

**Example:**
```bash
python3 scripts/generate-from-catalog.py --catalog scripts/popular-apps.json --output-dir .
```

### generate-templates.py

Fetches all available images from the LinuxServer.io API and generates templates for them.

**Usage:**
```bash
# Generate all templates
python3 scripts/generate-templates.py

# List available categories
python3 scripts/generate-templates.py --list-categories

# Generate only specific category
python3 scripts/generate-templates.py --category "Web Browsers"

# Output to specific directory
python3 scripts/generate-templates.py --output-dir /tmp/templates
```

**Options:**
- `--category`: Filter by category (e.g., 'Web Browsers', 'Development')
- `--output-dir`: Output directory for templates (default: `.` - repository root)
- `--list-categories`: List all available categories and exit

## Requirements

Install required Python packages:

```bash
pip install pyyaml
```

## Template Format

Generated templates follow the StreamSpace Template CRD specification:

```yaml
apiVersion: stream.space/v1alpha1
kind: Template
metadata:
  name: app-name
  namespace: workspaces
spec:
  displayName: Application Name
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
  tags:
    - app-name
    - category
```

## Categories

Templates are automatically organized into category directories:

- `web-browsers/` - Web browsers
- `development/` - Development tools and IDEs
- `productivity/` - Office suites and productivity apps
- `design-graphics/` - Design and graphics tools
- `audio-video/` - Media editing tools
- `gaming/` - Game emulators
- `desktop-environments/` - Full Linux desktops
- `communication/` - Chat and messaging apps
- `file-management/` - File transfer and management tools
- `remote-access/` - Remote desktop clients
- And more...

## Workflow

1. **Update popular-apps.json** (optional) - Curate which apps to include
2. **Run generation script** - Generate templates from LinuxServer.io catalog
3. **Review generated templates** - Check YAML files in category directories
4. **Update catalog.yaml** - Update the master catalog with new templates
5. **Test templates** - Deploy to Kubernetes cluster and verify
6. **Commit and push** - Make templates available to users

## Adding Custom Templates

To add a custom template not from LinuxServer.io:

1. Create a new YAML file in the appropriate category directory
2. Follow the template format above
3. Add entry to `catalog.yaml`
4. Test with: `kubectl apply -f your-template.yaml`

## Notes

- Templates use LinuxServer.io images (`lscr.io/linuxserver/*`)
- KasmVNC is enabled for GUI applications (port 3000)
- Web-only applications use HTTP (port 8080)
- All templates use standard environment variables (PUID, PGID, TZ)
- User data is persisted to `/config` volume mount

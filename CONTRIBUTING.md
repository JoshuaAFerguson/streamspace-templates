# Contributing to StreamSpace Templates

Thank you for your interest in contributing to StreamSpace Templates! This document provides guidelines for contributing new application templates.

## How to Contribute

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b add-template-yourapp`
3. **Add your template** following the guidelines below
4. **Test your template** locally
5. **Update catalog.yaml** with your template metadata
6. **Submit a pull request**

## Template Guidelines

### File Location

Place your template in the appropriate category directory:

- `browsers/` - Web browsers
- `development/` - IDEs, editors, development tools
- `productivity/` - Office suites, productivity apps
- `design/` - Graphics, CAD, design tools
- `media/` - Audio/video editing
- `gaming/` - Games, emulators
- `webtop/` - Full desktop environments

If your template doesn't fit any category, propose a new one in your PR.

### File Naming

- Use lowercase with hyphens: `my-application.yaml`
- Be descriptive: `blender.yaml` not `app.yaml`
- Match the template name in metadata

### Template Structure

```yaml
apiVersion: stream.space/v1alpha1
kind: Template
metadata:
  name: my-application        # Lowercase, hyphens
  namespace: streamspace
  labels:
    app.kubernetes.io/name: streamspace-template
    app.kubernetes.io/component: template
    streamspace.io/category: "Category Name"
spec:
  # Required fields
  displayName: "My Application"
  description: "Clear, concise description of the application"
  category: "Category Name"
  baseImage: "image:tag"      # Use specific tags, not :latest

  # Recommended fields
  icon: "https://example.com/icon.png"  # Application icon URL
  tags:
    - relevant
    - search
    - tags

  # Resource configuration
  defaultResources:
    memory: 2Gi               # Reasonable defaults
    cpu: 1000m

  # Container configuration
  ports:
    - name: vnc
      containerPort: 3000     # 3000 for LinuxServer.io, 5900 for standard VNC
      protocol: TCP

  env:
    - name: PUID
      value: "1000"
    - name: PGID
      value: "1000"
    # Add app-specific environment variables

  volumeMounts:
    - name: user-home
      mountPath: /config      # Standard for LinuxServer.io images

  # VNC configuration
  vnc:
    enabled: true
    port: 3000                # Match containerPort above

  # Application capabilities
  capabilities:
    - Network                 # Common capabilities
    - Audio
    - Clipboard
    # Optional: GPU, USB, etc.
```

### Required Information

Every template must include:

- ✅ `apiVersion: stream.space/v1alpha1`
- ✅ `kind: Template`
- ✅ `metadata.name` - Unique identifier
- ✅ `spec.displayName` - Human-readable name
- ✅ `spec.description` - Clear description
- ✅ `spec.category` - Category classification
- ✅ `spec.baseImage` - Container image with tag
- ✅ `spec.defaultResources` - Memory and CPU limits
- ✅ `spec.vnc` - VNC configuration

### Image Selection

**Preferred Sources** (in order):
1. **Official images** - Maintained by application developers
2. **LinuxServer.io** - Well-maintained, VNC-enabled containers
3. **Trusted community** - Verified DockerHub official images
4. **Custom builds** - Only if no alternatives exist

**Image Requirements**:
- Must include VNC server (KasmVNC, TigerVNC, or similar)
- Must be actively maintained
- Must support ARM64 (preferred) or AMD64
- Use specific version tags, not `:latest`

### Resource Defaults

Set reasonable resource limits based on application requirements:

**Lightweight** (editors, terminals):
```yaml
defaultResources:
  memory: 1Gi
  cpu: 500m
```

**Standard** (browsers, IDEs):
```yaml
defaultResources:
  memory: 2Gi
  cpu: 1000m
```

**Heavy** (3D, video editing):
```yaml
defaultResources:
  memory: 8Gi
  cpu: 4000m
```

### Testing Your Template

Before submitting, test your template:

```bash
# Validate YAML syntax
kubectl apply --dry-run=client -f my-template.yaml

# Deploy to test cluster
kubectl apply -f my-template.yaml

# Create a test session
kubectl apply -f - <<EOF
apiVersion: stream.space/v1alpha1
kind: Session
metadata:
  name: test-my-app
spec:
  user: testuser
  template: my-application
  state: running
EOF

# Verify it works
kubectl get session test-my-app
kubectl logs -f deployment/ss-testuser-my-application

# Access the application
# (Forward ports or use ingress)

# Cleanup
kubectl delete session test-my-app
```

### Updating catalog.yaml

Add your template to `catalog.yaml`:

```yaml
templates:
  - name: my-application
    category: development
    displayName: My Application
    description: Clear description
    tags: [relevant, tags]
    path: development/my-application.yaml
    version: "1.0.0"
```

Also update the category count:

```yaml
categories:
  - name: development
    displayName: Development Tools
    description: IDEs, editors, and development environments
    icon: 💻
    templates: 4  # Increment this
```

And the total count:

```yaml
stats:
  totalTemplates: 23  # Increment this
```

## Pull Request Guidelines

### PR Title Format

```
feat(category): add [Application Name] template
```

Examples:
- `feat(browsers): add Edge browser template`
- `feat(development): add PyCharm IDE template`
- `feat(design): add DaVinci Resolve template`

### PR Description

Include in your PR description:

```markdown
## Summary
Brief description of the application and why it's useful.

## Template Details
- **Category**: Development
- **Base Image**: `lscr.io/linuxserver/code-server:latest`
- **Default Resources**: 2Gi RAM, 1 CPU
- **VNC Port**: 3000

## Testing
- [ ] Validated YAML syntax
- [ ] Tested template deployment
- [ ] Created and accessed test session
- [ ] Verified application functionality
- [ ] Updated catalog.yaml

## Screenshots
(Optional) Screenshots of the application running in StreamSpace

## Related Issues
Closes #123
```

## Code Review Process

All PRs require:

1. ✅ Automated validation (GitHub Actions)
2. ✅ Manual review by maintainer
3. ✅ Testing by maintainer

We aim to review PRs within 48 hours.

## Style Guide

### YAML Style
- **Indentation**: 2 spaces
- **Quotes**: Use double quotes for strings with special characters
- **Comments**: Add comments for non-obvious configuration
- **Line length**: Keep under 120 characters

### Documentation
- **Descriptions**: Clear, concise, active voice
- **Tags**: Lowercase, hyphen-separated
- **Categories**: Title Case

## Getting Help

- **Questions**: Open a [Discussion](https://github.com/JoshuaAFerguson/streamspace-templates/discussions)
- **Bugs**: Open an [Issue](https://github.com/JoshuaAFerguson/streamspace-templates/issues)
- **Chat**: Join our Discord (link in main repo)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Thank you for helping make StreamSpace better! 🚀

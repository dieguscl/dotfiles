---
name: helm-validate
description: Helm chart linting, template rendering, and schema validation
allowed-tools: Bash(helm *)
---

# Helm Chart Validation

Validate Helm charts by linting, rendering templates, and checking for common issues.

## Steps

1. **Identify chart**: Ask the user for the chart path, or detect it by looking for `Chart.yaml` in the current directory or subdirectories.

2. **Lint**: Run `helm lint <chart-path>` with `--strict` to catch warnings as errors. If values files exist, also run `helm lint <chart-path> -f <values-file>` for each environment.

3. **Template render**: Run `helm template test-release <chart-path>` to render all templates and check for rendering errors. If values files are provided, render with each: `helm template test-release <chart-path> -f <values-file>`.

4. **Dependency check**: Run `helm dependency list <chart-path>` to verify all dependencies are present. If missing, suggest running `helm dependency update`.

5. **Dry-run install** (if connected to a cluster): Run `helm install test-release <chart-path> --dry-run --debug` to validate against the Kubernetes API server.

6. **Report**: Present findings organized by severity:
   - Errors (must fix)
   - Warnings (should fix)
   - Info (best practices)

If the user provides a specific values file or release name, use those in all commands.

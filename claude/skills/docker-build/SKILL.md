---
name: docker-build
description: Build and test Docker images locally
disable-model-invocation: true
allowed-tools: Bash(docker *)
---

# Docker Build & Test

Build Docker images locally and run basic validation tests.

## Steps

1. **Find Dockerfile**: Locate the Dockerfile in the current directory or ask the user for the path. Check for multi-stage builds and build arguments.

2. **Build image**: Run `docker build -t <image-name>:local-test .` using the appropriate context and Dockerfile path. Pass any required build args with `--build-arg`.

3. **Inspect image**: Run `docker image inspect <image-name>:local-test` to verify:
   - Image size
   - Exposed ports
   - Environment variables
   - Entrypoint/CMD
   - Labels

4. **Security scan** (if available): Run `docker scout cves <image-name>:local-test` or `docker scan <image-name>:local-test` to check for known vulnerabilities.

5. **Smoke test**: Run the container with `docker run --rm -d --name test-container <image-name>:local-test` and verify:
   - Container starts successfully
   - Health check passes (if defined)
   - Expected ports are listening
   - Clean shutdown with `docker stop test-container`

6. **Report**: Summarize build results:
   - Build success/failure
   - Image size and layer count
   - Any security findings
   - Smoke test results

Always clean up test containers and images when done. Never push images without explicit user confirmation.

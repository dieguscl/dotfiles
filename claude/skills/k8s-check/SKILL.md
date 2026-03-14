---
name: k8s-check
description: Kubernetes diagnostics — pod status, events, logs, resource usage
allowed-tools: Bash(kubectl *)
---

# Kubernetes Cluster Diagnostics

Run a comprehensive Kubernetes health check for the current cluster context.

## Steps

1. **Cluster context**: Run `kubectl config current-context` and `kubectl cluster-info` to confirm the target cluster.

2. **Pod status overview**: Run `kubectl get pods --all-namespaces --field-selector=status.phase!=Running,status.phase!=Succeeded` to find unhealthy pods. Then run `kubectl get pods -A` for a full overview.

3. **Recent events**: Run `kubectl get events --all-namespaces --sort-by='.lastTimestamp' | tail -30` to surface recent warnings or errors.

4. **Resource usage**: Run `kubectl top nodes` and `kubectl top pods --all-namespaces --sort-by=memory | head -20` to check resource consumption.

5. **Restart analysis**: Run `kubectl get pods --all-namespaces --sort-by='.status.containerStatuses[0].restartCount' | tail -10` to find pods with high restart counts.

6. **Summary**: Present a concise report with:
   - Cluster context and node count
   - Unhealthy pods and their reasons
   - Top resource consumers
   - Recent warning events
   - Recommended actions

If the user specifies a namespace, scope all commands to that namespace with `-n <namespace>`.

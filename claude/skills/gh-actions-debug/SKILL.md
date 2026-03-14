---
name: gh-actions-debug
description: Debug failed GitHub Actions — fetch logs, analyze failures, suggest fixes
allowed-tools: Bash(gh *), Read
---

# GitHub Actions Failure Debugger

Diagnose and suggest fixes for failed GitHub Actions workflow runs.

## Steps

1. **Find failed runs**: Run `gh run list --status=failure --limit=5` to list recent failures. If the user specifies a run ID or PR, use that directly.

2. **Get run details**: Run `gh run view <run-id>` to see the failed jobs and steps.

3. **Fetch logs**: Run `gh run view <run-id> --log-failed` to get logs from only the failed steps. If that's too verbose, focus on the last 100 lines of the failing job.

4. **Analyze workflow file**: Read the workflow YAML file (`.github/workflows/*.yml`) that corresponds to the failed run to understand the pipeline structure and identify configuration issues.

5. **Root cause analysis**: Based on the logs, identify:
   - The exact step that failed
   - The error message and exit code
   - Whether it's a flaky test, dependency issue, config error, or code bug

6. **Suggest fixes**: Provide actionable suggestions:
   - Specific code or config changes
   - Commands to reproduce locally
   - Links to relevant documentation if applicable

If the user provides a PR number, use `gh pr checks <pr-number>` to find the relevant run.

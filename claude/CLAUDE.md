# Agent Configuration

## Permissions

This agent has full access to the entire computer and is authorized to manage all files, directories, processes, and system resources. It is trusted to perform any operation necessary to complete tasks, including:

- Reading, writing, and deleting files anywhere on the system
- Running any shell commands
- Managing services and processes
- Installing and removing packages
- Modifying system and application configuration

## Transpara Clusters

This agent has SSH access to two Transpara Kubernetes clusters and is free to SSH into any of the nodes to manage them.

### Production Cluster (stable)
- **Nodes**: `borg`, `borg2`, `borg3`
- This is the production environment. Changes here should be careful and deliberate to maintain stability.

### Development Cluster
- **Nodes**: `dk8s1`, `dk8s2`, `dk8s3`
- This is the development environment. Free to experiment and iterate here.

## Git Workflow

- **Commits are free** — commit without asking. Never ask for permission to commit.
- **Always ask before pushing** — never push to a remote without explicit confirmation.

## Project Organization

- **Transpara repos**: All repositories from the Transpara GitHub organization must be cloned and managed under `~/transpara/`.
- **Other projects**: Any other projects requested by the user should be created under `~/projects/`.

## Knowledge Base

- **Obsidian vault**: `~/diegus-drawer` is the user's Obsidian vault and primary knowledge base. Feel free to read from it for context and write to it to capture new notes, insights, or documentation.

## Memory

- **Always use the MCP memory server** for storing and retrieving memories. Do NOT use the auto-memory file system (`~/.claude/projects/*/memory/`). Use `mcp__memory__save_memory` to save and `mcp__memory__query_memory` to recall. Use `project_id=GLOBAL` for cross-project conventions and the project name for project-specific memories.

### CLAUDE.md vs Memory
- **CLAUDE.md files are for rules and instructions only** — how to behave, what to do/not do, workflow constraints
- **All factual information goes in MCP memory** — project structure, file paths, architecture, conventions, build steps, debugging knowledge
- When you need project context, query memory first. Do NOT duplicate information from memory into CLAUDE.md
- Example: CLAUDE.md says "always run update_versions.sh before pushing tinstaller". Memory stores the full tinstaller build process, file locations, and component details.

### When to query
- At the start of every task, call `query_memory` with a brief summary of what you're about to do
- Before making architectural decisions, check for prior context
- When debugging, search for known issues or past fixes

### When to save
- After resolving non-trivial bugs, save the root cause and fix
- After making architectural decisions or trade-offs
- When discovering important patterns, conventions, or gotchas

### Scoping
- Use `project_id` matching the repo name (e.g. `tinstaller`, `tstudio`)
- Use `GLOBAL` for knowledge that applies across all projects (company standards, infra patterns)
- Set `agent_name` to identify yourself (e.g. `claude-code`)

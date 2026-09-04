# TheAuditor Docker Quick Reference

For Claude Code instances: Use this to run TheAuditor on any codebase without Python 3.14.

## Prerequisites

- Docker Desktop running
- TheAuditor image built (see Build section if needed)

## Core Commands

```bash
# Always mount target repo to /target
docker run --rm -v /path/to/repo:/target theauditor <command>

# Windows PowerShell example:
docker run --rm -v D:\repos\MyProject:/target theauditor full --offline
```

## Workflow

### 1. Index the codebase (required first)
```bash
docker run --rm -v /path/to/repo:/target theauditor full --offline
```
This creates `.pf/` directory with `repo_index.db` and `graphs.db`.

### 2. Query the indexed data
```bash
# Architecture overview
docker run --rm -v /path/to/repo:/target theauditor blueprint --structure

# Security vulnerabilities
docker run --rm -v /path/to/repo:/target theauditor taint --severity high

# Explain a file or symbol
docker run --rm -v /path/to/repo:/target theauditor explain src/auth/service.ts

# Find callers of a function
docker run --rm -v /path/to/repo:/target theauditor query --symbol validateUser --show-callers

# Blast radius before refactoring
docker run --rm -v /path/to/repo:/target theauditor impact --symbol AuthManager
```

## Common Commands Reference

| Command | Purpose |
|---------|---------|
| `full --offline` | Index + analyze (no network, preferred) |
| `full --index` | Index only (fastest) |
| `blueprint --structure` | Architecture overview |
| `blueprint --security` | Security surface |
| `taint --severity high` | Find injection vulnerabilities |
| `boundaries` | Security boundary analysis |
| `explain <path>` | Complete context for file/symbol |
| `query --symbol X --show-callers` | Find who calls X |
| `impact --symbol X` | Blast radius of changes to X |
| `deadcode` | Find unused code |
| `fce --min-vectors 2` | High-risk files (multiple signals) |

## Build Image (one-time setup)

```bash
cd D:\repos\Auditor
docker build -t theauditor .
```

## Interactive Shell (debugging)

```bash
docker run --rm -it -v /path/to/repo:/target --entrypoint /bin/bash theauditor
```

## Notes

- The `.pf/` output directory persists in your mounted repo
- Re-run `full --offline` after significant code changes
- Use `--offline` to avoid rate limiting from network calls
- Image uses Python 3.14.0rc3 with Node.js for JS/TS parsing

# Security Policy

## What this repository is

Builds the optimized Keycloak image for the homelab and holds its login theme.
It publishes `ghcr.io/mainman94/keycloak:<commit-sha>`. Configuration,
credentials and the database URL come from the Keycloak CR at runtime, never
from this repository.

## Reporting a vulnerability

Report privately via GitHub's
[security advisories](https://github.com/mainman94/keycloak-build/security/advisories/new).
Please do not open a public issue for anything exploitable.

## What is already covered

- **No secrets in the repository.** `gitleaks` runs as a pre-commit hook and
  in CI.
- **Every action reference is pinned to a commit SHA**, and `actionlint` plus
  `zizmor` audit the workflows. Workflows start from `permissions: {}`.
- **trivy** scans the repo (misconfig, secrets) and the pushed image.
- **Published images are signed with cosign**, keylessly (OIDC identity,
  Rekor log):

```shell
cosign verify ghcr.io/mainman94/keycloak@<digest> \
  --certificate-identity-regexp '^https://github.com/mainman94/keycloak-build/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

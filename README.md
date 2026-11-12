# keycloak-build

Builds the optimized Keycloak image for the homelab with the
[FULLSTACKS Keycloak image builder](https://github.com/FullStackS-GmbH/keycloak-image-builder)
(GitHub Action, mirror of `gitlab.com/fullstacks-gmbh/cicd-components/keycloak`).

| | |
| --- | --- |
| Image | `ghcr.io/mainman94/keycloak:<commit-sha>` |
| Build options | PostgreSQL, health and metrics enabled, `linux/amd64` |
| Base image | Keycloak 26.x pinned by digest in the builder's `Dockerfile` |
| Consumer | Keycloak Operator CR in `multi-k8s-infra` (`eggenberg-talos-cluster-1`) |

`.github/workflows/build.yml` builds on every pull request and publishes on
pushes to `main` (or a manual run). The builder is pinned by commit SHA;
Renovate bumps it, and with it the Keycloak version.

The image runs `start --optimized`, so the build-time options above must match
the runtime configuration. Database URL, credentials, hostname and admin
bootstrap come from the Keycloak CR at runtime, never from the image.

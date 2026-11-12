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

## Themes

`themes/` is copied into the image (one directory per theme). `homelab` is a
login theme on top of `keycloak.v2`: it adds `css/homelab.css` and a logo and
leaves templates and messages to the parent. Select it per realm
(`login_theme = "homelab"` in `homelab/terraform/keycloak`).

Try a change locally without a build (theme cache off, reload to see edits):

```sh
docker run --rm -p 8080:8080 -v "$PWD/themes/homelab:/opt/keycloak/themes/homelab:ro" \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
  quay.io/keycloak/keycloak:26.8.2 start-dev --spi-theme--cache-themes=false
```

## Development

`make help` lists the targets: `make tools` installs the toolchain pinned in
`mise.toml`, `make hooks` installs the pre-commit hooks, `make check` runs
them all (yamlfmt, shellcheck, actionlint, zizmor, gitleaks), `make scan` runs
trivy and `make theme` starts Keycloak with the theme mounted. CI runs the same
hooks (`ci.yml`), a trivy repo scan (`trivy.yml`) and scans and cosign-signs
the pushed image (`build.yml`). Verification: see `SECURITY.md`.

## Build

`.github/workflows/build.yml` builds on every pull request and publishes on
pushes to `main` (or a manual run). The builder is pinned by commit SHA;
Renovate bumps it, and with it the Keycloak version.

The image runs `start --optimized`, so the build-time options above must match
the runtime configuration. Database URL, credentials, hostname and admin
bootstrap come from the Keycloak CR at runtime, never from the image.

# AGENTS

Builds the optimized Keycloak image for the homelab (FullStackS image builder
action) and holds the `homelab` login theme under `themes/`.

## Local workflow

| Command        | What it does                                         |
| -------------- | ---------------------------------------------------- |
| `make help`    | List every target                                    |
| `make tools`   | Install the pinned toolchain from `mise.toml`        |
| `make hooks`   | Install the git pre-commit hook (once)               |
| `make check`   | Everything a PR needs (all hooks)                    |
| `make scan`    | trivy misconfig + secret scan, as in CI (advisory)   |
| `make theme`   | Local Keycloak with the theme mounted, cache off     |

Tool versions live in `mise.toml` and nowhere else; CI and the dev container
install from it. Renovate bumps the pins and the builder action.

The image runs `start --optimized`, so build options in
`.github/workflows/build.yml` must match the runtime configuration in the CR.

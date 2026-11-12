# keycloak-build — optimized Keycloak image for the homelab, built in CI by
# the FullStackS keycloak-image-builder action. There is no local image build:
# the Dockerfile lives in the action, so `make` here is lint, scan and theme
# preview.

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

KEYCLOAK_VERSION ?= 26.8.2

.PHONY: help
help: ## Show this help
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

.PHONY: tools
tools: ## Install the pinned toolchain from mise.toml
	@command -v mise >/dev/null || { echo "mise not on PATH — see https://mise.jdx.dev or .devcontainer" >&2; exit 1; }
	mise install

.PHONY: hooks
hooks: ## Install the git pre-commit hook
	prek install

.PHONY: lint
lint: ## Run every pre-commit hook over the whole tree
	prek run --all-files

.PHONY: update-hooks
update-hooks: ## Bump pinned hook revisions
	prek update

# `make scan TRIVY_ARGS=--exit-code=1` to fail on any finding.
TRIVY_ARGS ?=

.PHONY: scan
scan: ## trivy misconfig + secret scan of the repo (advisory)
	@command -v trivy >/dev/null || { echo "trivy not on PATH — run make tools" >&2; exit 1; }
	trivy fs --scanners misconfig,secret $(TRIVY_ARGS) .

.PHONY: theme
theme: ## Run Keycloak locally with themes/homelab mounted (cache off; admin/admin)
	docker run --rm -p 8080:8080 -v "$(CURDIR)/themes/homelab:/opt/keycloak/themes/homelab:ro" \
		-e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
		quay.io/keycloak/keycloak:$(KEYCLOAK_VERSION) start-dev --spi-theme--cache-themes=false

.PHONY: check
check: lint ## Everything a PR needs to pass

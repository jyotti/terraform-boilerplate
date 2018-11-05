NAME = "terraform-project-starter"

INSTALL_DIR = $(CURDIR)/.local
TERRAFORM = $(INSTALL_DIR)/bin/terraform
TERRAFORM_VERSION := 0.11.10

.DEFAULT_GOAL := help

# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help: ## help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: install
install: install-terraform ## Install dependencies

.PHONY: install-terraform
install-terraform: ## Install terraform binary
	@bash scripts/install-terraform.sh --version $(TERRAFORM_VERSION) --path $(INSTALL_DIR)

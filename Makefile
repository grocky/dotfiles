
.PHONY: dotfiles bins brew agents test help

default: help

init: macos brew bins dotfiles agents ## Initialize a new machine

macos: ## Initialize macos settings
	./initialize_macos.sh

dotfiles: ## Install dotfiles
	./install_dotfiles.sh

bins: ## Install bins
	./install_bins.sh

brew: ## Install brew bundle
	brew bundle

agents: ## Install shared AI agent instructions (AGENTS.md, CLAUDE.md, language rules)
	./install_agents.sh

test: ## Run install script tests
	./tests/install_agents_test.sh

GREEN  := $(shell tput -Txterm setaf 2)
RESET  := $(shell tput -Txterm sgr0)

help: ## print this help message
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "${GREEN}%-20s${RESET}%s\n", $$1, $$NF }' $(MAKEFILE_LIST)

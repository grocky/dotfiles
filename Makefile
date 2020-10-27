
.PHONY: dotfiles bins brew help

default: help

init: macos brew bins dotfiles ## Initialize a new machine

dotfiles: ## Install dotfiles
	./install_dotfiles.sh

bins: ## Install bins
	./install_bins.sh

brew: ## Install brew bundle
	brew bundle

GREEN  := $(shell tput -Txterm setaf 2)
RESET  := $(shell tput -Txterm sgr0)

help: ## print this help message
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "${GREEN}%-20s${RESET}%s\n", $$1, $$NF }' $(MAKEFILE_LIST)

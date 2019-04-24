
.PHONY: dotfiles bins brew

default: brew bins dotfiles

dotfiles:
	./install_dotfiles.sh
bins:
	./install_bins.sh
brew:
	brew bundle

#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"


brew install ack
brew install bat
brew install dust
brew install exa
brew install fd
brew install fzf
brew install git
brew install git-lfs
brew install imagemagick --with-webp
brew install lsd
brew install lua
brew install neovim
brew install nu
brew install openssh
brew install p7zip
brew install procs
brew install python
brew install ripgrep
brew install sd
brew install starship
brew install tokei
brew install wget
brew install zoxide



# Remove outdated versions from the cellar.
brew cleanup

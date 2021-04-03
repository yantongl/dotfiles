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

# Install `wget` with IRI support.
brew install wget --with-iri

# # Install more recent versions of some macOS tools.
brew install python
brew install vim --with-override-system-vi
brew install grep
brew install openssh


# # Install other useful binaries.
brew install ack
brew install git
brew install git-lfs
# brew install gs
brew install imagemagick --with-webp
brew install lua
brew install lynx
brew install p7zip

# Remove outdated versions from the cellar.
brew cleanup

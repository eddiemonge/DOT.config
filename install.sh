#!/bin/sh

# Add different instructions for Linux/MacOSX
case "$(uname -s)" in
  Linux*)     OS=Linux;;
  Darwin*)    OS=Mac;;
  *)          echo "Unknown OS $(uname -s), quitting install" && exit 1;;
esac

# Make sure we start in the home directory
cd "$HOME" || exit 1

# Linux needs some things installed first
if [ "$OS" = "Linux" ]; then
  echo "Updating Linux system files ..."
  sudo apt-get update
  sudo apt-get -y upgrade
  sudo apt-get -y install build-essential curl file git vim-nox zsh
  which zsh | sudo tee -a /etc/shells
  sudo chsh -s "$(which zsh)"
fi

# Clone the repo
if [ ! -d "$HOME/.config" ]; then
  echo "Getting the config files from GitHub ..."
  git clone --recursive https://github.com/eddiemonge/DOT.config.git "$HOME/.config"
fi

# Install brew or update it if it is installed already
if [ ! "$(which brew)" ]; then
  echo "Installing Homebrew ..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Turn off brew analytics as most of the time this is a work machine
  brew analytics off

  # Install some supporting software
  if [ "$OS" = "Mac" ]; then
    brew install --cask docker google-chrome iterm2 visual-studio-code
    brew install trash
    open -a "Google Chrome" "https://apps.apple.com/app/skitch/id425955336"
    open -a "Google Chrome" "http://itunes.apple.com/app/id413857545"
    open -a "Google Chrome" "https://www.alfredapp.com/"
  fi
else
  echo "Updating Homebrew ..."
  brew update
  brew upgrade
fi

# Set where zsh gets it's config file from
if [ ! -z "$ZDOTDIR" ]; then
  echo "Setting up zsh env ..."
  ln -s "$HOME/.config/zsh/zshenv" "$HOME/.zshenv"
  . "$HOME/.zshenv"
fi

# Run the OS customizations
# if [ "$OS" = "Mac" ]; then
#   echo "Customizing OSX ..."
#   sh "$HOME/.config/osx/macos.sh"
# fi

# Install powerline fonts
if [ "$OS" = "Mac" ]; then
  if [ ! -f "$HOME/Library/Fonts/Inconsolata-Regular.ttf" ]; then
    echo "Installing Inconsolata ..."
    curl -sSL -o "$HOME/Library/Fonts/Inconsolata-Regular.ttf" https://github.com/google/fonts/raw/main/ofl/inconsolata/static/Inconsolata-Regular.ttf
  fi
  if [ ! -f "$HOME/Library/Fonts/Inconsolata for Powerline.otf" ]; then
    echo "Installing Inconsolata for Powerline ..."
    curl -sSL -o "$HOME/Library/Fonts/Inconsolata for Powerline.otf" https://github.com/powerline/fonts/raw/master/Inconsolata/Inconsolata%20for%20Powerline.otf
  fi
fi

# Cleanup
echo "Cleaning up ..."
brew cleanup
echo "All done!"


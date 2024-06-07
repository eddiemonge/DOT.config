#!/bin/sh

# Add different instructions for Linux/MacOSX
case "$(uname -s)" in
  Linux*)     OS=Linux;;
  Darwin*)    OS=Mac;;
  *)          echo "Unknown OS $(uname -s), quitting install" && exit 1;;
esac

CONFIG="$HOME/.config"


# Ask for the administrator password upfront
echo "Sudo password is needed later on. Asking now so installation can proceed unattended"
sudo -v

# Keep-alive: update existing `sudo` time stamp until finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we start in the home directory
cd "$HOME" || exit 1

# Linux needs some things installed first
if [ "$OS" = "Linux" ]; then
  echo 'Updating Linux system files ...'
  sudo apt-get update
  sudo apt-get -y upgrade
  sudo apt-get -y install ack build-essential curl file git vim-nox wget zsh
  which zsh | sudo tee -a /etc/shells
fi

# Install, or update, homebrew
if [ ! "$(which brew)" ]; then
  echo 'Installing Homebrew ...'
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Turn off brew analytics as most of the time this is a work machine
  brew analytics off

  # Install some supporting software
  if [ "$OS" = "Mac" ]; then
    brew install --cask docker google-chrome iterm2 visual-studio-code
    brew install trash git ack wget
    # Instal divvy window manager
    open -a "Google Chrome" "http://itunes.apple.com/app/id413857545"
  fi
  brew install bat prettyping
else
  echo 'Updating Homebrew ...'
  brew update
  brew upgrade
fi
brew cleanup

# Install powerline fonts
if [ "$OS" = "Mac" ]; then
  if [ ! -f "$HOME/Library/Fonts/Inconsolata-Regular.ttf" ]; then
    echo 'Installing Inconsolata ...'
    /bin/bash -c "$(curl -sSL -o "$HOME/Library/Fonts/Inconsolata-Regular.ttf" https://github.com/google/fonts/raw/main/ofl/inconsolata/static/Inconsolata-Regular.ttf)"
  fi
  if [ ! -f "$HOME/Library/Fonts/Inconsolata for Powerline.otf" ]; then
    echo 'Installing Inconsolata for Powerline ...'
    /bin/bash -c "$(curl -sSL -o "$HOME/Library/Fonts/Inconsolata for Powerline.otf" https://github.com/powerline/fonts/raw/master/Inconsolata/Inconsolata%20for%20Powerline.otf)"
  fi
fi

# Clone, or update, the repo
if [ ! -d "$CONFIG" ]; then
  echo 'Getting the config files from GitHub ...'
  git clone --recursive https://github.com/eddiemonge/DOT.config.git "$CONFIG"
  builtin cd "$CONFIG" && { \
    git submodule update --init --recursive
    git remote rename origin origin-http \
    builtin cd -; \
  }
else
  builtin cd "$CONFIG" && { \
    git submodule update --init --recursive
    git pull --rebase origin-http main ; \
    git submodule update ; \
    builtin cd -; \
  }
fi

# Switching to zsh shell now
sudo chsh -s "$(which zsh)"

# Set where zsh gets it's config file from
if [ ! -z "$ZDOTDIR" ]; then
  echo 'Setting up zsh env ...'
  ln -s "$CONFIG/zsh/zshenv" "$HOME/.zshenv"
  . "$HOME/.zshenv"
fi

# Source zsh files
. "$CONFIG/zsh/.zshrc"

# Setup Git Author info
if [ ! -f "$CONFIG/git/author" ]; then
  if [ "$OS" = "Mac" ]; then
    cp "$CONFIG/git/author.sample" "$CONFIG/git/author"
    code "$CONFIG/git/author"
  elif [ "$OS" = "Linux" ]; then
    echo 'To setup your git author information, copy and edit the sample'
    echo "cp $CONFIG/git/author.sample $CONFIG/git/author"
  fi
fi

# Run the OS customizations
# TODO: Should they be installed based on MacOS version?
if [ "$OS" = "Mac" ]; then
  echo 'Customizing OSX ...'
  sh "$CONFIG/osx/macos.sh"
fi

echo 'All done!'
echo 'Do not forget to configure ssh:'
echo 'ssh-keygen -t ed25519 -C "your_email@example.com"'

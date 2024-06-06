# Default user name (used for theming)
DEFAULT_USER=`whoami`

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.config/zsh/oh-my-zsh

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=$HOME/.config/zsh/oh-my-zsh-custom

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Change history settings
HIST_STAMPS="yyyy-mm-dd"
HISTFILE=$ZSH_CACHE_DIR/zsh_history
HISTFILESIZE=1000000000
HISTSIZE=1000000000

# nvm
# Defer nvm loading until needed
zstyle ':omz:plugins:nvm' lazy yes

# Set the auto-update behavior
# update automatically without asking
zstyle ':omz:update' mode auto

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git nvm)

source $ZSH/oh-my-zsh.sh

# Load aliases and things after path
source $ZSH/../aliases

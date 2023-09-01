# ZSH configuration
export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH

## Set where cache files should be created
if [[ -z "$ZSH_CACHE_DIR" ]]; then
  export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME}/.cache"
else
fi

## Change where the less history file goes
export LESSHISTFILE=$ZSH_CACHE_DIR/lesshst

## Path to the completion cache file
export ZSH_COMPDUMP=$ZSH_CACHE_DIR/zcompdump

# User configuration

## Add Visual Studio Code (code)
export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin

## Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

## Tell vim where it's config files are
export VIM=$HOME/.config/vim

## Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code -w'
fi
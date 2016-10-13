# Load modules.
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz vcs_info

# Enable zsh history.
setopt append_history
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt share_history
HISTFILE='/tmp/zsh'
HISTSIZE=1000
SAVEHIST=1000

# Set up the environment.
export EDITOR='vim'
export NETHACKOPTIONS='autodig,boulder=0,color,decgraphics,lit_corridor,nopet,pickup_types=$,time'
export PATH="$PATH:node_modules/.bin"

# Enable prompt variable use and configure the VCS prompt.
setopt prompt_subst
zstyle ':vcs_info:*' formats '%F{green}%b'
zstyle ':vcs_info:*' actionformats '%F{green}%b%F{blue}«%F{green}%a'

# Initailize VCS info, and in screen set the title to last command.
if [[ "$TERM" == "screen" ]]; then
  precmd () {
    echo -ne "\ekzsh\e\\"
    vcs_info
  }
  preexec () {
    echo -ne "\ek$1\e\\"
  }
else
  precmd () {
    vcs_info
  }
fi

# Set up left and right prompts.
PS1=' %F{blue}%1~${vcs_info_msg_0_}%f '
RPS1='%*'

# Set vim key mode and bindings.
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^r' history-incremental-search-backward
bindkey '^w' backward-kill-word
bindkey "^?" backward-delete-char

# Set up common aliases.
alias dr='screen -DR'
alias dl='screen -ls'
alias grep='grep --color=auto'
alias ls='ls -G'
alias l='ls -lAh'
alias ag='ag -s'

# Handle conditional shortcuts.
if [ -e "/usr/local/go" ]; then
  export GOPATH="/usr/local/go"
fi
if [ -d "$HOME/Documents" ]; then
  d(){cd "$HOME/Documents/$1"; ls}
  compctl -W "$HOME/Documents" -/ d
fi
if [ -d "$GOPATH" ]; then
  if [ -d "$GOPATH/src/github.com/$USER" ]; then
    g(){cd "$GOPATH/src/github.com/$USER/$1"; ls}
    compctl -W "$GOPATH/src/github.com/$USER" -/ g
  fi
  PATH="$PATH:$GOPATH/bin"
  alias goco='go test -coverprofile=cover -covermode=count && go tool cover -html=cover && rm cover'
fi
if [ -d "$HOME/Library/Logs/CoreSimulator" ]; then
  alias simlog='tail -f $HOME/Library/Logs/CoreSimulator/*/system.log'
fi
if [ -x "$(command -v virtualenv)" ]; then
  virt(){
    if [[ "$VIRTUAL_ENV" =~ '/tmp/virtualenv' ]]; then
      deactivate && rm -rf /tmp/virtualenv
    else
      virtualenv /tmp/virtualenv/py && source /tmp/virtualenv/py/bin/activate
    fi
  }
  if [ -x "$(command -v python3)" ]; then
    virt3(){
      if [[ "$VIRTUAL_ENV" =~ '/tmp/virtualenv' ]]; then
        deactivate && rm -rf /tmp/virtualenv
      else
        virtualenv -p python3 /tmp/virtualenv/py3 && source /tmp/virtualenv/py3/bin/activate
      fi
    }
  fi
fi

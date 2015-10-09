# Load modules.
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz vcs_info

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

# Set up the environment.
export EDITOR='vim'
export NETHACKOPTIONS='autodig,boulder=0,color,decgraphics,lit_corridor,nopet,pickup_types=$,time'
export PATH="node_modules/.bin:$PATH"

# Enable prompt variable use and configure the VCS prompt.
setopt prompt_subst
zstyle ':vcs_info:*' formats '%F{green}%b'

# Set up left and right prompts.
PS1=' %F{blue}%1~${vcs_info_msg_0_}%f '
RPS1='%*'

# Set vim key mode and bindings.
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

# Set additional key bindings.
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^r' history-incremental-search-backward
bindkey '^w' backward-kill-word
bindkey "^?" backward-delete-char

# Set up common aliases.
alias dr='screen -DR'
alias dl='screen -ls'
alias ls='ls -G'
alias l='ls -lA'

# Set up conditional aliases.
if [ -e "$HOME/Cloud" ]; then
  alias c='cd $HOME/Cloud/ && ls'
fi
if [ -e "$HOME/Documents" ]; then
  alias d='cd $HOME/Documents/ && ls'
fi
if [ -d "$GOPATH" ]; then
  PATH="$PATH:$GOPATH/bin"
fi

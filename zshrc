# Load modules.
autoload -Uz colors && colors
autoload -Uz compinit && compinit
autoload -Uz vcs_info
autoload -Uz zmv

# Rehash zsh's completion on miss.
zstyle ':completion:*' rehash true

# Enable zsh history.
setopt append_history
setopt extended_glob
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt share_history
HISTFILE=~/.zsh_history
HISTSIZE=100000
REPORTTIME=1
SAVEHIST=1000000

# Set up the environment.
export EDITOR='vim'
export GOPATH=$HOME/.config/go
export NETHACKOPTIONS='autodig,boulder=0,color,decgraphics,hilite_pile,hilite_status:hitpoints/100%/brightgreen,hilite_status:hitpoints/<100%/green,hilite_status:hitpoints/<60%/yellow,hilite_status:hitpoints/<40%/red,hilite_status:power/100%/brightgreen,hilite_status:power/<100%/green,hilite_status:power/<60%/yellow,hilite_status:power/<40%/red,hitpointbar,lit_corridor,nopet,pickup_types=$,statushilites,time'

# Enable prompt variable use and configure the VCS prompt.
setopt prompt_subst
zstyle ':vcs_info:*' formats '%F{green}%b'
zstyle ':vcs_info:*' actionformats '%F{green}%b%F{blue}«%F{green}%a'
TIMEFMT="$fg[cyan]%J$reset_color user $fg[yellow]%*U$reset_color sys $fg[yellow]%*S $fg[blue]%*E"

precmd () {
  vcs_info
}
preexec () {
  echo -ne "\e[0m
"
}

# Set vim key mode and bindings.
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^r' history-incremental-search-backward
bindkey '^w' backward-kill-word
bindkey "^?" backward-delete-char

# Change ls flags if running on OSX.
if [[ "$(uname -s)" == 'Darwin' ]]; then
  alias ls='ls -GT'
else
  alias ls='ls --color=auto'
fi

PROMPT='
╭ %* %B%F{blue}%1~%b${vcs_info_msg_0_}%f
%B'

# Set up common aliases.
alias dr='screen -T screen-256color -DR'
alias dl='screen -ls'
alias grep='grep --color=auto'
alias l='ls -lAh'

# Set additional zsh options.
setopt rm_star_silent

# Handle conditional shortcuts.
if [ -d "$HOME/Documents" ]; then
  d(){cd "$HOME/Documents/$1"; ls}
  compctl -W "$HOME/Documents" -/ d
fi
if [ -d "$HOME/Play" ]; then
  p(){cd "$HOME/Play/$1"; ls}
  compctl -W "$HOME/Play" -/ p
fi
if [ -d "$HOME/.local/bin" ]; then
  export PATH=$HOME/.local/bin:$PATH
fi

# Use ripgrep with sed if installed.
if [ -x "$(command -v rg)" ]; then
  rgs(){
    rg -l $1 | xargs sed -i '' "s$1$2g"
  }
fi

alias q='noglob q'

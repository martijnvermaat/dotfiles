# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Check if a command, function or builtin is available.
available () {
  command -v > /dev/null 2>&1 "$1" && return 0 || return 1
}

# No beeps.
[ $DISPLAY ] && xset -b b off

# Append to history, ignore duplicate and empty lines.
HISTCONTROL=ignoreboth
HISTSIZE=50000
HISTFILESIZE=100000
shopt -s histappend

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Bash completion.
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Prompt. This should be after loading completions, since many distributions
# load __git_ps1 as part of the completions.
if available __git_ps1; then
    GIT_PS1_SHOWDIRTYSTATE=0
    GIT_PS1_SHOWSTASHSTATE=0
    GIT_PS1_SHOWUPSTREAM="auto"
    PS1='\u@\h:\w$(__git_ps1)\$ '
else
    PS1='\u@\h:\w\$ '
fi

# Setup ls.
available dircolors && eval "$(dircolors -b)"
export QUOTING_STYLE=literal
alias ls="ls --color=auto"
alias l="ls -lh --group-directories-first"
alias la="l -a"

# Use less as pager.
export PAGER=less
export LESS="-S -R"
alias lg='less +G'
alias lf='less +F'

# Make less more friendly for non-text input files.
if available lesspipe; then
    # This comes with the Debian less package.
    eval "$(SHELL=/bin/sh lesspipe)"
else
    # This has a Nix package.
    available lesspipe.sh && eval "$(lesspipe.sh)"
fi

# Grep and ag (silver searcher).
alias grep="grep --color=auto"
alias ag="ag --pager=less"

# Emacs is our editor.
export EDITOR="emacsclient -a '' -c"
alias emacs="${EDITOR}"
alias e="${EDITOR}"

# Quick IPython terminal.
alias py="ipython"

# Enable alias expansion with sudo.
# http://stackoverflow.com/a/9947170
alias sudo='sudo '

# Auto aliases for SSH hosts (disable with '#bash:no-alias').
if [ -f ~/.ssh/config ]; then
    for host in $(grep -v 'bash:no-alias' ~/.ssh/config | grep -oP '^Host \K[\w-.]+'); do
        alias "${host}=ssh -t ${host} \"screen -Rd default && clear\""
    done
fi

# Go.
# TODO: What to do on NixOS?
if [ -d $HOME/projects/go ]; then
    export GOPATH=$HOME/projects/go
    export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
fi

# Python virtualenvwrapper with virtualenv-burrito.
# TODO: What to do on NixOS?
export WORKON_HOME=~/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.venvburrito/startup.sh" ]; then
        . "$HOME/.venvburrito/startup.sh"
    fi
fi

# Source site-specific configuration if it exists.
if [ -f ~/.bashrc.site ]; then
    . ~/.bashrc.site
fi

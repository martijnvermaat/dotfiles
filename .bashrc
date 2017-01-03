# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Check if a command, function or builtin is available.
available () {
  command -v > /dev/null 2>&1 "$1" && return 0 || return 1
}

# No beeps.
[ $DISPLAY ] && xset -b b off

# Append to history, ignore duplicate and empty lines, merge multi-line
# commands.
HISTCONTROL=ignoreboth
HISTSIZE=10000000
HISTFILESIZE=10000000
shopt -s histappend
shopt -s cmdhist

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Bash completion.
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Configure git PS1 indicator (and define as noop if unavailable). This should
# be after loading completions since many distributions load __git_ps1 as
# part of those.
GIT_PS1_SHOWDIRTYSTATE=0
GIT_PS1_SHOWSTASHSTATE=0
GIT_PS1_SHOWUPSTREAM="auto"
available __git_ps1 || __git_ps1 () { return 0; }

# PS1 indicator for nix-shell.
# We don't like the default PS1 change that nix-shell does, since it has ugly
# coloring and overrides any of our existing PS1 customizations. So we use a
# patched nix-shell which does not touch PS1 (see .nixpkgs/config.nix).
__nix_shell_ps1 () {
    [ "$IN_NIX_SHELL" ] && echo -e " [${name}]"
}

# Prompt.
PS1='\u@\h:\w$(__git_ps1)$(__nix_shell_ps1)\$ '

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
alias magit="e -e '(magit-status)'"

# Find a derivation for nix-shell going up starting with the current directory.
get_nix_shell_root () {
    root="${PWD}"
    while [[ "${root}" != "/" ]]; do
        if [ -f "${root}/shell.nix" ] || grep -qs '^\s*shellHook\s*=' "${root}/default.nix"; then
            echo "${root}"
            return
        fi
        root="$(readlink -f "${root}"/..)"
    done
    return 1
}

# One-letter editor shortcut that takes into account nix-shell.
if available nix-shell; then
    # If we have nix-shell, try to take it into account in how to run Emacs.
    e () {
        root="$(get_nix_shell_root)"
        if [ -n "${root}" ]; then
            # Dedicated Emacs server per nix-shell environment.
            socket="${root}/.emacs-server-socket.tmp"
            # If there is a daemon already listening on the socket, we can just
            # connect to it. If we are in a nix-shell we can just start a new
            # daemon.
            # In all other cases, we start a new daemon wrapped in a nix-shell
            # session.
            # Alternative to ss would be netstat -xan.
            if ss -lx src "${socket}" | grep -q LISTEN || [ "$IN_NIX_SHELL" ]; then
                emacs -s "${socket}" "$@"
            else
                # We should run nix-shell from the directory containing the
                # derivation file (not doing so is asking for trouble), so we
                # have to juggle a bit with working directories here.
                # Also, for reasons not entirely clear to me, in nix-shell the
                # $SHELL value is different from /run/current-system/sw/bin/bash
                # or /bin/sh (pkgs.bash instead of pkgs.bashInteractive?). This
                # causes issues in Emacs terminal sessions, so we explicitely
                # set it to the current value.
                # TODO: If we are already in nix-shell, $SHELL has the incorrect
                # value.
                pushd "${root}" > /dev/null
                nix-shell --run "cd ${OLDPWD} && SHELL=${SHELL} ${EDITOR} $(printf " %q" -s "${socket}" "$@")"
                popd > /dev/null
            fi
        else
            emacs "$@"
        fi
    }
else
    alias e="${EDITOR}"
fi

# Kill Emacs daemon, taking nix-shell context into account.
alias killemacs='e --eval "(kill-emacs)"'

# Quick IPython terminal.
alias py="ipython"

# Enable alias expansion with sudo.
# http://stackoverflow.com/a/9947170
alias sudo='sudo '

# Auto aliases for SSH hosts (disable with '#bash:no-alias').
if [ -f ~/.ssh/config ]; then
    for host in $(grep -v 'bash:no-alias' ~/.ssh/config | grep -oP '^Host \K[\w-.]+$'); do
        alias "${host}=ssh -t ${host} \"screen -Rd default && clear\""
    done
fi

# Quick querying of available Nix packages.
alias nq='nix-env -qaP --description | ag'

# Go.
if [ -d $HOME/projects/go ]; then
    export GOPATH=$HOME/projects/go
    export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
fi

# Python virtualenvwrapper with virtualenv-burrito.
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

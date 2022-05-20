# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Check if a command, function or builtin is available.
available () {
  command -v > /dev/null 2>&1 "$1" && return 0 || return 1
}

# Add ~/bin to $PATH.
if [ -d "$HOME/bin" ]; then
    export PATH="$HOME/bin:$PATH"
fi

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
PS1='me@\h:\w$(__git_ps1)$(__nix_shell_ps1)\$ '

# Setup ls.
alias ls="ls -G"
alias l="ls -lh"
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

# I want colored and unified diffs in 99% of the cases.
alias d="colordiff -ruN"

# Emacs is our editor.
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -nw -c -s /tmp/.emacs-server-socket.$(id -u).tmp"
alias emacs="\${EDITOR}"
alias e=emacs
alias magit="e -e '(magit-status)'"
alias killemacs='e --eval "(kill-emacs)"'

# Quick IPython terminal.
alias py="ipython"

# Enable alias expansion with sudo.
# http://stackoverflow.com/a/9947170
alias sudo='sudo '

# Auto aliases for SSH hosts (disable with '#bash:no-alias').
if [ -f ~/.ssh/config ]; then
    for host in $(grep -v 'bash:no-alias' ~/.ssh/config | sed -n 's/^Host \([0-9a-zA-Z._-]*\)$/\1/p'); do
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

export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOROOT/bin

# Python virtualenvwrapper with virtualenv-burrito.
export WORKON_HOME=~/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

# Pastebin (sorry, can't remember the name sprunge).
pastebin () {
    # Read with cat because curl won't expand ~.
    cat "${1:--}" | curl -F 'sprunge=<-' http://sprunge.us
}

# Shell environment switcher.
available direnv && eval "$(direnv hook bash)"

# https://github.com/wilmoore/php-version
# Running brew is very slow, so we're hardcoding the path.
#source $(brew --prefix php-version)/php-version.sh && php-version 7
[ -f /usr/local/opt/php-version/php-version.sh ] && source /usr/local/opt/php-version/php-version.sh && php-version 7

# https://blog.chendry.org/2015/03/13/starting-gpg-agent-in-osx.html
# https://www.linuxquestions.org/questions/slackware-14/gpg-agent-write-env-file-obsolete-4175608513/
# [ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
# if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
#   export GPG_AGENT_INFO
# else
#   eval $(gpg-agent --daemon --write-env-file ~/.gpg-agent-info)
# fi
GPG_TTY=$(/usr/bin/tty)

export WT_PLATFORM_USER=vermaat
export WT_SSH_IDENTITY_FILE=/Users/martijnvermaat/.ssh/id_rsa_wetransfer_platform

# Source site-specific configuration if it exists.
if [ -f ~/.bashrc.site ]; then
    . ~/.bashrc.site
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi

# MySQL 5.7 is an alternative version in Homebrew, so it doesn't automatically install in $PATH
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# For compilers to find mysql@5.7 you may need to set
export LDFLAGS="-L/usr/local/opt/mysql@5.7/lib"
export CPPFLAGS="-I/usr/local/opt/mysql@5.7/include"

# For pkg-config to find mysql@5.7 you may need to set
export PKG_CONFIG_PATH="/usr/local/opt/mysql@5.7/lib/pkgconfig"

# Configure NVM from Homebrew
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

alias ks='kubectl --namespace product --context stag'
alias kp='kubectl --namespace product --context prod'
alias kpus='kubectl --namespace product --context prod-useast1'

#hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035},{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x7000000E1}]}'

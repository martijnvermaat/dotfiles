# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1)\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

export TERM=xterm-256color
export ENABLE_COLORS=true
export EDITOR=emacs
export PAGER=less
export HISTSIZE=50000
export HISTFILESIZE=100000
export LESS="-S -R"

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUPSTREAM="auto"

alias ocaml='ledit ocaml'
alias gemacs='/usr/bin/emacs-snapshot-gtk'
alias l='ls -lh --group-directories-first'
alias la='l -a'
alias ack='ack-grep'
alias py='ipython'
alias igv='/home/martijn/projects/IGV/IGV_2.3.32/igv.sh'
alias sd='svn diff --diff-cmd ~/bin/svn-diff-meld'

PATH=/home/martijn/projects/kiek/trunk:"${PATH}"
#PATH=/home/martijn/coq-8.3-beta0-1/bin:"${PATH}"
PATH=/home/martijn/coq-8.3-rc1/bin:"${PATH}"
#PATH=/home/martijn/coq-trunk/bin:"${PATH}"

# No beeps
if [ $DISPLAY ]; then
    xset -b b off
fi

alias vermaat='ssh -t vermaat "screen -Rd default && clear"'
alias nora='ssh -t nora "screen -Rd default && clear"'
alias alienblonde='ssh -t alienblonde "screen -Rd default && clear"'
alias zoe='ssh -t zoe "screen -Rd default && clear"'
alias pi='ssh -t pi.remote "screen -Rd default && clear"'
alias pi_boot='ssh -o "UserKnownHostsFile /dev/null" -i ~/.ssh/id_rsa_pi_dropbear -p 22 root@pi'
alias n900='ssh n900'
alias shark='ssh -t shark.remote "screen -Rd default && clear"'
alias biggy='ssh -t biggy "screen -Rd default && clear"'
alias ngslims='ssh -t ngslims "screen -Rd default && clear"'
alias gitlab='ssh -t gitlab "screen -Rd default && clear"'
alias lumcui='ssh lumcui'
alias hue='ssh hue.remote'
alias europium='ssh europium'
alias casave='ssh casave'
alias web03='ssh -t web03 "screen -Rd default && clear"'
alias zwarterita='ssh -t zwarterita "screen -Rd default && clear"'
alias zwaluwtiran='ssh -t zwaluwtiran "screen -Rd default && clear"'
alias zwaveltiran='ssh -t zwaveltiran "screen -Rd default && clear"'
alias res-muta-tst91='ssh -t res-muta-tst91 "screen -Rd default && clear"'
alias res-muta-app01='ssh -t res-muta-app01 "screen -Rd default && clear"'
alias lgtc='ssh -t lgtc.nl "screen -Rd default && clear"'
alias mutalyzer2='ssh -t mutalyzer2 "screen -Rd default && clear"'
alias svep='ssh -t svep "screen -Rd default && clear"'
alias groningen='ssh -t groningen "screen -Rd default && clear"'
alias dvd='ssh -t dvd "screen -Rd default && clear"'
alias dvdtest='ssh dvdtest'
alias rp3vm='ssh -t rp3vm "screen -Rd default && clear"'
alias rp3martijn='ssh -t rp3martijn "screen -Rd default && clear"'
alias research-ssh='ssh -t research-ssh "screen -Rd default && clear"'

export R_LIBS_USER=~/.R/%p/%v

export WORKON_HOME=~/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

if [ -n "$BASH_VERSION" ]; then
    # startup virtualenv-burrito
    if [ -f "$HOME/.venvburrito/startup.sh" ]; then
        . "$HOME/.venvburrito/startup.sh"
    fi
fi

# Source site-specific configuration if it exists
if [ -f ~/.bashrc.site ]; then
    source ~/.bashrc.site
fi

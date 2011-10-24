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

function ps_svn() {
    local REV=$(svnversion 2>/dev/null)
    [ $? -eq 0 ] || return
    [ "$REV" == 'exported' ] && return
    echo -n "[r$REV]" | sed -e 's/M/\*/'
}

function ps_git() {
    local BRANCH=$(__git_ps1)
    [ "x$BRANCH" != 'x' ] || return
    echo -n "$BRANCH" | sed -e 's/^ (/\[:/' -e 's/)//'
    local STATUS=$(git status 2>/dev/null)
    echo "$STATUS" | grep -q 'have diverged' && echo -n !
    echo "$STATUS" | grep -q 'Your branch is behind' && echo -n -
    echo "$STATUS" | grep -q 'Your branch is ahead of' && echo -n +
    echo "$STATUS" | grep -q 'Changed but not updated\|Changes to be committed' && echo -n \*
    echo -n \]
}

if [ "$color_prompt" = yes ]; then
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@celly\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u@celly:\w$(ps_svn)$(ps_git)\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@celly: \w\a\]$PS1"
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

export ENABLE_COLORS=true
export EDITOR=emacs
export PAGER=less
export HISTSIZE=5000
export LESS="-S -R"

alias ocaml='ledit ocaml'
alias gemacs='/usr/bin/emacs-snapshot-gtk'
alias l='ls -lh --group-directories-first'
alias ack='ack-grep'
alias py='ipython'
alias igv='/home/martijn/projects/IGV/IGV_2.0.3/igv.sh'
alias sd='svn diff --diff-cmd ~/bin/svn-diff-meld'

PATH=/home/martijn/projects/kiek/trunk:"${PATH}"
#PATH=/home/martijn/coq-8.3-beta0-1/bin:"${PATH}"
PATH=/home/martijn/coq-8.3-rc1/bin:"${PATH}"
#PATH=/home/martijn/coq-trunk/bin:"${PATH}"
PATH=/home/martijn/projects/samtools-trunk:/home/martijn/projects/samtools-trunk/bcftools:"${PATH}"
PATH=/home/martijn/projects/gvnl/concordance/vcftools/bin:/home/martijn/projects/gvnl/concordance/vcftools/cpp:"${PATH}"
PATH=/home/martijn/projects/gvnl/concordance/tabix:"${PATH}"
PATH=/home/martijn/projects/bamtools/bamtools/bin:"${PATH}"
PATH=/home/martijn/projects/bedtools/bin:"${PATH}"
PATH=/home/martijn/projects/muscle/muscle3.8.31/src:"${PATH}"

# No beeps
if [ $DISPLAY ]; then
    xset -b b off
fi

alias vu='LANG=en_US.UTF-8 ssh mvt600@kits.few.vu.nl'
alias vermaat='ssh vermaat@vermaat.name'
alias vermaatsvn='ssh vermaatsvn@vermaat.name'
alias alienblonde='ssh -p 222 martijn@alienblonde.net'
alias shark='ssh shark.lumcnet.prod.intern'
alias europium='ssh -p 81 martijn@eu.liacs.nl'
alias casave='ssh martijn@casave'
alias zwarterita='ssh -p 81 martijn@zwarterita'
alias prgmr='ssh -p 404 martijn@martijn.xen.prgmr.com'
alias zwaluwtiran='ssh martijn@zwaluwtiran'
alias zwaveltiran='ssh martijn@zwaveltiran'
alias celdery='ssh -p 22222 martijn@celdery'
alias isilon='ssh gonl@Nas.isilon.lumcnet.prod.intern'

export CLASSPATH=/usr/share/java/varscan.jar:/usr/share/java/activation.jar:/usr/share/java/gnumail.jar:/usr/share/java/xercesImpl.jar:/usr/share/java/axis.jar:/usr/share/java/jaxrpc.jar:/usr/share/java/saaj.jar:/usr/share/java/commons-logging.jar:/usr/share/java/commons-discovery.jar:/usr/share/java/wsdl4j.jar:$CLASSPATH
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/samba/lib/pkgconfig
export PYTHONPATH=$PYTHONPATH:/usr/local/samba/lib/python2.6/site-packages
export PYTHONPATH=$PYTHONPATH:/usr/local/samba/lib/python2.6/site-packages
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/samba/lib/pkgconfig

export PERL5LIB=~/projects/gvnl/concordance/vcftools/perl

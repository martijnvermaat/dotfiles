# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -z "$RELEASE" ]; then  # Skip all this if already set.

    # File-creation mode mask.  No core dumps.
    umask 077
    ulimit -c 0

    : ${USER:=$LOGNAME}; export USER
    export RELEASE=`uname -r`
    export OS=`uname -s`
    export ARCH=`case $OS in SunOS) uname -p;; *) uname -m;; esac`
    case $ARCH in i?86) ARCH=i386;; esac
    export NODENAME=`uname -n`

    case "$NODENAME" in *.*) ;; *) NODENAME="$NODENAME.`domainname`";; esac
    export HOSTNAME=`expr $NODENAME : '\\([^.]*\\)'`

    # System executables.
    PATH=$PATH:/opt/mcrl-2.8.5/bin:/usr/local/bin:/bin:/usr/bin
    case $OS in
        SunOS) PATH=$PATH:/usr/openwin/bin:/opt/local/nmh/bin:/home/mklencke/bin:/usr/ccs/bin:/net/java/jdk1.5.0/bin:/net/public/bin:/net/public1/bin
            ;;
        Linux) PATH=$PATH:/usr/X11R6/bin:/usr/bin/mh
    esac

    # Java home
    case $OS in
        SunOS) export JAVA_HOME=/net/java/jdk1.5.0
            ;;
        Linux) export JAVA_HOME=/usr/local/java
    esac

    case $OS in
        SunOS)
        # ISO Latin-1 locale to enable 8-bit chars in many utilities.
            export LC_CTYPE=iso_8859_1
    esac

    # List of directories to look for manual pages.
    case $OS in
        SunOS) export MANPATH=/usr/local/man:/usr/man:/usr/openwin/man:/opt/local/nmh/man
    esac

    # Tell the shell that all these variables are to be given to any program
    # it executes.
    export USER RELEASE ARCH NODENAME HOSTNAME PATH EDITOR EXINIT MANPATH PAGER
    export TERMINFO LC_CTYPE JAVA_HOME CLASSPATH

fi  # end of skip

# don't put duplicate lines in the history. See bash(1) for more options
#export HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    case $OS in
        Linux) eval "`dircolors -b`"; alias ls='ls --color=auto'
    esac
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color)
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    ;;
esac

# Comment in the above and uncomment this below for a color prompt
#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    ;;
*)
    ;;
esac

# Define your own aliases here ...
#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# include ~/public/bin in PATH
if [ -d ~/public/bin ] ; then
    PATH=~/public/bin:"${PATH}"
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

export CADP=/opt/cadp/current
export PATH=$PATH:$CADP/com:$CADP/bin.sun5
export MANPATH=$MANPATH:$CADP/man
export CADP_CC=gcc
export CADP_LANGUAGE=english
export CADP_PS_VIEWER=gv

export ENABLE_COLORS=true
export EDITOR=emacs
export PAGER=less
export TERMINFO=/usr/local/lib/terminfo
export CLASSPATH=$CLASSPATH:/home/mvt600/public/sablecc/lib/ant-sablecc.jar:/home/mvt600/public/sablecc/lib/sablecc.jar:.
export MATLABPATH=/home/mvt600/neural-networks/netlab

# No beeps
if [ $DISPLAY ]; then
    xset -b b off
fi

alias ocaml='ledit ocaml'
alias gemacs='/usr/bin/emacs'
alias emacs='/usr/bin/emacs -nw'

function say {
    echo "$1" >> /tmp/teun-martijn-chat
}

alias vu='ssh mvt600@kits.few.vu.nl'
alias vermaat='ssh vermaat@vermaat.name'
alias tcs='ssh tcs@kits.few.vu.nl'
alias alienblonde='ssh -p 222 martijn@alienblonde.net'

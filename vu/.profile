# .profile - run by the shell after login.

# Set the character-erase, line-erase, and interrupt character.
stty sane -istrip erase '^?' kill '^U' intr '^C'

# Check terminal type.
case $TERM in
    dialup|unknown|network)
        echo -n "Terminal type? ($TERM) "; read term
        TERM="${term:-$TERM}"
        unset term
esac

# Initialize the shell.
. ~/.bashrc

# Manage .rhosts by adding and removing entries automatically.
dotrhosts

# Set the MAILPATH variable so that the shell will tell you if new mail
# arrives, unless there is an X11 session active.  Tell if any mail.
if [ -z "$DISPLAY" ]; then
    MAILPATH=$MAIL
    #test -s $MAIL && echo "You have mail"
fi

###################################################################################################
# Mine
###################################################################################################
# tab completion does not list hidden files
bind 'set match-hidden-files off'
# tab completion works with one tab
bind 'set show-all-if-ambiguous on'
# tab completion ignores case
bind 'set completion-ignore-case off'
# tab completion recognizes directories in symbolic links
bind 'set mark-symlinked-directories on'
# pasting does not highlight text
bind "set enable-bracketed-paste off"
# send EOF after the 11th Ctrl-D
set -o ignoreeof
# disable '^C' from being echoed when pressing Ctrl-C
stty -ctlecho

###################################################################################################
# Prompt
###################################################################################################
function __git_branch_prompt() {
    local BR=$(git branch --show-current 2> /dev/null)
    if [[ ! -z $BR ]]; then
        # echo " $BR "
        echo " $BR "
    fi
}

# find more icons at:
# - https://fontawesome.com/search
# - https://fontello.com/
# - https://fontello.com/
# - https://www.svgrepo.com/
# print all tput colors
# for c in {0..255}; do tput setaf $c; tput setaf $c | cat -v; echo =$c; done | l
# To add time, replace the first line with:
# PS1="\[$(tput sgr0)$(tput setaf 196)\]\D{%H:%M} "
# PS1+="\[$(tput rev)$(tput setaf 39)\]"
PS1="\[$(tput rev)$(tput setaf 39)\]"
# PS1+="\[$(tput sgr0)$(tput setab 39)$(tput setaf 0)\]  \w/"
# PS1+="\[$(tput sgr0)$(tput setab 39)$(tput setaf 0)\]  \w/ "
# PS1+="\[$(tput sgr0)$(tput setab 39)$(tput setaf 0)\]  \w/ "
PS1+="\[$(tput sgr0)$(tput setab 39)$(tput setaf 0)\]  \w/ "
PS1+="\[$(tput setab 47)$(tput setaf 39)\]"
PS1+="\[$(tput setab 47)$(tput setaf 0)\] \$(__git_branch_prompt)"
PS1+="\[$(tput sgr0)$(tput setaf 47)\]"
PS1+="\[$(tput sgr0)\] "

###################################################################################################
# Environment Variables
###################################################################################################
# prompt
export PS1
# do not complete commands from Windows
export EXECIGNORE="/mnt/c/*"
# less flags
export LESS="--tab=4 -~ -MRiS -j 1 --shift 4 -I"
#export LESSOPEN="|pygmentize %s"
# python shell
export PYTHONSTARTUP=~/.config/python/pystartup
# limit displayed entries in directory hierarchy
export PROMPT_DIRTRIM=3
# do not save duplicate commands to shell history
export HISTCONTROL=ignoredups

###################################################################################################
# Key Bindings
###################################################################################################
# Notes:
# - To print all commands: bind -l
# - To print which keys are bound to a specific command: bind -q <command>
stty werase undef
bind '"\C-w":    backward-kill-word'      # Ctrl-W
bind '"\C-h":    backward-kill-word'      # Ctrl-H/Ctrl-Backspace
bind '"\e[3;5~": kill-word'               # Ctrl-Delete
bind '"\e[1;5D": backward-word'           # Ctrl-Left arrow
bind '"\e[1;5C": forward-word'            # Ctrl-Right arrow
bind '"\e[1;5A": history-search-backward' # Ctrl-Up arrow
bind '"\e[1;5B": history-search-forward'  # Ctrl-Down arrow
bind '"\C-r":    insert-last-argument'    # Ctrl-R
bind '"\C-f":    alias-expand-line'       # Ctrl-F
bind '"\C-x":    shell-expand-line'       # Ctrl-X

###################################################################################################
# Aliases
###################################################################################################
alias       l='less'
alias       g='grep -sEI --color=always'
alias      gi='g -i'
alias      gv='grep -sEv'
alias      gr='g -rn'
alias      cp='cp -dr'
alias      ..='cd ..'
alias      du='du -csh'
alias      df='df -h'
alias      rm='rm -rf'
alias      ls='ls --color=auto --group-directories-first'
alias      ll='ls -hltr'
alias      la='ls -hltrA'
alias      rp='realpath'
alias   winrp='wslpath -aw'
alias     sum='perl -ne '"'"'$s += $_ ; END {print("$s\n")}'"'"''
alias    diff='diff -rq'
alias   mkdir='mkdir -p'
alias    echo='echo -e'
alias       i='item'
alias     hlp='subl -n ~/hlp'
alias     upd='sudo apt update && sudo apt upgrade -y'

###################################################################################################
# Typos
###################################################################################################
alias      sl='ls'
alias      ks='ls'
alias      ,,='..'
alias     got='git'
alias     gut='git'

###################################################################################################
# Functions
###################################################################################################
function ff() {
    local ARGS=$([[ $# == 0 ]] && echo "." || echo "$@")
    eval find "$ARGS" -type f
}

function cd() {
    builtin cd "$@" && ls
}

function =() {
    args=`echo "$@" | tr '[{' '(' | tr ']}' ')'`
    perl -le "print(eval($args))"
}

# function fuzzypath() {
#     local DIRNAME=$(echo "$2" | sed 's|[^/]*$||' | sed "s|~|$HOME|")
#     local FILTER=$(echo "$2" | sed 's|.*/||' | sed 's|[[:alnum:]_-]|*\0*|g')
#     local SUFFIX=$([[ "$1" == "cd" ]] && echo "*/" || echo "*")
#     local IFS=$'\n'
#     shopt -s nocaseglob
#     COMPREPLY=($({ \ls -1 -d $DIRNAME$FILTER$SUFFIX | sed "s|/*$||g"; } 2> /dev/null ))
#     shopt -u nocaseglob
# }

function fuzzypath() {
    local DIRNAME=$(echo "$2" | sed 's|[^/]*$||')
    if [[ $DIRNAME =~ ^~ ]]; then
        echo "\nTILDE~"
        local TILDE_USER=$(echo "$DIRNAME" | sed 's|\(~[^/]*/\).*|\1|')
        echo "TILDE_USER = $TILDE_USER"
        local TILDE_EXPANSION=$(eval \\ls -d $TILDE_USER 2> /dev/null)
        echo "TILDE_EXPANSION = $TILDE_EXPANSION"
        echo "DIRNAME before = $DIRNAME"
        DIRNAME=$(echo "$DIRNAME" | sed 's|~[^/]*/||')
        DIRNAME="${TILDE_EXPANSION}${DIRNAME}"
        echo "DIRNAME after = $DIRNAME"
    fi
    local FILTER=$(echo "$2" | sed 's|.*/||' | sed 's|[[:alnum:]_-]|*\0*|g')
    local SUFFIX=$([[ "$1" == "cd" ]] && echo "*/" || echo "*")
    local IFS=$'\n'
    shopt -s nocaseglob
    COMPREPLY=($({ \ls -1 -d $DIRNAME$FILTER$SUFFIX | sed "s|/*$||g"; } 2> /dev/null ))
    shopt -u nocaseglob
}

# fuzzy tab completion
#complete -o filenames -F fuzzypath ls ll la less l
#complete -o filenames -F fuzzypath cd

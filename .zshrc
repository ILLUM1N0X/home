################################################################################
# Completions
################################################################################
zstyle :compinstall filename '/Users/johnnyshehade/.zshrc'
zstyle ':completion:*:*:git:*' script ~/.config/git/git-completion.bash
fpath=(~/.config/git $fpath)
autoload -Uz compinit && compinit

################################################################################
# Miscellaneous
################################################################################
# disable bracketed paste which highlights text
unset zle_bracketed_paste
# add a slash after `..` when using tab completion
zstyle ':completion:*' special-dirs true

################################################################################
# Options: https://zsh.sourceforge.io/Doc/Release/Options.html
################################################################################
# Parameter expansion and command substitution are performed in prompts
setopt PROMPT_SUBST
# Write the history file in the ":start:elapsed;command" format.
setopt EXTENDED_HISTORY
# Write to the history file immediately, not when the shell exits.
setopt INC_APPEND_HISTORY
# Share history between all sessions.
setopt SHARE_HISTORY
# Expire duplicate entries first when trimming history.
setopt HIST_EXPIRE_DUPS_FIRST
# Don't record an entry that was just recorded again.
setopt HIST_IGNORE_DUPS
# Delete old recorded entry if new entry is a duplicate.
setopt HIST_IGNORE_ALL_DUPS
# Do not display a line previously found.
setopt HIST_FIND_NO_DUPS
# Don't write duplicate entries in the history file.
setopt HIST_SAVE_NO_DUPS
# Do not cycle through completion options when pressing tab.
setopt NO_AUTO_MENU
# Do not remove slash that was auto completed
unsetopt AUTO_REMOVE_SLASH

################################################################################
# Prompt
################################################################################
function __git_branch_prompt() {
    local BR=$(git branch --show-current 2> /dev/null)
    if [[ ! -z $BR ]]; then
        # echo "󰘬 $BR "
        # echo " $BR "
        # echo " $BR "
        echo "$BR "
    fi
}

PROMPT='%F{39}'
PROMPT+='%F{0}%K{39}%(5~|~/.../%3~|%~)/ '
PROMPT+='%K{47}%F{39}'
PROMPT+='%F{0}%K{47} $(__git_branch_prompt)'
PROMPT+='%K{reset}%F{47}%F{reset}%K{reset} '

################################################################################
# Environment Variables
################################################################################
# prompt
export PROMPT
# less flags
export LESS="--tab=4 -~ -MRiS -j 1 --shift 4 +g"
# python startup
export PYTHONSTARTUP=~/.config/python/pystartup
# do not change prompt when activating a python venv
export VIRTUAL_ENV_DISABLE_PROMPT=1
# suppress old pip version warning
export PIP_DISABLE_PIP_VERSION_CHECK=1
# modify word characters
WORDCHARS='*?_-.[]~&;!#$%^(){}<>\"'
WORDCHARS+="'"
export WORDCHARS
# command history
export HISTFILE=~/.histfile
export HISTSIZE=50000
export SAVEHIST=50000
# do not remove space or slash that was added by the completion system
export ZLE_REMOVE_SUFFIX_CHARS=""

################################################################################
# Bindings
################################################################################
if [[ -o interactive ]]; then
    bindkey "^W" backward-kill-word                      # Ctrl-W
    bindkey "^[[1;5C" forward-word                       # Ctrl-Right arrow
    bindkey "^[[1;5D" backward-word                      # Ctrl-Left arrow
    bindkey "^[[1;5A" history-beginning-search-backward  # Ctrl-Up arrow
    bindkey "^[[1;5B" history-beginning-search-forward   # Ctrl-Down arrow
    bindkey "^R" insert-last-word                        # Ctrl-R
    bindkey "^F" _expand_alias                           # Ctrl-F
    bindkey '^I' expand-or-complete-prefix               # Tab/Ctrl-I completes in the middle of a word
fi

################################################################################
# Aliases
################################################################################
alias       l='less'
alias       g='~/bin/grep -sEI --color=always'
alias      gi='g -i'
alias      gv='~/bin/grep -sEv'
alias      gr='g -rn --exclude-dir="build/" --exclude-dir="\.pytest_cache/" --exclude-dir="\.venv/" --exclude-dir="*\.egg-info/" --exclude-dir="\.git/" --exclude="*.ipynb"'
alias      gc='~/bin/grep -sEI'
alias      cp='~/bin/cp -R'
alias      ..='cd ..'
alias      du='du -csh'
alias      df='df -h'
alias      rm='~/bin/rm -I'
alias    sort='~/bin/sort'
alias      ls='~/bin/ls --color=auto --group-directories-first'
alias      ll='~/bin/ls --color=auto -hltr'
alias      la='~/bin/ls --color=auto -hltrA'
alias      rp='realpath'
alias     sum='perl -ne '"'"'$s += $_ ; END {print("$s\n")}'"'"''
alias    diff='diff -r --color'
alias   mkdir='mkdir -p'
alias    echo='echo -e'
alias    item='~/bin/item'
alias       i='item'
alias    subl='~/bin/subl -n'
alias     hlp='code ~/work/hlp.md'
alias     wdp='subl --project ~/work/repos/.waze-data.sublime-project'
alias   wdide='subl --project ~/work/repos/.waze-data-ide.sublime-project'
alias  pipdep='pipdeptree -w silence -p'
alias      ff='fd --type f --type l .'
alias  pytest='PYTHONWARNINGS="ignore" pytest'
alias ppytest='PYTHONWARNINGS="ignore" pytest -n auto'

################################################################################
# Typos
################################################################################
alias      sl='ls'
alias      ks='ls'
alias      ,,='..'
alias     got='git'
alias     gut='git'

################################################################################
# Functions
################################################################################
function cd() {
    builtin cd "$@" && ls
}

function uc() {
    tr '[a-z]' '[A-Z]'
}

function lc() {
    tr '[A-Z]' '[a-z]'
}

################################################################################
# Plugins
################################################################################
# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

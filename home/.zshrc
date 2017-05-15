source ~/.zsh/functions.zsh

zle -N expand_or_complete_with_dots
bindkey "^I" expand_or_complete_with_dots

function colors_enabled () {
    local num_colors=`tput colors`
    local retval=`test -n $num_colors && test $num_colors -ge 8`
    return $retval
}

source $HOME/.aliases

if [[ -d $HOME/gopath ]]; then
    export GOPATH="$HOME/gopath"
    export PATH="$GOPATH/bin:$PATH"
fi

autoload -U compinit promptinit
compinit
promptinit

prompt oliver

zstyle ':completion::complete:*' use-cache 1

if which emacs > /dev/null 2> /dev/null; then
    export EDITOR="`which emacs` -nw"
fi

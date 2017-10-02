source ~/.zsh/functions.zsh

zle -N expand_or_complete_with_dots
bindkey "^I" expand_or_complete_with_dots

function colors_enabled () {
    local num_colors=`tput colors`
    local retval=`test -n $num_colors && test $num_colors -ge 8`
    return $retval
}

source $HOME/.aliases

if [[ -d $HOME/go ]]; then
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
fi

if [[ -d $HOME/bin ]]; then
    export PATH="$HOME/bin:$PATH"
fi

if [[ -d $HOME/.cargo ]]; then
    export PATH="$HOME/.cargo/bin":$PATH
fi

if [[ -d $HOME/.asdf ]]; then
    source $HOME/.asdf/asdf.sh
fi

if which ruby > /dev/null 2> /dev/null; then
    export PATH=`gem env gemdir`/bin:$PATH
fi

if [[ -d $HOME/.cargo ]]; then
    export PATH="$HOME/.cargo/bin":$PATH
fi

autoload -U compinit promptinit
compinit
promptinit

prompt oliver

zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' menu select

if which emacs > /dev/null 2> /dev/null; then
    export EDITOR="`which emacs` -nw"
fi


#!/usr/bin/env zsh

### This script installs all the dotfiles, folders and scripts into the
### appropriate locations.
###
### This script works by copying the files out of intention. It is meant to be
### run on platforms that don't support symlinking. Perhaps there will be added
### an option later on, that recognises those platforms. 

autoload -U colors; colors

if [[ $1 == "help" ]]; then
    cat $0 | grep -E "^### ?" | sed -r 's|### ?||'
    exit 0
elif [[ $# -ne 0 ]]; then
    cat $0 | grep -E "^### ?" | sed -r 's|### ?||'
    exit 1
fi

local h1="${fg_bold[blue]}"
local h2="${fg_bold[cyan]}"

local default="${reset_color}"

local ok="\t[${fg[green]} OK ${default}]"
local fail="\t[${fg[red]}FAIL${default}]"

local cp="\t[${fg[green]} CP ${default}]"
local skip="\t[${fg[yellow]}SKIP${default}]"

function decorate () {
    local opts=()
    if [[ $1 == "-n" ]]; then
        opts=($opts -n); shift
    fi
    local prefix=$1; shift
    local suffix=$1; shift
    echo $opts "$prefix$@$suffix" 
}

function h1 () {
    decorate $h1 $default "*** $@ ***"
}

function h2 () {
    if [[ $1 == "-n" ]]; then
        shift
        decorate -n $h2 $default " *  $@"
    else
        decorate $h2 $default " *  $@"
    fi
}

function check () {
    h2 -n Check if "'$1'" is available
    if which $1 > /dev/null 2> /dev/null; then
        echo $ok
    else
        echo $fail
        exit 1
    fi
}

function compare_and_copy_files () {
    local src=$1
    local dest=$2

    local sum_src=`sha1sum $src | cut -d ' ' -f 1`
    local sum_dest=`sha1sum $dest | cut -d ' ' -f 1`

    if [[ $sum_src != $sum_dest ]]; then
        echo $cp
        cp $src $dest
    else
        echo $skip
    fi
}

function cp_files () {
    for src in $@; do
        local abs_src=`readlink -f $src`
        local dest=$HOME/${src#home/}
        h2 -n Copying "'$abs_src'" to "'$dest'"
        compare_and_copy_files $abs_src $dest
    done
}

LANG=C

h1 Prechecks
check sha1sum

h1 Finding files
local files=(`find home -type f`)

h1 "Copying files"
cp_files $files

h1 Compiling files
pushd ~
make -C .zsh
popd

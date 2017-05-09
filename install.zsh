#!/usr/bin/env zsh

### This script installs all the dotfiles, folders and scripts into the
### appropriate locations.
###
### This script works by copying the files out of intention. It is meant to be
### run on platforms that don't support symlinking. Perhaps there will be added
### an option later on, that recognises those platforms. 

if [[ $1 == "-d" ]]; then
    set -x; shift
fi

fpath=(install_helpers $fpath)

local funs=(
    check
    compare_and_copy_files
    cp_files
    decorate
    h1
    h2
)

for f in $funs; do
    autoload -U $f
done

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

LANG=C

h1 Prechecks
check sha1sum

h1 Finding files
local files=(`find home -type f -not -name '*~'`)

h1 "Copying files"
cp_files $files

h1 Compiling files
pushd ~
make -C .zsh
popd

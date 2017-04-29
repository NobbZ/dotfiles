#!/usr/bin/env zsh

autoload -U colors; colors

local h1="${fg_bold[blue]}"
local h2="${fg_bold[cyan]}"

local default="${reset_color}"

local ok=" [${fg[green]} OK ${default}]"
local fail=" [${fg[red]}FAIL${default}]"

function check () {
    echo -n "$h2 *  Check if '$1' is available\t${default}"
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
        cp $src $dest
    fi
}

LANG=C

echo "$h1*** Prechecks ***$default"
check sha1sum

echo "$h1*** Finding files ***$default"
local files=(`find home -type f`)

echo "$h1*** Copying files ***$default"
for src in $files; do
    local abs_src=`readlink -f $src`
    local dest=$HOME/${src#home/}
    echo "$h2 *  Copying $abs_src"
    echo "$h2    -> $dest"
    compare_and_copy_files $abs_src $dest
done

echo "$h1*** Compiling files ***$default"
pushd ~
make -C .zsh
popd

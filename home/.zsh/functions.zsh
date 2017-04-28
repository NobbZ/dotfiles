funpath=~/.zsh/funs

fpath=($funpath $fpath)

for f in `find $funpath -mindepth 1 -maxdepth 1 -type f`; do
    funname=`basename $f`
    whence $funname > /dev/null 2> /dev/null && unfunction $funname
    autoload $funname
done
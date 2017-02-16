#!/bin/bash
#

NAME="figure-debug.sh"
OPTIND=1

expunge=0
colors=0
figname=""

show_help()
{
    cat <<EOF
Usage: ${NAME} [-hce] file

-h    Print this text and exit
-c    Look for "colors.tex"
-e    Expunge auxiliary files after running (useful once finished with the figure)
file  File containing the code for the figure

EOF
}

while getopts "h?ec" opt; do
    case "$opt" in
	h|\?)
	    show_help
	    exit 0
	    ;;
	e)
	    expunge=1
	    ;;
	c)
	    colors=1
	    ;;
    esac
done

if [ $? != 0 ]; then
    echo "Usage: ${NAME} [-ce] file"
    exit 2
fi

figname="${!OPTIND}"

texroot="$figname-debug"
if [ $colors == 1 ]; then
    sed "s/@FILE/$figname/" figure-debug.tex | \
        sed "s/@COLORS/\\\\include{colors}/" > "$texroot.tex"
else
    sed "s/@FILE/$figname/" figure-debug.tex | \
        sed "s/@COLORS//" > "$texroot.tex"
fi

pdflatex "$texroot.tex"
mv "$texroot.pdf" "$figname.pdf"

if [ $expunge == 1 ]; then
    rm -v "$texroot"*
fi

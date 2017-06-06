#!/bin/bash
#

NAME="$0"
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
-e    Expunge auxiliary files (useful when done)
file  File containing the code for the figure

EOF
}

cat_template()
{
    cat <<EOF
\documentclass[a5paper]{article}
\usepackage{geometry}
\geometry{landscape}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{graphicx}
\usepackage{lmodern}
\usepackage{microtype}
\usepackage{amsmath}
\usepackage{amssymb,latexsym}
\usepackage{tikz}
\begin{document}
\thispagestyle{empty}
\begin{figure}[h]
  \centering

%% COLORS HERE
@COLORS
%% FILE NAME HERE
\include{@FILE}

\end{figure}
\end{document}

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

figname="${!OPTIND}"

if [ "$figname" = "" ]; then
    echo "Usage: ${NAME} [-ce] file"
    exit 2
fi

texroot="$figname-debug"
if [ $colors == 1 ]; then
    cat_template | sed "s/@FILE/$figname/" | \
        sed "s/@COLORS/\\\\include{colors}/" > "$texroot.tex"
else
    cat_template | sed "s/@FILE/$figname/" | \
        sed "s/@COLORS//" > "$texroot.tex"
fi

pdflatex "$texroot.tex"
mv "$texroot.pdf" "$figname.pdf"

if [ $expunge == 1 ]; then
    rm -v "$texroot"*
fi

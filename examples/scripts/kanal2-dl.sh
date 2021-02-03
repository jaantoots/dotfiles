#!/bin/bash

usage() { echo "usage: $0 [-vdqki] VIDEO [TARGET]" 1>&2; exit 2; }

verbose=false
debug=false
quiet=false
keep=false
id=false

while getopts ":vdqki" o; do
    case "${o}" in
        v)
            verbose=true
            ;;
        d)
            debug=true
            ;;
        q)
            quiet=true
            ;;
        k)
            keep=true
            ;;
        i)
            id=true
            ;;
        *)
            usage
    esac
done
shift $((OPTIND-1))

VIDEO="$1"
TARGET="$2"

if [ -z "$VIDEO" ]; then
    usage
fi

if [ $id = false ]; then
    echo "Downloading all videos on page \"$VIDEO\"..."
    lynx -dump -listonly 'https://kanal2.postimees.ee/pluss/saade/'"$VIDEO" |
        grep 'https://kanal2.postimees.ee/pluss/video' | awk '{ print $2; }' |
        sed 's|https://kanal2.postimees.ee/pluss/video/?id=||' | sort -nu |
        xargs -t -l "$0" -i
    exit
fi

set -eu

UA='User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:62.0) Gecko/20100101 Firefox/62.0'
REF='Referer: https://kanal2.postimees.ee/pluss/video/?id='"$VIDEO"
OPTS="-qsS"
if [ $debug = true ]; then
    OPTS="-q"
fi
ECHO=true
if [ $verbose = true ]; then
    ECHO="echo"
fi
OHCE="echo"
if [ $quiet = true ]; then
    OHCE=true
fi

responses=()
$OHCE "Getting list..."

# Get the data path/file and token from player page
url='https://kanal2.postimees.ee/player/playlist/'"$VIDEO"'?type=episodes'
$ECHO "> $url"
response="$(curl "$OPTS" "$url" -H "$UA" \
    -H 'Accept: application/json, text/javascript, */*; q=0.01' \
    --compressed -H "$REF" -H 'X-Requested-With: XMLHttpRequest')"
responses+=("$response")

if [ -z "$TARGET" ]; then
    TARGET="$(jq -r '"\(.info.title).\(.info.episode).\(.info.airdate)"' <<<"$response" |
        tr ' ' '.')"
fi
if [ -f "$TARGET".mp4 ]; then
    $OHCE "\"$TARGET.mp4\" already downloaded"
    exit
fi
token="$(jq -r '.data.token' <<<"$response")"
data_path="$(jq -r '.data.path' <<<"$response")"
file="$(jq -r '.data.streams | .[0].file' <<<"$response")"
$ECHO "$token"'\n'"$data_path"'\n'"$file"

# Use the data path containing token to get a session identifier
url='https://sts.postimees.ee/session/register'
$ECHO "> $url"
response="$(curl "$OPTS" "$url" -H "$UA" \
    -H 'Accept: application/json, text/javascript, */*; q=0.01' \
    --compressed -H "$REF" -H 'X-Original-URI: '"$data_path" \
    -H 'Content-Type: application/json' -H 'Origin: https://kanal2.postimees.ee')"
responses+=("$response")

session="$(jq -r .session <<<"$response")"
$ECHO "$session"

# Use the file combined with session identifier to get the playlist content
url="$file"'&s='"$session"
$ECHO "> $url"
response="$(curl "$OPTS" -I "$url" -H "$UA" -H 'Accept: */*' \
    --compressed -H "$REF" -H 'Origin: https://kanal2.postimees.ee')"
responses+=("$response")
url="$(grep "Location:" <<<"$response" | cut -d ' ' -f 2 | tr -d '\r')"
base="$(dirname "$url")"
$ECHO "> $url"
response="$(curl "$OPTS" "$url" -H "$UA" -H 'Accept: */*' \
    --compressed -H 'Origin: null' -H "$REF")"
responses+=("$response")

$ECHO "$response"
chunklist="$(grep -A1 "RESOLUTION=1024x576" <<<"$response" | tail -n 1)"

# Get the chunklist for the selected resolution
url="$base"/"$chunklist"
$ECHO "> $url"
response="$(curl "$OPTS" "$url" -H "$UA" -H 'Accept: */*' \
    --compressed -H "$REF" -H 'Origin: https://kanal2.postimees.ee')"
responses+=("$response")

# Download all the chunks in the list
chunklist="$(grep -v -E '^#' <<<"$response")"
nchunks="$(wc -l <<<"$chunklist")"
$OHCE "Downloading $nchunks chunks..."
mkdir "$TARGET"
i=0
while read -r chunk; do
    name="$(cut -d '?' -f 1 <<<"$chunk")"
    curl "$OPTS" "$base"/"$chunk" -H "$UA" -H 'Accept: */*' \
        --compressed -H "$REF" -H 'Origin: https://kanal2.postimees.ee' \
        -o "$TARGET"/"$name"
    echo file \'"$name"\' >> "$TARGET"/list
    ((i++)) || :
    $OHCE -ne "\r$i/$nchunks"
done <<<"$chunklist"
$OHCE

$OHCE "Converting video..."
(
if [ $quiet = true ]; then
    exec &>/dev/null
fi
ffmpeg -f concat -i "$TARGET"/list -c copy -bsf:a aac_adtstoasc "$TARGET".mp4
)

if [ $keep = false ]; then
    $OHCE "Removing chunks (use -k to keep)..."
    rm -r "$TARGET"
fi

#!/bin/bash

SDIR=`pwd`

if [ "$1" = "" ]
  then
    INPUT=$SDIR
else
    case $1 in
        -h | --help )
            echo "Usage: cuesplit [Path]"
            echo "       The default path is the current directory."
            exit
            ;;
        * )
        INPUT=$1
    esac
    OUTPUT=$2
fi

[ -z ${OUTPUT} ] && OUTPUT=${INPUT}

absOut=$(readlink -f "${OUTPUT}")

function _cuesplit {
    if [ -f "$1.ape" ]
    then
        mkdir -p "$2"
        shnsplit -d "$2" -f "$1.cue" -o "flac flac -V --best -o %f -" "$1.ape" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "$1.cue" "$2/*.flac"

    elif [ -f "$1.flac" ]
    then
        mkdir -p "$2"
        shnsplit -d "$2" -f "$1.cue" -o "flac flac -V --best -o %f -" "$1.flac" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "$1.cue" "$2/*.flac"

    elif [ -f "$1.mp3" ]
    then
        mp3splt -no "@n @p - @t" -c "$1.cue" -d "$2" "$1.mp3"
        cuetag.sh "$1.cue" "$2/*.mp3"

    elif [ -f "$1.ogg" ]
    then
        mp3splt -no "@n @p - @t" -c "$1.cue" -d "$2" "$1.ogg"
        cuetag.sh "$1.cue" "$2/*.ogg"

    elif [ -f "$1.tta" ]
    then
        mkdir -p "$2"
        shnsplit -d "$2" -f "$1.cue" -o "flac flac -V --best -o %f -" "$1.tta" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "$1.cue" "$2/*.flac"

    elif [ -f "$1.wv" ]
    then
        mkdir -p "$2"
        shnsplit -d "$2" -f "$1.cue" -o "flac flac -V --best -o %f -" "$1.wv" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "$1.cue" "$2/*.flac"

    elif [ -f "$1.wav" ]
    then
        mkdir -p "$2"
        shnsplit -d "$2" -f "$1.cue" -o "flac flac -V --best -o %f -" "$1.wav" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "$1.cue" "$2/*.flac"

    else
        echo "Error: Found no files to split!"
        echo "       --> APE, FLAC, MP3, OGG, TTA, WV, WAV"
    fi
}

pushd "${INPUT}"
while IFS= read -r -d '' -u 9
do
   subdir=$(echo $(dirname "$REPLY") | cut -d/ -f2-)
   prefix=$(echo "${REPLY%.*}")
   echo "$prefix.[ape|flac|mp3|ogg|tta|wv|wav]"
   echo --\> $OUTPUT/$subdir
   _cuesplit "$prefix" "$absOut/$subdir"
done 9< <( find "." -type f -name "*.cue" -exec printf '%s\0' {} + )
popd

exit
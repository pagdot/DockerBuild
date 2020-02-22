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

pushd "${INPUT}"
while IFS= read -r -d '' -u 9
do
   subdir=$(echo $(dirname "$REPLY") | cut -d/ -f2-)
   prefix=$(echo "${REPLY%.*}")
   echo "$prefix.[ape|flac|mp3|ogg|tta|wv|wav]"
   echo --\> $OUTPUT/$subdir
   split "$prefix" "$absOut/$subdir"
done 9< <( find "." -type f -name "*.cue" -exec printf '%s\0' {} + )
popd

function split {
    if [ -f "${prefix}.ape" ]
    then
        mkdir split
        shnsplit -d "$2" -f "${prefix}.cue" -o "flac flac -V --best -o %f -" "${prefix}.ape" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "${prefix}.cue" "$2/*.flac"

    elif [ -f "${prefix}.flac" ]
    then
        mkdir split
        shnsplit -d "$2" -f "${prefix}.cue" -o "flac flac -V --best -o %f -" "${prefix}.flac" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "${prefix}.cue" "$2/*.flac"

    elif [ -f "${prefix}.mp3" ]
    then
        mp3splt -no "@n @p - @t ($2)" -c "${prefix}.cue" -d "$2" "${prefix}.mp3"
        cuetag.sh "${prefix}.cue" "$2/*.mp3"

    elif [ -f "${prefix}.ogg" ]
    then
        mp3splt -no "@n @p - @t (split)" -c "${prefix}.cue" -d "$2" "${prefix}.ogg"
        cuetag.sh "${prefix}.cue" "$2/*.ogg"

    elif [ -f "${prefix}.tta" ]
    then
        mkdir split
        shnsplit -d "$2" -f "${prefix}.cue" -o "flac flac -V --best -o %f -" "${prefix}.tta" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "${prefix}.cue" "$2/*.flac"

    elif [ -f "${prefix}.wv" ]
    then
        mkdir split
        shnsplit -d "$2" -f "${prefix}.cue" -o "flac flac -V --best -o %f -" "${prefix}.wv" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "${prefix}.cue" "$2/*.flac"

    elif [ -f "${prefix}.wav" ]
    then
        mkdir split
        shnsplit -d "$2" -f "${prefix}.cue" -o "flac flac -V --best -o %f -" "${prefix}.wav" -t "%n %p - %t"
        rm -f "$2/00*pregap*"
        cuetag.sh "${prefix}.cue" "$2/*.flac"

    else
        echo "Error: Found no files to split!"
        echo "       --> APE, FLAC, MP3, OGG, TTA, WV, WAV"
    fi
}

exit
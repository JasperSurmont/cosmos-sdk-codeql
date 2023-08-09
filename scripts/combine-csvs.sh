#! /bin/bash

DIR=$1

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


export RESULT_DIR="$SCRIPT_DIR/../results"

if [ -z "$DIR" ]; then
    echo "Please provide a directory"
    exit 1
fi

copy-dir() {
    if [ -z "$1" ]; then
        echo "No name provided"
        exit 1
    fi
    name=$(basename $1)
    mkdir -p "$RESULT_DIR/$name"
    cp $1/ql/results/old.csv $RESULT_DIR/$name/old.csv
    cp $1/ql/results/new.csv $RESULT_DIR/$name/new.csv
}

export -f copy-dir

find $DIR -maxdepth 1 -type d -not -path "$DIR" | xargs -I {} bash -c 'copy-dir "{}"'
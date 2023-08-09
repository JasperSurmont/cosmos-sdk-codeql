#! /bin/bash

export SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e

DIR=$1

if [ -z "$1" ]
then 
    echo "Please specify directory"
    exit 1
fi

rm -f counts2.txt
touch $SCRIPT_DIR/counts.txt

count-abci-func() {
    name=$(basename $1)
    cd $1/ql
    cp "$SCRIPT_DIR/countfunc.ql" queries_new/countfunc.ql

    codeql database analyze db queries_new/countfunc.ql --format=sarif-latest --output=tmp.sarif --rerun
    count=$(sarif summary tmp.sarif | grep warning | grep -Po "\\d+")
    rm tmp.sarif
    echo "$name: $count" >> $SCRIPT_DIR/counts2.txt
}

export -f count-abci-func

find $DIR -maxdepth 1 -type d -not -path "$DIR" | xargs -I {} bash -c 'count-abci-func "{}"'
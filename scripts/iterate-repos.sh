#! /bin/bash

DIR=$1
ACTION=$2

if [ -z "$1" ]
then 
    echo "Please specify directory"
    exit 1
fi

if [ -z "$2" ]
then
    echo "Please specify action: clone-and-check, queries-new or queries-old"
    exit 1
fi

clone_and_check() {
    repo=$(sed "$1!d" repos.txt)
    ./clone-and-check.sh $repo $DIR
}

queries_new() {
    repo=$(sed "$1!d" repos.txt)
    ./queries-new.sh $repo $DIR
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

for i in $(seq 1 `wc -l $SCRIPT_DIR/repos.txt | awk '{print $1;}'`);
do
    if [ "$2" = "clone-and-check" ]; then
        clone_and_check $i
    elif [ "$2" = "queries-new" ]; then
        queries_new $i
    elif ["$2" = "queries-old" ]; then
        echo "Queries old not implemented"
        exit 1
    else
        echo "Not a valid action"
        exit 1
    fi
done

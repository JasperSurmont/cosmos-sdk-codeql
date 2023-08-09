#! /bin/bash

# Usage: ./clone-and-check.sh [URL] [DIR]
# URL: Git repository
# DIR: Directory to clone the repo in
# This script will clone the repo, create a new database and run the ql queries (old and new)
# as well as outputting the results

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
URL=$1
DIR=$2

cd $DIR

if [ ! -d "$(basename $URL)" ]; then
    git clone $URL
    cd $(basename $URL)
    mkdir ql && cd ql && mkdir results

    cp -r $SCRIPT_DIR/../queries_new .
    cp -r $SCRIPT_DIR/../queries_old .

    cd ..
    codeql database create ql/db --language=go -j=4
    cd ql

else
    # if already cloned: reset all ql data except database
    cd $(basename $URL)/ql
    rm -rf results/* db/results/*
    rm -rf queries_new queries_old

    cp -r $SCRIPT_DIR/../queries_new .
    cp -r $SCRIPT_DIR/../queries_old .
fi

codeql database analyze db queries_new/ --format=sarif-latest --output=results/new.sarif -j=4
codeql database analyze db queries_new/ --format=csv --output=results/new.csv -j=4

codeql database analyze db queries_old/ --format=sarif-latest --output=results/old.sarif -j=4
codeql database analyze db queries_old/ --format=csv --output=results/old.csv -j=4


#! /bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
URL=$1
DIR=$2

REPO=$(basename $URL)

cd $DIR/$REPO/ql
rm -rf queries_new 
rm results/new.*
cp -r $SCRIPT_DIR/../queries_new .

codeql query compile -j4 queries_new
codeql database analyze db queries_new/ --format=sarif-latest --output=results/new.sarif -j=4 --rerun
codeql database analyze db queries_new/ --format=csv --output=results/new.csv -j=4
#!/bin/bash
#
# revisionize.sh - update revisions and copyright years
#
# Usage: revisionize.sh html_files...
#

for f in $*
do
    echo "processing $f"
    sed -f ./bin/revisionize.sed $f > $f.1
    mv $f.1 $f
done

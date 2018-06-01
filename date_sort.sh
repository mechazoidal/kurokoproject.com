#!/usr/bin/env bash

# This is one of the ugliest one-liners I've ever written, soley in the attempt to not need dependencies
# Read each file looking for the 3rd line(has the "date written" field), then format it and sort list
find src/writing -name "*.md" -print0 | xargs -0 bash -c 'for filename; do printf "%s %s\n" $(sed "3q;d" $filename | sed "s/% Document //" | tr -d "\n") $filename; done' bash | sort --numeric-sort 
#| cut -d" " -f 2

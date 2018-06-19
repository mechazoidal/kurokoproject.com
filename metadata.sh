#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

filename=${1?required}

title=$(sed "1q;d" "$filename" | sed "s/% Document //" | tr -d "\n")
subtitle=$(sed "2q;d" "$filename" | sed "s/% Document //" | tr -d "\n")
date=$(sed "3q;d" "$filename" | sed "s/% Document //" | tr -d "\n")
url=$(echo "$filename" | sed "s|src/||" | sed "s|.md$|.html|")

# ASCII 30(037 in octal), "Unit Separator"
sep="\037"
#printf "%s\n" $title
#printf "%s %s %s %s %s\n" $filename $title $subtitle $date $url
#printf "%s$sep%s$sep%s$sep%s$sep%s\n" $filename $title $subtitle $date $url
printf "%s$sep%s$sep%s$sep%s\n" $title $subtitle $date $url

#/usr/bin/env bash
filename="$1"
# TODO probably should guard against (rare) case of not having a % Document header
title="$2"
if [[ -z "$title" ]]
then
  title=$(sed "1q;d" "$filename" | sed "s/% Document //" | tr -d "\n")
fi
discount "$filename" | page_wrapper.sh "$title"

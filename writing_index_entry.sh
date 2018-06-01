#!/usr/bin/env bash

filename=${1?required}

title=$(sed "1q;d" $filename | sed "s/% Document //" | tr -d "\n")
subtitle=$(sed "2q;d" $filename | sed "s/% Document //" | tr -d "\n")
date=$(sed "3q;d" $filename | sed "s/% Document //" | tr -d "\n")

cat <<EOF
=[${title}](${filename#src/})=
     ${subtitle}
EOF

exit

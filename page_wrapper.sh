#/usr/bin/env bash
title=${1-"TITLE"}
cat ./src/header.html - ./src/footer.html | sed "s/%%TITLE%%/$title/"

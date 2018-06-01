#/usr/bin/env bash
title=${1-"TITLE"}
# FIXME how to substitute title
cat ./src/header.html - ./src/footer.html

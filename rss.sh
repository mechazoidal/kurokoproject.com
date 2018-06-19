#!/usr/bin/env bash
set -eu
set -o pipefail
IFS=$'\n\t'

SRC_DIR=${1?required}
HOSTNAME=${2:-localhost}
TITLE="Kuroko Project"
SUBTITLE="A place"
build_date=$(date +"%a, %d %b %Y %H:%M:%S %z")


writing=$(find "$SRC_DIR" -name "*.md" -print0 | xargs -0 -I % ./metadata.sh % )

entries=
for entry in $writing
do
  title=$(echo "$entry" | awk 'BEGIN {FS="\037"} {print $1}')
  subtitle=$(echo "$entry" | awk 'BEGIN {FS="\037"} {print $2}')
  date_raw=$(echo "$entry" | awk 'BEGIN {FS="\037"} {print $3}' | tr -d :Z-)
  date=$(date -j +"%a, %d %b %Y %H:%M:%S %z" ${date_raw::-2})
  url=$(echo "$entry" | awk 'BEGIN {FS="\037"} {print $4}')
  # FIXME this means uuids will change on every rebuild, which is a no-no, but at this point I don't care
  # (also requires e2fsprogs, but everyone has that now)
  uuid=$(uuidgen)
  entries=$(printf "<item><title>%s</title><description>%s</description><link>%s</link><pubDate>%s</pubDate><guid isPermaLink=\"false\">%s</guid></item>%s" $title $subtitle "$HOSTNAME/$url" $date $uuid $entries)
done

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
 <title>Kuroko Project</title>
 <description>This is an example of an RSS feed</description>
 <link>${HOSTNAME}/feed.xml</link>
 <atom:link href="${HOSTNAME}/feed.xml" rel="self" type="application/rss+xml" />
 <lastBuildDate>${build_date}</lastBuildDate>
 <pubDate>${build_date}</pubDate>
${entries}
</channel>
</rss>
EOF

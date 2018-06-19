#!/usr/bin/env bash
set -u
set -o pipefail
IFS=$'\n\t'

SRC_DIR=${1?required}
HOSTNAME=${2:-localhost}

static=$(find "$SRC_DIR" -name "*.html" -print0 | xargs -0 grep -L datetime)
writing=$(find "$SRC_DIR" -name "*.html" -print0 | xargs -0 awk -v HOSTNAME="$HOSTNAME" '/datetime/ {loc=FILENAME; sub(/output/, HOSTNAME, loc); print loc "@" $0}')

entries=
for entry in $writing
do
  loc=$(echo $entry | cut -d@ -f1)
  lastmod=$(echo $entry | cut -d@ -f2 | sed -E 's/.+"(.+)".+/\1/')
  entries=$(printf "<url><changefreq>never</changefreq><lastmod>%s</lastmod><loc>%s</loc></url>%s" $lastmod $loc $entries)
done

statics=
for entry in $static
do
  loc=${entry/$SRC_DIR/$HOSTNAME}
  #lastmod=$(stat -n -f "%Sm" -t "%Y-%m-%d" "$entry")
  statics=$(printf "<url><changefreq>monthly</changefreq><loc>%s</loc></url>%s" $loc $statics)

done

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" 
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
${statics}
${entries}
</urlset>
EOF

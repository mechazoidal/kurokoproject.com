SRC="src"
OUTPUT="output"

# HOSTNAME="http://www.kurokoproject.com"

# FIXME need to stop sblg from inserting 'output' into relative links

SOURCES=`{find src/writing -name "*.xml"}
ARTICLES=${SOURCES:$SRC%.xml=$OUTPUT%.html}

TEMPLATED_HTML=$OUTPUT/index.html $OUTPUT/writing.html $OUTPUT/feed.xml

TEMPLATE_TARGETS=$SRC/blog.xml $SRC/article.xml
STATIC_SOURCES=style.css robots.txt .htaccess
STATIC_TARGETS=${STATIC_SOURCES:%=$OUTPUT/%}

ALL=$OUTPUT $OUTPUT/writing.html $OUTPUT/writing $TEMPLATED_HTML $ARTICLES $STATIC_TARGETS $TEMPLATE_TARGETS

# Top-level targets

all:V:  $ALL

clean:V:
  rm -rf $OUTPUT/*
  rm -f $SRC/blog.xml
  rm -f $SRC/article.xml

dryrun:QV:
  echo SOURCES: $SOURCES
  echo ARTICLES: $ARTICLES
  echo TEMPLATE_TARGETS: $TEMPLATE_TARGETS
  echo OUTPUT: $OUTPUT

# Specific targets and format rules

$OUTPUT:
  mkdir -p $OUTPUT

$OUTPUT/writing:
  mkdir -p $OUTPUT/writing

#%.html: %.xml.html

# FIXME can these two rules be combined
$OUTPUT%.css: $SRC%.css
  cp $prereq $target

$OUTPUT%.txt: $SRC%.txt
  cp $prereq $target

$OUTPUT/.htaccess: $SRC/_htaccess
  cp $prereq $target

$OUTPUT/writing.html: $ARTICLES
  sblg -t $SRC/blog.xml -o $target $prereq

$OUTPUT/%.html: $SRC/%.xml
  sblg -c -o $target $prereq

$OUTPUT/feed.xml: $ARTICLES
  sblg -a -t $SRC/atom.xml -o $target $prereq

# used so that I can modify header/footer separately
$SRC/article.xml: $SRC/header.html $SRC/art.xml $SRC/footer.html
  cat $prereq > $target

$SRC/blog.xml: $SRC/header.html $SRC/blg.xml $SRC/footer.html
  cat $prereq > $target

$OUTPUT/index.html: $SRC/header.html $SRC/index.xml $SRC/footer.html
  cat $prereq > $target

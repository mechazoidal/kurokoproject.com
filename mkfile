SRCDIR="src"
BUILDDIR="output"

HOSTNAME="http://www.kurokoproject.com"

SOURCES=index.md
TARGETS=${SOURCES:%.md=$BUILDDIR/%.html}

WRITE_SOURCES=`{find src/writing -name "*.md"}
WRITE_TARGETS=${WRITE_SOURCES:$SRCDIR%.md=$BUILDDIR%.html}

DIRS=writing
DIR_TARGETS=${DIRS:%=$BUILDDIR/%}

STATIC_SOURCES=style.css
STATIC_TARGETS=${STATIC_SOURCES:%=$BUILDDIR/%}

META_SOURCES=sitemap.xml feed.xml
META_TARGETS=${META_SOURCES:%=$BUILDDIR/%}

ALL=$STATIC_TARGETS $BUILDDIR/writing.html $WRITE_TARGETS $TARGETS $META_TARGETS

all:V:  $ALL

$BUILDDIR%.html: $SRCDIR%.md
  page_builder.sh $prereq > $target


$BUILDDIR%.css: $SRCDIR%.css
  cp $prereq $target

$BUILDDIR/sitemap.xml: $BUILDDIR/writing
  sitemap.sh $BUILDDIR $HOSTNAME > $BUILDDIR/sitemap.xml

$BUILDDIR/feed.xml: $BUILDDIR/writing
  rss.sh src/writing $HOSTNAME > $BUILDDIR/feed.xml

$BUILDDIR/writing:
  mkdir -p $BUILDDIR/writing

# FIXME must fire writing.html automatically from md->html rule

$BUILDDIR/writing.html: $BUILDDIR/writing
  #date_sort.sh src/writing | cut -d" " -f2 | xargs -I % writing_index_entry.sh % | discount | page_wrapper.sh "Writing" > $BUILDDIR/writing.html
  date_sort.sh src/writing | cut -d" " -f2 | xargs writing_index_entry.sh | discount | page_wrapper.sh "Writing" > $BUILDDIR/writing.html

clean:V:
  rm -r $BUILDDIR/*

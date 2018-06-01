SRCDIR="src"
BUILDDIR="output"

SOURCES=index.md
TARGETS=${SOURCES:%.md=$BUILDDIR/%.html}

WRITE_SOURCES=`{find src/writing -name "*.md"}
WRITE_TARGETS=${WRITE_SOURCES:$SRCDIR%.md=$BUILDDIR%.html}

DIRS=writing
DIR_TARGETS=${DIRS:%=$BUILDDIR/%}

STATIC_SOURCES=style.css
STATIC_TARGETS=${STATIC_SOURCES:%=$BUILDDIR/%}

ALL=$STATIC_TARGETS $BUILDDIR/writing.html $WRITE_TARGETS $TARGETS

all:V:  $ALL

$BUILDDIR%.html: $SRCDIR%.md
  discount $prereq | page_wrapper.sh > $target

$BUILDDIR%.css: $SRCDIR%.css
  cp $prereq $target

$BUILDDIR/writing:
  mkdir -p $BUILDDIR/writing

$BUILDDIR/writing.html: $BUILDDIR/writing
  date_sort.sh | cut -d" " -f2 | xargs -I % writing_index_entry.sh % | discount | page_wrapper.sh > $BUILDDIR/writing.html

clean:V:
  rm -r $BUILDDIR/*

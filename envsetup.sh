#!/bin/sh

# This script copies docs files from various projects to the
# Zola content/ directory and fixes up a few things:
#
# - redo image links
# - map README.md -> _index.md
# - remove "*.md" from markdown links

siot_projects="hardware go"

siot_update_docs() {
  echo "updating docs"
  for project in $siot_projects; do
    src=sources/$project/docs
    dest=content/$project
    rm -rf "$dest"
    mkdir -p "$dest"
    for f in "$src"/*.md; do
      file_name=$(basename "$f")
      echo "file_name: $file_name"
      if [ "$file_name" = "README.md" ]; then
        cp "$f" "$dest/_index.md"
      else
        cp "$f" "$dest/"
      fi
    done
    cp "$src"/*.png "$dest/"
    cp "$src"/*.jpg "$dest/"

    for f in "$dest"/*.md; do
      echo "processing $f"

      # prefix images with parent path
      sed -i "s/(\([A-Za-z0-9_-]*\.png\))/(\/${project}\/\1)/g" "$f"
      sed -i "s/(\([A-Za-z0-9_-]*\.jpg\))/(\/${project}\/\1)/g" "$f"

      # remove md extension from links to markdown files
      sed -i "s/(\([A-Za-z0-9_-]*\)\.md)/(\1)/g" "$f"
    done
  done
}

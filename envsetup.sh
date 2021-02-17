#!/bin/sh

# This script copies docs files from various projects to the
# Zola content/ directory and fixes up a few things:
#
# - redo image links
# - map README.md -> _index.md
# - remove "*.md" from markdown links

siot_projects="hardware"

siot_update_docs() {
  echo "updating docs"
  for project in $siot_projects; do
    src=sources/$project/docs
    dest=content/$project
    rm -rf $dest
    mkdir "$dest"
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

    md_files=$(siot_find_md_files)
    echo "updating links in files $md_files"
    for f in "$dest"/*.md; do
      echo "processing $f"
      siot_update_image_links "$f"

      # prefix images with parent path
      sed -i "s/(\([A-Za-z0-9_-]*\.png\))/(\/${project}\/\1)/g" "$f"
      sed -i "s/(\([A-Za-z0-9_-]*\.jpg\))/(\/${project}\/\1)/g" "$f"

      # remove md extension from links to markdown files
      sed -i "s/(\([A-Za-z0-9_-]*\)\.md)/(\1)/g" "$f"
    done
  done
}

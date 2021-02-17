#!/bin/sh

# need to make a function that replaces the following links
# in markdown files:
# ![gw](gw.jpg)
# with
# ![gw](/img/projects/gw.jpg)
# but not include links like:
# ![conn](https://www.wiredwatts.com/img/products/m/pt3c6km3-1_m.jpg)

siot_projects="hardware"

siot_update_docs() {
  echo "updating docs"
  for project in $siot_projects; do
    src=sources/$project/docs
    dest=content/$project
    rm -rf $dest
    mkdir "$dest"
    cp "$src"/*.md "$dest/"
    cp "$src"/*.png "$dest/"
    cp "$src"/*.jpg "$dest/"

    md_files=$(siot_find_md_files)
    echo "updating links in files $md_files"
    for f in "$dest"/*.md; do
      echo "processing $f"
      siot_update_image_links "$f"
      sed -i "s/(\([A-Za-z0-9_-]*\.png\))/(\/${project}\/\1)/g" "$f"
      sed -i "s/(\([A-Za-z0-9_-]*\.jpg\))/(\/${project}\/\1)/g" "$f"
    done
  done
}

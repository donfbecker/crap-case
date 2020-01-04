#!/bin/sh

mkdir -p stl

grep '^module\s\+[a-z_]\+()\s\+{\s\+//\s\+make\s\+[0-9]\+$' control-box.scad | awk '{print $2 $6}' | sed -e 's/()/ /' | while read -r MODULE COUNT; do
	echo -ne "use <control-box.scad>\n$MODULE();" > temp.scad
	openscad --render -D 'override_scale=25.4' -o stl/${MODULE}_x${COUNT}.stl temp.scad;
	rm temp.scad;
done;

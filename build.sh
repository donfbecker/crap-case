#!/bin/sh

mkdir -p stl;
mkdir -p dxf;

grep '^module\s\+[a-z_]\+()\s\+{\s\+//\s\+make\s\+[0-9]\+$' control-box.scad | awk '{print $2 $6}' | sed -e 's/()/ /' | while read -r MODULE COUNT; do
	echo $MODULE;

	if [ ! -f "stl/${MODULE}_x${COUNT}.stl" ]; then
		echo -ne "use <control-box.scad>\n$MODULE();" > temp.scad
		openscad --render -D 'override_scale=25.4' -o stl/${MODULE}_x${COUNT}.stl temp.scad;
		rm temp.scad;
	fi;

	if [ `echo $MODULE | cut -d'_' -f 1` == "panel" ]; then
		if [ ! -f "dxf/${MODULE}_x${COUNT}.dxf" ]; then
			echo -ne "use <control-box.scad>\nprojection() $MODULE();" > temp.scad
			openscad --render -D 'override_scale=25.4' -o dxf/${MODULE}_x${COUNT}.dxf temp.scad;
			rm temp.scad;
		fi;
	fi;
done;

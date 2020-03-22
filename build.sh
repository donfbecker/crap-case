#!/bin/sh

mkdir -p out/stl;
mkdir -p out/dxf;

grep '^module\s\+[a-z_]\+\(.*\)\s\+{\s\+//\s\+make\s\+[0-9]\+$' crap-case.scad | awk '{print $2 $6}' | sed -e 's/(.*)/ /' | while read -r MODULE COUNT; do
	echo $MODULE;

	if [ ! -f "out/stl/${MODULE}_x${COUNT}.stl" ]; then
		echo -ne "use <crap-case.scad>\n$MODULE();" > temp.scad
		openscad --render -D 'override_scale=25.4' -o out/stl/${MODULE}_x${COUNT}.stl temp.scad;
		rm temp.scad;
	fi;

	if [ `echo $MODULE | cut -d'_' -f 1` == "panel" ]; then
		if [ ! -f "out/dxf/${MODULE}_x${COUNT}.dxf" ]; then
			echo -ne "use <crap-case.scad>\nprojection() $MODULE();" > temp.scad
			openscad --render -D 'override_scale=25.4' -o out/dxf/${MODULE}_x${COUNT}.dxf temp.scad;
			rm temp.scad;
		fi;
	fi;
done;

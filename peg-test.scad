use <crap-case.scad>

beam(0.5, false, false);

inches() {
    translate([0.75, 0, 0]) {
        difference() {
            cube([0.5, 0.5, 0.5]);
            translate([0.25, 0.125, 0.25]) rotate([90, 0, 0]) rotate([0, 0, 22.5]) cylinder(r=0.125, h=0.25, $fn=8);
            translate([0.25, 0.25, 0.375]) rotate([0, 0, 22.5]) cylinder(r=0.125, h=0.25, $fn=8);
        }
    }
}


use <crap-case.scad>

beam(0.5, false, false);

inches() {
    translate([0.75, 0, 0]) {
        difference() {
            cube([0.5, 0.5, 0.5]);
            translate([0.25, 0.125, 0.25]) rotate([90, 0, 0]) peg_hole();
            translate([0.25, 0.25, 0.375]) peg_hole();
        }
    }
}
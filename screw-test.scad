use <crap-case.scad>

inches() {
    difference() {
        // I just want to shorten the catch.
        screw_catch();
        translate([0, 0, 0.125]) cube([0.5, 0.5, 0.5]);
    }
    
    translate([0.625, 0, 0]) {
        difference() {
            cube([0.5, 0.5, 0.125]);
            screw_hole();
        }
	}
}

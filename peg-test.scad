use <crap-case.scad>

inches() {
    translate([0, 0, 0]) {
        difference() {
            union() {
                cube([0.5, 0.5, 0.5]);
                peg(z=1);
            }
 
            peg_hole(y=-1);
        }
    }
    
    translate([0.75, 0, 0]) {
        difference() {
            union() {
                cube([0.5, 0.5, 0.5]);
                peg(y=-1);
            }
            
            peg_hole(z=1);            
        }
    }
}

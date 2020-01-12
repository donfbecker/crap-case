// Hey!  Why didn't you just use FreeCAD or Fusion360?
// Listen... I may from time to time over complicate things.
// I do use FreeCAD, but I don't really care for the constraint
// system, at least not yet.  I may need to learn more about it.
// As for Fusion360, I am not a fan of vendor lock in.  I want
// to make sure I can use all my models in the future, and that
// other people can freely use them as well.

// The comments above each variable below will have a verbose
// comment explaining it's function, and also a single line 
// comment for Customizer to use as a label.

/* [Model] */

// This model was built using inches as the unit, but is scaled
// to millimeters to make it easier for people to print.  If you
// want a nice rounded metric version, just change this value to
// 25, instead of 25.4.  You can set it to a larger number if you
// want a bigger case.  The 30 amp power supply will not fit if
// you make it less than 25.
//
// Number of mm in an inch.
inch_to_mm = 25.4;

// Diameter of screw hole in panels in inches.  This should be
// loose so the screws can easily pass through. I found that
// 0.17 works well with my printer for #6 sheet metal and
// machine screws.  You can use screw_test.scad to test
// this value.
//
// Diameter of screw holes in panels.
screw_hole = 0.17;

// Diameter of screw hole in beams in inches.  This should be
// tight so that the threads are able to grab. I found that
// 0.14 works well with my printer for #6 sheet metal and
// machine screws. You can use screw-test.scad to test
// this value
//
// Diameter of screw holes in catches.
screw_catch = 0.14;

// Diameter of alignment pegs.  The hole will always be 0.25
// inches, but the peg may need to be undersized to account
// for how your printer prints.  Use peg-test.scad to test
// this value.
//
// Diameter of alignment pegs.
alignment_peg = 0.235;

// Set this to the thickness of the material you plan
// to use for panels in inches.  I wouldn't use anything
// over 0.25 inches.  If you are printing them, leave it
// at 0.125.
//
// Thickness of panels
panel_thickness = 0.125;

// If you want single panels on the sides, and
// have a cnc to cut them, or a large 3D printer,
// set this to true.  Otherwise, set it to false;
//
// Use large panels?
large_panels = true;

/* [Preview] */
// -----------------------------------------------------------
// Settings below this line only affect the preview you
// see in OpenSCAD, and not the STL files that are generated
// by build.sh
// -----------------------------------------------------------

// Set this to true for an exploded view
explode = false;

// Build.sh will generate STL files for both big
// and small parts, but you can choose which version
// to display in an exploded view by setting this to
// true for small parts, and false for big parts.
// 
// Display small parts
small_parts = true;

// Hide panels.
hide_panels = false;

// If hide_panels is false, you can set this
// to true to leave one side open.
//
// Leave one open side.
open_side = true;

// -----------------------------------------------------------
// Do not edit below this line
// -----------------------------------------------------------

$fn = $preview ? 6 : 360;

e = explode ? 0.5 : 0;

function inch(size) =  size * inch_to_mm;
function inch_v(x, y, z) = [x * inch_to_mm, y * inch_to_mm, z * inch_to_mm];

module inch_translate(v) {
    for (i = [0:1:$children-1]) {
        translate([v[0] * inch_to_mm, v[1] * inch_to_mm, v[2] * inch_to_mm]) {
            children(i);
        }
    }
}

module inches() {
    scale([inch_to_mm, inch_to_mm, inch_to_mm]) {
        for (i = [0:1:$children-1]) children(i);
    }
}

module rambo_v14() {
    difference() {
        inches() cube([4.10, 4.05, 0.125]);
        rambo_v14_template();
    }
}

module rambo_v14_template() {
    // Rambo 1.4 is 4.1 by 4.05 inches.
    // screw holes are 0.15 inches from each edge.
    inches() {
        translate([0.15, 0.15, 0]) cylinder(r=(1/16), h=0.5, center=true);
        translate([0.15, 3.9, 0]) cylinder(r=(1/16), h=0.5, center=true);
        translate([3.95, 0.15, 0]) cylinder(r=(1/16), h=0.5, center=true);
        translate([3.95, 3.9, 0]) cylinder(r=(1/16), h=0.5, center=true);
    }
}

module smart_controller() {
    difference() {
        cube([93, 87, 3.175]);
        smart_controller_template();
    }
}

module smart_controller_template() {
    translate([8, 27, -1]) cube([78, 51, 8]);

    // Screw holes
    translate([2.5, 84.5, -1]) cylinder(r=1.5, h=7);
    translate([90.5, 84.5, -1]) cylinder(r=1.5, h=7);
    translate([2.5, 19.5, -1]) cylinder(r=1.5, h=7);
    translate([90.5, 19.5, -1]) cylinder(r=1.5, h=7);

    // Knob
    translate([84, 8.25, -1]) cylinder(r=3.25, h=17);

    // Reset
    translate([49.5, 8, -1]) cylinder(r=1.75, h=17);

    // Speaker
    translate([49.5, 8, -1]) cylinder(r=1.75, h=17);

    // Contrast
    translate([8.5, 11, -1]) cylinder(r=3, h=17);
}

module power_supply() {
    difference() {
        cube([115, 215, 50]);
        translate([2, 197, 5]) cube([111, 20, 50]);

        #translate([-2, 32.5, 12.5]) rotate([0, 90, 0]) cylinder(r=2, h=7);
        #translate([-2, 182.5, 12.5]) rotate([0, 90, 0]) cylinder(r=2, h=7);

        #translate([-2, 32.5, 37.5]) rotate([0, 90, 0]) cylinder(r=2, h=7);
        #translate([-2, 182.5, 37.5]) rotate([0, 90, 0]) cylinder(r=2, h=7);

        #translate([117, 32.5, 12.5]) rotate([0, -90, 0]) cylinder(r=2, h=7);
        #translate([117, 182.5, 12.5]) rotate([0, -90, 0]) cylinder(r=2, h=7);

        #translate([117, 32.5, 37.5]) rotate([0, -90, 0]) cylinder(r=2, h=7);
        #translate([117, 182.5, 37.5]) rotate([0, -90, 0]) cylinder(r=2, h=7);
    }
}

module screw_hole() {
    // don't scale this to inches, the modules
    // that call it will do that
    translate([0.25, 0.25, -0.5]) cylinder(r=(screw_hole/2), h=1);
}

module screw_catch() {
    // don't scale this to inches, the modules
    // that call it will do that
    difference() {
        cube([0.5, 0.5, 0.5 - panel_thickness]);
        translate([0.25, 0.25, -0.001]) cylinder(r=(screw_catch/2), h=0.502);
    }
}

module peg(x=0, y=0, z=0, taper=true) {
    major = (alignment_peg / 2);
    minor = taper ? ((alignment_peg * 0.75) / 2) : major;
    #translate([0.25 * (x + 1), 0.25 * (y + 1), 0.25 * (z + 1)]) rotate([90 * y, 90 * x, 0]) rotate([0, 0, 22.5]) {
        translate([0, 0, -(7/32)]) mirror([0, 0, 1]) cylinder(r1=major, r2=minor, h=(1/32), center=false, $fn=8);
        cylinder(r=major, h=(7/16), center=true, $fn=8);
        translate([0, 0, (7/32)]) cylinder(r1=major, r2=minor, h=(1/32), center=false, $fn=8);
    }
}

module peg_hole(x=0, y=0, z=0) {
    peg(x, y, z, false);
}

module beam(length, screws=true, bottom=false) {
    inches() union() {
        cube([0.5, length, 0.5]);

        if(screws) {
            translate([0.5, 0, 0.5]) rotate([0, -90, 0]) screw_catch();
            translate([0.5, length - 0.5, 0.5]) rotate([0, -90, 0]) screw_catch();

            translate([0.5, 0, bottom ? 0 : panel_thickness]) screw_catch();
            translate([0.5, length - 0.5, bottom ? 0 : panel_thickness]) screw_catch();
        }

        peg(y=-1);
        translate([0, length - 0.5, 0]) peg(y=1);
    }
}

module beam_bottom() { // make 4
    beam(5.25, true, true);
}

module beam_top() { // make 2
    beam(5.25, true, false);
}

module beam_front() { // make 1
    beam(5, false, false);
}

module beam_slope_left() { // make 1
    union() {
        beam(4, false, false);
        inches() {
            translate([0.5, 0, 0]) screw_catch();
            translate([0.5, 3.5, 0]) screw_catch();
        }
    }
}

module beam_slope_right() { // make 1
    translate([inch(0.5), 0, 0]) mirror([1, 0, 0]) beam_slope_left();
}

module board_beam() { // make 4
    difference() {
        beam(5.25, false, false);

        for(i = [0 : 9]) {
            inches() translate([0, 0.125 + (0.5 * i), 0.25]) screw_hole();
        }

        for(i = [0 : 8]) {
            inches() translate([0.25, 0.375 + (0.5 * i), 0]) rotate([0, -90, 0]) screw_hole();
        }
    }
}

module power_supply_bracket() { // make 4
    inset = (115 - inch(4)) / 2;
    spacing = (150 - inch(5.125)) / 2;
    difference() {
        union() {
            inches() cube([0.5, 1.5, 0.5]);
            inch_translate([0, 0, -2]) cube([inch(0.5) - inset, inch(1.5), inch(2)]);
        }

        // Holes to mount to beam
        inches() {
            translate([0.125, 0, 0]) rotate([0, -90, 0]) screw_hole();
            translate([0.125, 0.5, 0]) rotate([0, -90, 0]) screw_hole();
            translate([0.125, 1, 0]) rotate([0, -90, 0]) screw_hole();
        }

        // Holes to mount to power supply
        translate([0, inch(0.75) - spacing, -inch(2) + 12.5]) rotate([0, -90, 0]) cylinder(r=2.5, h=inch(1.5), center=true);
        translate([0, inch(0.75) + spacing, -inch(2) + 12.5]) rotate([0, -90, 0]) cylinder(r=2.5, h=inch(1.5), center=true);

        translate([0, inch(0.75) - spacing, -inch(2) + 37.5]) rotate([0, -90, 0]) cylinder(r=2.5, h=inch(1.5), center=true);
        translate([0, inch(0.75) + spacing, -inch(2) + 37.5]) rotate([0, -90, 0]) cylinder(r=2.5, h=inch(1.5), center=true);

    }
}

module frame_back() { // make 1
    inches() {
        difference() {
            union() {
                difference() {
                    cube([6, 0.5, 6]);
                    translate([0.5, -0.1, 0.5]) cube([5, 0.7, 5]);
                }

                translate([0.5, 0, 2.5]) cube([1, 0.5 - panel_thickness, 0.5]);
                translate([4.5, 0, 2.5]) cube([1, 0.5 - panel_thickness, 0.5]);
            }

            translate([0, 0, 0]) peg_hole(y=-1);
            translate([5.5, 0, 0]) peg_hole(y=-1);

            // Make sure these go through
            translate([1, 0, 2.5]) peg_hole(y=-1);
            translate([1, 0, 2.5]) peg_hole(y=1);
            translate([4.5, 0, 2.5]) peg_hole(y=-1);
            translate([4.5, 0, 2.5]) peg_hole(y=1);

            translate([0, 0, 5.5]) peg_hole(y=-1);
            translate([5.5, 0, 5.5]) peg_hole(y=-1);
        }

        translate([0.5, 0, 1]) rotate([-90, 0, 0]) screw_catch();
        translate([5, 0, 1]) rotate([-90, 0, 0]) screw_catch();
        translate([0.5, 0, 5.5]) rotate([-90, 0, 0]) screw_catch();
        translate([5, 0, 5.5]) rotate([-90, 0, 0]) screw_catch();
    }
}

module frame_middle() { // make 1
    inches() difference() {
        union() {
            difference() {
                cube([6, 0.5, 6]);
                translate([0.5, -0.1, 0.5]) cube([5, 0.7, 5]);
            }

            translate([0.5, 0, 2.5]) cube([1, 0.5, 0.5]);
            translate([4.5, 0, 2.5]) cube([1, 0.5, 0.5]);
        }

        if(large_panels) {
            // If large_panels, cut notches for panels
            translate([0.5, -0.125, 6 - panel_thickness]) cube([5, 0.75, panel_thickness * 2]);
            translate([0.5, -0.125, 0.5 - panel_thickness]) cube([5, 0.75, panel_thickness * 2]);

            translate([-panel_thickness, -0.125, 0.5]) cube([panel_thickness * 2, 0.75, 5]);
            translate([6 - panel_thickness, -0.125, 0.5]) cube([panel_thickness * 2, 0.75, 5]);
        }

        for(i = [-1,1]) {
            peg_hole(y=i);
            translate([5.5, 0, 0]) peg_hole(y=i);

            translate([1, 0, 2.5]) peg_hole(y=i);
            translate([4.5, 0, 2.5]) peg_hole(y=i);

            translate([0, 0, 5.5]) peg_hole(y=i);
            translate([5.5, 0, 5.5]) peg_hole(y=i);
        }
    }
}

module frame_left() { // make 1
    union() {
        frame_front_bottom_left(false);
        inch_translate([0, 0, 3]) rotate([atan(3/4), 0, 0]) inch_translate([0, 0.5, -0.5]) beam_slope_left();
        inch_translate([0, 4, 5.5]) frame_front_top_left(false);
    }
}

module frame_right() { // make 1
    translate([inch(0.5), 0, 0]) mirror([1, 0, 0]) frame_left();
}

module frame_front_bottom_left(slope_peg=true) { // make 1
    inches() difference() {
        union() {
            cube([0.5, 0.5, 3]);
            translate([0, 0, 3]) rotate([atan(3/4), 0, 0]) difference() {
                translate([0, 0, -0.5]) {
                    cube([0.5, 0.5, 0.5]);
                }
            }

            // Screws for front panel
            translate([0.5, 0.5, 0.5]) rotate([90, 0, 0]) screw_catch();
            translate([0.5, 0.5, 2]) rotate([90, 0, 0]) screw_catch();

            // Screws for side panel
            translate([0.5, 0.5, 2.25]) rotate([0, -90, 0]) screw_catch();
        }

        // Peg for slope
        if(slope_peg) translate([0, 0, 3]) rotate([atan(3/4), 0, 0]) difference() {
            translate([0, 0, -0.5]) {
                peg_hole(y=1);
            }
        }

        peg_hole(x=1);
        peg_hole(y=1);
        translate([0, 0, 2.5]) peg_hole(x=1);
    }
}

module frame_front_bottom_right() { // make 1
    translate([inch(0.5), 0, 0]) mirror([1, 0, 0]) frame_front_bottom_left();
}

module frame_front_top_left(slope_peg=true) { // make 1
    inches() difference() {
        union() {
            cube([0.5, 1.75, 0.5]);
            translate([0, 0, 0.5]) rotate([-atan(4/3), 0, 0]) translate([0, 0, -0.5]) difference() {
                cube([0.5, 0.5, 0.5]);
                if(slope_peg) peg_hole(z=-1);
            }

            translate([0, 1.25, 0]) peg(y=1);

            // Screws for small panel on top
            translate([0.5, 0.5, 0]) screw_catch();
            translate([0.5, 1.25, 0]) screw_catch();

            // Screws for side panel
            translate([0.5, (0.5 * (1/3)), -0.5]) rotate([0, -90, 0]) screw_catch();
            translate([0.5, 1.25, -0.5]) rotate([0, -90, 0]) screw_catch();
        }

        translate([0, 0, 0]) peg_hole(x=1);
    }
}

module frame_front_top_right() { // make 1
    translate([inch(0.5), 0, 0]) mirror([1, 0, 0]) frame_front_top_left();
}

module bevel_bottom() { // make 1
    inches() {
        difference() {
            cube([5, 0.5, 1]);

            translate([-0.001, 0, 0.5]) rotate([atan(3/4), 0, 0]) cube([5.002, 1, 1]);
            translate([-0.001, 0, 0.5]) rotate([atan(3/4), 0, 0]) translate([0, 0.5, -0.5]) cube([5.002, 1, 1]);

            translate([0.5, 0, 0]) peg_hole(y=1);
            translate([4, 0, 0]) peg_hole(y=1);
        }

        peg(x=-1);
        translate([4.5, 0, 0]) peg(x=1);
    }
}

module bevel_top() { // make 1
    inches() {
        translate([0, 0.5, 0.5]) rotate([90, 0, 0]) mirror([0, 1, 0]) {
            difference() {
                cube([5, 0.5, 1]);

                translate([-0.001, 0, 0.5]) rotate([atan(4/3), 0, 0]) cube([5.002, 1, 1]);
                translate([-0.001, -0.001, 0.5]) rotate([-atan(3/4), 0, 0]) translate([0, 0, 0.5]) cube([5.002, 1.002, 1]);
            }

            peg(x=-1);
            translate([4.5, 0, 0]) peg(x=1);
        }
    }
}

module panel_front() { // make 1
    inches() {
        difference() {
            cube([5, 2, panel_thickness]);

            translate([0, 0, 0]) screw_hole();
            translate([4.5, 0, 0]) screw_hole();
            translate([0, 1.5, 0]) screw_hole();
            translate([4.5, 1.5, 0]) screw_hole();
        }
    }
}

module panel_front_left() { // make 1
    inches() difference() {
        hull() {
            cube([2.25, 5.25, panel_thickness]);
            translate([2.75, 3.5 + (0.5 * (1/3)), 0]) cube([2.25, 1.75 - (0.5 * (1/3)), panel_thickness]);
        }

        translate([0, 0, 0]) screw_hole();
        translate([0, 4.75, 0]) screw_hole();
        translate([4.5, 3.5 + (0.5 * (1/3)), ,0]) screw_hole();
        translate([4.5, 4.75, 0]) screw_hole();
        translate([1.75, 0, 0]) screw_hole();
    }
}

module panel_front_right() { // make 1
    translate([0, 0, 0]) mirror([1, 0, 0]) panel_front_left();
}

module panel_large_left() { // make 1
    difference() {
        hull() {
            panel_front_left();
            inches() translate([0, 10, 0]) cube([5, 1, panel_thickness]);
        }

        inches() {
            translate([0, 0, 0]) screw_hole();
            translate([0, 4.75, 0]) screw_hole();
            translate([4.5, 3.5 + (0.5 * (1/3)), 0]) screw_hole();

            translate([4.5, 4.75, 0]) screw_hole();
            translate([1.75, 0, 0]) screw_hole();

            translate([0, 5.75, 0]) screw_hole();
            translate([4.5, 5.75, 0]) screw_hole();

            translate([0, 10.5, 0]) screw_hole();
            translate([4.5, 10.5, 0]) screw_hole();
        }
    }
}

module panel_large_right() { // make 1
    mirror([1, 0, 0]) panel_large_left();
}

module panel_large_top() { // make 1
    inches() difference() {
        cube([5, 7, panel_thickness]);

        translate([0, 0, 0]) screw_hole();
        translate([4.5, 0, 0]) screw_hole();

        translate([0, 0.75, 0]) screw_hole();
        translate([4.5, 0.75, 0]) screw_hole();

        translate([0, 1.75, 0]) screw_hole();
        translate([4.5, 1.75, 0]) screw_hole();

        translate([0, 6.5, 0]) screw_hole();
        translate([4.5, 6.5, 0]) screw_hole();
    }
}

module panel_large_bottom() { // make 1
    inches() difference() {
        cube([5, 11, panel_thickness]);

        translate([0, 0, 0]) screw_hole();
        translate([4.5, 0, 0]) screw_hole();

        translate([0, 4.75, 0]) screw_hole();
        translate([4.5, 4.75, 0]) screw_hole();

        translate([0, 5.75, 0]) screw_hole();
        translate([4.5, 5.75, 0]) screw_hole();

        translate([0, 10.5, 0]) screw_hole();
        translate([4.5, 10.5, 0]) screw_hole();
    }
}

module panel_back() { // make 1
    inches() difference() {
        cube([5, 5, panel_thickness]);

        translate([0, 0, 0]) screw_hole();
        translate([4.5, 0, 0]) screw_hole();
        translate([0, 4.5, 0]) screw_hole();
        translate([4.5, 4.5, 0]) screw_hole();
    }
}

module panel_small() { // make 1
    inches() difference() {
        cube([5, 1.25, panel_thickness]);

        translate([0, 0, 0]) screw_hole();
        translate([4.5, 0, 0]) screw_hole();
        translate([0, 0.75, 0]) screw_hole();
        translate([4.5, 0.75, 0]) screw_hole();
    }
}

module panel_misc() { // make 3
    inches() difference() {
        cube([5, 5.25, panel_thickness]);

        translate([0, 0, 0]) screw_hole();
        translate([4.5, 0, 0]) screw_hole();
        translate([0, 4.75, 0]) screw_hole();
        translate([4.5, 4.75, 0]) screw_hole();
    }
}

module panel_screen() { // make 1
    difference() {
        inches() {
            cube([5, 4, panel_thickness]);
        }
        translate([(inch(5) - 93) / 2, (inch(4) - 87) / 2, 0]) smart_controller_template();

        inches() {
            translate([0, 0, 0]) screw_hole();
            translate([4.5, 0, 0]) screw_hole();
            translate([0, 3.5, 0]) screw_hole();
            translate([4.5, 3.5, 0]) screw_hole();
        }
    }
}

color([0.1, 0.1, 0.1]) {
    if(small_parts) {
        frame_front_bottom_left();
        inch_translate([0, 0, 3]) rotate([atan(3/4), 0, 0]) inch_translate([0, 0.5 + e, -0.5]) beam_slope_left();
        inch_translate([0, 4 + (e * 2), 5.5 + e]) frame_front_top_left();

        inch_translate([5.5 + (e * 4), 0, 0]) frame_front_bottom_right();
        inch_translate([5.5 + (e * 4), 0, 3]) rotate([atan(3/4), 0, 0]) inch_translate([0, 0.5 + e, -0.5]) beam_slope_right();
        inch_translate([5.5 + (e * 4), 4 + (e * 2), 5.5 + e]) frame_front_top_right();
    } else {
        frame_left();
        inch_translate([5.5 + (e * 4), 0, 0]) frame_right();
    }

    inch_translate([e * 2, 5.75 + (e * 2), 0]) frame_middle();

    inch_translate([e * 2, 11.5 + (e * 5), 0]) frame_back();

    // Front bottom bevel
    inch_translate([0.5 + (e * 2), 0, 2.5]) bevel_bottom();

    // Back top bevel
    inch_translate([0.5 + (e * 2), 4, 5.5]) bevel_top();

    // Bottom face beam
    inch_translate([0.5 + (e * 2), 0, 0]) mirror([0, 1, 0]) rotate([0, 0, -90]) beam_front();

    // Bottom front side beams
    inch_translate([0, 0.5 + e, 0]) beam_bottom();
    inch_translate([6 + (e * 4), 0.5 + e, 0]) mirror([1, 0, 0]) beam_bottom();


    // Back half beams
    inch_translate([0, 6.25 + (e * 3), 0]) beam_bottom();
    inch_translate([6 + (e * 4), 6.25 + (e * 3), 0]) mirror([1, 0, 0]) beam_bottom();
    inch_translate([0, 6.25 + (e * 3), 6]) mirror([0, 0, 1]) beam_top();
    inch_translate([6 + (e * 4), 6.25 + (e * 3), 6]) mirror([1, 0, 0]) mirror([0, 0, 1]) beam_top();

    // Board shelf beams
    inch_translate([1 + e, 0.5 + e, 2.5]) board_beam();
    inch_translate([4.5 + (e * 3), 0.5 + e, 2.5]) board_beam();

    inch_translate([1 + e, 6.25 + (e * 3), 2.5]) board_beam();
    inch_translate([4.5 + (e * 3), 6.25 + (e * 3), 2.5]) board_beam();
}

if(!hide_panels) color([0.5, 0.5, 0.5]) {
    if(large_panels) {
        inch_translate([panel_thickness - e, 0.5 + e, 0.5]) rotate([0, -90, 0]) panel_large_left();
        if(!open_side) inch_translate([6 - panel_thickness + (e * 5), 0.5 + e, 0.5]) rotate([0, 90, 0]) panel_large_right();
        inch_translate([0.5 + (e * 2), 4.5 + e, 6 - panel_thickness + e]) panel_large_top();
        inch_translate([0.5 + (e * 2), 0.5 + e, 0.375 + e]) panel_large_bottom();
    } else {
        inch_translate([0.5 + (e * 2), 4.5, 6 - panel_thickness + e]) panel_small();
        inch_translate([panel_thickness - e, 0.5, 0.5]) rotate([0, -90, 0]) panel_front_left();
        if(!open_side) inch_translate([6 - panel_thickness + (e * 5), 0.5, 0.5]) rotate([0, 90, 0]) panel_front_right();

        inch_translate([0.5 + (e * 2), 0.5, 0.5 - panel_thickness]) panel_misc();
        inch_translate([0.5 + (e * 2), 6.25 + (e * 2), 0.5 - panel_thickness]) panel_misc();
        inch_translate([0.5 + (e * 2), 6.25 + (e * 2), 6 - panel_thickness + e]) panel_misc();

        inch_translate([panel_thickness - e, 6.25 + (e * 2), 0.5]) rotate([0, -90, 0]) panel_misc();
        if(!open_side) inch_translate([6 + (e * 5), 6.25 + (e * 2), 0.5]) rotate([0, -90, 0]) panel_misc();
   }

   inch_translate([0.5 + (e * 2), panel_thickness - e, 0.5]) rotate([90, 0, 0]) panel_front();
   inch_translate([0.5 + (e * 2), 12 + (e * 6), 0.5]) rotate([90, 0, 0]) panel_back();

   inch_translate([0, 0, 3]) rotate([atan(3/4), 0, 0]) inch_translate([0.5 + (e * 2), 0.5, -0.125]) panel_screen();
}

color([0.4, 0.4, 0.4]) {
    inch_translate([0.5 + e, 2, 2.5]) power_supply_bracket();
    inch_translate([0.5 + e, 7.125 + (e * 3), 2.5]) power_supply_bracket();

    inch_translate([5.5 + (e * 3), 2, 2.5]) mirror([1, 0, 0]) power_supply_bracket();
    inch_translate([5.5 + (e * 3), 7.125 + (e * 3), 2.5]) mirror([1, 0, 0]) power_supply_bracket();
}

if(!explode) {
    color([0.3, 0.3, 0.5]) translate([((inch(6) - 115) / 2) + inch(e * 2), inch(1) + (inch(1) - 25) * 5, inch(0.5)]) power_supply();
    color([0.0, 0.7, 0.5]) inch_translate([0, 0, 3]) rotate([atan(3/4), 0, 0]) inch_translate([0.5 + (e * 2), 0.5, -0.125]) translate([(inch(5) - 93) / 2, (inch(4) - 87) / 2, -10]) import("full_graphic_smart_controller.stl");
    color([0.0, 0.5, 0.7]) inch_translate([(6 - 4.05) / 2 + (e * 2), 6, 3]) rotate([0, 0, -90]) import("rambo_v1.4.stl");
}

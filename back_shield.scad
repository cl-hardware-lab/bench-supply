$fn=24;


view = "cuts"; // 3d or cuts for sliced view


X = 85; // Internal X Size
Y = 42.5; // Internal Y Size
BORDER = 2.5; // Width of Border
CORNER_RADIUS = 5; // Radius of Corners
SCREW_DRILL = 3.2; // Diameter of Screw Holes
SCREW_ANULAR = 3.5; // Radius of Screw Mounts
SCREW_Y_OFF = 20; // Vertical Offset of Screw Mounts

module rounded_top_rect(x, y, r, d) {
    union() {
        cube([x, y - r, d]);
        translate([r, 0, 0]) cube([x - 2*r, y, d]);
        translate([r, y - r, 0]) cylinder(d, r=r);
        translate([x - r, y - r, 0]) cylinder(d, r=r);
    }
}

module screwmount(drill, r, h) {
    difference() {
        union() {
            cylinder(h=h, r=r);
            difference() {
                translate([0, -r*2, 0]) cube([r, r*4, h]);
                translate([0, r*2, 0]) cylinder(h=h, r=r);
                translate([0, -r*2, 0]) cylinder(h=h, r=r);
            }
        }
        cylinder(h=h, d=drill);
    }    
}

module plate() {
    difference() {
        rounded_top_rect(X + BORDER*2, Y + BORDER, r=CORNER_RADIUS, d=5);
        translate([BORDER, 0, 1]) rounded_top_rect(X, Y, r=CORNER_RADIUS, d=4);
    }

    translate([SCREW_ANULAR + BORDER, SCREW_Y_OFF, 1])
        rotate([0,0,180])
        screwmount(3.2, SCREW_ANULAR, 3);

    translate([X - SCREW_ANULAR + BORDER, SCREW_Y_OFF, 1])
        screwmount(SCREW_DRILL, SCREW_ANULAR, 3);
}

if(view == "3d"){
    plate();
} else if(view == "cuts"){
    projection(true) plate();
    projection(true) translate([0, Y*1.5, -2]) plate();
    projection(true) translate([0, Y*3, -5]) plate();
}
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

module screwmount(r, h) {
    union() {
        cylinder(h=h, r=r);
        difference() {
            translate([0, -r*2, 0]) cube([r, r*4, h]);
            translate([0, r*2, 0]) cylinder(h=h, r=r);
            translate([0, -r*2, 0]) cylinder(h=h, r=r);
        }
    }   
}

module plate() {
    difference() {
        union() {
            difference() {
                rounded_top_rect(X + BORDER*2, Y + BORDER, r=CORNER_RADIUS, d=6);
                translate([BORDER, 0, 2]) rounded_top_rect(X, Y, r=CORNER_RADIUS, d=4);
            }

            translate([SCREW_ANULAR + BORDER, SCREW_Y_OFF, 2])
                rotate([0,0,180])
                screwmount(SCREW_ANULAR, 3);

            translate([X - SCREW_ANULAR + BORDER, SCREW_Y_OFF, 2])
                screwmount(SCREW_ANULAR, 3);
        }
        translate([SCREW_ANULAR + BORDER, SCREW_Y_OFF, 0])
            cylinder(h=6, d=SCREW_DRILL);
        translate([SCREW_ANULAR + BORDER, SCREW_Y_OFF, 0])
            cylinder($fn=6, h=2, d=6.25);
        
        translate([X - SCREW_ANULAR + BORDER, SCREW_Y_OFF, 0])
            cylinder(h=6, d=SCREW_DRILL);
        translate([X - SCREW_ANULAR + BORDER, SCREW_Y_OFF, 0])
            cylinder($fn=6, h=2, d=6.25);
    }
}

if(view == "3d"){
    plate();
} else if(view == "cuts"){
    projection(true) plate();
    translate([-40, 0, 0]) text("2mm");
    projection(true) translate([0, Y*1.5, -3]) plate();
    translate([-40, Y*1.5, 0]) text("3mm");
    projection(true) translate([0, Y*3, -6]) plate();
    translate([-40, Y*3, 0]) text("1mm");
}
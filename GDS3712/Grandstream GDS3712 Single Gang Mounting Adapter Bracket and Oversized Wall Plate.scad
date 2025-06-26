$fn=64;
mounting_slot_w=7;
mounting_slot_distance=83.34;
plate_radius_d=12;
mounting_box_h=12;
plate_thickness=2;
screw_nut_d=10;
screw_nut_h=5;
screw_hole_d=4;
internal_post_od=16;
box_x=168;
box_y=76;
thru_hole_x=68;
thru_hole_y=35;
wall_plate_y=150;
sacrificial_layer_h=0.28;	// Set to 0 to disable the sacficicial layer in mounting holes

module mounting_slot(){
	union(){
		translate([0,-mounting_slot_w/4,0]) cylinder(h=plate_thickness, d=5, center=true);
		cube([5,mounting_slot_w/2,plate_thickness], center=true);
		translate([0,mounting_slot_w/4,0]) cylinder(h=plate_thickness, d=5, center=true);
	}
}

module internal_post(){
  union(){
		difference(){
			cylinder(d=internal_post_od, h=mounting_box_h-plate_thickness, center=true);
			cylinder(d=screw_hole_d, h=mounting_box_h-plate_thickness, center=true);
			translate([0,0,-(mounting_box_h-plate_thickness)/2]) cylinder(d=screw_nut_d, h=screw_nut_h, center=true);	// Screw nut recess
		}
		translate([0,0,-mounting_box_h/2+plate_thickness]) cylinder(d=screw_nut_d, h=sacrificial_layer_h, cener=true);
	}
}

module fillet12(){
	difference(){
		translate([0,0,-1]) cube([6,6,2]);
		cylinder(d=12, h=2, center=true);
	}
}

// Wall plate
module wall_plate(){
	difference(){
		cube([box_x,wall_plate_y,2], center=true);																// Main plate
		translate([-mounting_slot_distance/2,0,0]) mounting_slot();								// Upper mounting slot
		translate([mounting_slot_distance/2,0,0]) mounting_slot();								// Lower mounting slot
		cube([thru_hole_x,thru_hole_y,2], center=true);														// Wiring thru-hole
		translate([ box_x/2-6, wall_plate_y/2-6,0]) 									fillet12();	// Outer fillets
		translate([-box_x/2+6,-wall_plate_y/2+6,0]) rotate([0,0,180]) fillet12(); // Outer fillets
		translate([-box_x/2+6, wall_plate_y/2-6,0]) rotate([0,0,90]) 	fillet12();	// Outer fillets
		translate([ box_x/2-6,-wall_plate_y/2+6,0]) rotate([0,0,-90]) fillet12();	// Outer fillets
	}
}

// GDS3712 Mounting Bracket
module mounting_bracket(){
	union(){
		difference(){
			translate([0,0,mounting_box_h/2]) cube([box_x,box_y,mounting_box_h], center=true);									// Main box
			translate([0,0,mounting_box_h/2+plate_thickness]) cube([154,62,mounting_box_h], center=true);				// Box Hollow
			translate([-mounting_slot_distance/2,0,plate_thickness/2]) mounting_slot();													// Upper mounting slot
			translate([ mounting_slot_distance/2,0,plate_thickness/2]) mounting_slot();													// Lower mounting slot
			translate([0,0,plate_thickness/2])cube([thru_hole_x,thru_hole_y,2], center=true);										// Wiring thru-hole
			translate([ 100/2, 50/2,plate_thickness/2]) cylinder(d=screw_nut_d, h=plate_thickness, center=true);// Bracket mount holes
			translate([-100/2,-50/2,plate_thickness/2]) cylinder(d=screw_nut_d, h=plate_thickness, center=true);// Bracket mount holes
			translate([-100/2, 50/2,plate_thickness/2]) cylinder(d=screw_nut_d, h=plate_thickness, center=true);// Bracket mount holes
			translate([ 100/2,-50/2,plate_thickness/2]) cylinder(d=screw_nut_d, h=plate_thickness, center=true);// Bracket mount holes
			translate([ box_x/2-6, box_y/2-6,0]) 										scale([1,1,50]) fillet12();									// Outer fillets
			translate([-box_x/2+6,-box_y/2+6,0]) 	rotate([0,0,180]) scale([1,1,50]) fillet12();									// Outer fillets
			translate([-box_x/2+6, box_y/2-6,0]) 	rotate([0,0,90]) 	scale([1,1,50]) fillet12();									// Outer fillets
			translate([ box_x/2-6,-box_y/2+6,0]) 	rotate([0,0,-90]) scale([1,1,50]) fillet12();									// Outer fillets
		}
		translate([ 100/2, 50/2,(plate_thickness+mounting_box_h)/2]) internal_post();													// Internal posts
		translate([-100/2,-50/2,(plate_thickness+mounting_box_h)/2]) internal_post();													// Internal posts
		translate([-100/2, 50/2,(plate_thickness+mounting_box_h)/2]) internal_post();													// Internal posts
		translate([ 100/2,-50/2,(plate_thickness+mounting_box_h)/2]) internal_post();													// Internal posts
	}
}



// Compliation (comment/uncomment to render a specific part/body
//color("blue") wall_plate();								// Oversized wall plate
translate([0,0,2]) mounting_bracket();		// Single-gang adapter bracket


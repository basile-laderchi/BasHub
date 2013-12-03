servo_hub_extra_height = 2;
servo_hole_count = 4;
servo_attachment_height = 2;
magnet_offset = 3;
magnet_diameter = 0;

// Same as BasWheel parameters
hub_type = "hubattachment"; // (lego, hubattachment)
wheel_height = 10;
hub_diameter = 5;
hub_thickness = 5;
slot_OD = 10;
slot_height = 2;

/*
 *
 * BasHub v1.01
 *
 * by Basile Laderchi
 *
 * Licensed under Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported http://creativecommons.org/licenses/by-nc-sa/3.0/
 *
 * v 1.01, 22 Nov 2013 : Changed license and added parameter hub_type
 * v 1.00, 03 Sep 2013 : Initial release
 *
 */

basHub(hub_type, wheel_height, hub_diameter, hub_thickness, slot_OD, slot_height, servo_hub_extra_height, servo_hole_count, servo_attachment_height, magnet_offset, magnet_diameter, $fn=100);

module basHub(hub_type, height, hub_diameter, hub_thickness, slot_OD, slot_height, servo_hub_extra_height, servo_hole_count, servo_attachment_height, magnet_offset, magnet_diameter) {
	hub_radius = hub_diameter / 2;
	magnet_radius = magnet_diameter / 2;
	hub_other_outer_radius = hub_radius + hub_thickness;

	hub(hub_type, hub_radius, hub_thickness, slot_OD, slot_height, servo_hub_extra_height, servo_hole_count, servo_attachment_height, height, magnet_offset, magnet_radius);
}

module hub(type, inner_radius, thickness, slot_OD, slot_height, servo_extra_height, servo_hole_count, servo_attachment_height, tire_height, magnet_offset, magnet_radius) {
	padding = 1;
	small_padding = 0.1;
	servo_outer_radius = 18;

	lego_piece_height = 15.6;
	lego_piece_size = 4.72;

	radius = inner_radius + thickness;

	slot_radius = slot_OD / 2;
	slot_x = tire_height - slot_height;

	slot_hole_height = servo_extra_height + servo_attachment_height + slot_height;
	slot_hole_x = tire_height + servo_attachment_height + servo_extra_height - slot_height;

	rotate([180, 0, 0]) {
		if (type == "lego") {
			union() {
				servoHub(servo_outer_radius, radius, inner_radius, servo_extra_height, servo_hole_count, servo_attachment_height, tire_height, magnet_offset, magnet_radius);
				difference() {
					rotate([0, 90, 0]) {
						translate([-(tire_height + servo_attachment_height) / 2, -lego_piece_size / 2, -lego_piece_size / 2]) {
							scale([(tire_height + servo_attachment_height) / lego_piece_height, 1, 1]) {
								import("LegoAxleSize2.stl", convexity=10);
							}
						}
					}
					translate([0, 0, -(servo_attachment_height + tire_height) / 2]) {
						cylinder(r=radius, h=servo_attachment_height, center=true);
					}
				}
			}
		} else if (type == "hubattachment") {
			difference() {
				union() {
					servoHub(servo_outer_radius, radius, inner_radius, servo_extra_height, servo_hole_count, servo_attachment_height, tire_height, magnet_offset, magnet_radius);
					translate([0, 0, slot_x / 2]) {
						cylinder(r=slot_radius, h=slot_height + small_padding, center=true);
					}
				}
				translate([0, 0, slot_hole_x / 2]) {
					cylinder(r=inner_radius, h=slot_hole_height + padding, center=true);
				}
			}
		}
	}
}

module servoHub(outer_radius, radius, inner_radius, extra_height, hole_count, attachment_height, tire_height, magnet_offset, magnet_radius) {
	padding = 0.1;

	if (magnet_radius > 0) {
		difference() {
			servoSimpleHub(outer_radius, radius, inner_radius, extra_height, hole_count, attachment_height, tire_height);
			for (i = [0 : hole_count - 1]) {
				rotate([0, 0, i * 360 / hole_count + (360 / hole_count / 2)]) {
					translate([0, outer_radius - magnet_radius - magnet_offset, tire_height / 2 + extra_height - padding]) {
						cylinder(r=magnet_radius, h=attachment_height + padding * 2);
					}
				}
			}
		}
	} else {
		servoSimpleHub(outer_radius, radius, inner_radius, extra_height, hole_count, attachment_height, tire_height);
	}
}

module servoSimpleHub(outer_radius, radius, inner_radius, extra_height, hole_count, attachment_height, tire_height) {
	padding = 0.1;

	translate([0, 0, tire_height / 2]) {
		difference() {
			union() {
				cylinder(r=radius, h=extra_height);
				translate([0, 0, extra_height]) {
					cylinder(r=outer_radius, h=attachment_height);
				}
			}
			for (i = [0 : hole_count - 1]) {
				rotate([0, 0, i * 360 / hole_count]) {
					hull() {
						translate([0, 5, -padding]) {
							cylinder(r=.75, h=attachment_height + extra_height + padding * 2);
						}
						translate([0, 14, -padding]) {
							cylinder(r=.75, h=attachment_height + extra_height + padding * 2);
						}
					}
				}
			}
		}
	}
}

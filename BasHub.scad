servo_hub_extra_height = 2;  // Extra height of the servo hub
servo_hole_count = 4;  // How many screw hole will the servo hub have
servo_attachment_height = 2;  // Height of the servo hub base
magnet_offset = 3;  // Distance of the magnet holes from the outside
magnet_diameter = 0;  // Magnet's diameter

// Same as BasWheel's parameters
hub_type = "hubattachment";  // define hubtype to be used. Options are (lego, hubattachment)
wheel_height = 10;  // height of the wheel
hub_diameter = 5;  // diameter of the hub
hub_thickness = 5;  // thickness of the hub
slot_OD = 9.6;  // Outer diameter of the screw slot (attachment to BasWheel). Be sure to leave some padding for the Hub, glue and Wheel to fit together.

/*
 *
 * BasHub v1.03
 *
 * by Basile Laderchi
 *
 * Licensed under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International http://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 * v 1.03, 29 Nov 2013 : Changed license from BY-NC-SA v3 to BY-NC-SA v4.0 and added comments to parameters
 * v 1.02, 26 Nov 2013 : Removed parameter slot_height
 * v 1.01, 22 Nov 2013 : Changed license from BY-SA to BY-NC-SA and added parameter hub_type
 * v 1.00, 03 Sep 2013 : Initial release
 *
 */

basHub(hub_type, wheel_height, hub_diameter, hub_thickness, slot_OD, servo_hub_extra_height, servo_hole_count, servo_attachment_height, magnet_offset, magnet_diameter, $fn=100);

module basHub(hub_type, height, hub_diameter, hub_thickness, slot_OD, servo_hub_extra_height, servo_hole_count, servo_attachment_height, magnet_offset, magnet_diameter) {
	hub_radius = hub_diameter / 2;
	magnet_radius = magnet_diameter / 2;
	hub_other_outer_radius = hub_radius + hub_thickness;

	hub(hub_type, hub_radius, hub_thickness, slot_OD, servo_hub_extra_height, servo_hole_count, servo_attachment_height, height, magnet_offset, magnet_radius);
}

module hub(type, inner_radius, thickness, slot_OD, servo_extra_height, servo_hole_count, servo_attachment_height, tire_height, magnet_offset, magnet_radius) {
	padding = 1;
	small_padding = 0.1;
	servo_outer_radius = 18;

	lego_piece_height = 15.6;
	lego_piece_size = 4.72;

	radius = inner_radius + thickness;

	slot_radius = slot_OD / 2;
	slot_height = tire_height / 2;
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

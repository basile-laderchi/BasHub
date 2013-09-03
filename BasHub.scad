servo_hub_extra_height = 2;
servo_hole_count = 6;
servo_attachment_height = 2;
magnet_offset = 3;
magnet_diameter = 6;

// Same as BasWheel parameters
wheel_height = 10;
hub_diameter = 5;
hub_thickness = 5;

/*
 *
 * BasHub v1.00
 *
 * by Basile Laderchi
 *
 * Licensed under Creative Commons Attribution-ShareAlike 3.0 Unported http://creativecommons.org/licenses/by-sa/3.0/
 *
 * v 1.00, 03 September 2013 : Initial release
 *
 */

basHub(wheel_height, hub_diameter, hub_thickness, servo_hub_extra_height, servo_hole_count, servo_attachment_height, magnet_offset, magnet_diameter, $fn=100);

module basHub(height, hub_diameter, hub_thickness, servo_hub_extra_height, servo_hole_count, servo_attachment_height, magnet_offset, magnet_diameter) {
	hub_radius = hub_diameter / 2;
	magnet_radius = magnet_diameter / 2;
	hub_other_outer_radius = hub_radius + hub_thickness;

	hub(hub_radius, hub_thickness, servo_hub_extra_height, servo_hole_count, servo_attachment_height, height, magnet_offset, magnet_radius);
}

module hub(inner_radius, thickness, servo_extra_height, servo_hole_count, servo_attachment_height, tire_height, magnet_offset, magnet_radius) {
	padding = 1;
	servo_outer_radius = 18;

	lego_piece_height = 15.6;
	lego_piece_size = 4.72;

	radius = inner_radius + thickness;
	nut_x = radius - thickness + 0.5;

	rotate([180, 0, 0]) {
		union() {
			servoHub(servo_outer_radius, radius, inner_radius, servo_extra_height, servo_hole_count, servo_attachment_height, tire_height, magnet_offset, magnet_radius);
			rotate([0, 90, 0]) {
				translate([-(tire_height + servo_attachment_height) / 2, -lego_piece_size / 2, -lego_piece_size / 2]) {
					scale([(tire_height + servo_attachment_height / 2) / lego_piece_height, 1, 1]) {
						import("LegoAxleSize2.stl");
					}
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

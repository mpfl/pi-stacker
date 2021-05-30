use <hex-mesh.scad>;

$fn = 180;

mini_sled_x = 56;
mini_sled_y = 90;
mini_sled_z = 5;

pi_connector_x = 2.5;
pi_connector_y = 86;
pi_connector_z = 6;

sled_x = 65;
sled_y = 90;
sled_height = 5;
sled_rail_tolerance = 0.5;
rail_x = 2;


fan_thickness = 12;
fan_x = 40;
fan_z = 40;

case_x = 44.45 * 2 - 0.794;
case_y = sled_y + fan_thickness;
case_z = 44.45 * 1 - 0.794;
case_wall_thickness = (case_z - fan_z) / 2;

inner_wall_offset = case_x - (mini_sled_x + rail_x + sled_rail_tolerance * 2);


mesh_corner_radius = 2;
mesh_size = 9;
mesh_thickness = 2;

translate([mini_sled_x/2 + inner_wall_offset + sled_rail_tolerance, mini_sled_y-7 ,sled_height])
    mini_sled();

housing();

/*
translate([sled_x/2 + inner_wall_offset + sled_rail_tolerance,sled_y-7,sled_height])
    sled();
*/
translate([ case_wall_thickness / 2,0,case_z - 27.8 - case_wall_thickness])
    # oled_pcb();

module oled_pcb() {
    cube([27.5,2.7,27.8]);
}

module pi_connector_cutout() {
    translate([inner_wall_offset - case_wall_thickness,0,sled_height + mini_sled_z])
        cube([pi_connector_x, pi_connector_y, pi_connector_z]);
}

module housing() {
    intersection() {
/*
        linear_extrude(case_z)
            hull() {
                translate([case_wall_thickness, case_wall_thickness])
                    circle( r = case_wall_thickness );
                translate([case_x - case_wall_thickness, case_wall_thickness])
                    circle( r = case_wall_thickness );
                translate([case_x - case_wall_thickness, case_y - case_wall_thickness])
                    circle( r = case_wall_thickness );
                translate([case_wall_thickness, case_y - case_wall_thickness])
                    circle( r = case_wall_thickness );
            }
*/
        union() {
            hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = case_x, y = case_y, z = case_wall_thickness);  // bottom;
            translate([0,0, case_z - case_wall_thickness])
                hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = case_x, y = case_y, z = case_wall_thickness);  // top;
            translate([case_wall_thickness, 0, 0])
                rotate([0,270,0])
                    hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = case_z, y = case_y, z = case_wall_thickness);  // left;
            translate([case_x, 0, 0])
                rotate([0,270,0])
                    hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = case_z, y = case_y, z = case_wall_thickness);  // right;
            translate([inner_wall_offset, 0, 0])
                rotate([0,270,0])
                    union() {
                        hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = sled_height + mini_sled_z + 4, y = case_y - fan_thickness + case_wall_thickness, z = case_wall_thickness);  // inner bottom;
                        translate([0,case_y - fan_thickness,0])
                        cube([case_z,fan_thickness,case_wall_thickness]);
                    }
            translate([inner_wall_offset, 0, sled_height + mini_sled_z + 4 + pi_connector_z])
                rotate([0,270,0])
                    union() {
                        hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = case_z - (sled_height + mini_sled_z + 4 + pi_connector_z), y = case_y - fan_thickness + case_wall_thickness, z = case_wall_thickness);  // inner top;
                    }
            translate([0,case_y,0])
                rotate([90,0,0])
                    hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = (case_x - inner_wall_offset - fan_x)/2 + inner_wall_offset, y = case_z, z = fan_thickness);  // back left;
            translate([fan_x + (case_x + inner_wall_offset - fan_x)/2,case_y,0])
                rotate([90,0,0])
                    hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = (case_x - inner_wall_offset - fan_x)/2, y = case_z, z = fan_thickness);  // back right;
            translate([inner_wall_offset, case_y, sled_height + mini_sled_z/2])
                mini_rails();
/*
            translate([inner_wall_offset - case_wall_thickness, 0,0])
                rails();
*/
        }
    }
}

module mini_rails() {
    mini_rail();
    translate([mini_sled_x + sled_rail_tolerance * 2,0,0])
        mirror([1,0,0])
            mini_rail();
}


module mini_rail() {
    rotate([90,0,0])
        cylinder(d = 4 - sled_rail_tolerance, h = case_y);
}

module rails() {
    rail();
    translate([sled_x + rail_x + case_wall_thickness + sled_rail_tolerance * 2,0,0])
        mirror([1,0,0])
            rail();
}

module rail() {
    difference() {
        translate([case_wall_thickness,case_y,sled_height + sled_rail_tolerance])
            rotate([90,0,0])
                hexagon(corner_radius = mesh_corner_radius, size = rail_x - mesh_corner_radius, z = case_y, quality = 30); // rail
        translate([rail_x - sled_rail_tolerance,-sled_rail_tolerance,sled_height - sled_rail_tolerance])
           rail_cutout(); // sled cutout
        translate([-12,-sled_rail_tolerance,-case_z/2])
            cube([12,case_y+2,case_z]); // trim
    }
}

module rail_cutout() {
    cube([sled_x + sled_rail_tolerance, sled_y + sled_rail_tolerance,2 + sled_rail_tolerance * 2]);
}

module mini_sled() {
    difference() {
        union() {
            translate([-24.5,0,mini_sled_z])
                mini_standoff();
            translate([24.5,0,mini_sled_z])
                mini_standoff();
            translate([-24.5,-58,mini_sled_z])
                mini_standoff();
            translate([24.5,-58,mini_sled_z])
                mini_standoff();
            mini_sled_plate();
            translate([0,7-mini_sled_y,0])
                mini_grip();
        }
        translate([-24.5,0, 3 - mini_sled_z])
            cylinder(h = (mini_sled_z) * 2 + 3, d = 2.5);
        translate([24.5,0, 3 - mini_sled_z])
            cylinder(h = (mini_sled_z) * 2 + 3, d = 2.5);
        translate([-24.5,-58, 3 - mini_sled_z])
            cylinder(h = (mini_sled_z) * 2 + 3, d = 2.5);
        translate([24.5,-58, 3 - mini_sled_z])
            cylinder(h = (mini_sled_z) * 2 + 3, d = 2.5);
        translate([mini_sled_x/2,7,mini_sled_z/2])
            rotate([90,0,0])
                cylinder( h = mini_sled_y, d = 4);
        translate([-mini_sled_x/2,7,mini_sled_z/2])
            rotate([90,0,0])
                cylinder( h = mini_sled_y, d = 4);

    }
}

module mini_sled_plate() {
    linear_extrude(mini_sled_z)
        difference() {
            hull() {
                translate([-(mini_sled_x-10)/2,0])
                    circle(r = 5);
                translate([-mini_sled_x/2,-83])
                    square([10,10]);
                translate([(mini_sled_x-20)/2,-83])
                    square([10,10]);
                translate([(mini_sled_x-10)/2,0])
                    circle(r = 5);
            }
            hull() {
                translate([-(mini_sled_x-10)/2+10,-10])
                    circle(r = 5);
                translate([-(mini_sled_x-10)/2+10,-83+10])
                    circle(r = 5);
                translate([(mini_sled_x-10)/2-10,-83+10])
                    circle(r = 5);
                translate([(mini_sled_x-10)/2-10,-10])
                    circle(r = 5);
            }
    }
}

module sled() {
    difference() {
        union() {
            translate([-24.5,0,0])
                standoff();
            translate([24.5,0,0])
                standoff();
            translate([-24.5,-58,0])
                standoff();
            translate([24.5,-58,0])
                standoff();
            linear_extrude(2)
                difference() {
                    hull() {
                        translate([-(sled_x-10)/2,0])
                            circle(r = 5);
                        translate([-sled_x/2,-83])
                            square([10,10]);
                        translate([(sled_x-20)/2,-83])
                            square([10,10]);
                        translate([(sled_x-10)/2,0])
                            circle(r = 5);
                    }
                    hull() {
                        translate([-(sled_x-10)/2+10,-10])
                            circle(r = 5);
                        translate([-(sled_x-10)/2+10,-83+10])
                            circle(r = 5);
                        translate([(sled_x-10)/2-10,-83+10])
                            circle(r = 5);
                        translate([(sled_x-10)/2-10,-10])
                            circle(r = 5);
                    }
                }
            translate([0,7-sled_y,0])
                grip();
            //# old_grip();
        }
        translate([-24.5,0,-1])
            cylinder(h=10, d = 2.5);
        translate([24.5,0,-1])
            cylinder(h=10, d = 2.5);
        translate([-24.5,-58,-1])
            cylinder(h=10, d = 2.5);
        translate([24.5,-58,-1])
            cylinder(h=10, d = 2.5);
    }
}

module mini_standoff() {
        cylinder(h=4, r = 3);
}

module standoff() {
        cylinder(h=7, r = 3);
}

module mini_grip() {
    intersection() {
        translate([-mini_sled_x/2,-10,0])
            cube([mini_sled_x,10,10]);
    linear_extrude(7)
        hull() {
            translate([5-mini_sled_x/2,0,0])
                circle(r = 5);
            translate([mini_sled_x/2 - 5,0,0])
                circle(r = 5);
            translate([7-mini_sled_x/2,-5,0])
                circle(r = 5);
            translate([mini_sled_x/2-7,-5,0])
                circle(r = 5);
        }
    }
}

module grip() {
    intersection() {
        translate([-sled_x/2,-10,0])
            cube([sled_x,10,10]);
    linear_extrude(7)
        hull() {
            translate([5-sled_x/2,0,0])
                circle(r = 5);
            translate([sled_x/2 - 5,0,0])
                circle(r = 5);
            translate([7-sled_x/2,-5,0])
                circle(r = 5);
            translate([sled_x/2-7,-5,0])
                circle(r = 5);
        }
    }
}

module old_grip() {
    intersection() {
        translate([-sled_x/2,-103,0])
            cube([sled_x,20,10]);
        cylinder(h=7, r=100);
    }
}

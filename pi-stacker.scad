use <hex-mesh.scad>;

$fn = 180;

mini_sled_x = 56;
mini_sled_y = 90;
mini_sled_z = 5;

pi_connector_x = 2.5;
pi_connector_y = 86;
pi_connector_z = 8;

sled_x = 65;
sled_y = 90;
sled_height = 7;
sled_rail_tolerance = 0.2;
sled_standoff_height = 2;
rail_x = 2;

mini_rail_x = 2;

fan_thickness = 12;
fan_x = 40.2;
fan_z = 40.2;

case_x = 44.45 * 2 - 0.794;
case_y = sled_y + fan_thickness;
case_z = 44.45 * 1 - 0.794;
case_wall_thickness = (case_z - fan_z) / 2;

inner_wall_offset = case_x - (mini_sled_x + rail_x + sled_rail_tolerance * 2);

mesh_corner_radius = 2;
mesh_size = 9;
mesh_thickness = 2;


/*
translate([mini_sled_x/2 + inner_wall_offset + sled_rail_tolerance, mini_sled_y-7 ,sled_height])
    mini_sled();
*/
housing();

/*
translate([sled_x/2 + inner_wall_offset + sled_rail_tolerance,sled_y-7,sled_height])
    sled();

translate([ case_wall_thickness / 2,0,case_z - 27.8 - case_wall_thickness])
    # oled_pcb();
*/
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
            case_end();
            translate([0,case_y - fan_thickness,0])
                case_end();
            translate([0, fan_thickness, 0])
                hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = case_x, y = case_y - 2 * fan_thickness, z = case_wall_thickness);  // bottom mesh;
            translate([0,fan_thickness, case_z - case_wall_thickness])
                hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = case_x, y = case_y - 2 * fan_thickness, z = case_wall_thickness);  // top mesh;
            translate([case_wall_thickness, fan_thickness, 0])
                rotate([0,270,0])
                    hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = case_z, y = case_y - 2 * fan_thickness, z = case_wall_thickness);  // left mesh;
            translate([case_x, fan_thickness, 0])
                rotate([0,270,0])
                    hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = case_z, y = case_y - 2 * fan_thickness, z = case_wall_thickness);  // right mesh;
            translate([inner_wall_offset, fan_thickness, 0])
                rotate([0,270,0])
                    hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = sled_height + mini_sled_z + sled_standoff_height, y = case_y - 2 * fan_thickness + case_wall_thickness, z = case_wall_thickness);  // inner bottom mes;
            translate([inner_wall_offset - case_wall_thickness + mini_rail_x - sled_rail_tolerance / 2, case_y, sled_height + mini_sled_z/2])
                mini_rails();
        }
    }
}

module fan_mount() {

}

module case_end() {
    cube([case_x, fan_thickness, case_wall_thickness]);
    translate([0,0,case_z - case_wall_thickness])
        cube([case_x, fan_thickness, case_wall_thickness]);
    cube([case_wall_thickness, fan_thickness, case_z]);
    translate([case_x - case_wall_thickness, 0, 0])
        cube([case_wall_thickness, fan_thickness, case_z]);
    translate([inner_wall_offset - case_wall_thickness, 0, 0])
        cube([case_wall_thickness, fan_thickness, case_z]);
}

module mini_rails() {
    mini_rail();
    translate([mini_sled_x + sled_rail_tolerance * 2,0,0])
        mirror([1,0,0])
            mini_rail();
}


module mini_rail() {
    rotate([90,0,0])
        cylinder(r = mini_rail_x - sled_rail_tolerance, h = case_y);
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
                cylinder( h = mini_sled_y, r = mini_rail_x);
        translate([-mini_sled_x/2,7,mini_sled_z/2])
            rotate([90,0,0])
                cylinder( h = mini_sled_y, r = mini_rail_x);

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

module mini_standoff() {
        cylinder(h = sled_standoff_height, r = 3);
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

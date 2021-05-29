use <hex-mesh.scad>;

$fn = 180;

sled_x = 70;
sled_y = 90;

sled_height = 10;

fan_thickness = 11;
fan_x = 40;
fan_y = 40;

case_x = sled_x + 10;
case_y = sled_y + fan_thickness;
case_z = 44;
case_wall_thickness = 2;

rail_x = 10;

mesh_corner_radius = 2;
mesh_size = 9;
mesh_thickness = 2;


housing();

translate([5+sled_x/2,sled_y-7,sled_height])
    sled();


module housing() {
    intersection() {
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
            translate([0,case_y,0])
                rotate([90,0,0])
                    hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = (case_x - fan_x)/2, y = case_z, z = fan_thickness);  // back left;
            translate([fan_x + (case_x - fan_x)/2,case_y,0])
                rotate([90,0,0])
                    hex_mesh(corner_radius = mesh_corner_radius, size = mesh_size, thickness = mesh_thickness, x = (case_x - fan_x)/2, y = case_z, z = fan_thickness);  // back right;
            rails();
        }
    }
}

module rails() {
    rail();
    translate([case_x,0,0])
    mirror([1,0,0])
        rail();
}

module rail() {
    difference() {
        translate([mesh_corner_radius,case_y,sled_height + 1])
            rotate([90,0,0])
                hexagon(corner_radius = mesh_corner_radius, size = rail_x - mesh_corner_radius, z = case_y, quality = 30); // rail
        translate([5,-1,sled_height-0.5])
            rail_cutout(); // sled cutout
        translate([-12,-1,-case_z/2])
            cube([12,case_y+2,case_z]); // trim
    }
}

module rail_cutout() {
        cube([sled_x+1,sled_y,3]);
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
            grip();
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

module standoff() {
        cylinder(h=7, r = 3);
}

module grip() {
    intersection() {
        translate([-sled_x/2,-103,0])
            cube([sled_x,20,10]);
        cylinder(h=7, r=100);
    }
}

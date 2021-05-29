hex_mesh(corner_radius = 2, size = 9, thickness = 2, x = 40, y = 101, z = 2, quality = 60);

module hex_mesh(corner_radius = 2, size = 5, thickness = 3, x = 100, y = 150, z = 1, quality = 30) {
    inner_size = cos(30) * (size - corner_radius) + corner_radius;
    hexes_x = ceil(x / (inner_size * 2)) + 1;
    hexes_y = ceil(y / (inner_size * 2)) + 1;
    grid_x = (hexes_x * inner_size * 2) + (hexes_x - 1) * thickness;
    grid_y = sin(60) * (hexes_y * inner_size * 2) + (hexes_y - 1) * thickness;

    difference() {
        cube([x,y,z]);
        difference() {
            translate([inner_size-(grid_x-x)/2,inner_size-(grid_y-y)/2,-z/2])
                union() {
                    for (i = [0:hexes_x-1]) {
                        for (j = [0:1:hexes_y-1]) {
                            translate([i * ((inner_size *2) + thickness) + (j % 2 * (inner_size + thickness/2)),j * sin(60) * ((inner_size * 2 ) + thickness),0])
                               hexagon(corner_radius = corner_radius, size = size, z = z*2, quality = quality);
                        }
                    }
                }
            frame(x = x, y = y, z = z, thickness = thickness);
        }
    }
}

module hexagon(corner_radius = 2, size = 5, z = 1, quality = 30) {
    linear_extrude(z)
        hull() {
            for (i = [0:60:360]) {
            rotate([0,0,i])
                translate([0,size-corner_radius])
                    circle(r = corner_radius, $fn=quality);
                }
        }
}

module frame(x = 100, y = 150, z = 1, thickness = 3) {
        difference() {
            cube([x,y,z]);
            translate([thickness,thickness,-z/2])
                cube([x-thickness*2, y-thickness*2, z*2]);
        }
}
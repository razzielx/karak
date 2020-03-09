module center_cross(width, thickness, height){
    translate([0,0,height/2]){
        union(){
            cube(size= [width, thickness, height], center = true );
            cube(size= [thickness, width, height], center = true);    
        }
    }
}

module notch(width, height, thickness){
//    translate([-width/2,0, 0]){
//        cube(size=[width, height, thickness]);
//    }
    scale([width, height, 1]){
        linear_extrude(height = thickness){
            polygon(points=[[-0.4,0],[-0.5,1],[0.5,1],[0.4,0]], paths=[[0,1,2,3]]);
        }
    }
    
}

tile_size = 45;

cross_width = 10;
cross_thickness = 1;
cross_height = 2;

cross_x_count = 2;
cross_y_count = 4;

desk_x_size = cross_x_count*(tile_size + cross_thickness);
desk_y_size = cross_y_count*(tile_size + cross_thickness);

desk_thickness = 1;

notch_width = tile_size;
notch_height = tile_size/3;

difference(){
    union(){
        //Base desk
        cube(size=[desk_x_size, desk_y_size, desk_thickness]);

        //positive notch top
        translate([desk_x_size/2,desk_y_size, 0]){
            notch(notch_width, notch_height,  desk_thickness);
        }

        //positive notch right
        translate([desk_x_size,desk_y_size/2, 0]){
            rotate([0,0,-90]){
                notch(notch_width, notch_height,  desk_thickness);
            }
        }

        //Crosses
        translate([0, 0, desk_thickness]) {
            for (i=[0:cross_x_count-1]) {
                for (j=[0:cross_y_count-1]) {
                    x_offset = i*(tile_size + cross_thickness) + tile_size/2 + cross_thickness/2;
                    y_offset = j*(tile_size + cross_thickness) + tile_size/2 + cross_thickness/2;
                    translate([x_offset, y_offset,0]) {
                        center_cross(cross_width,cross_thickness,cross_height);
                    }
                }
            }
        }
    }

    //Holes
    for (i=[1:cross_x_count-1]) {
        for (j=[1:cross_y_count-1]) {
            x_offset = i*(tile_size + cross_thickness);
            y_offset = j*(tile_size + cross_thickness);
            translate([x_offset, y_offset,desk_thickness/2]) {
                cylinder(r=tile_size*0.4, h=desk_thickness*2, center=true);
            }
        }
    }

    translate([0,0,-desk_thickness/2]){
        scale([1,1, 2]){
            //negative notch bottom
            translate([desk_x_size/2, 0, 0]){
                notch(notch_width, notch_height,  desk_thickness);
            }

            //negative notch left
            translate([0,desk_y_size/2, 0]){
                rotate([0,0,-90]){
                    notch(notch_width, notch_height,  desk_thickness);
                }
            }
        }
    }
}




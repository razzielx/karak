//All dimensions in mm

//Karak tile size
tile_size = 45;

/*[ Cross Properties ]*/
cross_width = 10;
//Thickness (affects space between tiles)
cross_thickness = 1;
//Height above board
cross_height = 2;

/*[ Board Properties ]*/
board_width_mm = 190;
board_height_mm = 230;
board_thickness = 2;

function getCount(size) = floor((size - notch_height) /
                                (tile_size + cross_thickness));

notch_width = tile_size;
notch_height = tile_size / 3;


// number of tiles in both directions automatically calculated from desired size
// in mm
cross_x_count = getCount(board_width_mm);  // or set to a fixed number
cross_y_count = getCount(board_height_mm);

board_x_size = cross_x_count * (tile_size + cross_thickness);
board_y_size = cross_y_count * (tile_size + cross_thickness);

module center_cross(width, thickness, height) {
  translate([ 0, 0, height / 2 ]) {
    union() {
      cube(size = [ width, thickness, height ], center = true);
      cube(size = [ thickness, width, height ], center = true);
    }
  }
}

module notch(width, height, thickness) {
  scale([ width, height, 1 ]) {
    linear_extrude(height = thickness) {
      polygon(points = [ [ -0.4, 0 ], [ -0.5, 1 ], [ 0.5, 1 ], [ 0.4, 0 ] ],
              paths = [[ 0, 1, 2, 3 ]]);
    }
  }
}


difference() {
  union() {
    // Base board
    cube(size = [ board_x_size, board_y_size, board_thickness ]);

    // positive notch top
    translate([ board_x_size / 2, board_y_size, 0 ]) {
      notch(notch_width, notch_height, board_thickness);
    }

    // positive notch right
    translate([ board_x_size, board_y_size / 2, 0 ]) {
      rotate([ 0, 0, -90 ]) {
        notch(notch_width, notch_height, board_thickness);
      }
    }

    // Crosses
    translate([ 0, 0, board_thickness ]) {
      for (i = [0:cross_x_count - 1]) {
        for (j = [0:cross_y_count - 1]) {
          x_offset = i * (tile_size + cross_thickness) + tile_size / 2 +
                     cross_thickness / 2;
          y_offset = j * (tile_size + cross_thickness) + tile_size / 2 +
                     cross_thickness / 2;
          translate([ x_offset, y_offset, 0 ]) {
            center_cross(cross_width, cross_thickness, cross_height);
          }
        }
      }
    }
  }

  // Holes
  for (i = [1:cross_x_count - 1]) {
    for (j = [1:cross_y_count - 1]) {
      x_offset = i * (tile_size + cross_thickness);
      y_offset = j * (tile_size + cross_thickness);
      translate([ x_offset, y_offset, board_thickness / 2 ]) {
        cylinder(r = tile_size * 0.4, h = board_thickness * 2, center = true);
      }
    }
  }

  translate([ 0, 0, -board_thickness / 2 ]) {
    scale([ 1, 1, 2 ]) {
      // negative notch bottom
      translate([ board_x_size / 2, 0, 0 ]) {
        notch(notch_width, notch_height, board_thickness);
      }

      // negative notch left
      translate([ 0, board_y_size / 2, 0 ]) {
        rotate([ 0, 0, -90 ]) {
          notch(notch_width, notch_height, board_thickness);
        }
      }
    }
  }
}

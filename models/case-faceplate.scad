include <MCAD/units.scad>

// Height in mm
height = 100;

// Has button?
has_button = true;

width = 12 * inch;
tophole_x_offset = 3 * inch;
tophole_y_offset = (3/8) * inch;
sidehole_x_offset = (5/8) * inch;
hole_dia = (1/4) * inch;

button_side_offset = (1 + 3/4) * inch;
button_offset = (1 + 5/8) * inch;
button_top_offset = (height < (button_offset * 2))
    ? (height / 2)
    : button_offset;
button_dia = 1 * inch;

difference() {
  square([width, height]);
    
  translate([sidehole_x_offset, height / 2, 0])
    circle(d = hole_dia);
  translate([width - sidehole_x_offset, height / 2, 0])
    circle(d = hole_dia);
    
  translate([tophole_x_offset, tophole_y_offset, 0])
    circle(d = hole_dia);
  translate([tophole_x_offset, height - tophole_y_offset])
    circle(d = hole_dia);
  translate([width - tophole_x_offset, tophole_y_offset, 0])
    circle(d = hole_dia);
  translate([width - tophole_x_offset, height - tophole_y_offset])
    circle(d = hole_dia);
  
  if (has_button) {
    translate([button_side_offset, height - button_top_offset, 0])
      circle(d = button_dia);
  }
}

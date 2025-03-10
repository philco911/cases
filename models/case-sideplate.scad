include <MCAD/units.scad>

// Height in mm
height = 100;

plate_thickness = (1/8) * inch;
width = 12 * inch;
tophole_x_offset = 3 * inch;
tophole_y_offset = (3/8) * inch;
sidehole_x_offset = (5/8) * inch;
hole_dia = (1/4) * inch;

difference() {
  // The faceplate goes the full width so the sides get cut back by the plate thickness. This does mean there's a front and back edge.
  square([width - plate_thickness, height]);
    
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
}
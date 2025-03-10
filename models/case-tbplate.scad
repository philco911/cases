include <MCAD/units.scad>

// Put vent slots in?
has_vents = true;

// Has half rack bottom cutout?
has_cutout = false;

// Drill mATX standoff holes?
has_matx = true;

width = 12 * inch;
hole_offset = (5/8) * inch;
hole_dia = (1/4) * inch;
slot_thickness = (1/8) * inch;
slot_length = 4 * inch;
slot_offset = 1 * inch;
slot_spacing = (3/8) * inch;
cutout_depth = 5 * inch;
cutout_offset = 1 * inch;
matx_dia = 3 * mm;
matx_inset = 1.083 * inch;
matx_offset = 1.250 * inch;
matx_width = 9.600 * inch;

matx_holes = [
  [0.400 * inch, 1.350 * inch],
  [0.400 * inch, 3.150 * inch],
  [1.300 * inch, 9.350 * inch],
  [6.500 * inch, 1.350 * inch],
  [6.500 * inch, 3.150 * inch],
  [6.500 * inch, 9.350 * inch],
  [6.500 * inch, 0.550 * inch],
  [9.350 * inch, 3.150 * inch],
  [9.350 * inch, 9.350 * inch]
];

module slot(length, thick) {
  union() {
    circle(d = thick);
    translate([length, 0, 0])
      circle(d = thick);
    translate([length / 2, 0, 0])
      square([length, thick], center = true);
  }
}

module matx(d) {
  union() {
    for(hole=matx_holes) {
      translate([hole[0], hole[1], 0])
        circle(d = d);
    }
  }
}

difference() {
  union() {
    difference() {
      square([width, width]);
        
      translate([hole_offset, hole_offset, 0])
        circle(d = hole_dia);
      translate([width - hole_offset, hole_offset, 0])
        circle(d = hole_dia);
      translate([hole_offset, width - hole_offset, 0])
        circle(d = hole_dia);
      translate([width - hole_offset, width - hole_offset, 0])
        circle(d = hole_dia);
      
      if (has_vents) {
        translate([slot_offset, width / 2, 0])
          slot(thick = slot_thickness, length = slot_length);
        for(dy=[slot_spacing:slot_spacing:((width / 2) - slot_offset)]) {
          translate([slot_offset, (width / 2) + dy, 0])
            slot(thick = slot_thickness, length = slot_length);
          translate([slot_offset, (width / 2) - dy, 0])
            slot(thick = slot_thickness, length = slot_length);
        }
      }
      
      if (has_cutout) {
        translate([width - cutout_depth, cutout_offset, 0])
          square([cutout_depth, width - (cutout_offset * 2)]);
      }
    }
    
    if (has_matx) {
      translate([width - matx_inset, matx_width + matx_offset, 0])
        rotate([0, 0, 180])
        matx(d = (matx_dia * 3));
    }
  }

  if (has_matx) {
    translate([width - matx_inset, matx_width + matx_offset, 0])
      rotate([0, 0, 180])
      matx(d = matx_dia);
  }
}
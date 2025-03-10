include <MCAD/units.scad>

// Height in mm
height = 100;

// Has button?
has_button = true;

width = 10 * inch;
thick = (7/8) * inch;
ledge = (1/2) * inch;
wall = (1/4) * inch;
slope = (1/4) * inch;
hole_top_offset = (3/8) * inch;
hole_side_offset = 2 * inch;
hole_dia = (1/4) * inch;
button_side_offset = (3/4) * inch;
button_top_offset = (1 + (5/8)) * inch;
button = (height < (button_top_offset * 2)) ? (height / 2) : button_top_offset;
button_dia = (1 + (1/8)) * inch;
button_hole_dia = 20 * mm;
gap = 20 * mm;
gap_spacing = 1.414 * gap + 5;
h_gap_span = (width / 2) - hole_side_offset;
v_gap_span = (height / 2) - hole_top_offset;
bump_height = (1/8) * inch;
bump_dia = (3/8) * inch;

tol = 0.3 * mm;

module gap_row() {
  union() {
    rotate([-90, 45, 0])
      cube(gap, center = true);
    
    for(dx=[gap_spacing:gap_spacing:h_gap_span]) {
      translate([-dx, 0, 0])
        rotate([-90, 45, 0])
        cube(gap, center = true);
      translate([dx, 0, 0])
        rotate([-90, 45, 0])
        cube(gap, center = true);
    }
  }
}

module gaps() {
  union() {
    if ((v_gap_span % gap_spacing) < (gap_spacing / 2)) {
      for(dz=[gap_spacing / 2:gap_spacing:v_gap_span]) {
        translate([0, 0, -dz])
          gap_row();
        translate([0, 0, dz])
          gap_row();
      }
    } else {
      gap_row();
      
      for(dz=[gap_spacing:gap_spacing:v_gap_span]) {
        translate([0, 0, -dz])
          gap_row();
        translate([0, 0, dz])
          gap_row();
      }
    }
  }
}

module bump() {
  rotate_extrude() {
    poly = [
      [0, 0],
      [0, -bump_height],
      [bump_dia / 2, -bump_height],
      [(bump_dia / 2) + bump_height, 0],
      [0, 0]];
    polygon(poly);
  }
}

difference() {
  union() {
    linear_extrude(height) {
      poly = [
        [0, 0],
        [0, ((3/8) * inch) - tol],
        [((1/8) * inch) + tol, ((1/4) * inch) - tol],
        [((1/8) * inch) + tol, ((3/4) * inch) + tol],
        [0, ((5/8) * inch) + tol],
        [0, thick],
        [ledge, thick],
        [ledge + slope, wall],
        [width - slope - ledge, wall],
        [width - ledge, thick],
        [width, thick],
        [width, ((5/8) * inch) + tol],
        [width - ((1/8) * inch) - tol, ((3/4) * inch) + tol],
        [width - ((1/8) * inch) - tol, ((1/4) * inch) - tol],
        [width, ((3/8) * inch) - tol],
        [width, 0],
        [0,0]];
      polygon(poly);
    }
    translate([hole_side_offset, wall, hole_top_offset])
      rotate([90, 0, 0])
      bump();
    translate([width - hole_side_offset, wall, hole_top_offset])
      rotate([90, 0, 0])
      bump();
    translate([hole_side_offset, wall, height - hole_top_offset])
      rotate([90, 0, 0])
      bump();
    translate([width - hole_side_offset, wall, height - hole_top_offset])
      rotate([90, 0, 0])
      bump();
  }
  
  translate([hole_side_offset, 0, hole_top_offset])
    rotate([-90, 0, 0])
    cylinder(h = thick, d = hole_dia);
  translate([width - hole_side_offset, 0, hole_top_offset])
    rotate([-90, 0, 0])
    cylinder(h = thick, d = hole_dia);
  
  translate([hole_side_offset, 0, height - hole_top_offset])
    rotate([-90, 0, 0])
    cylinder(h = thick, d = hole_dia);
  translate([width - hole_side_offset, 0, height - hole_top_offset])
    rotate([-90, 0, 0])
    cylinder(h = thick, d = hole_dia);
  
  translate([width / 2, 0, height / 2])
    gaps();
  
  if (has_button) {
    translate([button_side_offset, (1/8) * inch, height - button])
      rotate([-90, 0, 0])
      cylinder(h = thick,d = button_dia);
    
    translate([button_side_offset, 0, height - button])
      rotate([-90, 0, 0])
      cylinder(h = thick,d = button_hole_dia);
  }
}
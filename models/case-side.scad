include <MCAD/units.scad>

// Height in mm
height = 89;

// Has rackmount rail?
has_rail = true;

width = 10 * inch;
thick = (7/8) * inch;
ledge = (1/2) * inch;
wall = (1/4) * inch;
slope = (1/4) * inch;
rail = 0.625 * inch;
hole_top_offset = (3/8) * inch;
hole_side_offset = 2 * inch;
hole_dia = (1/4) * inch;
gap = 26 * mm;
gap_spacing = 1.414 * gap + 8;
h_gap_span = (width / 2) - ledge - slope;
v_gap_span = (height / 2) - hole_top_offset;
bump_height = (1/8) * inch;
bump_dia = (3/8) * inch;
rail_dia = 8 * mm;
rail_offset = 0.344 * inch;
rail_hole = 0.625 * inch;
rail_spacing = 1.752 * inch;

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

module rail_holes() {
  union() {
    cylinder(h = ledge, d = rail_dia);
    translate([rail_hole, 0, 0])
      cylinder(h = ledge, d = rail_dia);
    translate([-rail_hole, 0, 0])
      cylinder(h = ledge, d = rail_dia);
  }
}

difference() {
  union() {
    linear_extrude(height) {
      poly_0 = [
        [0, 0],
        [0, ((3/8) * inch) - tol],
        [((1/8) * inch) + tol, ((1/4) * inch) - tol],
        [((1/8) * inch) + tol, ((3/4) * inch) + tol],
        [0, ((5/8) * inch) + tol],
        [0, thick]];
      poly_1 = [
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
      if (has_rail) {
        polygon(concat(poly_0, [[0, thick + rail], [ledge, thick + rail]], poly_1));
      } else {
        polygon(concat(poly_0, poly_1));
      }
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
  
  if (has_rail) {
    for(dz=[(rail_spacing / 2):rail_spacing:height]) {
      translate([0, thick + rail_offset, dz])
        rotate([0, 90, 0])
        rail_holes();
    }
  }
}
include <MCAD/units.scad>
use <MCAD/metric_fastners.scad>

// Height in mm
height = 100;

// Dovetail on second side?
dovetail = true;

// Bolt holes on second side?
bolts = false;

hole_dia = 4.2 * mm; // drill size for 5mm tap
width = (7/8) * inch;
tol = 0.3 * mm;

difference() {
  linear_extrude(height) {
    difference() {
      if (dovetail) {
        poly = [
          [0, 0],
          [0, ((1/4) * inch) + tol],
          [(-(1/8) * inch) - tol, ((1/8) * inch) + tol],
          [(-(1/8) * inch) - tol, ((5/8) * inch) - tol],
          [0, ((1/2) * inch) - tol],
          [0, width], [width - 1, width],
          [width, width - 1],
          [width, 0],
          [((1/2) * inch) - tol, 0],
          [((5/8) * inch) - tol, (-(1/8) * inch) - tol],
          [((1/8) * inch) + tol, (-(1/8) * inch) - tol], 
          [((1/4) * inch) + tol, 0], [0,0]];
        polygon(poly);
      } else {
        poly = [
          [0, 0],
          [0, ((1/4) * inch) + tol],
          [(-(1/8) * inch) - tol, ((1/8) * inch) + tol],
          [(-(1/8) * inch) - tol, ((5/8) * inch) - tol],
          [0, ((1/2) * inch) - tol],
          [0, width],
          [width - 1, width],
          [width, width - 1],
          [width, 1],
          [width - 1, 0],
          [0,0]];
        polygon(poly);
      }
      translate([(3/8) * inch, (3/8) * inch])
        circle(d = hole_dia);
    };
  }
  
  translate([(3/8) * inch, dovetail ? 1 : -1, height / 2])
    rotate([-90, 0, 0])
    cylinder(h = width * 2 + 2, d = hole_dia);
  translate([1, (3/8) * inch, height / 2])
    rotate([-90, 0, -90])
    cylinder(h = width * 2 + 2, d = hole_dia);

  if (bolts) {
    translate([(1/8) * inch, width, (1/2) * inch])
      rotate([90, 0, 0])
      csk_bolt(3, width + 4);
    translate([(5/8) * inch, width, (1/2) * inch])
      rotate([90, 0, 0])
      csk_bolt(3, width + 4);
    
    translate([(1/8) * inch, width, height - ((1/2) * inch)])
      rotate([90, 0, 0])
      csk_bolt(3, width + 4);
    translate([(5/8) * inch, width, height - ((1/2) * inch)])
      rotate([90, 0, 0])
      csk_bolt(3, width + 4);
   }
}
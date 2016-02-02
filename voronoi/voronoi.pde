// Author: Guillermo Alonso Nunez
// e-mail: guillermo.alonso.nunez@alumnos.upm.es

import megamu.mesh.*;

final int scale = 500; // size values at the start of setup should have this value

// Executed once
void setup() {
  size(500, 500); // set these values to the same of scale!
  
  if (height != scale || width != scale) {
    System.out.println(err_incorr_size);
    exit();
  }
  
  initializePartition(lineNumber);
  initializeBarycenters(); // calculate the barycenters for each polygon of the partition
  my_voronoi = new Voronoi(barycenters); // create Voronoi diagram from the barycenters
}

// Executed every frame
void draw() {
  // order of drawing is important because of overlapping
  drawVoronoi();
  drawPoints();
  drawBarycenters();
}
// Draws the Barycenters of the polygons of the given partition
void drawBarycenters() {
        stroke(0,0,255); // draw in blue
        strokeWeight(5); // draw thick points

        for (int i = 0; i < barycenters.length; i++)
                point(barycenters[i][0], barycenters[i][1]);

        stroke(0); // draw in black
        strokeWeight(1); // draw normal size
}

// Draws the Voronoi diagram
void drawVoronoi() {
        MPolygon[] myRegions = my_voronoi.getRegions();
        fill(255,0,0); //fill in red
          
        for(int i=0; i<myRegions.length; i++)
                myRegions[i].draw(this); // draw this shape
          
        fill(0); //fill in black
}

// Draws the "points" array to the screen
void drawPoints() {
        stroke(0,255,0); //draw in green
        
        for (int i = 0; i < partition.length; i++) { // for each polygon
                line( partition[i][0][0] * scale, // connect first and last
                        partition[i][0][1] * scale,
                        partition[i][partition[i].length - 1][0] * scale,
                        partition[i][partition[i].length - 1][1] * scale); 
                for (int j = 0; j < partition[i].length - 1; j++)
                        line( partition[i][j][0] * scale, 
                                partition[i][j][1] * scale,
                                partition[i][j+1][0] * scale,
                                partition[i][j+1][1] * scale);
        }
        stroke(0); //draw in black
}
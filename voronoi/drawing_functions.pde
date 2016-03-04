// Draws the Barycenters of the polygons of the given partition
void drawBarycenters() {
    stroke(0,70,70); // draw in dark green
    strokeWeight(5); // draw thick points

    for (int i = 0; i < barycenters.length; i++)
        point(barycenters[i][0], barycenters[i][1]);

    stroke(0); // draw in black
    strokeWeight(1); // draw normal size
}

void draw_pol(ArrayList<float []> pol) {
    for (int i = 0; i < pol.size(); i++){
      int next_i = (i == pol.size() - 1) ? 0 : i + 1;
      
      line(pol.get(i)[0], pol.get(i)[1], pol.get(next_i)[0], pol.get(next_i)[1]);
    }
}

// Draws the Voronoi diagram - DEPRECATED
void drawVoronoi() {
    MPolygon[] myRegions = my_voronoi.getRegions();
    fill(255,0,0); //fill in red
    strokeWeight(3); // draw thick lines
      
    for(int i = 0; i < myRegions.length; i++)
        myRegions[i].draw(this); // draw this shape
      
    fill(0); //fill in black
    strokeWeight(1); // draw normal size
}

// Draws the Voronoi diagram from the float points
void drawFlVoronoi() {
    stroke(0,0,255); //fill in blue
    strokeWeight(2); // draw thick lines
      
    for(int i = 0; i < fl_voronoi.length; i++) {
        line( fl_voronoi[i][0][0], // connect first and last
                fl_voronoi[i][0][1],
                fl_voronoi[i][fl_voronoi[i].length - 1][0],
                fl_voronoi[i][fl_voronoi[i].length - 1][1]); 
        for (int j = 0; j < fl_voronoi[i].length - 1; j++)
            line( fl_voronoi[i][j][0], 
                    fl_voronoi[i][j][1],
                    fl_voronoi[i][j+1][0],
                    fl_voronoi[i][j+1][1]);
    } 
      
    stroke(0); //fill in black
    strokeWeight(1); // draw normal size
}

// Draws the "points" array to the screen
void drawPoints() {
    stroke(0,255,0); //draw in green
    strokeWeight(2); // draw thick lines
    
    for (int i = 0; i < partition.length; i++) { // for each polygon
        line( partition[i][0][0], // connect first and last
                partition[i][0][1],
                partition[i][partition[i].length - 1][0],
                partition[i][partition[i].length - 1][1]); 
        for (int j = 0; j < partition[i].length - 1; j++)
            line( partition[i][j][0], 
                    partition[i][j][1],
                    partition[i][j+1][0],
                    partition[i][j+1][1]);
    }
    stroke(0); //draw in black
    strokeWeight(1); // draw normal size
}
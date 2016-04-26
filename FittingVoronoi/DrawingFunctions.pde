// Draws the Barycenters of the polygons of the given partition
void drawBarycenters() {
    stroke(0,70,70); // draw in dark green
    strokeWeight(3);

    for (int i = 0; i < barycenters.size(); i++)
        point(barycenters.get(i)[0], barycenters.get(i)[1]);

    clearDrawingSettings();
}

void drawPart(ArrayList<ArrayList<float []>> partition, color col) {
    stroke(col);

    for (int i = 0; i < partition.size(); i++)
        drawPol(partition.get(i), col);

    clearDrawingSettings();
}

void drawPol(ArrayList<float []> pol, color col) {
    stroke(col);
  
    for (int i = 0; i < pol.size(); i++) {
      int iNext = (i == pol.size() - 1) ? 0 : i + 1;
      
      line(pol.get(i)[0], pol.get(i)[1], pol.get(iNext)[0], pol.get(iNext)[1]);
    }

    clearDrawingSettings();
}

void clearDrawingSettings() {
    strokeWeight(1);
    stroke(defaultBlack);
}
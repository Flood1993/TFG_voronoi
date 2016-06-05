// Author: Guillermo Alonso Nunez
// e-mail: guialonun@gmail.com

float drawingOffset = 50;

// Draws the Barycenters of the polygons of the given tessellation
void drawBarycenters() {
    stroke(0,70,70); // draw in dark green
    strokeWeight(3);

    for (int i = 0; i < barycenters.size(); i++)
        point(barycenters.get(i)[0] + drawingOffset, barycenters.get(i)[1] + drawingOffset);

    clearDrawingSettings();
}

void drawPart(ArrayList<ArrayList<float []>> tessellation, color col) {
    stroke(col);

    for (int i = 0; i < tessellation.size(); i++)
        drawPol(tessellation.get(i), col);

    clearDrawingSettings();
}

void drawPol(ArrayList<float []> pol, color col) {
    stroke(col);
  
    for (int i = 0; i < pol.size(); i++) {
      int iNext = (i == pol.size() - 1) ? 0 : i + 1;
      
      line(pol.get(i)[0] + drawingOffset, pol.get(i)[1] + drawingOffset, pol.get(iNext)[0] + drawingOffset, pol.get(iNext)[1] + drawingOffset);
    }

    clearDrawingSettings();
}

void clearDrawingSettings() {
    strokeWeight(1);
    stroke(defaultBlack);
}

void drawTextGUI() {
    fill(0, 0, 0);
    textSize(13);

    float xCoord = scale + drawingOffset*1.5;

    text("· SD at start: " + String.format("%.5f", symDiffAtStart), xCoord, 30);
    text("· SD currently: " + String.format("%.5f", symmetricDiff), xCoord, 50);
    text("· Step count: " + stepCount, xCoord, 70);
    text("· Total regions: " + barycenters.size(), xCoord, 90);

    if (finished)
        text("--- FINISHED EXECUTION ---", xCoord, 150);

    fill(backgroundColor);
}
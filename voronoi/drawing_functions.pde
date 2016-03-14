// Draws the Barycenters of the polygons of the given partition
void drawBarycenters() {
    stroke(0,70,70); // draw in dark green
    strokeWeight(3);

    for (int i = 0; i < barycenters.size(); i++)
        point(barycenters.get(i)[0], barycenters.get(i)[1]);

    stroke(0); // draw in black
    strokeWeight(1); // draw normal size
}

void draw_part(ArrayList<ArrayList<float []>> partition) {
    for (int i = 0; i < partition.size(); i++)
        draw_pol(partition.get(i));
}

void draw_pol(ArrayList<float []> pol) {
    for (int i = 0; i < pol.size(); i++) {
      int next_i = (i == pol.size() - 1) ? 0 : i + 1;
      
      line(pol.get(i)[0], pol.get(i)[1], pol.get(next_i)[0], pol.get(next_i)[1]);
    }
}
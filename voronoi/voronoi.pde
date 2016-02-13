// Author: Guillermo Alonso Nunez
// e-mail: guillermo.alonso.nunez@alumnos.upm.es

import megamu.mesh.*;

final int scale = 500; // size parameters should have this value

// Executed once
void setup() {
        size(500, 500); // set these values to the same of scale!

        if (height != scale || width != scale) { // check size
                System.out.println(err_incorr_size);
                exit();
        }

        initializePartition(lineNumber);
        initializeBarycenters();
        my_voronoi = new Voronoi(barycenters);
}

// Executed every frame
void draw() {
        // order of drawing is important because of overlapping
        drawVoronoi();
        drawPoints();
        drawBarycenters();
}

// First point above the height of the barycenter for a partition polygon
int find_first_point(int n) {
        int cur = 0;
        float _height = barycenters[n][1];
        int part_len = partition[n].length;
        
        if (partition[n][cur][1] >= _height) { // point above, move clockwise
                while (partition[n][(cur + 1) % part_len][1] >= _height)
                        cur = (cur + 1) % part_len;
        } else { // point below, move anti-clockwise
                while (partition[n][(cur - 1 + part_len) % part_len][1] < 
                                height)
                        cur = (cur - 1 + part_len) % part_len;
        }

        return cur;
}

// Returns whether the point 1 changed its coordinates to be inside the square
// of scale*scale
float[][] intersect_points(float pts[][]) {
        float[][] res = new float[pts.length][2];

        boolean changed = true;

        while (changed) {
                changed = false;

                // if first point is in: copy it
                // else if first point is out and prev is in: adjust. changed TRUE
                // for every other point:
                        // if point n is in: copy it
                        // if point n is out and prev is in: adjust. changed TRUE




                if (pts[0][0] >= 0 &&
                                pts[0][0] <= scale &&
                                pts[0][1] >= 0 &&
                                pts[0][1] <= scale) { // if first point is in: copy it
                        
                }

                if ((pts[0][0] < 0 || // check first point
                                pts[0][0] > scale ||
                                pts[0][1] < 0 ||
                                pts[0][1] > scale) && // point 1 out
                                (pts[pts.length - 1][0] >= 0 &&
                                pts[pts.length - 1][0] <= scale &&
                                pts[pts.length - 1][1] >= 0 &&
                                pts[pts.length - 1][1] <= scale)) { // prev in
                        if (pts[0][0])
                        changed = true;
                }
        }

        
}
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
    //fl_voronoi = intersectVoronoi(my_voronoi);
    
    System.out.println(init_succesful);
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

// 1. Para cada polígono, meto en la lista ordenadamente todas las
//    intersecciones, hasta llegar al punto de partida.
// 2. Si empece en un punto de fuera, cuidado, que al volver puedo haber
//    recortado una esquina.
// 3. Después, simplemente tengo que ir mirando que puntos me sobran de esa
//    lista
// 4. Mucho cuidado con las intersecciones, si salgo y vuelvo por otra cara,
//    hay que meter la esquina a mano
float[][] intersect_points(float pts[][]) {
    float[][] res = pts.clone();

    boolean changed = true;

    while (changed) {
        changed = false;

        // check the first point
        // if its out and previous is in, we adjust it
        if ((res[0][0] < 0 || 
                res[0][0] > scale ||
                res[0][1] < 0 ||
                res[0][1] > scale) &&
                (res[res.length - 1][0] >= 0 &&
                res[res.length - 1][0] <= scale &&
                res[res.length - 1][1] >= 0 &&
                res[res.length - 1][1] <= scale)) {
            // same x coord
            if (res[0][0] == res[res.length - 1][0]) {
                if (res[0][1] < 0)
                    res[0][1] = 0;
                if (res[0][1] > scale)
                    res[0][1] = scale;
            }
            // same y coord
            else if (res[0][1] == res[res.length - 1][1]) {
                if (res[0][0] < 0)
                    res[0][0] = 0;
                if (res[0][0] > scale)
                    res[0][0] = scale;
            }
            else { // diagonal line
                if (res[0][0] < 0) { 
                    float y_inter = ver_inter(res[0][0], res[0][1], 
                            res[res.length - 1][0], res[res.length - 1][1], 0);
                    if (y_inter >= 0 && y_inter <= scale) {
                        res[0][0] = 0;
                        res[0][1] = y_inter;
                    }
                }
                if (res[0][0] > scale) {
                    float y_inter = ver_inter(res[0][0], res[0][1],
                            res[res.length - 1][0], res[res.length - 1][1],
                            scale);
                    if (y_inter >= 0 && y_inter <= scale) {
                        res[0][0] = scale;
                        res[0][1] = y_inter;
                    }
                }
                if (res[0][1] < 0) {
                    float x_inter = hor_inter(res[0][0], res[0][1],
                            res[res.length - 1][0], res[res.length - 1][1], 0);
                    if (x_inter >= 0 && x_inter <= scale) {
                        res[0][0] = x_inter;
                        res[0][1] = 0;
                    }
                }
                if (res[0][1] > scale) {
                    float x_inter = hor_inter(res[0][0], res[0][1],
                            res[res.length - 1][0], res[res.length - 1][1],
                            scale);
                    if (x_inter >= 0 && x_inter <= scale) {
                        res[0][0] = x_inter;
                        res[0][1] = scale;
                    } 
                }
            }
            changed = true;
        }

        // For every other point
        for (int i = 1; i < res.length; i++) {
            if ((res[i][0] < 0 || 
                    res[i][0] > scale ||
                    res[i][1] < 0 ||
                    res[i][1] > scale) &&
                    (res[i - 1][0] >= 0 &&
                    res[i - 1][0] <= scale &&
                    res[i - 1][1] >= 0 &&
                    res[i - 1][1] <= scale)) {
                // same x coord
                if (res[i][0] == res[i - 1][0]) {
                    if (res[i][1] < 0)
                        res[i][1] = 0;
                    if (res[i][1] > scale)
                        res[i][1] = scale;
                }
                // same y coord
                else if (res[i][1] == res[i - 1][1]) {
                    if (res[i][0] < 0)
                        res[i][0] = 0;
                    if (res[i][0] > scale)
                        res[i][0] = scale;
                }
                else { // diagonal line
                    if (res[i][0] < 0) { 
                        float y_inter = ver_inter(res[i][0], res[i][1],
                                res[i - 1][0], res[i - 1][1], 0);
                        if (y_inter >= 0 && y_inter <= scale) {
                            res[i][0] = 0;
                            res[i][1] = y_inter;
                        }
                    }
                    if (res[i][0] > scale) {
                        float y_inter = ver_inter(res[i][0], res[i][1],
                                res[i - 1][0], res[i - 1][1], scale);
                        if (y_inter >= 0 && y_inter <= scale) {
                            res[i][0] = scale;
                            res[i][1] = y_inter;
                        }
                    }
                    if (res[i][1] < 0) {
                        float x_inter = hor_inter(res[i][0], res[i][1],
                                res[i - 1][0], res[i - 1][1], 0);
                        if (x_inter >= 0 && x_inter <= scale) {
                            res[i][0] = x_inter;
                            res[i][1] = 0;
                        }
                    }
                    if (res[i][1] > scale) {
                        float x_inter = hor_inter(res[i][0], res[i][1],
                                res[i - 1][0], res[i - 1][1], scale);
                        if (x_inter >= 0 && x_inter <= scale) {
                            res[i][0] = x_inter;
                            res[i][1] = scale;
                        }
                    }
                }
                changed = true;
            }
        }
    }

    return res;
}

// Returns the x coordinate at which a line intersects y = y_pos
float hor_inter(float x1, float y1, float x2, float y2, float y_pos) {
    float t = (y_pos - y1)/(y2 - y1);
    return (x1 + (x2 - x1)*t);
}

// Returns the y coordinate at which a line intersects x = x_pos
float ver_inter(float x1, float y1, float x2, float y2, float x_pos) {
    float t = (x_pos - x1)/(x2 - x1);
    return (y1 + (y2 - y1)*t);
}

void dbg(String txt) {
    System.out.println("dbg " + txt);
    delay(200);
}
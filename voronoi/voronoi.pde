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
    fl_voronoi = intersectVoronoi(my_voronoi);
    
    System.out.println(init_succesful);
}

// Executed every frame
void draw() {
    // order of drawing is important because of overlapping
    //drawVoronoi(); // voronoi calculated from "barycenters" - DEPRECATED
    drawPoints(); // given partition
    drawBarycenters(); // calculated "barycenters"
    drawFlVoronoi(); // adjusted voronoi to square
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
    float[][] tmp = new float[pts.length + 10][2];
    // FIXME: In a near future we may want to allocate memory dinamically

    int cnt = 0;
    float tmp_f = 0.0; // to avoid allocating many different variables

    // Preprocess all points, so tmp will contain the inside points and the
    // intersection points
    for (int i = 0; i < pts.length; i++) {
        int next = (i == pts.length - 1) ? 0 : i + 1;

        if (is_point_in(pts[i])) { // we are inside
            tmp[cnt] = pts[i];
            cnt++;

            if (!is_point_in(pts[next])) {// next isn't, store intersection
                if ((tmp_f = hor_inter(pts[i], pts[next], 0)) != -1) { // 1 top
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = 0;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], scale)) != -1) { // 2 right
                    tmp[cnt][0] = scale;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], scale)) != -1) { // 3 bottom
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = scale;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], 0)) != -1) { // 4 left
                    tmp[cnt][0] = 0;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
            }
        }

        else if (is_point_in(pts[next])) { // outside and next point inside
            if (pts[i][0] < 0 && pts[i][1] < 0) { // top left
                if ((tmp_f = hor_inter(pts[i], pts[next], 0)) != -1) { // 1
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = 0;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], scale)) != -1) { // 3
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = scale;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], scale)) != -1) { // 2
                    tmp[cnt][0] = scale;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], 0)) != -1) { // 4
                    tmp[cnt][0] = 0;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
            }
            else if (pts[i][0] > scale && pts[i][1] < 0) { // top right
                if ((tmp_f = hor_inter(pts[i], pts[next], 0)) != -1) { // 1
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = 0;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], scale)) != -1) { // 2
                    tmp[cnt][0] = scale;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], scale)) != -1) { // 3
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = scale;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], 0)) != -1) { // 4
                    tmp[cnt][0] = 0;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
            }
            else if (pts[i][0] < 0 && pts[i][1] > scale) { // bottom left

                if ((tmp_f = hor_inter(pts[i], pts[next], scale)) != -1) { // 3
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = scale;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], 0)) != -1) { // 4
                    tmp[cnt][0] = 0;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], 0)) != -1) { // 1
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = 0;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], scale)) != -1) { // 2
                    tmp[cnt][0] = scale;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
            }
            else if (pts[i][0] > scale && pts[i][1] > scale) { // bottom right
                if ((tmp_f = ver_inter(pts[i], pts[next], scale)) != -1) { // 2
                    tmp[cnt][0] = scale;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], scale)) != -1) { // 3
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = scale;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], 0)) != -1) { // 4
                    tmp[cnt][0] = 0;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], 0)) != -1) { // 1
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = 0;
                    cnt++;
                }
            }
            else if (pts[i][1] < 0) { // top
                if ((tmp_f = hor_inter(pts[i], pts[next], 0)) != -1) { // 1
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = 0;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], scale)) != -1) { // 2
                    tmp[cnt][0] = scale;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], scale)) != -1) { // 3
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = scale;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], 0)) != -1) { // 4
                    tmp[cnt][0] = 0;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
            }
            else if (pts[i][0] > scale) { // right
                if ((tmp_f = ver_inter(pts[i], pts[next], scale)) != -1) { // 2
                    tmp[cnt][0] = scale;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], 0)) != -1) { // 1
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = 0;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], scale)) != -1) { // 3
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = scale;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], 0)) != -1) { // 4
                    tmp[cnt][0] = 0;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
            }
            else if (pts[i][1] > scale) { // bottom
                if ((tmp_f = hor_inter(pts[i], pts[next], scale)) != -1) { // 3
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = scale;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], 0)) != -1) { // 4
                    tmp[cnt][0] = 0;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], 0)) != -1) { // 1
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = 0;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], scale)) != -1) { // 2
                    tmp[cnt][0] = scale;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
            }
            else if (pts[i][0] < 0) { // left
                if ((tmp_f = hor_inter(pts[i], pts[next], scale)) != -1) { // 3
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = scale;
                    cnt++;
                }
                if ((tmp_f = hor_inter(pts[i], pts[next], 0)) != -1) { // 1
                    tmp[cnt][0] = tmp_f;
                    tmp[cnt][1] = 0;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], scale)) != -1) { // 2
                    tmp[cnt][0] = scale;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
                if ((tmp_f = ver_inter(pts[i], pts[next], 0)) != -1) { // 4
                    tmp[cnt][0] = 0;
                    tmp[cnt][1] = tmp_f;
                    cnt++;
                }
            }
        }
    }

    int cnt2 = 0;
    float tmp2[][] = new float[pts.length + 10][2];
    // in this process, corners may be missing. check for them
    for (int i = 0; i < cnt; i++) {
        int next = (i == cnt - 1) ? 0 : i + 1;

        tmp2[cnt2] = tmp[i];
        cnt2++;

        // If its on an edge and next too
        int edge_cur = point_in_edge(tmp[i]);
        int edge_next = point_in_edge(tmp[next]);
        // Points are on different edges
        // We use a hack that would be storing a binary representation
        if ((edge_cur != -1) && (edge_next != -1) && (edge_cur != edge_next)) {
            int hack = 0;
            if (edge_cur == 1 || edge_next == 1)
                hack += 1;
            if (edge_cur == 2 || edge_next == 2)
                hack += 2;
            if (edge_cur == 3 || edge_next == 3)
                hack += 4;
            if (edge_cur == 4 || edge_next == 4)
                hack += 8;

            if (hack == 9) { // top left must be added
                tmp2[cnt2][0] = 0;
                tmp2[cnt2][1] = 0;
                cnt2++;
            }
            if (hack == 3) {// top right must be added
                tmp2[cnt2][0] = scale;
                tmp2[cnt2][1] = 0;
                cnt2++;
            }
            if (hack == 12) { // bottom left must be added
                tmp2[cnt2][0] = 0;
                tmp2[cnt2][1] = scale;
                cnt2++;
            }
            if (hack == 6) {// bottom right must be added
                tmp2[cnt2][0] = scale;
                tmp2[cnt2][1] = scale;
                cnt2++;
            }
        }
    }

    float res[][] = new float[cnt2][2];
    for (int i = 0; i < cnt2; i++) {
        res[i][0] = tmp2[i][0];
        res[i][1] = tmp2[i][1];
    }
    pts = res;

    return pts;
}

// Returns the edge a point is in. -1 if its not.
// Point is assumed to be inside
boolean is_point_in(float pt[]) {
    return (pt[0] >= 0 && pt[0] <= scale && pt[1] >= 0 && pt[1] <= scale);
}

int point_in_edge(float pt[]) {
    if (pt[1] == 0) // top
        return 1;
    if (pt[0] == scale) // right
        return 2;
    if (pt[1] == scale) // bottom
        return 3;
    if (pt[0] == 0) // left
        return 4;

    return -1; //not in edge
}

// Returns the x coordinate at which a segment intersects y = y_pos
// -1 if it doesn't intersect in the square (in direction p1p2)
float hor_inter(float p1[], float p2[], float y_pos) {
    float t = (y_pos - p1[1])/(p2[1] - p1[1]);
    float res = (p1[0] + (p2[0] - p1[0])*t);
    return (t >= 0 && t <= 1 && res >= 0 && res <= scale) ? res : -1;
}

// Returns the y coordinate at which a segment intersects x = x_pos
// -1 if it doesn't intersect in the square (in direction p1p2)
float ver_inter(float p1[], float p2[], float x_pos) {
    float t = (x_pos - p1[0])/(p2[0] - p1[0]);
    float res = (p1[1] + (p2[1] - p1[1])*t);
    return (t >= 0 && t <= 1 && res >= 0 && res <= scale) ? res : -1;
}

void dbg(String txt) {
    System.out.println("dbg " + txt);
    delay(200);
}
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

    t_call(); // Functions starting with t_* are related to testing

    //initializePartition(lineNumber);
    //initializeBarycenters();
    //my_voronoi = new Voronoi(barycenters);
    //fl_voronoi = intersectVoronoi(my_voronoi);
    //
    //System.out.println(init_succesful);
}

// Executed every frame
void draw() {
    // order of drawing is important because of overlapping
    //drawVoronoi(); // voronoi calculated from "barycenters" - DEPRECATED
    //drawPoints(); // given partition
    //drawBarycenters(); // calculated "barycenters"
    //drawFlVoronoi(); // adjusted voronoi to square
}

// Returns a value in [0, 1) if the point is contained in segment or is the
//      start of it
// Furthermore, that value is the value of the parameter P = s1+(s2-s1)*t
// -1 if its not
float point_in_segment(float[] s1, float[] s2, float[] point) {
    float x1 = s1[0];
    float y1 = s1[1];

    float x2 = s2[0];
    float y2 = s2[1];

    float p1 = point[0];
    float p2 = point[1];

    float t = (p1 - x1)/(x2 - x1);

    if (p2 == (y1 + (y2 - y1)*t) && t >= 0 && t < 1)
        return t;

    return -1;
}

ArrayList<float []> segment_intersection(float[] l1, float[] l2, float[] s1,
        float[] s2) {
    ArrayList<float []> res = new ArrayList<float []>();

    float x1 = l1[0];
    float y1 = l1[1];

    float x2 = l2[0];
    float y2 = l2[1];

    float x3 = s1[0];
    float y3 = s1[1];

    float x4 = s2[0];
    float y4 = s2[1];

    // Same segments
    if (x1 == x3 && x2 == x4 && y1 == y3 && y2 == y4) {
        res.add(l1);
        res.add(l2);

        return res;
    }
    // Both are vertical
    // FIXME: Maybe the order of checking is wrong
    if (x1 == x2 && x3 == x4) { // Both vectors are vertical
        if (x1 == x3) { // Both vectors belong to the same line
            if (y1 == y3 || y1 == y4)
                res.add(l1);
            if (y2 == y3 || y2 == y4)
                res.add(l2);
            if ((y1 > y3 && y1 < y4) || (y1 < y3 && y1 > y4))
                res.add(l1); // y1
            if ((y2 > y3 && y2 < y4) || (y2 < y3 && y2 > y4))
                res.add(l2); // y2
            if ((y3 > y1 && y3 < y2) || (y3 < y1 && y3 > y2))
                res.add(s1); // y3
            if ((y4 > y1 && y4 < y2) || (y4 < y1 && y4 > y2))
                res.add(s2); // y4
        }
        // Vectors belong to different lines. In any case, end.
        return res;
    }
    // One is vertical
    // FIXME: Check that t is a correct value (> 0 && < 1)
    if (x1 == x2 || x3 == x4) {
        if (x1 == x2) { // First is vertical
            float t = (x1 - x3)/(x4 - x3);
            if (t >= 0 && t <= 1) {
                float y_itsc = y3 + (y4 - y3)*t;

                if ((y1 >= y_itsc && y2 <= y_itsc) || 
                        (y1 <= y_itsc && y2 >= y_itsc))
                    res.add(new float[]{x1, y_itsc});
            }
        }

        if (x3 == x4) { // Second is vertical
            float t = (x3 - x1)/(x2 - x1);
            if (t >= 0 && t <= 1) {
                float y_itsc = y1 + (y2 - y1)*t;

                if ((y3 >= y_itsc && y4 <= y_itsc) ||
                        (y3 <= y_itsc && y4 >= y_itsc))
                    res.add(new float[]{x3, y_itsc});
            }
        }

        return res;
    }
    // Diagonal. Check slopes of vectors
    float slope_l1 = (x1 < x2) ? (y2 - y1)/(x2 - x1) : (y1 - y2)/(x1 - x2);
    float slope_l2 = (x3 < x4) ? (y4 - y3)/(x4 - x3) : (y3 - y4)/(x3 - x4);
    //      Same slope
    if (slope_l1 == slope_l2) {
        float t1 = (x3 - x1)/(x2 - x1);
        //float t2 = (y3 - y1)/(y2 - y1);
    //          Same line - check for all points and get intersection
        //if (t1 == t2) { // Point from one is contained in the other
                        // Since its diagonal, we just check the x coordinates
        if (y3 == (y1 + (y2 - y1)*t1)) {
            if (x1 == x3 || x1 == x4)
                res.add(l1);
            if (x2 == x3 || x2 == x4)
                res.add(l2);
            if ((x1 > x3 && x1 < x4) || (x1 < x3 && x1 > x4))
                res.add(l1); // y1
            if ((x2 > x3 && x2 < x4) || (x2 < x3 && x2 > x4))
                res.add(l2); // y2
            if ((x3 > x1 && x3 < x2) || (x3 < x1 && x3 > x2))
                res.add(s1); // y3
            if ((x4 > x1 && x4 < x2) || (x4 < x1 && x4 > x2))
                res.add(s2); // y4
            // FIXME: This code is copypasted from above
        }
    //          Different line - empty intersection
    // In any case, end
        return res; 
    }

    //      Different slope
    else {
    //          Check for normal intersection (reuse formula)
        // TODO: Check k in [0, 1] and t in [0, 1]
        float num = (x2 - x1)*(y1 - y3) + (y2 - y1)*(x3 - x1);
        float den = (x2 - x1)*(y4 - y3) - (y2 - y1)*(x4 - x3);

        float k = num/den;
        if (k >= 0 && k <= 1)
            res.add(new float[]{x3 + (x4 - x3)*k, y3 + (y4 - y3)*k});

        return res;
    }
}


// Returns a list with the raw intersection points of two polygons
ArrayList<float []> raw_intersection_points(float[][] pol1, float[][] pol2) {
    ArrayList<float []> res = new ArrayList<float []>();
    ArrayList<float []> tmp = new ArrayList<float []>();

    int next_i = 0, next_j = 0;

    for (int i = 0; i < pol1.length; i++) {
        next_i = (i == pol1.length - 1) ? 0 : i+1;
        for (int j = 0; j < pol2.length; j++) {
            next_j = (j == pol2.length - 1) ? 0 : j+1;

            tmp.clear();
            tmp = segment_intersection(pol1[i], pol1[next_i], pol2[j],
                    pol2[next_j]);

            for (int k = 0; k < tmp.size(); k++) {
                res.add(tmp.get(k));
            }
        }
    }

    return res;
}

// Returns the area of a triangle using cross product
// Orientation of ABC is assumed to be positive (counter-clockwise)
float area_triang(float A[], float B[], float C[]) {
    float ax = A[0], ay = A[1];
    float bx = B[0], by = B[1];
    float cx = C[0], cy = C[1];

    return ((bx*cy - cx*by) - (ax*cy - cx*ay) + (ax*by - bx*ay))/2;
}


/*
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
*/

/*
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
            if (hack == 3) { // top right must be added
                tmp2[cnt2][0] = scale;
                tmp2[cnt2][1] = 0;
                cnt2++;
            }
            if (hack == 12) { // bottom left must be added
                tmp2[cnt2][0] = 0;
                tmp2[cnt2][1] = scale;
                cnt2++;
            }
            if (hack == 6) { // bottom right must be added
                tmp2[cnt2][0] = scale;
                tmp2[cnt2][1] = scale;
                cnt2++;
            }

            // FIXME: This patch doesn't always work.
            // Only works if opposite edges come from going around the square
            // Not if there is a direct line between them
            if (edge_cur == 1 && edge_next == 3) {
                tmp2[cnt2][0] = scale;
                tmp2[cnt2][1] = 0;
                cnt2++;
                tmp2[cnt2][0] = scale;
                tmp2[cnt2][1] = scale;
                cnt2++; 
            }
            if (edge_cur == 2 && edge_next == 4) {
                tmp2[cnt2][0] = scale;
                tmp2[cnt2][1] = scale;
                cnt2++;
                tmp2[cnt2][0] = 0;
                tmp2[cnt2][1] = scale;
                cnt2++; 
            }
            if (edge_cur == 3 && edge_next == 1) {
                tmp2[cnt2][0] = 0;
                tmp2[cnt2][1] = scale;
                cnt2++;
                tmp2[cnt2][0] = 0;
                tmp2[cnt2][1] = 0;
                cnt2++; 
            }
            if (edge_cur == 4 && edge_next == 2) {
                tmp2[cnt2][0] = 0;
                tmp2[cnt2][1] = 0;
                cnt2++;
                tmp2[cnt2][0] = scale;
                tmp2[cnt2][1] = 0;
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
*/

/*
// Returns the edge a point is in. -1 if its not.
// Point is assumed to be inside
boolean is_point_in(float pt[]) {
    return (pt[0] >= 0 && pt[0] <= scale && pt[1] >= 0 && pt[1] <= scale);
}
*/

/*
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
*/

/*
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
*/

/*
// Returns whether segments P1P2 and P3P4 cross or not
boolean cross(float p1[], float p2[], float p3[], float p4[]) {
    float x1 = p1[0];
    float y1 = p1[1];
    float x2 = p2[0];
    float y2 = p2[1];
    float x3 = p3[0];
    float y3 = p3[1];
    float x4 = p4[0];
    float y4 = p4[1];

    float den = (x2 - x1)*(y4 - y3) - (y2 - y1)*(x4 - x3);

    if (den == 0)
        return false;

    float num = (x2 - x1)*(y1 - y3) + (y2 - y1)*(x3 - x1);

    float k = num/den;

    if (k >= 0 && k <= 1)
        return true;

    return false;
}
*/

/*
// Returns the intersection point between P1P2 and P3P4
// Call only checking with cross before
float[] intersection_point(float p1[], float p2[], float p3[], float p4[]) {
    float x1 = p1[0];
    float y1 = p1[1];
    float x2 = p2[0];
    float y2 = p2[1];
    float x3 = p3[0];
    float y3 = p3[1];
    float x4 = p4[0];
    float y4 = p4[1];

    float num = (x2 - x1)*(y1 - y3) + (y2 - y1)*(x3 - x1);
    float den = (x2 - x1)*(y4 - y3) - (y2 - y1)*(x4 - x3);

    float k = num/den;

    float res[] = new float[2];
    res[0] = x3 + (x4 - x3)*k;
    res[1] = y3 + (y4 - y3)*k;

    return res;
}
*/

// Returns the symmetric difference for the polygon i
float symmetric_diff(int i) {
    // elegir un inicio. cuando dos aristas se crucen, sus inicios nos valen
    // así, una ira por fuera y la otra por dentro.
    boolean found = false;

    // Initialize copies
    float _part[][] = copy_array(partition, i);
    float _vor[][] = copy_array(fl_voronoi, i);

    while (!found) { // FIXME: If there is no intersection, infinite loop

    }

    // despues, empezando en cada uno, tengo que generarme un nuevo poligono
    // siempre moviendome por la que estoy, y en cada interseccion, cambiar

    // cuando tenga esos dos poligonos, miro a ver las areas de cada uno
    // desde el baricentro. la diferencia simetrica es la mayor menos la menor

    // muevo puntos aleatoriamente y comparo
    return 1;
}

void dbg(String txt) {
    System.out.println("dbg " + txt);
    delay(200);
}

float[][] copy_array(float arr[][][], int pos) {
    float res[][] = new float[arr[pos].length][2];

    for (int i = 0; i < arr[pos].length; i++) {
        res[i][0] = arr[pos][i][0];
        res[i][1] = arr[pos][i][1];
    }

    return res;
}
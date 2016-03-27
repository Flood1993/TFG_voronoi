// Author: Guillermo Alonso Nunez
// e-mail: guillermo.alonso.nunez@alumnos.upm.es

import megamu.mesh.*;

final int scale = 500; // size parameters should have this value

boolean debugging = false;

float simulated_annealing[] = new float[]{10, 8, 5, 4, 2.5, 1, 0.5, 0.2, 0.1};
int step_index = 0;
boolean has_improved = true;

// Executed once
void setup() {
    size(500, 500); // set these values to the same of scale!

    if (height != scale || width != scale) { // check size
        System.out.println(err_incorr_size);
        exit();
    }
    
    randomSeed(2);
    
    initializePartition(lineNumber);
    initializeBarycenters();
    partition = positive_orientation(partition, barycenters);
    float_barycenters = array_barycenters(barycenters); // Convert barycenters to array (Voronoi input format)
    my_voronoi = new Voronoi(float_barycenters);
    fl_voronoi = store_voronoi(my_voronoi); // Store to array list from the voronoi format
    fl_voronoi = positive_orientation(fl_voronoi, barycenters);
    fl_voronoi = clip_partition_to_square(fl_voronoi);
    symmetric_diff = total_sym_diff(partition, fl_voronoi);
    
    if (debugging)
        System.out.println("Sym diff setup: " + symmetric_diff);
}

// Executed every frame
void draw() {
    background(100); // clear screen
    gradient_method(simulated_annealing[step_index]);
    //System.out.println("Step: " + simulated_annealing[step_index]);
    //delay(5);

    if (!has_improved && step_index + 1 < simulated_annealing.length)
        step_index++;

    draw_part(partition);
    draw_part(fl_voronoi);
    drawBarycenters();
    textSize(26);
    text("Symmetric difference: " + symmetric_diff, 10, 30);
    
    if (debugging)
        delay(800);
}

// Returns the signed area of a triangle
float area_triang(float A[], float B[], float C[]) {
    float ax = A[0], ay = A[1];
    float bx = B[0], by = B[1];
    float cx = C[0], cy = C[1];

    return ((bx*cy - cx*by) - (ax*cy - cx*ay) + (ax*by - bx*ay))/2;
}

// Returns the signed area of a polygon
float area_polygon(ArrayList<float []> pol) {
    float res = 0;
    float point[] = new float[]{scale/2, scale/2};

    for (int i = 0; i < pol.size(); i++) {
        int next_i = (i == pol.size() - 1) ? 0 : i + 1;

        res += area_triang(pol.get(i), pol.get(next_i), point);
    }

    return res;
}

// Clips a polygon with a given line
ArrayList<float []> clip_line(ArrayList<float []> pol, float line_start[],
        float line_end[]) {
    ArrayList<float []> res = new ArrayList<float []>();

    for (int i = 0; i < pol.size(); i++) {
        int next_i = (i == pol.size() - 1) ? 0 : i + 1;

        float area_origin = area_triang(line_start, line_end, pol.get(i));
        float area_end = area_triang(line_start, line_end, pol.get(next_i));

        // Check current start
        if (area_origin >= 0)
            res.add(pol.get(i));

        // Check for intermediate points
        if (area_origin * area_end < 0) {
            float t = segment_intersection(line_start, line_end, pol.get(i), 
                    pol.get(next_i));
            if (t >= 0 && t < 1) {
                float x = pol.get(i)[0];
                float y = pol.get(i)[1];
                float next_x = pol.get(next_i)[0];
                float next_y = pol.get(next_i)[1];

                res.add(new float[]{x + (next_x - x)*t, y + (next_y - y)*t});
            }                
        }
    }

    return res;
}

void gradient_method(float step) {
    // TODO: randomize barycenter order
    has_improved = false;

    int access_order[] = new int[barycenters.size()];
    
    for (int pos = 0; pos < access_order.length; pos++)
        access_order[pos] = pos;

    for (int i = 0; i < access_order.length; i++) {
        int swap_with = (int) random(access_order.length);
        int tmp = access_order[i];
        access_order[i] = access_order[swap_with];
        access_order[swap_with] = tmp;
    }

    for (int j = 0; j < access_order.length; j++) { // for each point
        int i = access_order[j];
        // TODO: Need some refactoring
        ArrayList<float []> best_solution = barycenters;
        fl_voronoi = positive_orientation(fl_voronoi, barycenters);
        float best_sym_diff = total_sym_diff(partition, fl_voronoi);
        




        ArrayList<float []> cloned_barycenters = clone_arraylist(barycenters);
        cloned_barycenters.get(i)[0] = cloned_barycenters.get(i)[0] + step;
        float [][] new_barycenters = array_barycenters(cloned_barycenters);
        tmp_vor = new Voronoi(new_barycenters);
        ArrayList<ArrayList<float []>> tmp_new_stuff = store_voronoi(tmp_vor);
        tmp_new_stuff = positive_orientation(tmp_new_stuff, cloned_barycenters);
        tmp_new_stuff = clip_partition_to_square(tmp_new_stuff);

        float diff = total_sym_diff(partition, tmp_new_stuff);

        if (debugging)
            System.out.println("Diff 1: " + diff);

        if (diff < best_sym_diff) {
            has_improved = true;
            best_solution = cloned_barycenters;
            best_sym_diff = diff;
        }




        cloned_barycenters = clone_arraylist(barycenters);
        cloned_barycenters.get(i)[0] = cloned_barycenters.get(i)[0] - step;
        new_barycenters = array_barycenters(cloned_barycenters);
        tmp_vor = new Voronoi(new_barycenters);
        tmp_new_stuff = store_voronoi(tmp_vor);
        tmp_new_stuff = positive_orientation(tmp_new_stuff, cloned_barycenters);
        tmp_new_stuff = clip_partition_to_square(tmp_new_stuff);
        diff = total_sym_diff(partition, tmp_new_stuff);
        if (debugging)
            System.out.println("Diff 2: " + diff);
        if (diff < best_sym_diff) {
            has_improved = true;
            best_solution = cloned_barycenters;
            best_sym_diff = diff;
        }

        cloned_barycenters = clone_arraylist(barycenters);
        cloned_barycenters.get(i)[1] = cloned_barycenters.get(i)[1] + step;
        new_barycenters = array_barycenters(cloned_barycenters);
        tmp_vor = new Voronoi(new_barycenters);
        tmp_new_stuff = store_voronoi(tmp_vor);
        tmp_new_stuff = positive_orientation(tmp_new_stuff, cloned_barycenters);
        tmp_new_stuff = clip_partition_to_square(tmp_new_stuff);
        diff = total_sym_diff(partition, tmp_new_stuff);
        if (debugging)
            System.out.println("Diff 3: " + diff);
        if (diff < best_sym_diff) {
            has_improved = true;
            best_solution = cloned_barycenters;
            best_sym_diff = diff;
        }

        cloned_barycenters = clone_arraylist(barycenters);
        cloned_barycenters.get(i)[1] = cloned_barycenters.get(i)[1] - step;
        new_barycenters = array_barycenters(cloned_barycenters);
        tmp_vor = new Voronoi(new_barycenters);
        tmp_new_stuff = store_voronoi(tmp_vor);
        tmp_new_stuff = positive_orientation(tmp_new_stuff, cloned_barycenters);
        tmp_new_stuff = clip_partition_to_square(tmp_new_stuff);
        diff = total_sym_diff(partition, tmp_new_stuff);
        if (debugging)
            System.out.println("Diff 4: " + diff);
        if (diff < best_sym_diff) {
            has_improved = true;
            best_solution = cloned_barycenters;
            best_sym_diff = diff;
        }

        if (debugging)
            System.out.println("Best symmetric difference: " + best_sym_diff);

        symmetric_diff = best_sym_diff;
        barycenters = best_solution;
        float_barycenters = array_barycenters(barycenters); // Convert barycenters to array (Voronoi input format)
        my_voronoi = new Voronoi(float_barycenters);
        fl_voronoi = store_voronoi(my_voronoi);
        fl_voronoi = positive_orientation(fl_voronoi, barycenters);
        fl_voronoi = clip_partition_to_square(fl_voronoi);
    }
}

// Clips a whole partition to the square
ArrayList<ArrayList<float []>> clip_partition_to_square(
        ArrayList<ArrayList<float []>> partition) {
    ArrayList<ArrayList<float []>> res = new ArrayList<ArrayList<float []>>();

    for (int i = 0; i < partition.size(); i++) {
        ArrayList<float []> tmp = clip_to_square(partition.get(i));

        res.add(tmp);
    }

    return res;
}

// pol is assumed to be negatively oriented
ArrayList<float []> clip_to_square(ArrayList<float []> pol) {
    ArrayList<float []> res = new ArrayList<float []>();
    float c1[] = new float[]{0, 0};
    float c2[] = new float[]{scale, 0};
    float c3[] = new float[]{scale, scale};
    float c4[] = new float[]{0, scale};

    res = clip_line(pol, c1, c2);
    res = clip_line(res, c2, c3);
    res = clip_line(res, c3, c4);
    res = clip_line(res, c4, c1);

    return res;
}

// Returns a new polygon which is the intersection of two
ArrayList<float []> clip_polygons(ArrayList<float []> pol1,
        ArrayList<float []> pol2) {
    ArrayList<float []> res = new ArrayList<float []>();

    for (int i = 0; i < pol2.size(); i++) {
        int next_i = (i == pol2.size() - 1) ? 0 : i + 1;

        if (i == 0)
            res = clip_line(pol1, pol2.get(i), pol2.get(next_i));
        else
            res = clip_line(res, pol2.get(i), pol2.get(next_i));
    }

    return res;
}

// Returns the symmetric difference of two polygons
float sym_diff(ArrayList<float []> pol1, ArrayList<float []> pol2) {
    ArrayList<float []> intersection = clip_polygons(pol1, pol2);

    float area1 = area_polygon(pol1);
    float area2 = area_polygon(pol2);
    float area_intersection = area_polygon(intersection);

    float res = area1 + area2 - 2*area_intersection;

    return (area1 + area2 - 2*area_intersection);
}

float total_sym_diff(ArrayList<ArrayList<float []>> x,
        ArrayList<ArrayList<float []>> y) {
    float res = 0;

    for (int i = 0; i < x.size(); i++) {
        float cur_area = sym_diff(x.get(i), y.get(i));
        res += cur_area;
    }

    return res;
}

// Makes sure all polygons are positively oriented
ArrayList<ArrayList<float []>> positive_orientation(
        ArrayList<ArrayList<float []>> part, ArrayList<float []> barycenters) {
    
    ArrayList<ArrayList<float []>> res = new ArrayList<ArrayList<float []>>();
    
    // For each polygon
    for (int i = 0; i < part.size(); i++) {
        // Make sure orientation is correct
        if (area_polygon(part.get(i)) < 0) {
            ArrayList<float []> tmp = new ArrayList<float []>();

            for (int j = part.get(i).size() - 1; j >= 0; j--)
                tmp.add(part.get(i).get(j));

            res.add(tmp); // Change
        } else {
            res.add(part.get(i));
        }
    }

    return res;
}

// Returns -1 if there is no intersection. A value in [0, 1] if they intersect
float segment_intersection(float[] l1, float[] l2, float[] s1, float[] s2) {
    float x1 = l1[0], y1 = l1[1];
    float x2 = l2[0], y2 = l2[1];
    float x3 = s1[0], y3 = s1[1];
    float x4 = s2[0], y4 = s2[1];

    // Same segments
    if (x1 == x3 && x2 == x4 && y1 == y3 && y2 == y4)
        return -1;

    // Both are vertical
    if (x1 == x2 && x3 == x4)
        return -1;

    // One is vertical
    if (x1 == x2 || x3 == x4) {
        float res = -1;

        if (x1 == x2) { // Line is vertical
            float t = (x1 - x3)/(x4 - x3);
            if (t >= 0 && t <= 1) {
                res = t;
            }
        }

        else if (x3 == x4) { // Segment is vertical
            float t = (x3 - x1)/(x2 - x1);
            if (t >= 0 && t <= 1) {
                float y_itsc = y1 + (y2 - y1)*t;
                float k = (y_itsc - y3)/(y4 - y3);

                if ((y3 >= y_itsc && y4 <= y_itsc) ||
                        (y3 <= y_itsc && y4 >= y_itsc))
                    res = k;
            }
        }

        return res;
    }
    
    // Diagonal. Check slopes of vectors
    float slope_l1 = (x1 < x2) ? (y2 - y1)/(x2 - x1) : (y1 - y2)/(x1 - x2);
    float slope_l2 = (x3 < x4) ? (y4 - y3)/(x4 - x3) : (y3 - y4)/(x3 - x4);
    // Same slope
    if (slope_l1 == slope_l2) {
        return -1;
    } else { // different slope
        float num = (x2 - x1)*(y1 - y3) + (y2 - y1)*(x3 - x1);
        float den = (x2 - x1)*(y4 - y3) - (y2 - y1)*(x4 - x3);

        float k = num/den;
        if (k >= 0 && k <= 1)
            return k;

        return -1;
    }
}

ArrayList<float []> clone_arraylist(ArrayList<float []> obj) {
    ArrayList<float []> res = new ArrayList<float []>();

    for (int i = 0; i < obj.size(); i++) {
        res.add(new float[]{obj.get(i)[0], obj.get(i)[1]});
    }

    return res;
}

void dbg(String txt) {
    System.out.println("dbg " + txt);
    delay(200);
}
// Author: Guillermo Alonso Nunez
// e-mail: guillermo.alonso.nunez@alumnos.upm.es

/*
    GENERAL WORKFLOW:

    Initialize given partition
    Calculate starting points
    Generate voronoi diagram
    Make sure all polygons are negatively oriented
    Adjust that diagram to the square
        Clip each segment to the four lines of the square
    Once we have done that, calculate the intersection polygon
        Clip each segment of the partition with each segment of the voronoi
    One we have done that, the symmetric difference is A + B - 2(A intersect B)
    Accumulate symmetric difference for each polygon, and keep that value
    Move each point to its 4 neighbours and check the result. If its better,
            update points and keep going in that direction
*/

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
    float_barycenters = array_barycenters(barycenters); // Convert barycenters to array (Voronoi input format)
    my_voronoi = new Voronoi(float_barycenters);
    fl_voronoi = store_voronoi(my_voronoi); // Store to array list from the voronoi format
    fl_voronoi = negative_orientation(fl_voronoi, barycenters);
    fl_voronoi = clip_partition_to_square(fl_voronoi);
    symmetric_diff = total_sym_diff(partition, fl_voronoi);


    /*
    ArrayList<float []> square = new ArrayList<float []>();
    square.add(new float[]{0, 0});
    square.add(new float[]{0, 100});
    square.add(new float[]{100, 100});
    square.add(new float[]{100, 0});
    
    ArrayList<float []> square2 = new ArrayList<float []>();
    square2.add(new float[]{50, 0});
    square2.add(new float[]{50, 100});
    square2.add(new float[]{150, 100});
    square2.add(new float[]{150, 0});

    float symmetric_diff = sym_diff(square, square2);
    */
    //float clipper_start[] = new float[2];
    //float clipper_end[] = new float[2];

    /*clipper_start[0] = 50;
    clipper_start[1] = 0;
    clipper_end[0] = 50;
    clipper_end[1] =100;
    square = clip_line(square, clipper_start, clipper_end);*/
    
    /*clipper_start[0] = 400;
    clipper_start[1] = 450;
    clipper_end[0] = 190;
    clipper_end[1] = 50;
    square = clip_line(square, clipper_start, clipper_end);*/
    //draw_pol(square);
    /*System.out.println("Symmetric diff: " + symmetric_diff);


    initializePartition(lineNumber);
    System.out.println("Partition size: " + partition.size());
    draw_part(partition); // given partition
    initializeBarycenters();
    drawBarycenters();*/
/*    initializeBarycenters();
    my_voronoi = new Voronoi(barycenters);

    fl_voronoi = intersectVoronoi(my_voronoi);
    // We need to make sure all polygons are oriented negatively
    fl_voronoi = negative_orientation(fl_voronoi, barycenters);

    t_call(); // Functions starting with t_* are related to testing
*/
    //symmetric_diff = total_diff(partition, fl_voronoi);
    //System.out.println("Diferencia simétrica total: " + 
    //        symmetric_diff);
    //System.out.println(init_succesful);
}

// Executed every frame
void draw() {
    background(100);
    // order of drawing is important because of overlapping
    //drawVoronoi(); // voronoi calculated from "barycenters" - DEPRECATED

    // If results are better, keep and repeat
    // If results are worse, discard

    gradient_method();

    draw_part(partition);
    draw_part(fl_voronoi);
    drawBarycenters();
/*    drawBarycenters(); // calculated "barycenters"
    drawFlVoronoi(); // adjusted voronoi to square
    */
    /*
    // Slightly move barycenters
    tmp_bary = randomize_barycenters(barycenters);
    tmp_vor = new Voronoi(tmp_bary);
    tmp_fl_vor = intersectVoronoi(tmp_vor);
    tmp_fl_vor = negative_orientation(tmp_fl_vor, tmp_bary);
    tmp_sym_diff = total_diff(partition, tmp_fl_vor);
    // if improved results
    if (tmp_sym_diff > symmetric_diff) {
        fl_voronoi = tmp_fl_vor;
        my_voronoi = tmp_vor;
        barycenters = tmp_bary;
        symmetric_diff = tmp_sym_diff;
    }
  */
    textSize(26);
    text("Current symmetric diff: " + symmetric_diff, 10, 30); 
  
    //delay(5);
}

// Returns the signed area of a triangle using cross product
// If first two parameters represent a line and its direction, the location of
// the third parameter is:
//      left of the line if result > 0
//      on the line if result == 0
//      right of the line if result < 0
float area_triang(float A[], float B[], float C[]) {
    float ax = A[0], ay = A[1];
    float bx = B[0], by = B[1];
    float cx = C[0], cy = C[1];

    return ((bx*cy - cx*by) - (ax*cy - cx*ay) + (ax*by - bx*ay))/2;
}

float area_polygon(ArrayList<float []> pol) {
    float res = 0;
    float point[] = new float[]{scale/2, scale/2}; // middle of screen

    for (int i = 0; i < pol.size(); i++) {
        int next_i = (i == pol.size() - 1) ? 0 : i + 1;

        res += area_triang(pol.get(i), pol.get(next_i), point);
    }

    return res;
}


// Clips a polygon with the given line.
// Note that in this project, we will be working with both polygons having a
//  negative orientation.
ArrayList<float []> clip_line(ArrayList<float []> pol, float line_start[],
        float line_end[]) {
    ArrayList<float []> res = new ArrayList<float []>();

    for (int i = 0; i < pol.size(); i++) {
        //System.out.println("i " + i);
        int next_i = (i == pol.size() - 1) ? 0 : i + 1;

        float area_origin = area_triang(line_start, line_end, pol.get(i));
        float area_end = area_triang(line_start, line_end, pol.get(next_i));

        // Check current start
        if (area_origin <= 0)
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

void gradient_method() {
    /*
    Randomize barycenters order
    For each barycenter
        Compare against all of its neighbours. Take the best neighbour and replace
    Repeat
    */
    // TODO: randomize barycenter order

    for (int i = 0; i < barycenters.size(); i++) { // for each point
        ArrayList<float []> best_solution = barycenters;
        float best_sym_diff = total_sym_diff(partition, fl_voronoi);
        
        ArrayList<float []> cloned_barycenters = clone_arraylist(barycenters);
        cloned_barycenters.get(i)[0] = cloned_barycenters.get(i)[0] + 1;
        float [][] new_barycenters = array_barycenters(cloned_barycenters);
        tmp_vor = new Voronoi(new_barycenters);
        ArrayList<ArrayList<float []>> tmp_new_stuff = store_voronoi(tmp_vor);
        tmp_new_stuff = negative_orientation(tmp_new_stuff, cloned_barycenters);
        tmp_new_stuff = clip_partition_to_square(tmp_new_stuff);
        float diff = total_sym_diff(partition, tmp_new_stuff);
        if (diff > best_sym_diff) {
            best_solution = cloned_barycenters;
            best_sym_diff = diff;
        }

        cloned_barycenters = clone_arraylist(barycenters);
        cloned_barycenters.get(i)[0] = cloned_barycenters.get(i)[0] - 1;
        new_barycenters = array_barycenters(cloned_barycenters);
        tmp_vor = new Voronoi(new_barycenters);
        tmp_new_stuff = store_voronoi(tmp_vor);
        tmp_new_stuff = negative_orientation(tmp_new_stuff, cloned_barycenters);
        tmp_new_stuff = clip_partition_to_square(tmp_new_stuff);
        diff = total_sym_diff(partition, tmp_new_stuff);
        if (diff > best_sym_diff) {
            best_solution = cloned_barycenters;
            best_sym_diff = diff;
        }

        cloned_barycenters = clone_arraylist(barycenters);
        cloned_barycenters.get(i)[1] = cloned_barycenters.get(i)[1] + 1;
        new_barycenters = array_barycenters(cloned_barycenters);
        tmp_vor = new Voronoi(new_barycenters);
        tmp_new_stuff = store_voronoi(tmp_vor);
        tmp_new_stuff = negative_orientation(tmp_new_stuff, cloned_barycenters);
        tmp_new_stuff = clip_partition_to_square(tmp_new_stuff);
        diff = total_sym_diff(partition, tmp_new_stuff);
        if (diff > best_sym_diff) {
            best_solution = cloned_barycenters;
            best_sym_diff = diff;
        }

        cloned_barycenters = clone_arraylist(barycenters);
        cloned_barycenters.get(i)[1] = cloned_barycenters.get(i)[1] - 1;
        new_barycenters = array_barycenters(cloned_barycenters);
        tmp_vor = new Voronoi(new_barycenters);
        tmp_new_stuff = store_voronoi(tmp_vor);
        tmp_new_stuff = negative_orientation(tmp_new_stuff, cloned_barycenters);
        tmp_new_stuff = clip_partition_to_square(tmp_new_stuff);
        diff = total_sym_diff(partition, tmp_new_stuff);
        if (diff > best_sym_diff) {
            best_solution = cloned_barycenters;
            best_sym_diff = diff;
        }

        symmetric_diff = best_sym_diff;
        barycenters = best_solution;
        float_barycenters = array_barycenters(barycenters); // Convert barycenters to array (Voronoi input format)
        my_voronoi = new Voronoi(float_barycenters);
        fl_voronoi = store_voronoi(my_voronoi); // Store to array list from the 
    }
}

// Clips a whole partition to the square
ArrayList<ArrayList<float []>> clip_partition_to_square(
        ArrayList<ArrayList<float []>> partition) {
    ArrayList<ArrayList<float []>> res = new ArrayList<ArrayList<float []>>();

    for (int i = 0; i < partition.size(); i++) {
        ArrayList<float []> tmp = clip_to_square(partition.get(i));

        //System.out.println("partition " + i + " size: " + partition.get(i).size());
        //System.out.println("tmp size: " + tmp.size());

        res.add(tmp);
    }

    return res;
}

// pol is assumed to be negatively oriented
ArrayList<float []> clip_to_square(ArrayList<float []> pol) {
    ArrayList<float []> res = new ArrayList<float []>();
    float c1[] = new float[]{0, 0};
    float c2[] = new float[]{0, scale}; // scale 0
    float c3[] = new float[]{scale, scale};
    float c4[] = new float[]{scale, 0}; // 0 scale

    res = clip_line(pol, c1, c2);
    res = clip_line(res, c2, c3);
    res = clip_line(res, c3, c4);
    res = clip_line(res, c4, c1);

    //System.out.println("res.size(): " + res.size());

    return res;
}

// returns a new polygon which is the intersection of the two
ArrayList<float []> clip_polygons(ArrayList<float []> pol1,
        ArrayList<float []> pol2) {
    ArrayList<float []> res = new ArrayList<float []>();

    // Clonarme el primer array. Hacerle clip para todas las lineas del segundo
    // TODO
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

    //System.out.println("intersection.size() = " + intersection.size());

    /*for (int i = 0; i < intersection.size(); i++) {
        System.out.println("x: " + intersection.get(i)[0] + ", y: " + 
                intersection.get(i)[1]);
    }*/

    float area1 = area_polygon(pol1);
    float area2 = area_polygon(pol2);
    float area_intersection = area_polygon(intersection);

    float res = area1 + area2 - 2*area_intersection;

    /*if (res < -10000.0) {
        System.out.println("\tarea 1: " + area1);
        System.out.println("\tarea 2: " + area2);
        System.out.println("\tarea intersection: " + area_intersection);
    }*/
    //System.out.println("area 1 = " + area1);
    //System.out.println("area 2 = " + area2);
    //System.out.println("area intersection = " + area_intersection);

    return (area1 + area2 - 2*area_intersection);
}

float total_sym_diff(ArrayList<ArrayList<float []>> x,
        ArrayList<ArrayList<float []>> y) {
    float res = 0;

    for (int i = 0; i < x.size(); i++) {
        float cur_area = sym_diff(x.get(i), y.get(i));
        //System.out.println("Cur area: " + cur_area);
        res += cur_area;
    }

    return res;
}

// Makes sure all polygons are negatively oriented
ArrayList<ArrayList<float []>> negative_orientation(
        ArrayList<ArrayList<float []>> part, ArrayList<float []> barycenters) {
    // For each polygon
    ArrayList<ArrayList<float []>> res = new ArrayList<ArrayList<float []>>();
    //float[][][] res = new float[part.length][][];
    
    for (int i = 0; i < part.size(); i++) {
        // If the first two points have a positive area, all do
        //if (area_triang(barycenters.get(i), part.get(i).get(0),
        //        part.get(i).get(1)) > 0) {
        if (area_polygon(part.get(i)) > 0) {
            //System.out.println("Polygon " + i + " was badly oriented");
            //delay(20);

            ArrayList<float []> tmp = new ArrayList<float []>();
            //float tmp[][] = new float[part[i].length][2];

            for (int j = part.get(i).size() - 1; j >= 0; j--) {
                tmp.add(part.get(i).get(j)); // = part[i][part[i].length - 1 - j];
            }

            res.add(tmp); // Change
        }

        else {
            //System.out.println("Polygon " + i + " was correctly oriented");
            res.add(part.get(i)); // Simply add it
        }

        //if (area_triang(barycenters.get(i), res.get(i).get(0),
        //        res.get(i).get(1)) > 0)
            //System.out.println("And I am still badly oriented :(");
    }

    return res;
}


boolean sgm_its_line(float l1[], float l2[], float s1[], float s2[]) {
    float tmp1 = area_triang(l1, l2, s1);
    float tmp2 = area_triang(l1, l2, s2);

    // If one (or both) is zero, one point is lying in the line
    // If multiplication is < 0, they lie in different sides
    return (tmp1*tmp2 <= 0);
}

// Returns -1 if there is no intersection. A value in [0, 1] if they intersect
//  Note that the first two parameters are the line and last two the segment
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
        //System.out.println("Uno vertical");
        float res = -1;

        if (x1 == x2) { // Line is vertical
            //System.out.println("Linea vert");
            float t = (x1 - x3)/(x4 - x3);
            if (t >= 0 && t <= 1) {
                res = t;
            }
        }

        else if (x3 == x4) { // Segment is vertical
            //System.out.println("Segment vert");
            //System.out.println("x3 " + x3);
            //System.out.println("x1 " + x1);
            //System.out.println("x2 " + x2);
            //System.out.println("y1 " + y1);
            //System.out.println("y2 " + y2);
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
        // System.out.println("misma diagonal");
        return -1;
    }

    // Different slope
    else {
        // System.out.println("Clipping lineas con diferente slope");
    //          Check for normal intersection (reuse formula)
        // TODO: Check k in [0, 1] and t in [0, 1]
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
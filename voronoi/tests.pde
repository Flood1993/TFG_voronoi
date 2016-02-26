
void t_call() {
    boolean passing_all_tests = true;

    t_s1 = new float[2];
    t_s2 = new float[2];
    t_l1 = new float[2];
    t_l2 = new float[2];
    t_point = new float[2];

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
// Testing segment_intersection                          //
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

    t_init_line_one(0, 0, 0, 100);
    t_init_line_two(50, 0, 100, 0);
    // No intersection test
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 0) {
        System.out.println("Error on test 1.1");
        passing_all_tests = false;
    }

    t_init_line_one(0, 100, 0, 100);
    t_init_line_two(50, 0, 100, 0);
    // No intersection test
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 0) {
        System.out.println("Error on test 1.2");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 30, 100);
    t_init_line_two(30, 0, 47, 21);
    // No intersection test
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 0) {
        System.out.println("Error on test 1.3");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 100);
    t_init_line_two(100, 0, 0, 100);
    // Normal intersection
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 2.1");
        passing_all_tests = false;
    }

    t_init_line_one(34, 5, 89, 101);
    t_init_line_two(93, -2, 3.4, 97.7453);
    // Normal intersection
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 2.2");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 100);
    t_init_line_two(100, 0, 0, 100);
    // Normal intersection
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 2.3");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 0);
    t_init_line_two(50, 0, 50, 100);
    // One segment touches the other on its end
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 3.1");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 100);
    t_init_line_two(0, 100, 50, 50);
    // One segment touches the other on its end
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 3.2");
        passing_all_tests = false;
    }

    t_init_line_one(25, 10, 75, 90);
    t_init_line_two(50, 50, 76.5452, -5.1635);
    // One segment touches the other on its end
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 3.3");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 0);
    t_init_line_two(50, 0, 150, 0);
    // Contained in the same line. One starts in the middle of the other
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 2) {
        System.out.println("Error on test 4.1");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 0, 100);
    t_init_line_two(0, 50, 0, 150);
    // Contained in the same line. One starts in the middle of the other
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 2) {
        System.out.println("Error on test 4.2");
        passing_all_tests = false;
    }

    t_init_line_one(20, 30, 60, 90);
    t_init_line_two(40, 60, 80, 120);
    // Contained in the same line. One starts in the middle of the other
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 2) {
        System.out.println("Error on test 4.3");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 200, 0);
    t_init_line_two(50, 0, 150, 0);
    // One segment is contained in the other
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 2) {
        System.out.println("Error on test 5.1");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 0, 200);
    t_init_line_two(0, 50, 0, 150);
    // One segment is contained in the other
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 2) {
        System.out.println("Error on test 5.2");
        passing_all_tests = false;
    }

    t_init_line_one(20, 30, 80, 120);
    t_init_line_two(40, 60, 60, 90);
    // One segment is contained in the other
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 2) {
        System.out.println("Error on test 5.3");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 100);
    t_init_line_two(0, 0, 100, 100);
    // Segments are the same
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 2) {
        System.out.println("Error on test 6.1");
        passing_all_tests = false;
    }

    t_init_line_one(5.65826, 3.71587, 9.873725, 10.578357);
    t_init_line_two(5.65826, 3.71587, 9.873725, 10.578357);
    // Segments are the same
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 2) {
        System.out.println("Error on test 6.2");
        passing_all_tests = false;
    }

    t_init_line_one(5.65826, -3.71587, -9.873725, 10.578357);
    t_init_line_two(5.65826, -3.71587, -9.873725, 10.578357);
    // Segments are the same
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 2) {
        System.out.println("Error on test 6.3");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 0);
    t_init_line_two(0, 50, 100, 50);
    // Segments are parallel
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 0) {
        System.out.println("Error on test 7.1");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 0, 100);
    t_init_line_two(50, 0, 50, 50);
    // Segments are parallel
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 0) {
        System.out.println("Error on test 7.2");
        passing_all_tests = false;
    }

    t_init_line_one(10, 20, 50, 100);
    t_init_line_two(30, 20, 60, 100);
    // Segments are parallel
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 0) {
        System.out.println("Error on test 7.3");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 0, 100);
    t_init_line_two(0, 200, 0, 300);
    // Segments are contained in the same line, but no intersection
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 0) {
        System.out.println("Error on test 8.1");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 0, 100);
    t_init_line_two(0, 200, 0, 300);
    // Segments are contained in the same line, but no intersection
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 0) {
        System.out.println("Error on test 8.2");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 50, 100);
    t_init_line_two(100, 200, 150, 300);
    // Segments are contained in the same line, but no intersection
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 0) {
        System.out.println("Error on test 8.3");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 0);
    t_init_line_two(0, 0, 0, 100);
    // Segments touch on one of their ends
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 9.1");
        passing_all_tests = false;
    }

    t_init_line_one(100, 0, 50, 60);
    t_init_line_two(0, 0, 50, 60);
    // Segments touch on one of their ends
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 9.2");
        passing_all_tests = false;
    }

    t_init_line_one(184.684, 0, 45.6785, 92.58489);
    t_init_line_two(-13.56, 0, 45.6785, 92.58489);
    // Segments touch on one of their ends
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 9.3");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 0);
    t_init_line_two(100, 0, 200, 0);
    // Segments touch on one of their ends and belong to the same line
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 10.1");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 0, 100);
    t_init_line_two(0, 100, 0, 200);
    // Segments touch on one of their ends and belong to the same line
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 10.2");
        passing_all_tests = false;
    }

    t_init_line_one(50, 0, 100, 100);
    t_init_line_two(150, 200, 100, 100);
    // Segments touch on one of their ends and belong to the same line
    if (segment_intersection(t_s1, t_s2, t_l1, t_l2).size() != 1) {
        System.out.println("Error on test 10.3");
        passing_all_tests = false;
    }

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
// Testing point_in_segment                              //
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

    t_init_line_one(0, 0, 100, 100);
    t_init_point(50, 50);
    if (point_in_segment(t_s1, t_s2, t_point) != 0.5) {
        System.out.println("Error on test 11.1");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 100);
    t_init_point(0, 0);
    if (point_in_segment(t_s1, t_s2, t_point) != 0) {
        System.out.println("Error on test 11.2");
        passing_all_tests = false;
    }

    t_init_line_one(0, 0, 100, 100);
    t_init_point(95.65165, -50);
    if (point_in_segment(t_s1, t_s2, t_point) != -1) {
        System.out.println("Error on test 11.3");
        passing_all_tests = false;
    }

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
// Testing raw_intersection_points                       //
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

    float tri1[][] = new float[3][2];
    tri1[0][0] = 100;  tri1[0][1] = 0;
    tri1[1][0] = 200;  tri1[1][1] = 200;
    tri1[2][0] =   0;  tri1[2][1] = 200;

    float tri2[][] = new float[3][2];
    tri2[0][0] = 100;  tri2[0][1] = 300;
    tri2[1][0] =   0;  tri2[1][1] = 100;
    tri2[2][0] = 200;  tri2[2][1] = 100;

    if (raw_intersection_points(tri1, tri2).size() != 6) {
        System.out.println("Error on test 12.1");
        passing_all_tests = false;
    }

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
// Testing area_triang                                   //
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

    float A[] = new float[]{0, 0};
    float B[] = new float[]{100, 0};
    float C[] = new float[]{0, 100};

    if (area_triang(A, B, C) != 5000) {
        System.out.println("Error on test 13.1");
        passing_all_tests = false;
    }

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
// END OF TESTING                                        //
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

    if (passing_all_tests)
        System.out.println("¡¡Milagro!! Pasando todos los tests");
}

void t_init_point(float a, float b) {
    t_point[0] = a;
    t_point[1] = b;
}

void t_init_line_one(float a, float b, float c, float d) {
    t_s1[0] = a;
    t_s1[1] = b;
    t_s2[0] = c;
    t_s2[1] = d;
}

void t_init_line_two(float a, float b, float c, float d) {
    t_l1[0] = a;
    t_l1[1] = b;
    t_l2[0] = c;
    t_l2[1] = d;
}
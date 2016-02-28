int lineNumber = 8; // Line of the partition file which we want to load

// Variables that will be used for reading the partition from a file
BufferedReader reader;
String line;
String polygons[];

// "partition" will contain information about the given partition.
float partition[][][]; // [polygon][point][x or y coordinate]
float barycenters[][]; // [polygon][x or y coordinate]

float tmp_bary[][];

Voronoi my_voronoi;
Voronoi tmp_vor;
float[][][] fl_voronoi; // will contain the voronoi diagram adjusted to the
                        // scale*scale square
float[][][] tmp_fl_vor;


float symmetric_diff = -80000000000.0;
float tmp_sym_diff = -80000000000.0;
int rndm_seed = 0;

float t_s1[], t_s2[], t_l1[], t_l2[];
float t_point[];
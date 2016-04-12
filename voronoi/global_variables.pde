int lineNumber = 8; // Line of the partition file which we want to load

// Variables that will be used for reading the partition from a file
BufferedReader reader;
String line;
String polygons[];

// "partition" will contain information about the given partition.
ArrayList<ArrayList<float []>> partition;
ArrayList<float []> barycenters;
float float_barycenters[][]; // [polygon][x or y coordinate]

Voronoi my_voronoi;
Voronoi tmp_vor;

ArrayList<ArrayList<float []>> fl_voronoi;


float symmetric_diff = -80000000000.0;
float tmp_sym_diff = -80000000000.0;
int rndm_seed = 2;

float t_s1[], t_s2[], t_l1[], t_l2[];
float t_point[];

PrintWriter output;
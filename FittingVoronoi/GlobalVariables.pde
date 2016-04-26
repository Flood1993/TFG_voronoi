int lineNumber = 8; // Line of the partition file which we want to load

// Variables that will be used for reading the partition from a file
BufferedReader reader;
String line;
String polygons[];

// "partition" will contain information about the given partition.
ArrayList<ArrayList<float []>> partition;
ArrayList<float []> barycenters;
float floatBarycenters[][]; // [polygon][x or y coordinate]

Voronoi myVoronoi;
Voronoi tmpVor;

ArrayList<ArrayList<float []>> flVoronoi;


float symmetricDiff = -80000000000.0;
float tmpSymDiff = -80000000000.0;

int rndmSeed = 2;

float t_s1[], t_s2[], t_l1[], t_l2[];
float t_point[];

PrintWriter output;

color defaultBlack = color(0, 0, 0);
color backgroundColor = color(215, 215, 215);
color defaultGreen = color(55,126,68);

boolean firstScreenSaved = false;
boolean finished = false;

// Error strings
String excLoadingData = "Exception when loading data...";
String errIncorrSize  = "Size of window is not set accordingly... The drawings will not fill in the screen!\n" + 
                          "Please change the values in setup -> size(, ) to the one in -final int scale- and try again!";
String errLoadingPart = "Error when loading partition...\n" + 
                          "Please make sure variable lineNumber has a correct value and your partition file contains one partition per line.\n" +
                          "Current value of lineNumber: ";
                          
// Other strings
String initSuccessful = "Data initialization successful";
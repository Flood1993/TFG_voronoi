// Author: Guillermo Alonso Nunez
// e-mail: guialonun@gmail.com

// Variables that will be used for reading the tessellation from a file
BufferedReader reader;
String line;
String polygons[];

// "tessellation" will contain information about the given tessellation.
ArrayList<ArrayList<float []>> tessellation;
ArrayList<float []> barycenters;
float floatBarycenters[][]; // [polygon][x or y coordinate]

Voronoi myVoronoi;
Voronoi tmpVor;

ArrayList<ArrayList<float []>> flVoronoi;


float symDiffAtStart = -80000000000.0;
float symmetricDiff = -80000000000.0;
float tmpSymDiff = -80000000000.0;

// Variables used at the gradient method
ArrayList<float []> clonedBarycenters;
float [][] newBarycenters;
ArrayList<ArrayList<float []>> tmpNewStuff;
float diff;
ArrayList<float []> bestSolution;
float bestSymDiff;
float simAnnValue;

int rndmSeed = 2;

int stepCount = 0;

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
String errLoadingPart = "Error when loading tessellation...\n" + 
                          "Please make sure variable lineNumber has a correct value and your tessellation file contains one tessellation per line.\n" +
                          "Current value of lineNumber: ";
                          
// Other strings
String initSuccessful = "Data initialization successful";
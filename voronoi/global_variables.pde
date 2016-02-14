int lineNumber = 6; // Line of the partition file which we want to load

// Variables that will be used for reading the partition from a file
BufferedReader reader;
String line;
String polygons[];

// "partition" will contain information about the given partition.
float partition[][][]; // [polygon][point][x or y coordinate]
float barycenters[][]; // [polygon][x or y coordinate]

Voronoi my_voronoi;
float[][][] fl_voronoi; // will contain the voronoi diagram adjusted to the
						// scale*scale square

float symmetric_diff;
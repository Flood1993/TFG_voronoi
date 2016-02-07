int lineNumber = 9; // Line of the partitions file which we want to load

// Variables that will be used for reading the partition from a file
BufferedReader reader;
String line;
String polygons[];

// "partition" will contain information about the given partition.
//   The first dimension is the number of polygons of the partition
//   The second dimension is the number of points per polygon
//   The third dimension is always 2, "0" for x-coord and "1" for y-coord
float partition[][][];
float barycenters[][];

Voronoi my_voronoi;
// Author: Guillermo Alonso Nunez
// e-mail: guialonun@gmail.com

// Name of the file we want to load the tesellation from. It should be in the same folder than this file.
String fileToReadFrom = "10_partitions.txt";
// Line of the input file which we want to load. First line corresponds to 1, second line to 2...
int lineNumber = 13;

// Whether we want to apply the simulated annealing technique.
boolean useSimulatedAnnealing = true;

// Values we want to use for searching for neighbour solutions. Expressed as a ratio of the square unit side.
float setA[] = new float[]{0.05, 0.04, 0.01, 0.005, 0.001};
float setB[] = new float[]{0.05, 0.03, 0.01};
float setC[] = new float[]{0.1, 0.01, 0.005};
float setD[] = new float[]{0.2, 0.16, 0.09, 0.05, 0.03};

// NOTE: If you will not be working with a partition that fits perfectly in the unit square, make sure you
//       change the values of the variables xClipOffset and yClipOffset, located at the start of FittingVoronoi
//       Those variables should contain 1 for the biggest side and smallestSideLength/BiggestSizeLength for the smallest.

float simulatedAnnealing[] = setA; // new float[]{0.05}
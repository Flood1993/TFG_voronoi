// Author: Guillermo Alonso Nunez
// e-mail: guialonun@gmail.com

// Name of the file we want to load the tesellation from. It should be in the same folder than this file.
String fileToReadFrom = "10_partitions.txt";
// Line of the input file which we want to load. First line corresponds to 1, second line to 2...
int lineNumber = 12;

// Whether we want to apply the simmulated annealing technique or not.
boolean useSimmulatedAnnealing = true;
// Values we want to use for searching for neighbour solutions. Expressed as a ratio of the square unit side.
float simulatedAnnealing[] = setD;
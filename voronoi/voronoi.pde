final int scale = 500; //Important: change size(val1, val2) values in setup to the value of scale 

int lineNumber = 11; //Line of the partitions file which we want to load

//Variables that will be used for reading the partition from a file
BufferedReader reader;
String line;
String polygons[];

/*
Points will contain information about all the points of the given partition.
  The first dimension is the number of polygons of the partition
  The second dimension is the number of points per polygon
  The third dimension is always 2, "0" for x-coordinate and "1" for y-coordinate
*/
float points[][][];


void setup()
{
  size(500, 500); //Set these values to the same of scale!
  initializeData(lineNumber);
}

void draw()
{
  drawPoints();
}


void drawPoints()
{
  for (int i = 0; i < points.length; i++)
  {
    line( points[i][0][0] * scale,
          points[i][0][1] * scale,
          points[i][points[i].length - 1][0] * scale,
          points[i][points[i].length - 1][1] * scale); //Connect the first with the last one
    for (int j = 0; j < points[i].length - 1; j++) //We exclude the last one from the loop
      line( points[i][j][0] * scale,
            points[i][j][1] * scale,
            points[i][j+1][0] * scale,
            points[i][j+1][1] * scale);
  }
}




/*
Information from file to be read is considered to be as follows:
  P1=[verticesOfPol1, verticesOfPol2, ..., verticesOfPolN]
  P2=...

where verticesOfPol1 would be
  [(1.6, 2.54), (7.26, 52.5461), ..., (2.4, 6.3)]
*/
void initializeData(int lineNumber)
{
  reader = createReader("10_particiones.txt"); //handle the file
  
  for (int i = 1; i <= lineNumber; i++) //advance to desired line
  {
    try
    {
      line = reader.readLine();
    }
    catch (IOException e)
    {
      line = null;
      System.out.println("Exception when loading data...");
    }
  }
  
  if (line == null) //error
    System.out.println("Error when loading partition...\nPlease make sure variable lineNumber has a correct value and your partition file contains one partition per line.");
    
  //line contains the raw polygon list from file
  
  line = line.replace(" ", "");  //We delete blank spaces
  line = line.replace("]", "");  //We delete close square brackets
  line = line.replace(")", "");  //We delete close round brackets
  
  polygons = line.split("\\["); //The first 2 elements will be trash
  
  points = new float[polygons.length - 2][][];
  
  for (int i = 2; i < polygons.length; i++) //We start from 2 since polygons[0] = "partition_name" and polygons[1] = "" (empty string)
  {
    String pointPairs[] = polygons[i].split("\\("); //The first element will be trash
    
    points[i-2] = new float[pointPairs.length - 1][2];
    
    for (int j = 1; j < pointPairs.length; j++)
    {
      String[] point = pointPairs[j].split(",");
      points[i-2][j-1][0] = Float.parseFloat(point[0]); 
      points[i-2][j-1][1] = Float.parseFloat(point[1]);
    }
  }
  
  System.out.println("Data initialization successful");
}
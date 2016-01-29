import megamu.mesh.*;

final int scale = 500; //Important: change size(val1, val2) values in setup to the value of scale 

int lineNumber = 9; //Line of the partitions file which we want to load

//Variables that will be used for reading the partition from a file
BufferedReader reader;
String line;
String polygons[];

/*
partition will contain information about all the points of the given partition.
  The first dimension is the number of polygons of the partition
  The second dimension is the number of points per polygon
  The third dimension is always 2, "0" for x-coordinate and "1" for y-coordinate
*/
float partition[][][];
float barycenters[][];

Voronoi myVoronoi;

void setup()
{
  size(500, 500); //Set these values to the same of scale!
  
  if (height != scale || width != scale)
  {
    System.out.println("Size of window is not set accordingly... The drawings will not fill in the screen!\nPlease change the values in setup -> size(, ) to the one in -final int scale- and try again!");
    exit();
  }
  
  initializePartition(lineNumber);
  initializeBarycenters(); //Calculate the barycenters for each polygon of the partition
  myVoronoi = new Voronoi(barycenters); //Create Voronoi diagram from the barycenters
}

void draw()
{
  //We first draw the Voronoi diagram (of the barycenters)
  drawVoronoi();
  //And on top of that, we draw the given partition in green and the barycenters in blue
  drawPoints();
  drawBarycenters();
}

/*
Draws the Barycenters of the polygons of the given partition
*/
void drawBarycenters()
{
  stroke(0,0,255); //draw in blue
  strokeWeight(5); //draw thick points
  
  for (int i = 0; i < barycenters.length; i++)
    point(barycenters[i][0], barycenters[i][1]);
  
  stroke(0); //draw in black
  strokeWeight(1); //draw normal size
}

/*
Draws the Voronoi diagram
*/
void drawVoronoi()
{
  MPolygon[] myRegions = myVoronoi.getRegions();
  
  fill(255,0,0); //fill in red
  for(int i=0; i<myRegions.length; i++)
  {    
    myRegions[i].draw(this); // draw this shape
  }
  fill(0); //fill in black
}

/*
Calculates the barycenters of each polygon of points
*/
void initializeBarycenters()
{
  barycenters = new float[partition.length][2];
  
  float sumX, sumY;
  
  for (int i = 0; i < partition.length; i++) //for each polygon
  {
    sumX = 0;
    sumY = 0;
    
    for (int j = 0; j < partition[i].length; j++)
    {
      sumX += partition[i][j][0]*scale;
      sumY += partition[i][j][1]*scale;
    }
    
    barycenters[i][0] = sumX/partition[i].length;
    barycenters[i][1] = sumY/partition[i].length;
  }
}

/*
Draws the "points" array to the screen
*/
void drawPoints()
{
  stroke(0,255,0); //draw in green
  
  for (int i = 0; i < partition.length; i++) //for each polygon
  {
    line( partition[i][0][0] * scale,
          partition[i][0][1] * scale,
          partition[i][partition[i].length - 1][0] * scale,
          partition[i][partition[i].length - 1][1] * scale); //First, connect the first point with the last
    for (int j = 0; j < partition[i].length - 1; j++) //For every other point, connect it to the next one
      line( partition[i][j][0] * scale,
            partition[i][j][1] * scale,
            partition[i][j+1][0] * scale,
            partition[i][j+1][1] * scale);
  }
  
  stroke(0); //draw in black
}




/*
Information from file to be read is considered to be as follows:
  P1=[verticesOfPol1, verticesOfPol2, ..., verticesOfPolN]
  P2=...

where verticesOfPol1 would be
  [(1.6, 2.54), (7.26, 52.5461), ..., (2.4, 6.3)]
*/
void initializePartition(int lineNumber)
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
  {
    System.out.println("Error when loading partition...\nPlease make sure variable lineNumber has a correct value and your partition file contains one partition per line.");
    System.out.println("Current value of lineNumber: " + lineNumber);
  }
    
  //line contains the raw polygon list from file
  
  line = line.replace(" ", "");  //We delete blank spaces
  line = line.replace("]", "");  //We delete close square brackets
  line = line.replace(")", "");  //We delete close round brackets
  
  polygons = line.split("\\["); //The first 2 elements will be trash
  
  partition = new float[polygons.length - 2][][];
  
  for (int i = 2; i < polygons.length; i++) //We start from 2 since polygons[0] = "partition_name" and polygons[1] = "" (empty string)
  {
    String pointPairs[] = polygons[i].split("\\("); //The first element will be trash
    
    partition[i-2] = new float[pointPairs.length - 1][2];
    
    for (int j = 1; j < pointPairs.length; j++)
    {
      String[] point = pointPairs[j].split(",");
      partition[i-2][j-1][0] = Float.parseFloat(point[0]); 
      partition[i-2][j-1][1] = Float.parseFloat(point[1]);
    }
  }
  
  System.out.println("Data initialization successful");
}
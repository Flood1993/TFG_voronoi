import megamu.mesh.*;

final int scale = 500; //Important: change size(val1, val2) values in setup to the value of scale 

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
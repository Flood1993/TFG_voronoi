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
// Author: Guillermo Alonso Nunez
// e-mail: guialonun@gmail.com

// Calculates the barycenter for each polygon of "points"
void initializeBarycenters() {
    barycenters = new ArrayList<float []>();
    float sumX, sumY;

    for (int i = 0; i < partition.size(); i++) { // for each polygon
        sumX = 0;
        sumY = 0;
        for (int j = 0; j < partition.get(i).size(); j++) {
            sumX += partition.get(i).get(j)[0];
            sumY += partition.get(i).get(j)[1];
        }
        barycenters.add(new float[]
                            {
                                sumX/partition.get(i).size(),
                                sumY/partition.get(i).size()
                            });
    }
}

// Converts Voronoi structure to our format, so we can calculate on it
ArrayList<ArrayList<float []>> storeVoronoi(Voronoi vor) {
    ArrayList<ArrayList<float []>> res = new ArrayList<ArrayList<float []>>();
    ArrayList<float []> tmp;
    MPolygon[] myRegions = vor.getRegions();

    for(int i = 0; i < myRegions.length; i++) {
        tmp = new ArrayList<float []>();
        float[][] regionCoordinates = myRegions[i].getCoords();

        for (int j = 0; j < regionCoordinates.length; j++)
            tmp.add(regionCoordinates[j]);

        res.add(tmp);
    }

    return res;
}

float[][] arrayBarycenters(ArrayList<float []> points) {
    float res[][] = new float[points.size()][2];

    for (int i = 0; i < points.size(); i++) {
        res[i] = points.get(i);
    }

    return res;
}

// Loads information from an external file, storing it in "partition"
//
// Information from file to be read is considered to be as follows:
//   P1=[verticesOfPol1, verticesOfPol2, ..., verticesOfPolN]
//   P2=...
//
// where verticesOfPol1 would be
//  [(1.6, 2.54), (7.26, 52.5461), ..., (2.4, 6.3)]
void initializePartition(int lineNumber) {
    reader = createReader(fileToReadFrom); // handle the file

    for (int i = 1; i <= lineNumber; i++) { // advance to desired line
        try {
            line = reader.readLine();
        } catch (IOException e) {
            line = null;
            System.out.println(excLoadingData); // error
        }
    }

    if (line == null)
        System.out.println(errLoadingPart + lineNumber); // error

                             // line contains raw polygon list from file
    line = line.replace(" ", "");  // delete blank spaces
    line = line.replace("]", "");  // delete close square brackets
    line = line.replace(")", "");  // delete close round brackets

    polygons = line.split("\\["); //The first 2 elements will be trash

    partition = new ArrayList<ArrayList<float []>>();
    ArrayList<float []> tmp = new ArrayList<float []>();

    for (int i = 2; i < polygons.length; i++) {  // first 2 are trash
        tmp = new ArrayList<float []>(); // CRITICAL?
        String pointPairs[] = polygons[i].split("\\("); // first trash

        for (int j = 1; j < pointPairs.length; j++) {
            String[] point = pointPairs[j].split(",");

            tmp.add(new float[]
                        {
                            Float.parseFloat(point[0]) * scale,
                            Float.parseFloat(point[1]) * scale
                        });
        }

        partition.add(tmp);
    }
}
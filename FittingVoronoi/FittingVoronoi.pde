// Author: Guillermo Alonso Nunez
// e-mail: guillermo.alonso.nunez@alumnos.upm.es

import megamu.mesh.*;

final int scale = 500; // size(...) parameters should have this value
final float squareArea = scale*scale;

boolean debugging = false;

// Values relative to the square unit
float simulatedAnnealing[] = new float[]{0.05, 0.04, 0.01, 0.005, 0.001};
// As of now, these values are hard-coded (they don't care about resolution)
int stepIndex = 0;
boolean hasImproved = true;
StringBuilder sb = new StringBuilder();

// Executed once
void setup() {
    size(800, 600); // set these values to the same of scale!
    
    background(backgroundColor); // clear screen

    /*if (height != scale || width != scale) { // check size
        System.out.println(errIncorrSize);
        exit();
    }*/

    output = createWriter("Output.csv");
    
    randomSeed(rndmSeed);
    
    initializePartition(lineNumber);
    initializeBarycenters();
    partition = positiveOrientation(partition, barycenters);
    floatBarycenters = arrayBarycenters(barycenters); // Convert barycenters to array (Voronoi input format)
    myVoronoi = new Voronoi(floatBarycenters);
    flVoronoi = storeVoronoi(myVoronoi); // Store to array list from the voronoi format
    flVoronoi = positiveOrientation(flVoronoi, barycenters);
    flVoronoi = clipPartitionToSquare(flVoronoi);
    symmetricDiff = totalSymDiff(partition, flVoronoi);
    symDiffAtStart = symmetricDiff;
    
    fill(150, 160, 160);
    rect(drawingOffset, drawingOffset, scale, scale);
    fill(backgroundColor);
    
    drawPart(partition, defaultBlack);
    drawPart(flVoronoi, defaultGreen);
    drawBarycenters();
    
    drawTextGUI();
    
    
    if (!firstScreenSaved) {
        saveFrame("Output-Start.png");
        firstScreenSaved = true;
    }
    
    if (debugging)
        System.out.println("Sym diff setup: " + symmetricDiff);
    delay(400);
}

// Executed every frame
void draw() { 
    background(backgroundColor); // clear screen

    fill(150, 160, 160);
    rect(drawingOffset, drawingOffset, scale, scale);
    fill(backgroundColor);

    if (!finished)
        gradientMethod(simulatedAnnealing[stepIndex]*scale, true);

    if (!hasImproved && stepIndex < simulatedAnnealing.length) {
        stepIndex++;
    }
    drawPart(partition, defaultBlack);
    drawPart(flVoronoi, defaultGreen);
    drawBarycenters();
    
    drawTextGUI();
    
    
    if (!finished && !hasImproved && stepIndex == simulatedAnnealing.length) {
        finished = true;
        saveFrame("Output-End.png");
        output.flush();
        output.close();
        //exit();
    }
    
    
    if (debugging)
        delay(800);
}

// Returns the signed area of a triangle
float areaTriang(float A[], float B[], float C[]) {
    float ax = A[0], ay = A[1];
    float bx = B[0], by = B[1];
    float cx = C[0], cy = C[1];

    return ((bx*cy - cx*by) - (ax*cy - cx*ay) + (ax*by - bx*ay))/2;
}

// Returns the signed area of a polygon
float areaPolygon(ArrayList<float []> pol) {
    float res = 0;
    float point[] = new float[]{scale/2, scale/2};

    for (int i = 0; i < pol.size(); i++) {
        int iNext = (i == pol.size() - 1) ? 0 : i + 1;

        res += areaTriang(pol.get(i), pol.get(iNext), point);
    }

    return res;
}

// Clips a polygon with a given line
ArrayList<float []> clipLine(ArrayList<float []> pol, float lineStart[],
        float lineEnd[]) {
    ArrayList<float []> res = new ArrayList<float []>();

    for (int i = 0; i < pol.size(); i++) {
        int iNext = (i == pol.size() - 1) ? 0 : i + 1;

        float areaOrigin = areaTriang(lineStart, lineEnd, pol.get(i));
        float areaEnd = areaTriang(lineStart, lineEnd, pol.get(iNext));

        // Check current start
        if (areaOrigin >= 0)
            res.add(pol.get(i));

        // Check for intermediate points
        if (areaOrigin * areaEnd < 0) {
            float t = segmentIntersection(lineStart, lineEnd, pol.get(i), 
                    pol.get(iNext));
            if (t >= 0 && t < 1) {
                float x = pol.get(i)[0];
                float y = pol.get(i)[1];
                float xNext = pol.get(iNext)[0];
                float yNext = pol.get(iNext)[1];

                res.add(new float[]{x + (xNext - x)*t, y + (yNext - y)*t});
            }                
        }
    }

    return res;
}

void gradientMethod(float step, boolean useSimulatedAnnealing) {
    stepCount++;
    // TODO: randomize barycenter order
    hasImproved = false;

    int accessOrder[] = new int[barycenters.size()];
    
    for (int pos = 0; pos < accessOrder.length; pos++)
        accessOrder[pos] = pos;

    for (int i = 0; i < accessOrder.length; i++) {
        int swapWith = (int) random(accessOrder.length);
        int tmp = accessOrder[i];
        accessOrder[i] = accessOrder[swapWith];
        accessOrder[swapWith] = tmp;
    }

    for (int j = 0; j < accessOrder.length; j++) { // for each point
        int i = accessOrder[j];

        float randomNumber = random(0, 1);

        // TODO: Need some refactoring
        ArrayList<float []> bestSolution = barycenters;
        flVoronoi = positiveOrientation(flVoronoi, barycenters);
        float bestSymDiff = totalSymDiff(partition, flVoronoi);
        
        float simAnnValue = 0;






        ArrayList<float []> clonedBarycenters = cloneArraylist(barycenters);
        clonedBarycenters.get(i)[0] = clonedBarycenters.get(i)[0] + step;
        float [][] newBarycenters = arrayBarycenters(clonedBarycenters);
        tmpVor = new Voronoi(newBarycenters);
        ArrayList<ArrayList<float []>> tmpNewStuff = storeVoronoi(tmpVor);
        tmpNewStuff = positiveOrientation(tmpNewStuff, clonedBarycenters);
        tmpNewStuff = clipPartitionToSquare(tmpNewStuff);

        float diff = totalSymDiff(partition, tmpNewStuff);

        if (debugging)
            System.out.println("Diff 1: " + diff);

        simAnnValue = exp((symmetricDiff - diff)/step);
        if ((diff < bestSymDiff) || (useSimulatedAnnealing && simAnnValue < randomNumber)) {
            hasImproved = true;
            bestSolution = clonedBarycenters;
            bestSymDiff = diff;
        }

        clonedBarycenters = cloneArraylist(barycenters);
        clonedBarycenters.get(i)[0] = clonedBarycenters.get(i)[0] - step;
        newBarycenters = arrayBarycenters(clonedBarycenters);
        tmpVor = new Voronoi(newBarycenters);
        tmpNewStuff = storeVoronoi(tmpVor);
        tmpNewStuff = positiveOrientation(tmpNewStuff, clonedBarycenters);
        tmpNewStuff = clipPartitionToSquare(tmpNewStuff);
        diff = totalSymDiff(partition, tmpNewStuff);
        if (debugging)
            System.out.println("Diff 2: " + diff);
        simAnnValue = exp((symmetricDiff - diff)/step);
        if ((diff < bestSymDiff) || (useSimulatedAnnealing && simAnnValue < randomNumber)) {
            hasImproved = true;
            bestSolution = clonedBarycenters;
            bestSymDiff = diff;
        }

        clonedBarycenters = cloneArraylist(barycenters);
        clonedBarycenters.get(i)[1] = clonedBarycenters.get(i)[1] + step;
        newBarycenters = arrayBarycenters(clonedBarycenters);
        tmpVor = new Voronoi(newBarycenters);
        tmpNewStuff = storeVoronoi(tmpVor);
        tmpNewStuff = positiveOrientation(tmpNewStuff, clonedBarycenters);
        tmpNewStuff = clipPartitionToSquare(tmpNewStuff);
        diff = totalSymDiff(partition, tmpNewStuff);
        if (debugging)
            System.out.println("Diff 3: " + diff);
        simAnnValue = exp((symmetricDiff - diff)/step);
        if ((diff < bestSymDiff) || (useSimulatedAnnealing && simAnnValue < randomNumber)) {
            hasImproved = true;
            bestSolution = clonedBarycenters;
            bestSymDiff = diff;
        }

        clonedBarycenters = cloneArraylist(barycenters);
        clonedBarycenters.get(i)[1] = clonedBarycenters.get(i)[1] - step;
        newBarycenters = arrayBarycenters(clonedBarycenters);
        tmpVor = new Voronoi(newBarycenters);
        tmpNewStuff = storeVoronoi(tmpVor);
        tmpNewStuff = positiveOrientation(tmpNewStuff, clonedBarycenters);
        tmpNewStuff = clipPartitionToSquare(tmpNewStuff);
        diff = totalSymDiff(partition, tmpNewStuff);
        if (debugging)
            System.out.println("Diff 4: " + diff);
        simAnnValue = exp((symmetricDiff - diff)/step);
        if ((diff < bestSymDiff) || (useSimulatedAnnealing && simAnnValue < randomNumber)) {
            hasImproved = true;
            bestSolution = clonedBarycenters;
            bestSymDiff = diff;
        }

        if (debugging)
            System.out.println("Best symmetric difference: " + bestSymDiff);

        if (hasImproved) {
            sb.setLength(0); // clear sb

            for (int k = 0; k < barycenters.size(); k++) {
                if (k != 0)
                    sb.append(",");

                sb.append(barycenters.get(i)[0]);
                sb.append("@");
                sb.append(barycenters.get(i)[1]);
            }
            sb.append(",");
            sb.append(symmetricDiff);

            String outputLine = sb.toString();

            output.println(outputLine);
        }

        symmetricDiff = bestSymDiff;
        barycenters = bestSolution;
        floatBarycenters = arrayBarycenters(barycenters); // Voronoi input format
        myVoronoi = new Voronoi(floatBarycenters);
        flVoronoi = storeVoronoi(myVoronoi);
        flVoronoi = positiveOrientation(flVoronoi, barycenters);
        flVoronoi = clipPartitionToSquare(flVoronoi);
    }
}

// Clips a whole partition to the square
ArrayList<ArrayList<float []>> clipPartitionToSquare(
        ArrayList<ArrayList<float []>> partition) {
    ArrayList<ArrayList<float []>> res = new ArrayList<ArrayList<float []>>();

    for (int i = 0; i < partition.size(); i++) {
        ArrayList<float []> tmp = clipToSquare(partition.get(i));

        res.add(tmp);
    }

    return res;
}

// pol is assumed to be negatively oriented
ArrayList<float []> clipToSquare(ArrayList<float []> pol) {
    ArrayList<float []> res = new ArrayList<float []>();
    float c1[] = new float[]{0, 0};
    float c2[] = new float[]{scale, 0};
    float c3[] = new float[]{scale, scale};
    float c4[] = new float[]{0, scale};

    res = clipLine(pol, c1, c2);
    res = clipLine(res, c2, c3);
    res = clipLine(res, c3, c4);
    res = clipLine(res, c4, c1);

    return res;
}

// Returns a new polygon which is the intersection of two
ArrayList<float []> clipPolygons(ArrayList<float []> pol1,
        ArrayList<float []> pol2) {
    ArrayList<float []> res = new ArrayList<float []>();

    for (int i = 0; i < pol2.size(); i++) {
        int iNext = (i == pol2.size() - 1) ? 0 : i + 1;

        if (i == 0)
            res = clipLine(pol1, pol2.get(i), pol2.get(iNext));
        else
            res = clipLine(res, pol2.get(i), pol2.get(iNext));
    }

    return res;
}

float symDiff(ArrayList<float []> pol1, ArrayList<float []> pol2) {
    ArrayList<float []> intersection = clipPolygons(pol1, pol2);
    float areaIntersection = areaPolygon(intersection);

    return areaIntersection;
}

float totalSymDiff(ArrayList<ArrayList<float []>> x,
        ArrayList<ArrayList<float []>> y) {
    float res = squareArea;

    for (int i = 0; i < x.size(); i++) {
        res -= symDiff(x.get(i), y.get(i));
    }

    return res/squareArea;
}

// Makes sure all polygons are positively oriented
ArrayList<ArrayList<float []>> positiveOrientation(
        ArrayList<ArrayList<float []>> part, ArrayList<float []> barycenters) {
    
    ArrayList<ArrayList<float []>> res = new ArrayList<ArrayList<float []>>();
    
    // For each polygon
    for (int i = 0; i < part.size(); i++) {
        if (areaPolygon(part.get(i)) < 0) {
            ArrayList<float []> tmp = new ArrayList<float []>();

            for (int j = part.get(i).size() - 1; j >= 0; j--)
                tmp.add(part.get(i).get(j));

            res.add(tmp); // Change
        } else {
            res.add(part.get(i));
        }
    }

    return res;
}

// Returns -1 if there is no intersection. A value in [0, 1] if they intersect
float segmentIntersection(float[] l1, float[] l2, float[] s1, float[] s2) {
    float x1 = l1[0], y1 = l1[1];
    float x2 = l2[0], y2 = l2[1];
    float x3 = s1[0], y3 = s1[1];
    float x4 = s2[0], y4 = s2[1];

    // Same segments
    if (x1 == x3 && x2 == x4 && y1 == y3 && y2 == y4)
        return -1;

    // Both are vertical
    if (x1 == x2 && x3 == x4)
        return -1;

    // One is vertical
    if (x1 == x2 || x3 == x4) {
        float res = -1;

        if (x1 == x2) { // Line is vertical
            float t = (x1 - x3)/(x4 - x3);
            if (t >= 0 && t <= 1) {
                res = t;
            }
        }

        else if (x3 == x4) { // Segment is vertical
            float t = (x3 - x1)/(x2 - x1);
            if (t >= 0 && t <= 1) {
                float yItsc = y1 + (y2 - y1)*t;
                float k = (yItsc - y3)/(y4 - y3);

                if ((y3 >= yItsc && y4 <= yItsc) ||
                        (y3 <= yItsc && y4 >= yItsc))
                    res = k;
            }
        }

        return res;
    }
    
    // Diagonal. Check slopes of vectors
    float slopeL1 = (x1 < x2) ? (y2 - y1)/(x2 - x1) : (y1 - y2)/(x1 - x2);
    float slopeL2 = (x3 < x4) ? (y4 - y3)/(x4 - x3) : (y3 - y4)/(x3 - x4);
    // Same slope
    if (slopeL1 == slopeL2) {
        return -1;
    } else { // different slope
        float num = (x2 - x1)*(y1 - y3) + (y2 - y1)*(x3 - x1);
        float den = (x2 - x1)*(y4 - y3) - (y2 - y1)*(x4 - x3);

        float k = num/den;
        if (k >= 0 && k <= 1)
            return k;

        return -1;
    }
}

ArrayList<float []> cloneArraylist(ArrayList<float []> obj) {
    ArrayList<float []> res = new ArrayList<float []>();

    for (int i = 0; i < obj.size(); i++) {
        res.add(new float[]{obj.get(i)[0], obj.get(i)[1]});
    }

    return res;
}

void dbg(String txt) {
    System.out.println("dbg " + txt);
    delay(200);
}
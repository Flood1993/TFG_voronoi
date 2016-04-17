# Adjusting partitions of the plane through Voronoi diagrams

## About

The aim of my final year project is to study and design strategies for adjusting a given partition of the square unit through [Voronoi diagrams](http://mathworld.wolfram.com/VoronoiDiagram.html).

Since checking the whole search space is not doable, we will be using and comparing different heuristics, specifically the [gradient method](http://mathworld.wolfram.com/ConjugateGradientMethod.html) and the [simulated annealing technique](http://mathworld.wolfram.com/SimulatedAnnealing.html).

I am developing my project under the [Processing](https://processing.org/) IDE. For computing the Voronoi diagrams, I am using a library made by [Lee Byron](http://leebyron.com/mesh/).

If you have any question, suggestion or comment, please feel free to write me at guillermo.alonso.nunez@alumnos.upm.es

## Quick tour

So, we are giving a specific partition and we want to fit it the best we can...

Let's throw some "random" starting points at the given partition (in black) and calculate the corresponding Voronoi diagram (in green):

![alt text](https://github.com/Flood1993/TFG_voronoi/blob/master/images/start.png "Before adjusting")

It doesn't look like a good approximation... We need to do something in order to improve it. After applying an iterative gradient method, this is the result:

![alt text](https://github.com/Flood1993/TFG_voronoi/blob/master/images/end.png "After adjusting")

We managed to get something better, but we cannot guarantee this is the best possible solution.

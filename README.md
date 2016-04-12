# Adjusting partitions of the plane through Voronoi diagrams

The aim of my final year project is to study and design strategies for adjusting a given partition of the square unit through [Voronoi diagrams](http://mathworld.wolfram.com/VoronoiDiagram.html).

Since checking the whole search space is not doable, we will be using and comparing different techniques, specifically the [gradient method](http://mathworld.wolfram.com/ConjugateGradientMethod.html) and the [simulated annealing technique](http://mathworld.wolfram.com/SimulatedAnnealing.html).

I am developing my project under the [Processing](https://processing.org/) integrated development environment. For computing the Voronoi diagrams, I am using a library made by [Lee Byron](http://leebyron.com/mesh/).

If you have any question, suggestion or comment, please feel free to write me at guillermo.alonso.nunez@alumnos.upm.es

***

How would all of the above look like?

Let's throw some "random" starting points to a given partition (in black) and calculate the corresponding Voronoi diagram (in green)!

![alt text](https://github.com/Flood1993/TFG_voronoi/images/start.png "Before adjusting")

Oops, it doesn't look like a good approximation... Maybe we can do something about it?

![alt text](https://github.com/Flood1993/TFG_voronoi/images/end.png "After adjusting")

But... Is it the best we can do?
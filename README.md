# Power Crust MATLAB
an implementation of the Power Crust algorithm in MATLAB Code

### About Power Crust

Power Crust is an algorithm developed by Nina Amenta, Sunghee Choi, and Ravi Krishna Kolluri at the University of Texas at Austin. The algorithm takes in a point cloud as input, and outputs a surface mesh and the corresponding medial axis transform (MAT). A point cloud is a collections of points in space, typically in either 2D or 3D (Figure 1-1, Figure 2-1). These points are usually captured using a 3D scanner or similar technology, which, like all sensors that attempt to capture the real world, can often result in noisy data. Point clouds are typically assumed to be hallow in the inside, and the points represent points on the surface of the scanned object.

### Algorithm Overview

At a high level, the algorithm works by computing a set of balls on the interior and the exterior of the point cloud. These balls are referred to as “polar balls”, named as such because they are located at a set of Voronoi vertices from the input points referred to as “poles”. Each polar ball is given a radius equal to the distance between it and any sample point on the point cloud’s surface. Because the balls were positioned at the Voronoi vertices, this results in the set of balls on the inside of the cloud, and those on the outside, reaching towards each other to meet up at the point cloud surface itself. The algorithm simply needs to run a labelling process to determine which poles belong on the inside of the mesh and which on the outside, and then it can reconstruct a dense surface from where the balls meet up.

After the polar balls have been appropriately labeled, the algorithm creates another Voronoi diagram, this time using the poles themselves as inputs. This time, it creates a special kind of Voronoi diagram called a power diagram. A power diagram is just a weighted version of the standard Voronoi diagram, where each input point is assigned a weight to describe its influence on the Voronoi (“power”) regions. The process uses the square of the polar ball’s radius as it’s weight.
	
The power diagram generated in the previous step is then used to generate the mesh and the MAT. The mesh is defined as the set of vertices and edges in the power diagram separating the interior poles from the outer poles. These edges and vertices can be represented as a polygonal mesh with the same dimensionality as the input point cloud. The medial axis is defined as the set of poles labeled as interior regions. To form the MAT, we just join the medial axis points together based on the connectivity of the power diagram. If we take the dual of the interior power diagram cells, it forms the MAT. 


### Results

<p align="center">
  <img src="./result samples/input3D.png" alt="3D Input"/>
</p>
	Input Point Cloud

<p align="center">
  <img src="./result samples/MAT3D.png" alt="3D Mat"/>
</p>

	Output MAT

<p align="center">
  <img src="./result samples/Mesh3D.png" alt="3D Mesh"/>
</p>

	Output Surface Mesh


### Acknowledgements

* This project makes use of Frederick McCollum's [MATLAB Power Diagram code](http://www.mathworks.com/matlabcentral/fileexchange/44385-power-diagrams)

* Based on the paper by Nina Amenta, Sunghee Choi, and Ravi Krishna Kolluri at the University of Texas at Austin


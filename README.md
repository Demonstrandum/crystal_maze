# Crystal-Maze

A* Path finding for PNG mazes, from Ruby now in Crystal! Using StumpyPNG!
Now ×40 faster than its Ruby counterpart: [A-Star](https://github.com/Demonstrandum/A-Star)

![Example-400x400maze](mazes/400-example.png)

## Installation
Build it from source:
Clone and enter repository:
```shell
git clone https://github.com/Demonstrandum/Crystal-Maze.git && cd Crystal-Maze
```
then install dependencies with [`shards`](https://github.com/crystal-lang/shards) ([StumpyPNG](https://github.com/stumpycr/stumpy_png)):
```shell
shards install
```
and run the make file:
```shell
make
sudo make install clean
#sudo make uninstall # to remove the program
```

## Usage
To run the program itself:
```shell
maze ~/Pictures/yourImage.png
```
This will solve the maze and make and image with the suffix "-solved"<br />
e.g. `yourImage-solved.png` in the same location as the input image.


You can also add optional arguments of heuristic distance type, verbosity and wheather to draw nodes or not. For heuristic distance just type `euclidean` or `manhattan`  as argument for distance calculation type, these are the only two currently supported. Showing nodes is done with the argument `--show-nodes` and for verbosity (prints the nodes of the final path) either `-v`, `verbose` or `--verbose`.

For example:
```shell
maze euclidean -v hipMaze.png --show-nodes
```

## Maze PNG requirements
The start and end points of the maze must be from top to bottom. <br />
It's highly recommended that the maze's walls and paths are 1 pixel wide as the program draws and reads the paths as one pixel.  

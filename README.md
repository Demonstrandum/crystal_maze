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
them install dependencies with shard ([StumpyPNG](https://github.com/stumpycr/stumpy_png)):
```shell
shard install
```
then run the make file:
```shell
make
make install clean
#make uninstall, if you want.
```

## Usage
To run the program itself:
```shell
maze ~/Pictures/yourImage.png
```
This will solve the maze and make and image with the suffix "-solved"<br />
e.g. `yourImage-solved.png` in the same location as the input image.

## Maze PNG requirements
The start and end points of the maze must be from top to bottom. <br />
It's highly recommended that the maze's walls and paths are 1 pixel wide as the program draws and reads the paths as one pixel.  

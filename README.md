# A-Star

A* path finding algorithm for images, in Ruby.

## Usage
Clone and enter repository:
```shell
git clone https://github.com/Demonstrandum/A-Star.git && cd A-Star
```
then run the program itself:
```shell
ruby lib/A\*.rb ~/Pictures/yourImage.png
```
This will solve the maze and make and image with the suffix "-solved"<br />
e.g. `yourImage-solved.png` in the same location as the input image.

## Maze image requirements
The start and end points of the maze must be from top to bottom. <br />
It's highly recommended that the maze's walls and path are 1 pixel wide as the solver draws the path as one pixel.  

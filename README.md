# A-Star

A* path finding algorithm for images, in Ruby.

## Usage
Clone and enter repository:
```shell
git clone https://github.com/Demonstrandum/A-Star.git && cd A-Star
```
Then install the gem:
Either online:
```shell
gem install a-star
```
or build it from source:
```shell
gem build a-star.gemspec
gem install a-star-*
```
and run the program itself:
```shell
a-star ~/Pictures/yourImage.png
```
This will solve the maze and make and image with the suffix "-solved"<br />
e.g. `yourImage-solved.png` in the same location as the input image.

## Maze image requirements
The start and end points of the maze must be from top to bottom. <br />
It's highly recommended that the maze's walls and paths are 1 pixel wide as the program draws and reads the paths as one pixel.  

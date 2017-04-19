require 'chunky_png'

image = nil

begin   
    image = ChunkyPNG::Image.from_file(ARGV[ARGV.length - 1])
rescue
    puts "Please supply correct commandline arguments. No image given."
end

def findStart image
    # ...
end

def findEnd image
    # ...
end

class Astar
    def initialize(maze, start, dest)
        inf = Float::INFINITY
        
        #@firstNode = Node.new(start[0], start[1], -1, -1, -1, -1) ...
        #@destNode  = ==========dest======dest==================== ...

        @height       = maze.width
        @width        = maze.height
        @perimiter    = 2 * height + 2 * width
        @area = total = height * width
        
        
        @visited  = [false] * total
        @previous = [nil]   * total
        @distance = [inf]   * total

        #@unvisited = someHeapFunc() ...
    end
end

unless image.nil? 
    Astar.new.solver(image, findStart image, findEnd image)
end

class Node
    # ...
end

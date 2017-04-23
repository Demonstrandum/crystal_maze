require 'chunky_png'
@inf = Float::INFINITY
image = nil

begin
  image = ChunkyPNG::Image.from_file(ARGV[ARGV.length - 1])
rescue
  puts "Please supply correct commandline arguments. No image given."
end

class FromTo
  def initialize image
    @image = image
  end

  def findEnd
    0.upto @image.dimension.width - 1 do |i|
      red = ChunkyPNG::Color.r(@image[i, @image.dimension.height - 1])
      green = ChunkyPNG::Color.g(@image[i, @image.dimension.height - 1])
      blue = ChunkyPNG::Color.b(@image[i, @image.dimension.height - 1])

      if red > 255/2 && green > 255/2 && blue > 255/2
        return [i, @image.dimension.height - 1]
      end
    end
    return Array.new
  end

  def findStart
    0.upto @image.dimension.width - 1 do |i|
      red = ChunkyPNG::Color.r(@image[i, 0])
      green = ChunkyPNG::Color.g(@image[i, 0])
      blue = ChunkyPNG::Color.b(@image[i, 0])

      if red > 255/2 && green > 255/2 && blue > 255/2
        return [i, 0]
      end
    end
    return Array.new
  end
end

class Astar
  def initialize maze, start, dest
    raise "Either start, end or both locations not found!" if start.empty? || dest.empty?
    puts start.to_s + ", " + dest.to_s # REMOVE ME, testing only.
    @maze = maze
    @start = start
    @dest = dest
    puts @start[0]

    #@firstNode = Node.new start[0], start[1], -1, -1, -1, -1)
    #@destNode  = Node.new dest[0], dest[1], -1, -1, -1, -1)
    @height       = maze.dimension.height
    @width        = maze.dimension.width
    @perimiter    = (2 * @width) + (2 * @height)
    @area = @width * @height

    @unvisited = []
    @visited  = []
    #@unvisited.push @firstNode

    puts @nodeList.to_s + "\n" + @nodeList.length.to_s###########
  end

  def solve
    solvedMaze = @maze
    startColour = "#6414e6"
    destColour  = "#e67777"
    solvedMaze[@start[0], @start[1]] = ChunkyPNG::Color.from_hex startColour
    solvedMaze[@dest[0], @dest[1]] = ChunkyPNG::Color.from_hex destColour




    (1..@width - 1).each do |x|
      (1..@height - 1).each do |y|
        red = ChunkyPNG::Color.r(@maze[x, y])
        green = ChunkyPNG::Color.g(@maze[x, y])
        blue = ChunkyPNG::Color.b(@maze[x, y])
        if red > 255/2 && green > 255/2 && blue > 255/2


          #solvedMaze[x, y] = ChunkyPNG::Color.from_hex startColour
        end
      end
    end

    mazeName = ARGV[ARGV.length - 1]
    mazeLabel = (mazeName.split /\s|\./)[0]
    mazeFileType = "." + (mazeName.split /\s|\./)[1]
    solvedMaze.save(mazeLabel + "-solved" + mazeFileType)
  end

  def heuristic here, destination
    return (((here[0] - destination[0] ** 2) + (here[1] - destination[1]) ** 2) ** 0.5).floor
  end

  def cost here, destination
    direction = direction here, destination
    if direction.include? [2, 4, 6, 8]
      return 10
    end
    return 14
  end

  def direction here, destination
    direction = [ destination[1] - here[1], destination[0] - here[0] ]
    return case
      when direction[0] > 0 && direction[1] == 0
        2 # y-negative, down
      when direction[1] < 0 && direction[0] == 0
        4 # x-negative, left
      when direction[0] < 0 && direction[1] == 0
        8 # y-positive, up
      when direction[1] > 0 && direction[0] == 0
        6 # x-positive, right
    end
    return 0
  end

end

unless image.nil?
  loc = FromTo.new image
  init = Astar.new image, loc.findStart, loc.findEnd
  init.solve
end

class Node
  # ...
end

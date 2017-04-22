require 'chunky_png'

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

  def findStart
    0.upto @image.dimension.width - 1 do |i|
      red = ChunkyPNG::Color.r(@image[i, @image.dimension.height - 1])
      green = ChunkyPNG::Color.r(@image[i, @image.dimension.height - 1])
      blue = ChunkyPNG::Color.r(@image[i, @image.dimension.height - 1])

      if red > 255/2 && green > 255/2 && blue > 255/2
        return [(@image.dimension.width - 1) - (i - 1), @image.dimension.height - 1]
      end
    end
    return Array.new
  end

  def findEnd
    0.upto @image.dimension.width - 1 do |i|
      red = ChunkyPNG::Color.r(@image[i, 0])
      green = ChunkyPNG::Color.r(@image[i, 0])
      blue = ChunkyPNG::Color.r(@image[i, 0])

      if red > 255/2 && green > 255/2 && blue > 255/2
        return [(@image.dimension.width - 1) - (i - 1), 0]
      end
    end
    return Array.new
  end
end

class Astar
  def initialize maze, start, dest
    raise "Either start, end or both locations not found!" if start.empty? || dest.empty?
    puts start.to_s + ", " + dest.to_s # REMOVE ME, testing only.
    inf = Float::INFINITY

    #@firstNode = Node.new start[0], start[1], -1, -1, -1, -1)
    #@destNode  = Node.new dest[0], dest[1], -1, -1, -1, -1)

    @height       = maze.dimension.width - 1
    @width        = maze.dimension.height - 1
    @perimiter    = (2 * (@height + 1)) + (2 * (@width + 1))
    @area = (@height + 1) * (@width + 1)
    @total = @height * @width

    @nodeList = [nil] * @total
    @visited  = [false] * @total
    @previous = [nil]   * @total
    @distance = [inf]   * @total

    #@unvisited = someHeapFunc() ...
  end
end

unless image.nil?
  loc = FromTo.new image
  Astar.new image, loc.findStart, loc.findEnd
end

class Node
  # ...
end

require 'chunky_png'

@inf = Float::INFINITY
image = nil

begin
  image = ChunkyPNG::Image.from_file(ARGV[ARGV.length - 1])
rescue
  puts "Please supply correct commandline arguments.\nNo image given or wrong image format, PNG only!"
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

def node x, y, index, cost, destCost, totalCost
  return [x, y, index, cost, destCost, totalCost]
end

class Astar
  def initialize maze, start, dest
    raise "Either start, end or both locations not found!" if start.empty? || dest.empty?
    @maze = maze
    @start = start
    @dest = dest
    @solvedMaze = @maze
    mazeName = ARGV[ARGV.length - 1]
    @mazeLabel = (mazeName.split /\s|\./)[0]
    @mazeFileType = "." + (mazeName.split /\s|\./)[1]

    @firstNode = node start[0], start[1], -1, -1, -1, -1 # [x, y, index, startCost, destcost, totalCost]
    @destNode  = node dest[0], dest[1],   -1, -1, -1, -1

    @height       = maze.dimension.height
    @width        = maze.dimension.width
    @perimiter    = (2 * @width) + (2 * @height)
    @area = @width * @height
    @open = []
    @unvisited  = []
    @open << @firstNode
  end

  def solve

    while @open.length > 0 do
      minIndex = 0
      0.upto @open.length - 1 do |i|
        if @open[i][5] < @open[minIndex][5]
          minIndex = i
        end
      end
      chosenNode = minIndex

      here = @open[chosenNode]

      if here[0] == @destNode[0] && here[1] == @destNode[1]
        path = [@destNode]
        puts "We're here! Final node at: (x: #{here[0]}, y: #{here[1]})"
        while here[2] != -1 do
          here = @unvisited[here[2]]
          path.unshift here
        end
        puts "The entire path from #{@start} to #{@dest} is: \n#{path}"
        path.each do |arr|
          @solvedMaze[arr[0], arr[1]] = ChunkyPNG::Color.from_hex "#6691ff"
        end
        return path
      end

      @open.delete_at chosenNode
      @unvisited << here

      friendNodes = lookAround here
      0.upto friendNodes.length - 1 do |j|
        friend = friendNodes[j]
        horizontalFriend = friend[0]
        verticalFriend   = friend[1]

        if passable? horizontalFriend, verticalFriend || (horizontalFriend = @destNode[0] && verticalFriend == @destNode[1])
          onUnvisited = false
          0.upto @unvisited.length - 1 do |k|
            unvisitedNode = @unvisited[k]
            if horizontalFriend == unvisitedNode[0] && verticalFriend == unvisitedNode[1]
              onUnvisited = true
              break
            end
          end
          next if onUnvisited

          onOpen = false
          0.upto @open.length - 1 do |k|
            openNode = @open[k]
            if horizontalFriend == openNode[0] && verticalFriend == openNode[1]
              onOpen = true
              break
            end
          end

          unless onOpen
            newNode = node horizontalFriend, verticalFriend, @unvisited.length - 1, -1, -1, -1
            newNode[3] = here[3] + cost(here, newNode)
            newNode[4] = heuristic newNode, @destNode
            newNode[5] = newNode[3] + newNode[4]

            @open << newNode
            #puts "!! New Node at\n(x: " + horizontalFriend.to_s + ", y: " + verticalFriend.to_s + ")"
            #puts "Destination = " + @destNode[0].to_s + ", " + @destNode[1].to_s
            # Uncoment below to see unvisited nodes!
            @solvedMaze[horizontalFriend, verticalFriend] = ChunkyPNG::Color.from_hex "#fad1ee"
          end
        end
      end
    end
    return []
  end

  def heuristic here, destination
    return ( Math.sqrt( ((here[0] - destination[0]) ** 2) + ((here[1] - destination[1]) ** 2) ) ).floor
  end

  def cost here, destination
    direction = direction here, destination
    if [2, 4, 6, 8].include? direction
      return 10
    end
    return 14
  end

  def passable? x, y
    if (x < 0 || y < 0) || (x > @width - 1 || y > @height - 1)
      return false
    end
    red = ChunkyPNG::Color.r(@maze[x, y])
    green = ChunkyPNG::Color.g(@maze[x, y])
    blue = ChunkyPNG::Color.b(@maze[x, y])
    if red > 255/2 && green > 255/2 && blue > 255/2
      return true
    end
    return false
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

  def lookAround here
    return [
      [here[0], (here[1] - 1)], # y-positive, up
      [here[0], (here[1] + 1)], # y-negative, down
      [(here[0] + 1), here[1]], # x-positive, right
      [(here[0] - 1), here[1]]  # x-negative, left
    ]
  end

  def draw
    puts "Solving..."
    go = Time.new

    solve # Here we go

    finish = Time.new
    puts "\n\nTime taken to solve: " + (finish - go).to_s + " seconds!"
    minutes = ((finish - go) / 60).round
    if minutes > 0
      if minutes > 1
        puts "Circa " + minutes.to_s + " Minutes."
      else
        puts "Circa " + minutes.to_s + " Minute."
      end
    end

    startColour = "#ff5c7e"
    destColour  = "#68fb9f"
    @solvedMaze[@start[0], @start[1]] = ChunkyPNG::Color.from_hex startColour
    @solvedMaze[@dest[0], @dest[1]] = ChunkyPNG::Color.from_hex destColour

    mazeName = ARGV[ARGV.length - 1]
    mazeLabel = (mazeName.split /\s|\./)[0]
    mazeFileType = "." + (mazeName.split /\s|\./)[1]
    @solvedMaze.save(mazeLabel + "-solved" + mazeFileType)
  end
end

unless image.nil?
  loc = FromTo.new image
  init = Astar.new image, loc.findStart, loc.findEnd
  draw = init.draw
end

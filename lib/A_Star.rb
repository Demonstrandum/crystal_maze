require 'chunky_png'

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

def node x, y, index, cost, heuristic, totalCost
  return [x, y, index, cost, heuristic, totalCost]
end

class AStar
  def initialize maze, start, dest
    raise "Either start, end or both locations not found!" if start.empty? || dest.empty?
    @maze = maze
    @start = start
    @dest = dest
    @solvedMaze = @maze
    mazeName = ARGV[ARGV.length - 1]
    @mazeLabel = mazeName.split( /()\s|\./)[0]
    @mazeFileType = "." + mazeName.split(/\s|\./)[1]

    @firstNode = node start[0], start[1], -1, -1, -1, -1 # [x, y, index, cost, heuristic, totalCost]
    @destNode  = node dest[0], dest[1],   -1, -1, -1, -1

    @height       = maze.dimension.height
    @width        = maze.dimension.width
    @perimiter    = (2 * @width) + (2 * @height)
    @area = @width * @height
    @visited = []
    @unvisited  = []
    @visited << @firstNode
  end

  def solve

    until @visited.empty? do
      minIndex = 0
      0.upto @visited.length - 1 do |i|
        if @visited[i][5] < @visited[minIndex][5]
          minIndex = i
        end
      end
      chosenNode = minIndex

      here = @visited[chosenNode]

      if here[0] == @destNode[0] && here[1] == @destNode[1]
        path = [@destNode]
        puts "We're here! Final node at: (x: #{here[0]}, y: #{here[1]})"
        until here[2] == -1 do
          here = @unvisited[here[2]]
          path.unshift here
        end
        puts "The entire path from node #{@start} to node #{@dest} are the nodes: \n#{path}"

        hue = 0
        hueCoeff = 360.0 / path.length # when * by path.length (the end of the arr) it would be 360, so one complete rainbow

        (1..path.length).each do |n|
          @solvedMaze[ path[n - 1][0], path[n - 1][1] ] = ChunkyPNG::Color.from_hsl(hue, 1, 0.6)
          hue = (hueCoeff * n).floor # Rainbow!
        end

        return path
      end

      @visited.delete_at chosenNode
      @unvisited << here

      friendNodes = lookAround here
      0.upto friendNodes.length - 1 do |j|
        horizontalFriend = friendNodes[j][0]
        verticalFriend   = friendNodes[j][1]

        if passable? horizontalFriend, verticalFriend || (horizontalFriend == @destNode[0] && verticalFriend == @destNode[1])
          onUnvisited = false
          0.upto @unvisited.length - 1 do |k|
            unvisitedNode = @unvisited[k]
            if horizontalFriend == unvisitedNode[0] && verticalFriend == unvisitedNode[1]
              onUnvisited = true
              break
            end
          end
          next if onUnvisited

          onVisited = false
          0.upto @visited.length - 1 do |k|
            visitedNode = @visited[k]
            if horizontalFriend == visitedNode[0] && verticalFriend == visitedNode[1]
              onVisited = true
              break
            end
          end
          friendHeuristics = Array.new
          for k in 0..friendNodes.length - 1 do
            friendHeuristics << heuristic(friendNodes[k], @dest)
          end
          lowestHeuristic = friendHeuristics.min
          unless onVisited && heuristic(friendNodes[j], @dest) != lowestHeuristic # If you're somwhere new and is fastest
            newNode = node horizontalFriend, verticalFriend, @unvisited.length - 1, -1, -1, -1
            newNode[3] = here[3] + cost(here, newNode)
            newNode[4] = heuristic newNode, @destNode
            newNode[5] = newNode[3] + newNode[4]

            @visited << newNode
            #puts "!! New Node at\n(x: " + horizontalFriend.to_s + ", y: " + verticalFriend.to_s + ")"
            #puts "Destination = " + @destNode[0].to_s + ", " + @destNode[1].to_s
            # Uncoment below to see unvisited nodes!
            #@solvedMaze[horizontalFriend, verticalFriend] = ChunkyPNG::Color.from_hex "#999"
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
  end

  def lookAround here
    return [
      [here[0], (here[1] + 1)], # y-positive, up
      [here[0], (here[1] - 1)], # y-negative, down
      [(here[0] + 1), here[1]], # x-positive, right
      [(here[0] - 1), here[1]]  # x-negative, left
    ]
  end

  def draw
    puts "Solving..."

    go = Time.new # Start the time
    path = solve # Here we go!
    finish = Time.new # Take the finish time

    unless path.empty?
      puts "\n\nTime taken to solve: " + (finish - go).to_s + " seconds!"
      minutes = ((finish - go) / 60.0).round
      if minutes > 0
        if minutes > 1
          puts "Circa " + minutes.to_s + " Minutes."
        else
          puts "Circa " + minutes.to_s + " Minute."
        end
      end
    else
      puts "No solution found, solve function returned empty array for path!\nPlease make sure your maze is solvable!"
    end

    @solvedMaze.save(@mazeLabel + "-solved" + @mazeFileType)
  end
end

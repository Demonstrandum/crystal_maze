require 'chunky_png'

maze = nil

begin   
    maze = ChunkyPNG::Image.from_file(ARGV[ARGV.length - 1])
rescue
    puts "Please supply correct commandline arguments. No image given."
end


def Astar
    # TODO: Everything.
end


unless maze.nil?
    Astar()

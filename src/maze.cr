require "./a_star"

begin
  filepath : String = ""
  ARGV.each do |argument|
    if argument.includes? ".png"
      filepath = argument
      break
    end
  end
  image : StumpyCore::Canvas = StumpyPNG.read(filepath)
rescue
  puts "Please supply correct commandline arguments.\nNo image given or wrong image format, PNG only!"
  exit 1
end

distance_types : Array(String) = ["euclidean", "manhattan"]
if (ARGV & distance_types).size == 0
  puts "Distance type not specified, choosing default."
  distance = "manhattan"
else
  distance = (ARGV & distance_types).first
end

puts "Using distannce type: '#{distance}'."

unless ARGV.includes? "--show-nodes"
  hide_nodes? = true
  puts "Nodes will be hidden in the output image."
else
  hide_nodes? = false
  puts "Nodes will be visible in the output image."
end

gif = ARGV.includes? "--gif"
puts "Output image will be a gif of solving process." if gif

begining, ending = CrystalMaze::FromTo.find_start(image), CrystalMaze::FromTo.find_end(image)
if begining.empty? || ending.empty?
  puts "Could not find start and/or finish! Exiting..."
  exit 1
end

maze = CrystalMaze::AStar.new(
  canvas: image,
  start_coord: begining,
  end_coord: ending,
  hide_nodes: hide_nodes?,
  distance_type: distance,
  gif: gif
)

maze.draw
puts "Maze solution image generated at #{maze.final_file}"


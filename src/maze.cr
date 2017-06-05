require "A_Star"

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

distanceTypes : Array(String) = ["euclidean", "manhattan"]
if (ARGV & distanceTypes).size == 0
  puts "Distance type not specified, choosing default."
  distance = "manhattan"
else
  distance = (ARGV & distanceTypes).first
end

puts "Using distannce type: '#{distance}'."

unless ARGV.includes? "--show-nodes"
  hideNodes = true
  puts "Nodes will be hidden in the output image."
else
  hideNodes = false
  puts "Nodes will be visible in the output image."
end

begining, ending = FromTo.findStart(image), FromTo.findEnd(image)
if begining.empty? || ending.empty?
  puts "Could not find start and/or finish! Exiting..."
  exit 1
end

AStar.new(image, begining, ending, hideNodes)

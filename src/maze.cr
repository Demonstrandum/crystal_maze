require "A_Star"

begin
  image : StumpyCore::Canvas = StumpyPNG.read(ARGV[0])
rescue
  puts "Please supply correct commandline arguments.\nNo image given or wrong image format, PNG only!"
  exit 1
end

distanceTypes : Array(String) = ["euclidean", "manhattan"]
if ARGV.size <= 1
  ARGV << "manhattan" # If distance not specified, set to manhattan.
end

unless distanceTypes.includes? ARGV[1].downcase
  puts "Unknown distance type: '#{ARGV[1]}'!"
  exit 1
end

puts "Using distannce type: '#{ARGV[1]}'."
ARGV[1] = ARGV[1].downcase

begining, ending = FromTo.findStart(image), FromTo.findEnd(image)
if begining.empty? || ending.empty?
  puts "Could not find start and/or finish! Exiting..."
  exit 1
end

AStar.new(image, begining, ending)

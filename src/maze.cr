require "A_Star"

begin
  image : StumpyCore::Canvas = StumpyPNG.read(ARGV[0])
rescue
  puts "Please supply correct commandline arguments.\nNo image given or wrong image format, PNG only!"
  exit 1
end

begining, ending = FromTo.findStart(image), FromTo.findEnd(image)
if begining.empty? || ending.empty?
  puts "Could not find start and/or finish! Exiting..."
  exit 1
end

AStar.new(image, begining, ending)

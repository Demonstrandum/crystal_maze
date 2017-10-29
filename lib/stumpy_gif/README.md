# stumpy_gif

## Interface

* `StumpyGIF.write(frames : Array(Canvas), path, delay_between_frames = 10)`
  saves a list of frames (canvasses) as a GIF image file,
  `delay_between_frames` is in 1/100 of a second
* `Canvas` and `RGBA` from [stumpy_core](https://github.com/stumpycr/stumpy_core)

## Usage

### Writing

``` crystal
require "stumpy_gif"
include StumpyGIF

frames = [] of Canvas

(0..5).each do |z|
  canvas = Canvas.new(256, 256)

  (0..255).each do |x|
    (0..255).each do |y|
      color = RGBA.from_rgb_n([x, y, z * 51], 8)
      canvas[x, y] = color
    end
  end

  frames << canvas
end

StumpyGIF.write(frames, "rainbow.gif")
```

Left to right: Websafe, median split, NeuQuant

![GIF image with an animated color gradient](examples/rainbow_websafe.gif)
![GIF image with an animated color gradient](examples/rainbow_median_split.gif)
![GIF image with an animated color gradient](examples/rainbow_neuquant.gif)

(See `examples/` for more examples)

## Color Quantization Methods

* Use Websafe colors
* Median Split
* NeuQuant

## References

* [Kohonen Neural Networks for Optimal Colour Quantization](http://members.ozemail.com.au/~dekker/NeuQuant.pdf)

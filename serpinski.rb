require 'ruby2d'
require 'optparse'

def draw_triangle(x1, y1, x2, y2, x3, y3, color='blue', width=1)
  Line.new(
    x1: x1, y1: y1,
    x2: x2, y2: y2,
    width: width,
    color: color,
    z: 1
  )

  Line.new(
    x1: x2, y1: y2,
    x2: x3, y2: y3,
    width: width,
    color: color,
    z: 1
  )

  Line.new(
    x1: x3, y1: y3,
    x2: x1, y2: y1,
    width: width,
    color: color,
    z: 1
  )
end

def serpinski_triangle(x1, y1, x2, y2, x3, y3, recursion=3, color='blue', width=1)
  # Draw the outer triangle
  draw_triangle(x1, y1, x2, y2, x3, y3, color, width)
  # Draw the inner triangle by finding the midpoints between the three vertices
  x_a, y_a = x2 + (x1-x2)/2, y1 + (y2-y1)/2
  x_b, y_b = x1 + (x3-x1)/2, y1 + (y2-y1)/2
  x_c, y_c = x1, y3
  draw_triangle(x_a, y_a, x_b, y_b, x_c, y_c, color, width)
  # Draw the smaller serpinski triangles
  unless recursion == 1
    serpinski_triangle(x1, y1, x_a, y_a, x_b, y_b, recursion-1, color, width)
    serpinski_triangle(x_a, y_b, x2, y2, x_c, y_c, recursion-1, color, width)
    serpinski_triangle(x_b, y_b, x_c, y_c, x3, y3, recursion-1, color, width)
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = %{
Usage: ruby serpinski.rb [options]

Example:

ruby serpinski.rb --iterations=4
  }

  opts.on("-i", "--iterations [ITERATIONS]", "Number of iterations") do |iterations|
    options[:iterations] = iterations.to_i
  end

  opts.on("-c", "--color [COLOR]", "Color") do |color|
    options[:color] = color
  end
end.parse!

iterations = options[:iterations]
iterations = 1 if iterations <= 1

color = options[:color] || 'green'

x1 = Window.width/2
y1 = 10
x2 = 10
y2 = Window.height - 10
x3 = Window.width - 10
y3 = Window.height - 10

serpinski_triangle(x1, y1, x2, y2, x3, y2, iterations, color)

show

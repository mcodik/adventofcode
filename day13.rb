class Point
    attr_accessor :x, :y
    def initialize(x, y)
        @x = x
        @y = y
    end

    def fold_along_x(pos)
        # fold left
        if @x > pos
            @x = pos - (@x - pos)
        end
    end

    def fold_along_y(pos)
        # fold up
        if @y > pos
            @y = pos - (@y - pos)
        end
    end
end

def parse(filename)
    input = File.readlines(filename).map(&:strip)
    points = input.take_while { |l| l != "" }.map do |l| 
        p = l.split(",")
        Point.new(p[0].to_i, p[1].to_i)
    end
    folds = input.select { |l| l.start_with?("fold along") }.map do |l|
         prefix, pos = l.split("=")
         pos = pos.to_i
         [prefix.include?("x") ? :fold_along_x : :fold_along_y, pos]
    end
    [points, folds]
end

def dump(points)
    width = points.map { |p| p.x }.max
    height = points.map { |p| p.y }.max
    grid = Array.new(height+1) { Array.new(width+1, ".")}
    points.each do |p|
        grid[p.y][p.x] = "#"
    end
    grid.each do |row|
        puts row.join("")
    end
end

def folds(points, folds)
    folds.each do |(dir, pos)|
        points.each do |p|
            p.send(dir, pos)
        end
    end
    points.uniq! { |p| [p.x,p.y]}
    points.length
end

# test_input = parse("inputs/day13_test.txt")
# dump(test_input[0])
# puts part_a(test_input[0], test_input[1])
# puts "after fold: "
# dump(test_input[0])

input = parse("inputs/day13.txt")
# dump(test_input[0])
puts folds(input[0], input[1])
# puts "after fold: "
dump(input[0])

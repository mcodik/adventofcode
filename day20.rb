class Canvas
    attr_reader :out_of_bounds, :offsets
    def initialize(pixels, out_of_bounds)
        @pixels = pixels
        @out_of_bounds = out_of_bounds
        @out_writes = {}
        @offsets = []
        [-1, 0, 1].each do |i|
            [-1, 0, 1].each do |j|
                @offsets << [i,j]
            end
        end
    end

    def get(x, y)
        return @out_writes[[y,x]] if @out_writes.key?([y,x])
        return @out_of_bounds if y < 0 || y >= @pixels.length || x < 0 || x >= @pixels[0].length
        @pixels[y][x] 
    end

    def set(x, y, val)
        if y >= 0 && y < @pixels.length && x >= 0 && x < @pixels[0].length
            @pixels[y][x] = val
        else
            @out_writes[[y,x]] = val
        end
    end

    def width
        @pixels[0].length
    end

    def height
        @pixels.length
    end

    def get_square(x, y)
        @offsets.map do |(dy, dx)|
            self.get(x+dx, y+dy)
        end
    end

    def dark_pixels()
        raise "infinite!" if @out_of_bounds == "#"
        count = 0
        @out_writes.values.each { |v| count += 1 if v == "#"}
        @pixels.each do |row|
            row.each do |v|
                count += 1 if v == "#"
            end
        end
        count
    end
end

def parse(filename)
    lines = File.readlines(filename).map(&:strip)
    enhancement = lines.shift
    lines.shift
    [enhancement, Canvas.new(lines, ".")]
end

def to_index(address) 
    address.map { |b| b == "." ? 0 : 1 }.join("").to_i(2)
end

def enhance(start, end_offset, enhancement, canvas)
   result_pixels = Array.new(canvas.height - start) { Array.new(canvas.width - start, ".")}
   out_of_bounds_index = canvas.out_of_bounds == "." ? 0 : -1
   new_out_of_bounds = enhancement[out_of_bounds_index]
   result = Canvas.new(result_pixels, new_out_of_bounds) 
   (start..canvas.height+end_offset).each do |y|
        (start..canvas.width+end_offset).each do |x|
            address = canvas.get_square(x, y)
            index = to_index(address)
            replacement = enhancement[index]
            result.set(x, y, replacement)
        end
    end
    result
end 

def dump(x0, xn, y0, yn, canvas)
    (y0..yn).each do |y|
        row = []
        (x0..xn).each do |x|
            row << canvas.get(x, y)
        end
        puts row.join("")
    end
end

def part_a(filename)
    enhancement, canvas = parse(filename)
    new_canvas = enhance(-2, 2, enhancement, canvas)
    result = enhance(-4, 4, enhancement, new_canvas)
    result.dark_pixels
end

def part_b(filename)
    enhancement, canvas = parse(filename)
    50.times do |i|
        puts i
        canvas = enhance(-2*(i+1), 2*(i+1), enhancement, canvas)
    end
    canvas.dark_pixels
end

if __FILE__ == $0
    puts part_b("inputs/day20.txt")
end

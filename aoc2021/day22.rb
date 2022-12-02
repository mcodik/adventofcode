require "set"

def parse(filename)
    lines = File.readlines(filename).map(&:strip)
    lines.map do |line|
        op, cuboid = line.split(" ")
        dims = cuboid.split(",").map do |c| 
            nums = c[2..]
            s, e = nums.split("..").map(&:to_i).sort
            Range.new(s, e)
        end
        sign = op == "on" ? :+ : :-
        Cube.new(dims[0], dims[1], dims[2], sign)
    end
end

class Range
    def overlap?(other)
        return true if self.cover?(other) || other.cover?(self)
        (other.min <= self.min && other.max >= self.min) || (other.min <= self.max && other.max >= self.max)
    end
end

class Cube
    attr_reader :x, :y, :z
    attr_accessor :sign

    def initialize(x, y, z, sign)
        @x = x
        @y = y
        @z = z
        @sign = sign
    end

    def negate
        Cube.new(@x, @y, @z, @size == :+ ? :- : :+)
    end

    def size
        @x.size * @y.size * @z.size * (@sign == :+ ? 1 : -1)
    end
    
    def intersects?(other)
        x.overlap?(other.x) && y.overlap?(other.y) && z.overlap?(other.z)
    end

    def contains?(other)
        x.cover?(other.x) && y.cover?(other.y) && z.cover?(other.z)
    end

    def intersection(other, sign=:+)
        xp = intersect_range(x, other.x)
        yp = intersect_range(y, other.y)
        zp = intersect_range(z, other.z)
        Cube.new(xp, yp, zp, sign)
    end

    def minus(other)
        subcubes = []
        minus_points(@x, other.x).each do |xs| 
            minus_points(@y, other.y).each do |ys|
                minus_points(@z, other.z).each do |zs|
                    cube = Cube.new(xs, ys, zs, :+)
                    subcubes << cube unless cube == other
                end
            end
        end
        subcubes
    end

    def ==(other)
        @x.eql?(other.x) && @y.eql?(other.y) && @z.eql?(other.z) && @sign.eql?(other.sign) 
    end

    private

    def intersect_range(r1, r2)
        bounds = range_points(r1, r2)
        bounds[1] <= bounds[2] ? Range.new(bounds[1], bounds[2]) : nil
    end

    def range_points(r1, r2)
        [r1.min, r1.max, r2.min, r2.max].sort
    end

    def minus_points(me, other)
        result = []
        if me.min <= other.min && other.max <= me.max
            result = [[me.min, other.min-1], [other.min, other.max], [other.max+1, me.max]]
        else
            raise "unexpected? #{me} #{other}"
        end
        result.filter { |(a, b)| a <= b }.map { |(a,b)| Range.new(a,b) }
    end
end

class CubeSet
    attr_reader :cubes

    def initialize
        @cubes = []
    end

    def add(new_cube)
        new_cubes = []
        cubes_to_process = @cubes.clone
        while !cubes_to_process.empty? 
            cube = cubes_to_process.shift
            if cube.intersects?(new_cube)
                intersection = cube.intersection(new_cube)
                cubes_to_process.concat(cube.minus(intersection))
            else
                new_cubes << cube
            end
        end
        if new_cube.sign == :+
            new_cubes << new_cube
        end
        @cubes = new_cubes
    end

    def size
        @cubes.sum { |c| c.size }
    end
end

class NaiveReactor
    attr_reader :cubes
    def initialize
        @cubes = Set.new
    end

    def add(cube)
        if cube.sign == :+
            cube.x.each do |x|
                cube.y.each do |y|
                    cube.z.each do |z|
                        @cubes << [x,y,z]
                    end
                end
            end
        else
            cube.x.each do |x|
                cube.y.each do |y|
                    cube.z.each do |z|
                        @cubes.delete([x,y,z])
                    end
                end
            end
        end
    end

    def size
        @cubes.size
    end
end

def valid_range?(rs)
    (-50..50).cover?(rs)
end

def part_a(cubes)
    r = NaiveReactor.new
    cubes.each do |cube|
        next if !valid_range?(cube.x) || !valid_range?(cube.y) || !valid_range?(cube.z)
        # puts "exec #{op} "
        r.add(cube)
    end
    r.size
end
 
def solve_cubeset(cubes, filter)
    cs = CubeSet.new
    cubes.each do |cube|
        if filter
            next if !valid_range?(cube.x) || !valid_range?(cube.y) || !valid_range?(cube.z)
        end
        cs.add cube
    end
    cs.size
end

if __FILE__ == $0
    # puts part_a(parse("inputs/day22_test.txt"))
    # puts solve_cubeset(parse("inputs/day22_test.txt"), true)
    puts solve_cubeset(parse("inputs/day22.txt"), false)
end

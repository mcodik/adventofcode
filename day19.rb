require 'matrix'


class Scanner
    attr_reader :i, :beacons, :translation, :rotation
    def initialize(i, beacons)
        @i = i
        @beacons = beacons
        @rotation = 0
        @translation = Vector.zero(3)
    end

    def rotate(i)
        @rotation = i
        self
    end

    def translate(v)
        @translation = v
        self
    end

    def transformed_beacons
        beacons.map do |b|
            v = b + @translation
            apply_rotation(@rotation, v)
        end
    end

    def normalize(translation, rotation)
        @beacons = beacons.map do |v|
            b = apply_rotation(rotation, v)
            b + translation
        end
    end
end

def apply_rotation(i, v)
    Vector.elements(ROTATIONS[i].call([v[0], v[1], v[2]]))
end

def parse(filename)
    lines = File.readlines(filename).map(&:strip)
    scanners = []
    index = 0
    while lines.length > 0
        index += 1
        lines.shift # header
        beacon = lines.shift
        beacons = []
        while beacon != "" && !beacon.nil?
            beacons << Vector.elements(beacon.split(",").map { |c| c.to_i })
            beacon = lines.shift
        end
        scanners << Scanner.new(index, beacons)
        lines.shift
    end
    scanners
end

def dump(m)
    m.each do |row|
        puts "[" + row.map { |r| r.floor.to_s }.join(" ") + "]"
    end
end

ROTATIONS = [
        # x is facing x
        -> ((x,y,z)) { [x, y, z] },
        -> ((x,y,z)) { [x, -z, y] },
        -> ((x,y,z)) { [x, -y, -z] },
        -> ((x,y,z)) { [x, z, -y] },
        # x is facing -x
        -> ((x,y,z)) { [-x, -y, z] },
        -> ((x,y,z)) { [-x, -z, -y] },
        -> ((x,y,z)) { [-x, y, -z] },
        -> ((x,y,z)) { [-x, z, y] },
        # x is facing y
        -> ((x,y,z)) { [-z, x, -y] },
        -> ((x,y,z)) { [y, x, -z] },
        -> ((x,y,z)) { [z, x, y] },
        -> ((x,y,z)) { [-y, x, z] },
        # x is facing -y
        -> ((x,y,z)) { [z, -x, -y] },
        -> ((x,y,z)) { [y, -x, z] },
        -> ((x,y,z)) { [-z, -x, y] },
        -> ((x,y,z)) { [-y, -x, -z] },
        # x is facing z
        -> ((x,y,z)) { [-y, -z, x] },
        -> ((x,y,z)) { [z, -y, x] },
        -> ((x,y,z)) { [y, z, x] },
        -> ((x,y,z)) { [-z, y, x] },
        # x is facing -z
        -> ((x,y,z)) { [z, y, -x] },
        -> ((x,y,z)) { [-y, z, -x] },
        -> ((x,y,z)) { [-z, -y, -x] },
        -> ((x,y,z)) { [y, -z, -x] }
]

def match_with_vectors(s0, s1)
    s0.beacons.each do |b0|
        s0.translate(-b0)
        (0..ROTATIONS.length-1).each do |r|
            s1.beacons.each do |b1|
                s1.rotate(r)
                s1.translate(-b1)
                common_beacons = s0.transformed_beacons & s1.transformed_beacons
                if common_beacons.length >= 11
                    s0.translate(Vector[0,0,0])
                    s1.normalize(-scanner_loc, r)
                    return s1
                end
            end
        end
    end
    nil
end

def normalize_all(scanners)
    normalized = [scanners.shift]
    while scanners.length > 0
        made_progress = false
        normalized.clone.each do |n|
            scanners.clone.each do |s|
                s_prime = match_with_vectors(n, s)
                if !s_prime.nil?
                    normalized << s_prime
                    scanners.delete(s)
                    made_progress = true
                end
            end
        end
        if !made_progress
            raise "stuck?"
        end
    end
    beacons = {}
    normalized.each do |n|
        n.beacons.each do |b|
            beacons[b] = true
        end
    end
    beacons.keys
end

def part_a(filename)
    scanners = parse(filename)
    beacons = normalize_all(scanners)
    beacons.length
end

puts part_a("inputs/day19_test.txt")

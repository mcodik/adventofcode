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
        rotation_fn = ROTATIONS[@rotation]
        beacons.map do |b|
            v = b + @translation
            apply_rotation(@rotation, v)
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

def match_with_vectors_2(s0, s1)
    s0.beacons.each do |b0|
        s0.translate(-b0)
        (0..ROTATIONS.length-1).each do |r|
            s1.beacons.each do |b1|
                s1.rotate(r)
                s1.translate(-b1)
                common_beacons = s0.transformed_beacons & s1.transformed_beacons
                # puts common_beacons.inspect if r == 6
                if common_beacons.length >= 11
                    s0.translate(Vector[0,0,0])
                    scanner_loc = b0 - apply_rotation(r, b1)
                    s1.translate(-scanner_loc)
                    return [s1, scanner_loc]
                end
            end
        end
    end
    nil
end
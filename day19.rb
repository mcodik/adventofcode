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

    def relative_distances
        distances = Array.new(@beacons.length) { Array.new(@beacons.length, 0) }
        @beacons.each_index do |i|
            @beacons.each_index do |j|
                next unless j > i
                b1 = @beacons[i]
                b2 = @beacons[j]
                distances[i][j] = (b2 - b1).norm
            end
        end
        distances
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

def count_matches(b1, b2)
    matches = 0
    b1.each_index do |i|
        b2.each_index do |j|
            next unless j > i
            matches += 1 if (b1[i]-b2[j]).abs < 0.001
        end
    end
    matches
end

def match_with_distances(s1, s2)
    d1 = s1.relative_distances
    d2 = s2.relative_distances

    dump(d1)
    puts "-----------------"
    dump(d2)

    matches = []
    d1.each_with_index do |b1, i|
        d2.each_with_index do |b2, j|
            if count_matches(b1, b2) > 2
                matches << [i,j]
            end
        end
    end
    matches
end

def match_with_vectors(s0, s1)
    best_vectors = {}
    best_rotation = 0
    most_aligned = 0
    (0..ROTATIONS.length-1).each do |r|
        s1.rotate(r)
        vectors = Hash.new { |h,k| h[k] = 0 }
        s0.beacons.each_with_index do |b0, i|
            s1.transformed_beacons.each_with_index do |b1, j|
                vectors[b0 - b1] += 1
            end
        end
        aligned = vectors.values.max
        puts aligned
        if aligned > most_aligned
            best_vectors = vectors
            best_rotation = r
            most_aligned = aligned
        end
    end
    # puts best_vectors.inspect
    if most_aligned >= 11 # ????
        best = best_vectors.keys.sort_by { |k| best_vectors[k] }[-1]
        s1.translate(best)
        s1.rotate(best_rotation)
        s1
    end
end

def match_with_vectors_2(s0, s1)
    best_vectors = {}
    best_rotation = 0
    most_aligned = 0
    (0..ROTATIONS.length-1).each do |r|
        vectors = Hash.new { |h,k| h[k] = 0 }
        s0.beacons.each do |b0|
            s1.beacons.each do |b1|
                s1.rotate(r)
                s0.translate(-b0)
                s1.translate(-b1)
                common_beacons = s0.transformed_beacons & s1.transformed_beacons
                # puts common_beacons.inspect if r == 6
                if common_beacons.length >= 11
                    s0.translate(Vector[0,0,0])
                    scanner_loc = b0 - apply_rotation(r, b1)
                    return [s1, b1, b0, scanner_loc]
                end
            end
        end
    end
    nil
end
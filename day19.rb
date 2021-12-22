require 'matrix'


class Scanner
    attr_reader :index, :beacons, :translation, :rotation
    def initialize(index, beacons)
        @index = index
        @beacons = beacons
        @rotation = 0
        @translation = Vector.zero(3)
    end

    def clone
        s = Scanner.new(@index, @beacons)
        s.rotate(@rotation).translate(@translation)
        s
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
        puts "scanner #{@index} found at #{-translation} with rotation #{rotation}"
        @beacons = beacons.map do |v|
            b = apply_rotation(rotation, v)
            r = b - translation
            # puts "normalizing #{v} -> #{r}"
            r
        end
        #puts @beacons.length
        @translation = Vector.zero(3)
        @rotation = 0
    end
end

def apply_rotation(i, v)
    Vector.elements(ROTATIONS[i].call([v[0], v[1], v[2]]))
end

def parse(filename)
    file = File.read(filename)
    chunks = file.split("\n\n")
    scanners = []
    index = 0
    chunks.each do |c|
        lines = c.split("\n")
        lines.shift # header
        beacons = []
        lines.each do |beacon|
            beacons << Vector.elements(beacon.split(",").map { |c| c.to_i })
        end
        scanners << Scanner.new(index, beacons)
        index += 1
    end
    scanners
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
    s0 = s0.clone
    s0.beacons.each do |b0|
        s0.translate(-b0)
        (0..ROTATIONS.length-1).each do |r|
            s1.beacons.each do |b1|
                s1.rotate(r)
                s1.translate(-b1)
                common_beacons = s0.transformed_beacons & s1.transformed_beacons
                if common_beacons.length >= 11
                    scanner_loc = b0 - apply_rotation(r, b1)
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
    beacons = {}
    normalized[0].beacons.each do |b|
        beacons[b] = true
    end
    checked = {}
    while scanners.length > 0
        made_progress = false
        normalized.clone.each do |n|
            scanners.clone.each do |s|
                next if checked[[n.index, s.index]]
                checked[[n.index, s.index]] = true
                s_prime = match_with_vectors(n, s)
                if !s_prime.nil?
                    #puts "found overlap between #{n.index} #{s.index}"
                    normalized << s_prime
                    old_beacons = beacons.keys.length
                    s_prime.beacons.each do |b|
                        beacons[b] = true
                    end
                    puts "identified #{beacons.keys.length - old_beacons} new beacons. #{beacons.keys.length} total"
                    # beacons.keys.sort_by { |v| v[0] }.each { |b| puts b.inspect }
                    puts "-----"
                    scanners.delete(s)
                    made_progress = true
                end
            end
        end
        if !made_progress
            raise "stuck?"
        end
    end
    beacons.keys
end

def part_a(filename)
    scanners = parse(filename)
    beacons = normalize_all(scanners)
    beacons.length
end

def part_b()
    vectors = File.readlines("inputs/day19.out")
        .keep_if { |l| l.start_with?("scanner") }
        .map() { |l| l.match(/found at (.*) with/).captures }
        .flatten
        .map() { |l| eval(l) }
    max_dist = 0
    vectors.each do |v1|
        vectors.each do |v2|
            dist = (v1[0]-v2[0]).abs + (v1[1]-v2[1]).abs + (v1[2]-v2[2]).abs
            if dist > max_dist
                max_dist = dist
            end
        end
    end
    max_dist
end
            

if __FILE__ == $0 
    # puts part_a("inputs/day19_test.txt")
    # puts part_a("inputs/day19.txt")
    puts part_b().inspect
end
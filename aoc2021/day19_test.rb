require "test/unit"
require "matrix"
require_relative "./day19"

class Day19Test < Test::Unit::TestCase
    def test_parse
        scanners = parse("inputs/day19_test.txt")
        assert_equal 25, scanners[0].beacons.length
        assert_equal 25, scanners[1].beacons.length
    end

    def test_translate
        s0 = Scanner.new(0, [Vector[1,1,1], Vector[2,2,2]])
        s0.rotate(2).translate(-Vector[1,1,1])
        assert_equal [Vector[0,0,0], Vector[1,-1,-1]], s0.transformed_beacons
    end

    def test_match_with_vectors
        scanners = parse("inputs/day19_test.txt")
        adjusted_scanner = match_with_vectors(scanners[0], scanners[1])
        common_beacons = scanners[0].beacons & adjusted_scanner.beacons
        puts "====="
        adjusted_scanner.beacons.sort_by { |v| v[0]}.each { |b| puts b.inspect }
        expected = [
            Vector[-618,-824,-621],
            Vector[-537,-823,-458],
            Vector[-447,-329,318],
            Vector[404,-588,-901],
            Vector[544,-627,-890],
            Vector[528,-643,409],
            Vector[-661,-816,-575],
            Vector[390,-675,-793],
            Vector[423,-701,434],
            Vector[-345,-311,381],
            Vector[459,-707,401],
            Vector[-485,-357,347]
        ].sort_by { |v| v[0]}
        common_beacons.sort_by! { |v| v[0] }
        assert_equal expected, common_beacons
    end

end
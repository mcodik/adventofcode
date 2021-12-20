require "test/unit"
require_relative "./day19"

class Day19Test < Test::Unit::TestCase
    def test_match_scanners
        scanners = parse("inputs/day19_test.txt")
        matches = match_scanners(scanners[0], scanners[1])
        assert_equal 12, matches.length
    end

    def test_parse
        scanners = parse("inputs/day19_test.txt")
        assert_equal 25, scanners[0].beacons.length
    end

    def test_translate
        s0 = Scanner.new(0, [Vector[1,1,1], Vector[2,2,2]])
        s0.rotate(2).translate(-Vector[1,1,1])
        assert_equal [Vector[0,0,0], Vector[1,-1,-1]], s0.transformed_beacons
    end

    def test_match_with_vectors
        scanners = parse("inputs/day19_test.txt")
        adjusted_scanner = match_with_vectors(scanners[0], scanners[1])
        # best = vectors.keys.sort_by { |k| vectors[k] }
        # best.each do |b|
        #     puts "#{b.inspect} => #{vectors[b]}"
        # end
        # puts rotation
        puts "translation = #{adjusted_scanner.translation} rotation=#{adjusted_scanner.rotation}"
        puts adjusted_scanner.transformed_beacons.sort_by { |x| x[0] }.map { |v| v.inspect }
        puts "-----"
        puts scanners[0].beacons.sort_by { |x| x[0] }.map { |v| v.inspect }
    end

    def test_match_with_vectors_2
        scanners = parse("inputs/day19_test.txt")
        adjusted_scanner, b1, b0 = match_with_vectors_2(scanners[0], scanners[1])
        # best = vectors.keys.sort_by { |k| vectors[k] }
        # best.each do |b|
        #     puts "#{b.inspect} => #{vectors[b]}"
        # end
        # puts rotation
        puts (b0+b1).inspect
        puts b1.inspect
        puts "translation = #{adjusted_scanner.translation} rotation=#{adjusted_scanner.rotation}"
        puts adjusted_scanner.transformed_beacons.sort_by { |x| x[0] }.map { |v| v.inspect }
        puts "-----"
        puts scanners[0].beacons.sort_by { |x| x[0] }.map { |v| v.inspect }
    end

end
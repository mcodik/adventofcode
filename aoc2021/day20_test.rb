require "test/unit"
require_relative "./day20"

class Day20Test < Test::Unit::TestCase
    def test_parse
        e, c = parse("inputs/day20_test.txt")
        assert_equal 512, e.length
        assert_equal ".", c.out_of_bounds
        assert_equal 5, c.width
        assert_equal 5, c.height
    end

    def test_get_set
        e, c = parse("inputs/day20_test.txt")
        assert_equal "#", c.get(0,0)
        assert_equal ".", c.get(-10,-100)
        c.set(100, 200, "#")
        assert_equal "#", c.get(100, 200)
        c.set(2,2, "#")
        assert_equal "#", c.get(2,2)
    end

    def test_get_square
        e, c = parse("inputs/day20_test.txt")
        assert_equal 9, c.offsets.length
        sq = c.get_square(2,2)
        assert_equal "...#...#.".split(""), sq
        assert_equal 34, to_index(sq)
    end

    def test_enhance
        e, c = parse("inputs/day20_test.txt")
        dump(-10, 10, -10, 10, c)
        puts "-----"
        c2 = enhance(-2, 2, e, c)
        dump(-10, 10, -10, 10, c2)
        assert_equal ".", c2.out_of_bounds
        assert_equal 24, c2.dark_pixels
    end
end
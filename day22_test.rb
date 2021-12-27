require "test/unit"
require_relative "./day22"

class Day22Test < Test::Unit::TestCase
    def test_intersect
        a = Cube.new(0..5, 0..5, 0..5, :+)
        b = Cube.new(0..5, 0..5, 0..5, :+)
        assert_equal a, a.intersection(b, :+)

        a = Cube.new(0..5, 0..5, 0..5, :+)
        b = Cube.new(0..3, 0..5, 0..5, :+)
        assert_equal b, a.intersection(b, :+)
        
        a = Cube.new(0..5, 0..5, 0..5, :+)
        b = Cube.new(0..3, 0..7, 0..7, :+)
        assert_equal Cube.new(0..3, 0..5, 0..5, :+), a.intersection(b, :+)
    end

    def test_add_positive
        cs = CubeSet.new
        cs.add(Cube.new(0..5, 0..5, 0..5, :+))

        nr = NaiveReactor.new
        nr.add(Cube.new(0..5, 0..5, 0..5, :+))

        assert_equal nr.size, cs.size
        assert_equal 6*6*6, cs.size
    end

    def test_range_overlap
        assert_equal true, (10..12).overlap?(11..13)
        assert_equal true, (10..12).overlap?(11..12)
        assert_equal false, (10..12).overlap?(13..14)
    end

    def test_add_positive_overlap
        cs = CubeSet.new
        a = Cube.new(10..12, 10..12, 10..12, :+)
        b = Cube.new(11..13, 11..13, 11..13, :+)
        assert_equal true, a.intersects?(b)
        assert_equal true, b.intersects?(a)
        cs.add(a)
        cs.add(b)

        expected = [
            Cube.new(10..12, 10..12, 10..12, :+),
            Cube.new(11..12, 11..12, 11..12, :-),
            Cube.new(11..13, 11..13, 11..13, :+),
        ]

        assert_equal expected, cs.cubes

        nr = NaiveReactor.new
        nr.add(a)
        nr.add(b)

        assert_equal nr.size, cs.size
    end

    def test_divergence
        nr = NaiveReactor.new
        cs = CubeSet.new
        cubes = parse("inputs/day22_test.txt")
        cubes.each_with_index do |cube, i|
            nr.add(cube)
            cs.add(cube)
            assert_equal nr.size, cs.size, "#{i} #{cube.inspect}\n\n#{cs.cubes.inspect}"
        end
    end

    def test_add_negative_disjoint
        cs = CubeSet.new
        cs.add(Cube.new(0..5, 0..5, 0..5, :+))
        cs.add(Cube.new(6..10, 6..10, 6..10, :-))
        assert_equal 6*6*6, cs.size
    end

    def test_add_negative_overlap
        cs = CubeSet.new
        cs.add(Cube.new(0..5, 0..5, 0..5, :+))
        cs.add(Cube.new(4..10, 4..10, 4..10, :-))

        nr = NaiveReactor.new
        nr.add(Cube.new(0..5, 0..5, 0..5, :+))
        nr.add(Cube.new(4..10, 4..10, 4..10, :-))
        
        assert_equal nr.size, cs.size
    end

    def test_add_negative_overlap_2
        cs = CubeSet.new
        cs.add(Cube.new(0..5, 0..5, 0..5, :+))
        cs.add(Cube.new(4..7, 4..7, 4..7, :+))
        cs.add(Cube.new(4..10, 4..10, 4..10, :-))

        nr = NaiveReactor.new
        nr.add(Cube.new(0..5, 0..5, 0..5, :+))
        nr.add(Cube.new(4..7, 4..7, 4..7, :+))
        nr.add(Cube.new(4..10, 4..10, 4..10, :-))
        
        assert_equal nr.size, cs.size
    end

    def test_add_negative_overlap_3
        a = Cube.new(10..12, 10..12, 10..12, :+)
        b = Cube.new(11..13, 11..13, 11..13, :+)
        c = Cube.new(9..11, 9..11, 9..11, :-)

        cs = CubeSet.new
        cs.add(a)
        cs.add(b)
        cs.add(c)

        onr = NaiveReactor.new
        cs.cubes.each { |z| onr.add(z) }

        nr = NaiveReactor.new
        nr.add(a)
        nr.add(b)
        nr.add(c)

        expected = nr.cubes.to_a.sort_by { |x| x.inspect }
        actual = onr.cubes.to_a.sort_by { |x| x.inspect }

        assert_equal expected, actual

        assert_equal nr.size, cs.size
    end
end
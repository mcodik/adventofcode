require "test/unit"
require_relative "./day17"

class Day17Test < Test::Unit::TestCase
    def test_simulate_hit_1
        v0 = { :x => 7, :y => 2 }
        target = { :x => 20..30, :y => -10..-5 }
        result = simulate(ORIGIN, v0, target)
        assert_equal :hit, result
    end

    def test_simulate_hit_2
        v0 = { :x => 6, :y => 3 }
        target = { :x => 20..30, :y => -10..-5 }
        result = simulate(ORIGIN, v0, target)
        assert_equal :hit, result
    end

    def test_simulate_miss
        v0 = { :x => 17, :y => -4 }
        target = { :x => 20..30, :y => -10..-5 }
        result = simulate(ORIGIN, v0, target)
        assert_equal :miss, result
    end
end
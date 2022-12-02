require "test/unit"
require_relative "./day21"

class Day21Test < Test::Unit::TestCase
    def test_deterministic_dice
        d = DeterministicDice.new
        assert_equal 1, d.roll
        assert_equal 2, d.roll
        assert_equal 3, d.roll
        assert_equal 3, d.num_rolls
    end
    
    def test_deterministic_dice_wrap
        d = DeterministicDice.new
        99.times { d.roll }
        assert_equal 100, d.roll
        assert_equal 1, d.roll
        assert_equal 101, d.num_rolls
    end

    def test_game
        d = DeterministicDice.new
        g = Game.new(d, 4, 8)
        g.turn
        assert_equal [10, 8], g.positions
        assert_equal [10, 0], g.scores
        g.turn
        assert_equal [10, 3], g.positions
        assert_equal [10, 3], g.scores
        g.turn
        assert_equal [4, 3], g.positions
        assert_equal [14, 3], g.scores
        g.turn
        assert_equal [4, 6], g.positions
        assert_equal [14, 9], g.scores
    end

    def test_turn_outcomes
        assert_equal [0, 0, 0, 1, 3, 6, 7, 6, 3, 1], TURN_OUTCOMES
    end
end
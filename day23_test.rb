require "test/unit"
require_relative "./day23"

class Day23Test < Test::Unit::TestCase
    def test_dump
        PUZZLE_PART_B.clone.dump
    end

    def test_move_up_left
        cave = TEST_CASE.clone
        cave.dump()
        b = cave.rooms[0][1]
        move = CompoundMove.new(
            [Move.new(b, :up), Move.new(b, :left)]
        )
        move.apply_move(cave)
    end

    def test_move_up_right
        cave = TEST_CASE.clone
        cave.dump()
        b = cave.rooms[0][1]
        flunk if b.nil?
        move = CompoundMove.new(
            [Move.new(b, :up), Move.new(b, :right)]
        )
        move.apply_move(cave)
    end

    def test_possible_moves_go_to_destination
        outer = EMPTY_OUTER.clone
        a = Amphipod.new(:A)
        outer[0] = a
        cave = Cave.new([ 
            [Amphipod.new(:A), nil],
            [Amphipod.new(:B), Amphipod.new(:B)],
            [Amphipod.new(:C), Amphipod.new(:C)],
            [Amphipod.new(:D), Amphipod.new(:D)]],
            outer)
        cave.dump()
        moves = cave.move_from_outer_to_dest(0)
        # assert_equal CompoundMove.new([Move.new(a, :right), Move.new(a, :right), Move.new(a, :down)]), moves
        assert_equal FastMove.new(a, FastMove::Outer.new(0), FastMove::Room.new(0, 1)), moves
        updated = moves.apply_move cave
        assert_equal true, updated.complete?
    end

    def test_possible_moves_go_to_destination_2
        outer = EMPTY_OUTER.clone
        a1 = Amphipod.new(:A)
        a2 = Amphipod.new(:A)
        outer[0] = a1
        outer[5] = a2
        cave = Cave.new([ 
            [nil, nil],
            [Amphipod.new(:B), Amphipod.new(:B)],
            [Amphipod.new(:C), Amphipod.new(:C)],
            [Amphipod.new(:D), Amphipod.new(:D)]],
            outer)
        cave.dump()
        m1 = cave.move_from_outer_to_dest(0)
        assert_equal FastMove.new(a1, FastMove::Outer.new(0), FastMove::Room.new(0, 2)), m1
        updated = m1.apply_move cave
        updated.dump

        m2 = updated.move_from_outer_to_dest(5)
        assert_equal FastMove.new(a2, FastMove::Outer.new(5), FastMove::Room.new(0, 1)), m2

        updated = m2.apply_move updated
        assert_equal true, updated.complete?
    end

    def test_apply_move_exit_room
        outer = EMPTY_OUTER.clone
        a = Amphipod.new(:A)
        cave = Cave.new([ 
            [Amphipod.new(:A), a],
            [Amphipod.new(:B), Amphipod.new(:B)],
            [Amphipod.new(:C), Amphipod.new(:C)],
            [Amphipod.new(:D), Amphipod.new(:D)]],
            outer)
        cave.dump()
        move = CompoundMove.new([Move.new(a, :up), Move.new(a, :right)])
        cave = move.apply_move cave
        cave.dump
        # assert_equal 
    end

    def test_moves_to_leave_room
        cave = TEST_CASE.clone
        amphipod = cave.rooms[0][-1]
        moves = cave.moves_to_leave_room(0)
        expected = []
        [1,0,3,5,7,9,10].each do |i|
            expected << FastMove.new(amphipod, FastMove::Room.new(0, 1), FastMove::Outer.new(i))
        end
        7.times do |i|
            assert_equal expected[i], moves[i]
        end
    end

    def test_moves_to_leave_room_2
        outer = EMPTY_OUTER.clone
        a = Amphipod.new(:A)
        mover = Amphipod.new(:A)
        outer[1] = a
        cave = Cave.new([ 
            [mover, nil],
            [Amphipod.new(:B), Amphipod.new(:B)],
            [Amphipod.new(:C), Amphipod.new(:C)],
            [Amphipod.new(:D), Amphipod.new(:D)]],
            outer)
        moves = cave.moves_to_leave_room(0)
        expected = []
        [3,5,7,9,10].each do |i|
            expected << FastMove.new(mover, FastMove::Room.new(0, 2), FastMove::Outer.new(i))
        end
        5.times do |i|
            assert_equal expected[i], moves[i]
        end
        updated = moves[0].apply_move cave
        updated.dump
    end

    def test_manual_solve
        c = PUZZLE.clone
        cost = 0
        [
            move(c.rooms[0][1], :up, :left, :left), # A
            move(c.rooms[0][0], :up, :up, :left), # C
            move(c.rooms[3][1], :up, :right, :right), # B
            move(c.rooms[3][0], :up, :up, :right), # B
            move(c.rooms[1][1], :up, :right, :right, :right, :right, :down, :down), # D
            move(c.rooms[2][1], :up, :left, :left, :left, :left, :down, :down), # A
            move(c.rooms[2][0], :up, :up, :right, :right, :down), # D
            move(c.rooms[1][0], :up, :up, :right, :right, :down, :down), # C
            move(c.rooms[3][0], :left, :left, :left, :left, :left, :down, :down), # B
            move(c.rooms[3][1], :left, :left, :left, :left, :left, :left, :down), # B
            move(c.rooms[0][0], :right, :right, :right, :right, :right, :down), # C
            move(c.rooms[0][1], :right, :right, :down), # A
        ].each do |mv|
            c.dump
            c = mv.apply_move c
            cost += mv.cost
        end
        c.dump
        assert_equal true, c.complete?
        assert_equal 13713, cost
    end

    def test_manual_solve_2
        c = PUZZLE.clone
        cost = 0
        [
            move(c.rooms[2][1], :up, :left, :left, :left, :left, :left, :left), # A
            move(c.rooms[0][1], :up, :left), # A
            move(c.rooms[0][0], :up, :up, :right), # C
            move(c.rooms[3][1], :up, :right, :right), # B
            move(c.rooms[3][0], :up, :up, :right), # B
            move(c.rooms[1][1], :up, :right, :right, :right, :right, :down, :down), # D
            move(c.rooms[2][0], :up, :up, :right, :right, :down), # D
            move(c.rooms[1][0], :up, :up, :right, :right, :down, :down), # C
            move(c.rooms[0][1], :right, :down, :down), # A
            move(c.rooms[3][0], :left, :left, :left, :left, :left, :down, :down), # B
            move(c.rooms[3][1], :left, :left, :left, :left, :left, :left, :down), # B
            move(c.rooms[0][0], :right, :right, :right, :down), # C
            move(c.rooms[2][1], :right, :right, :down), # A
        ].each do |mv|
            c.dump
            c = mv.apply_move cave
            cost += mv.cost
        end
        c.dump
        assert_equal true, c.complete?
        assert_equal 13515, cost
    end

    def test_manual_solve_3
        c = PUZZLE.clone
        cost = 0
        [
            move(c.rooms[2][1], :up, :left, :left, :left, :left, :left, :left), # A
            move(c.rooms[0][1], :up, :left), # A
            move(c.rooms[3][1], :up, :left, :left, :left, :left, :left), # B
            move(c.rooms[3][0], :up, :up, :right), # B
            move(c.rooms[1][1], :up, :right, :right, :right, :right, :down, :down), # D
            move(c.rooms[2][0], :up, :up, :right, :right, :down), # D
            move(c.rooms[1][0], :up, :up, :right, :right, :down, :down), # C
            move(c.rooms[3][1], :right, :down, :down), # B
            move(c.rooms[0][0], :up, :up, :right, :right, :right, :right, :down), # C
            move(c.rooms[0][1], :right, :down, :down), # A
            move(c.rooms[2][1], :right, :right, :down), # A
            move(c.rooms[3][0], :left, :left, :left, :left, :left, :down), # B
        ].each do |mv|
            c.dump
            c = mv.apply_move c
            cost += mv.cost
        end
        c.dump
        assert_equal true, c.complete?
        assert_equal 13495, cost
    end

    def test_fast_move
        outer = EMPTY_OUTER.clone
        a = Amphipod.new(:A)
        cave = Cave.new([ 
            [Amphipod.new(:A), a],
            [Amphipod.new(:B), Amphipod.new(:B)],
            [Amphipod.new(:C), Amphipod.new(:C)],
            [Amphipod.new(:D), Amphipod.new(:D)]],
            outer)
        move = CompoundMove.new([Move.new(a, :up), Move.new(a, :right)])
        cave1 = move.apply_move cave
        cave1.dump
        fast_move = FastMove.new(a, FastMove::Room.new(0, 1), FastMove::Outer.new(3))
        cave2 = fast_move.apply_move cave
        cave2.dump
        assert_equal cave1, cave2
        assert_equal move.cost, fast_move.cost
    end

    def test_expected_cost
        cave = TEST_CASE.clone
        assert_equal 11610, expected_remaining_cost(cave)
    end

    private 

    def move(amphipod, *dirs)
        builder = CompoundMove.builder(amphipod)
        dirs.each do |d|
            builder.add(1, d)
        end
        builder.build
    end
end
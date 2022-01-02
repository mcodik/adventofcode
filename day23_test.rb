require "test/unit"
require_relative "./day23"

class Day23Test < Test::Unit::TestCase
    def test_dump
        PUZZLE_PART_B.clone.dump
    end

    def test_possible_moves_go_to_destination
        outer = EMPTY_OUTER.clone
        a = :A
        outer[0] = a
        cave = Cave.new([ 
            [:A, nil],
            [:B, :B],
            [:C, :C],
            [:D, :D]],
            outer)
        cave.dump()
        moves = cave.move_from_outer_to_dest(0)
        # assert_equal FastMove.new(a, FastMove::Outer.new(0), FastMove::Room.new(0, 1)), moves
        updated = moves.apply_move cave
        assert_equal true, updated.complete?
    end

    def test_possible_moves_go_to_destination_2
        outer = EMPTY_OUTER.clone
        a1 = :A
        a2 = :A
        outer[0] = a1
        outer[5] = a2
        cave = Cave.new([ 
            [nil, nil],
            [:B, :B],
            [:C, :C],
            [:D, :D]],
            outer)
        cave.dump()
        m1 = cave.move_from_outer_to_dest(0)
        # assert_equal FastMove.new(a1, FastMove::Outer.new(0), FastMove::Room.new(0, 2)), m1
        updated = m1.apply_move cave
        updated.dump

        m2 = updated.move_from_outer_to_dest(5)
        # assert_equal FastMove.new(a2, FastMove::Outer.new(5), FastMove::Room.new(0, 1)), m2

        updated = m2.apply_move updated
        assert_equal true, updated.complete?
    end

    def test_moves_to_leave_room
        cave = TEST_CASE.clone
        amphipod = cave.rooms[0][-1]
        moves = cave.moves_to_leave_room(0)
        expected = []
        [1,0,3,5,7,9,10].each do |i|
            # expected << FastMove.new(amphipod, FastMove::Room.new(0, 1), FastMove::Outer.new(i))
        end
        7.times do |i|
            assert_equal expected[i], moves[i]
        end
    end

    def test_moves_to_leave_room_2
        outer = EMPTY_OUTER.clone
        a = :A
        mover = :A
        outer[1] = a
        cave = Cave.new([ 
            [mover, nil],
            [:B, :B],
            [:C, :C],
            [:D, :D]],
            outer)
        moves = cave.moves_to_leave_room(0)
        expected = []
        [3,5,7,9,10].each do |i|
            # expected << FastMove.new(mover, FastMove::Room.new(0, 2), FastMove::Outer.new(i))
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

    def test_part_b_manual_solve
        c = PUZZLE_PART_B.clone
        cost = 0
        [
            RoomToOuter.new(:D, 10, 1, 3),
            RoomToOuter.new(:C, 0, 1, 2),
            RoomToOuter.new(:B, 3, 1, 1),
            RoomToOuter.new(:C, 1, 1, 0),
            OuterToRoom.new(:B, 3, 1, 0),
            RoomToOuter.new(:B, 7, 3, 3),
            OuterToRoom.new(:B, 7, 1, 1),
        ].each do |mv|
            c.dump 
            c = mv.apply_move c
            cost += mv.cost
        end
        c.dump
        assert_equal true, c.complete?
        assert_equal 13495, cost
    end

    def test_expected_cost
        cave = TEST_CASE.clone
        assert_equal 11610, expected_remaining_cost(cave)
    end

    def test_to_key
        outer = EMPTY_OUTER.clone
        cave = Cave.new([ 
            [:A, :A],
            [:B, :B],
            [:C, :C],
            [:D, :D]],
            outer)

        assert_equal [nil, nil,nil,nil,nil,nil,nil,nil,nil,nil,nil, :A, :A, :B, :B, :C, :C, :D, :D], cave.to_key
        other_cave = Cave.from_key cave.to_key
        assert_equal cave.rooms, other_cave.rooms
        assert_equal cave.outer, other_cave.outer
    end

    private 

    def move(amphipod, *dirs)
        # builder = CompoundMove.builder(amphipod)
        dirs.each do |d|
            builder.add(1, d)
        end
        builder.build
    end
end
require 'd_heap'

COSTS = {
    :A => 1,
    :B => 10, 
    :C => 100,
    :D => 1000
}

EMPTY_OUTER = Array.new(11, nil)
OUTER_INDEX = [2, 4, 6, 8]
DESTINATIONS = [:A, :B, :C, :D]
KIND_TO_ROOM = {
    :A => 0, :B => 1, :C => 2, :D => 3
}

class Cave

    attr_reader :rooms, :outer, :applied
    def initialize(rooms, outer, applied = nil)
        @rooms = rooms
        @outer = outer
        @applied = nil #applied.nil? ? [] : applied
        freeze
    end

    def clone
        new_rooms = []
        @rooms.each { |r| new_rooms << r.clone }
        Cave.new(new_rooms, @outer.clone, @applied.clone)
    end

    def dump_str
        str = []
        str << "#############"
        outers = @outer.map { |o| o.nil? ? "." : o }.join("")
        str << "##{outers}#"
        (@rooms[0].length-1).downto(0).each do |i|
            room_str = @rooms.map { |room| room[i].nil? ? "." : room[i] }.join("#")
            str << "####{room_str}###"
        end
        str << "  #########  "
        str.join("\n")
    end

    def dump
        puts dump_str()
    end

    def moves_to_leave_room(room_index)
        possible = []
        room = @rooms[room_index]
        amphipod_index = room.length - 1
        while amphipod_index >= 0 && room[amphipod_index].nil?
            amphipod_index -= 1
        end
        amphipod = room[amphipod_index]
        raise room.inspect if amphipod.nil?
        i = OUTER_INDEX[room_index]
        while i > 0 
            break unless @outer[i-1].nil?
            possible << RoomToOuter.new(amphipod, i-1, room_index, amphipod_index) unless OUTER_INDEX.include?(i-1)
            i -= 1
        end
        j = OUTER_INDEX[room_index]
        while j < @outer.length-1
            break unless @outer[j+1].nil?
            possible << RoomToOuter.new(amphipod, j+1, room_index, amphipod_index) unless OUTER_INDEX.include?(j-1)
            j += 1
        end
        possible
    end

    def room_depth(i)
        @rooms[i].each_with_index do |a, i|
            return @rooms[i].length - i if a.nil?
        end
        raise "room full"
    end

    def move_from_outer_to_dest(outer_index, room_offsets)
        outer = @outer[outer_index]
        room_i = KIND_TO_ROOM[outer]
        return nil unless @rooms[room_i][-1].nil?
        outer_dest_i = OUTER_INDEX[room_i]
        raise "invalid state" if outer_index == outer_dest_i
        step = outer_dest_i > outer_index ? 1 : -1
        i = outer_index    
        while i != outer_dest_i
            i += step
            return nil unless @outer[i].nil?
        end

        @rooms[room_i].each_with_index do |amphipod, j|
            if amphipod.nil?
                o = OuterToRoom.new(outer, outer_index, room_i, j+room_offsets[room_i])
                room_offsets[room_i] += 1
                return o
            end
            return nil if amphipod != outer
        end
    end

    def room_complete?(i)
        @rooms[i].each_with_index do |amphipod, j|
            return false if amphipod.nil?
            dest_room = KIND_TO_ROOM[amphipod]
            return false if dest_room != i
        end
        return true
    end

    def possible_moves
        possible = []
        @rooms.each_with_index do |room, i|
            if !room_complete?(i) && !room[0].nil?
                possible.concat(moves_to_leave_room(i))
            end
        end
        all_outers = []
        room_offsets = [0,0,0,0]
        @outer.each_with_index do |outer, i|
            next if outer.nil?
            move = move_from_outer_to_dest(i, room_offsets)
            all_outers << move unless move.nil?
        end
        possible << CompoundMove.new(all_outers) unless all_outers.empty?
        possible.shuffle  
    end
    
    def complete?
        return false unless @outer.all? { |o| o.nil? }
        DESTINATIONS.each_with_index do |amphipod, i|
            return false unless @rooms[i].all? { |a| a == amphipod }
        end
        true
    end

    def to_key
        key = []
        key.concat(@outer)
        @rooms.each do |r|
            key.concat(r.clone)
        end
        key.freeze
        key
    end

    def self.from_key(key)
        k = key.dup
        outer = k.shift(11)
        rooms = []
        room_size = k.length/4
        4.times do 
            rooms << k.shift(room_size)
        end
        Cave.new(rooms, outer)
    end
end

def spaces_between_rooms(a_i, a_depth, b_i, b_depth)
    a_exit = OUTER_INDEX[a_i]
    b_exit = OUTER_INDEX[b_i]
    (ROOM_LENGTH - a_depth) + (ROOM_LENGTH - b_depth) + (a_exit - b_exit).abs
end

def spaces_to_room(outer_i, room_i, room_depth)
    room_exit = OUTER_INDEX[room_i]
    (room_exit - outer_i).abs + (ROOM_LENGTH - room_depth)
end

class RoomToOuter
    attr_reader :amphipod, :outer_index, :room_index, :room_depth
    def initialize(amphipod, outer_index, room_index, room_depth)
        @amphipod = amphipod
        @outer_index = outer_index
        @room_index = room_index
        @room_depth = room_depth
    end

    def cost
        COSTS[@amphipod] * spaces_to_room(@outer_index, @room_index, @room_depth)
    end

    def apply_move(cave)
        new_rooms = []
        cave.rooms.each { |r| new_rooms << r.clone }
        new_outer = cave.outer.clone
        a = new_rooms[@room_index][@room_depth]
        raise "invalid move" if a != @amphipod
        new_rooms[@room_index][@room_depth] = nil
        raise "invalid move" if !new_outer[@outer_index].nil?
        new_outer[@outer_index] = a
        Cave.new(new_rooms, new_outer)
    end
end

class OuterToRoom
    attr_reader :amphipod, :outer_index, :room_index, :room_depth
    def initialize(amphipod, outer_index, room_index, room_depth)
        @amphipod = amphipod
        @outer_index = outer_index
        @room_index = room_index
        @room_depth = room_depth
    end

    def cost
        COSTS[@amphipod] * spaces_to_room(@outer_index, @room_index, @room_depth)
    end

    def apply_move(cave)
        new_rooms = []
        cave.rooms.each { |r| new_rooms << r.clone }
        new_outer = cave.outer.clone
        a = new_outer[@outer_index]
        raise "invalid move" if a != @amphipod
        new_outer[@outer_index] = nil
        raise "invalid move #{self.inspect}" if !new_rooms[@room_index][@room_depth].nil?
        new_rooms[@room_index][@room_depth] = a
        Cave.new(new_rooms, new_outer)
    end
end

class CompoundMove
    def initialize(moves)
        @moves = moves
    end
    def cost
        @moves.sum { |m| m.cost }
    end
    def apply_move(cave)
        updated = cave
        @moves.each do |move|
            updated = move.apply_move updated
        end
        updated
    end
end


def expected_remaining_cost(cave)
    cost = 0
    cave.rooms.each_with_index do |room, i|
        needs_to_move = false
        room.each_with_index do |am, j|
            home = DESTINATIONS[i]
            if !am.nil? && am == home && needs_to_move
                up_and_down = 2 * (room.length - j)
                cost += COSTS[am] * (1 + up_and_down)
            end
            if !am.nil? && am != home
                dest = KIND_TO_ROOM[am]
                needs_to_move = true
                cost += COSTS[am] * spaces_between_rooms(i, room.length - j, dest, 1)
            end
        end
    end
    cave.outer.each_with_index do |outer, i|
        if !outer.nil?
            dest = KIND_TO_ROOM[outer]
            cost += COSTS[outer] * spaces_to_room(i, dest, 1)
        end
    end
    OUTER_INDEX.each_with_index do |i, room_index|
        if !cave.outer[i-1].nil? && !cave.outer[i+1].nil? && cave.outer[i-1] == cave.outer[i+1]
            if cave.outer[i-1] == DESTINATIONS[room_index]
                cost += 500000
            end
        end
    end
    cost
end

def null_heuristic(cave)
    0
end

# alias :heuristic :expected_remaining_cost
alias :heuristic :null_heuristic
    
def search(cave)
    heap = DHeap::Map.new
    initial_key = cave.to_key
    heap.push initial_key, heuristic(cave)
    steps = 0
    actual_costs = {}
    actual_costs[initial_key] = 0
    new_keys = 0
    visited = {}
    while !heap.empty?
        current_key = heap.peek
        current_heuristic_cost = heap.score(current_key)
        current = Cave.from_key current_key
        heap.pop
        steps += 1
        puts "step = #{steps}, heap = #{heap.size}, positions = #{actual_costs.size}, new_keys = #{new_keys} cost = #{current_heuristic_cost}" if steps % 1000 == 0
        puts current.dump if steps % 1000 == 0
        moves = current.possible_moves
        moves.each do |move|
            updated = move.apply_move current
            updated_key = updated.to_key
            actual_cost = actual_costs[current_key] + move.cost
            if updated.complete?
                puts "done!"
                return actual_cost
            end     
            heuristic_cost = actual_cost + heuristic(updated)
            if heap[updated_key].nil?
                next if visited.key?(updated_key)
                new_keys += 1
                visited[updated_key] = true
                actual_costs[updated_key] = actual_cost
                heap.push updated_key, heuristic_cost
            else
                prev_cost = actual_costs[updated_key]
                if actual_cost < prev_cost
                    heap.rescore updated_key, heuristic_cost
                    actual_costs[updated_key] = actual_cost
                end
            end
        end
    end
end

ROOM_LENGTH = 4

TEST_CASE = Cave.new([ 
    [:A, :B],
    [:D, :C],
    [:C, :B],
    [:A, :D]],
    EMPTY_OUTER.clone)

PUZZLE = Cave.new([ 
    [:C, :A],
    [:C, :D],
    [:D, :A],
    [:B, :B]],
    EMPTY_OUTER.clone)

PUZZLE_PART_B = Cave.new([ 
    [:C, :D, :D, :A],
    [:C, :B, :C, :D],
    [:D, :A, :B, :A],
    [:B, :C, :A, :B]],
    EMPTY_OUTER.clone)

if __FILE__ == $0
    # ROOM_LENGTH = 2
    puts search(PUZZLE_PART_B)
end
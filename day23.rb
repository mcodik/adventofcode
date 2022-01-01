require 'd_heap'

COSTS = {
    :A => 1,
    :B => 10, 
    :C => 100,
    :D => 1000
}

class Amphipod
    attr_reader :kind, :index
    @@next_index = 0
    def initialize(kind)
        @kind = kind
        @index = 1 # @@next_index
        @@next_index += 1
        freeze
    end
    def ==(other)
        return false if other.nil?
        @kind == other.kind && @index == other.index
    end
end

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

    # def hash
    #     dump_str.hash
    # end

    def dump_str
        str = []
        str << "#############"
        outers = @outer.map { |o| o.nil? ? "." : o.kind }.join("")
        str << "##{outers}#"
        (@rooms[0].length-1).downto(0).each do |i|
            room_str = @rooms.map { |room| room[i].nil? ? "." : room[i].kind }.join("#")
            str << "####{room_str}###"
        end
        str << "  #########  "
        str.join("\n")
    end

    def dump
        puts dump_str()
    end

    def moves_to_leave_room_fast(room_index)
        possible = []
        room = @rooms[room_index]
        amphipod_index = room.length - 1
        while amphipod_index >= 0 && room[amphipod_index].nil?
            amphipod_index -= 1
        end
        amphipod = room[amphipod_index]
        depth = room.length - amphipod_index
        from = FastMove::Room.new(room_index, depth)
        i = OUTER_INDEX[room_index]
        while i > 0 
            break unless @outer[i-1].nil?
            possible << FastMove.new(amphipod, from, FastMove::Outer.new(i-1)) unless OUTER_INDEX.include?(i-1)
            i -= 1
        end
        j = OUTER_INDEX[room_index]
        while j < @outer.length-1
            break unless @outer[j+1].nil?
            possible << FastMove.new(amphipod, from, FastMove::Outer.new(j+1)) unless OUTER_INDEX.include?(j+1)
            j += 1
        end
        possible
    end

    def moves_to_leave_room_compound(room_index)
        possible = []
        room = @rooms[room_index]
        top_amphipod = room.filter { |a| !a.nil? }[-1]
        top_index = room.index(top_amphipod)

        builder = CompoundMove.builder(top_amphipod)
        builder.add(room.length - top_index, :up)
        outer_index = OUTER_INDEX[room_index]
        while outer_index > 0 
            break unless @outer[outer_index-1].nil?
            builder.add(1, :left)
            possible << builder.build() unless OUTER_INDEX.include?(outer_index-1)
            outer_index -= 1
        end

        builder = CompoundMove.builder(top_amphipod)
        builder.add(room.length - top_index, :up)
        outer_index = OUTER_INDEX[room_index]
        while outer_index < @outer.length-1
            break unless @outer[outer_index+1].nil?
            builder.add(1, :right)
            possible << builder.build() unless OUTER_INDEX.include?(outer_index+1)
            outer_index += 1
        end
        possible
    end

    def room_depth(i)
        @rooms[i].each_with_index do |a, i|
            return @rooms[i].length - i if a.nil?
        end
        raise "room full"
    end

    def move_from_outer_to_dest_fast(outer_index)
        outer = @outer[outer_index]
        room_i = KIND_TO_ROOM[outer.kind]
        return nil unless @rooms[room_i][-1].nil?
        outer_dest_i = OUTER_INDEX[room_i]
        raise "invalid state" if outer_index == outer_dest_i
        step = outer_dest_i > outer_index ? 1 : -1
        i = outer_index    
        while i != outer_dest_i
            i += step
            return nil unless @outer[i].nil?
        end
        j = 0
        room = @rooms[room_i]
        while j < room.length && !room[j].nil?
            j += 1
        end
        depth = room.length - j
        FastMove.new(outer, FastMove::Outer.new(outer_index), FastMove::Room.new(room_i, depth))
    end

    def move_from_outer_to_dest_compound(outer_index)
        outer = @outer[outer_index]
        # puts "considering outer #{outer.inspect}"
        room_i = KIND_TO_ROOM[outer.kind]
        return nil unless @rooms[room_i][-1].nil?
        # puts "destination empty"
        outer_dest_i = OUTER_INDEX[room_i]
        raise "invalid state" if outer_index == outer_dest_i
        direction = outer_dest_i > outer_index ? :right : :left
        step = direction == :right ? 1 : -1
        i = outer_index    
        while i != outer_dest_i
            i += step
            return nil unless @outer[i].nil?
        end

        CompoundMove.builder(outer)
            .add((outer_index - outer_dest_i).abs, direction)
            .add(room_depth(room_i), :down)
            .build
    end

    alias_method :moves_to_leave_room, :moves_to_leave_room_fast
    alias_method :move_from_outer_to_dest, :move_from_outer_to_dest_fast

    def room_complete?(i)
        @rooms[i].each_with_index do |amphipod, j|
            return true if amphipod.nil?
            dest_room = KIND_TO_ROOM[amphipod.kind]
            return false if dest_room != i
        end
        return true
    end

    def room_empty?(i)
        @rooms[i].filter { |r| !r.nil? }.empty?
    end

    def possible_moves
        possible = []
        @rooms.each_with_index do |room, i|
            if !room_complete?(i) && !room_empty?(i)
                possible.concat(moves_to_leave_room(i))
            end
        end
        @outer.each_with_index do |outer, i|
            next if outer.nil?
            move = move_from_outer_to_dest(i)
            possible << move unless move.nil?
        end
        possible     
    end

    def validate(applied_move)
        seen = Hash.new { |h,k| h[k] = 0 }
        @rooms.each do |r|
            seen[r[0].kind] += 1 if !r[0].nil? 
            seen[r[1].kind] += 1 if !r[1].nil?
        end
        @outer.each do |o|
            seen[o.kind] += 1 if !o.nil? 
        end
        [:A, :B, :C, :D].each do |kind|
            if seen[kind] != 2
                # dump()
                raise "missing #{kind} after #{applied_move.inspect}"
            end
        end
        OUTER_INDEX.each do |oi|
            if !@outer[oi].nil?
                # dump()
                raise "ended apply with #{oi} occupied after #{applied_move.inspect}"
            end
        end
    end
    
    def complete?
        @outer.all? { |o| o.nil? } && room_contains?(@rooms[0], :A, :A) && room_contains?(@rooms[1], :B, :B) && room_contains?(@rooms[2], :C, :C) && room_contains?(@rooms[3], :D, :D)
    end

    def ==(other)
        @rooms == other.rooms && @outer == other.outer
    end

    def eql?(other)
        @rooms == other.rooms && @outer == other.outer
    end

    private

    def room_contains?(room, a1, a2)
        room.all? { |a| !a.nil? } && room[0].kind == a1 && room[1].kind == a2
    end
end

def num_spaces(a, b)
    # puts "num spaces #{a.inspect} #{b.inspect}"
    room = b
    outer = a
    if a.respond_to? :room_index
        if b.respond_to? :room_index
            # puts "a and b are rooms"
            outer = FastMove::Outer.new(OUTER_INDEX[a.room_index])
            return a.depth + 1 + num_spaces(outer, b)
        end 
        # puts "a is room"
        room = a
        outer = b
    end

    room_exit = OUTER_INDEX[room.room_index]
    (room_exit - outer.index).abs + room.depth
end

class FastMove
    attr_reader :amphipod, :to, :from
    def initialize(amphipod, from, to)
        @amphipod = amphipod
        @to = to
        @from = from
    end

    Room = Struct.new(:room_index, :depth)
    Outer = Struct.new(:index)

    def cost
        COSTS[@amphipod.kind] * num_spaces(@to, @from)
    end

    def ==(other)
        @amphipod == other.amphipod && @to == other.to && @from == other.from
    end

    def eql?(other)
        @amphipod == other.amphipod && @to == other.to && @from == other.from
    end

    def apply_move(cave)
        new_rooms = []
        cave.rooms.each { |r| new_rooms << r.clone }
        new_outer = cave.outer.clone
        if @from.respond_to? :room_index
            a = new_rooms[@from.room_index][-@from.depth]
            # cave.dump if a != @amphipod
            # puts cave.applied.inspect if a != @amphipod

            raise "invalid move" if a != @amphipod
            new_rooms[@from.room_index][-@from.depth] = nil
            raise "invalid move" if !new_outer[@to.index].nil?
            new_outer[@to.index] = a
        else
            a = new_outer[@from.index]
            raise "invalid move" if a != @amphipod
            new_outer[@from.index] = nil
            raise "invalid move" if !new_rooms[@to.room_index][-@to.depth].nil?
            new_rooms[@to.room_index][-@to.depth] = a
        end
        Cave.new(new_rooms, new_outer)#, cave.applied.clone + [self])
    end
end

class Move
    attr_reader :amphipod, :dir
    def initialize(amphipod, dir)
        @amphipod = amphipod
        @dir = dir
    end
    def cost
        COSTS[@amphipod.kind]
    end
    def ==(other)
        @amphipod == other.amphipod && @dir == other.dir
    end

    def apply_move(cave)
        # puts move.inspect
        new_rooms = []
        cave.rooms.each { |r| new_rooms << r.clone }
        new_outer = cave.outer.clone
        new_applied = nil # @applied + [move]
        move = self
        new_rooms.each_with_index do |room, i|
            if move.amphipod == room[0]
                if move.dir == :up && room[1].nil?
                    room[0] = nil
                    room[1] = move.amphipod
                    return Cave.new(new_rooms, new_outer, new_applied)
                else
                    raise "invalid move"
                end
            elsif move.amphipod == room[1]
                if move.dir == :down && room[0].nil?
                    room[1] = nil
                    room[0] = move.amphipod
                    return Cave.new(new_rooms, new_outer, new_applied)
                elsif move.dir == :up
                    outer_index = OUTER_INDEX[i]
                    # puts "moving up to #{outer_index}"
                    if cave.outer[outer_index].nil?
                        # puts "have space"
                        new_outer[outer_index] = room[1]
                        room[1] = nil
                        # puts new_outer.inspect
                        return Cave.new(new_rooms, new_outer, new_applied)
                    else
                        raise "invalid move #{move.inspect}"
                    end
                else
                    raise "invalid move #{move.inspect}"
                end
            end
        end
        i = cave.outer.index(move.amphipod)
        raise "invalid move" if i.nil?
        if move.dir == :left
            raise "invalid move" if i < 0
            raise "invalid move #{move.inspect}" if !cave.outer[i-1].nil?
            new_outer[i-1] = cave.outer[i]
            new_outer[i] = nil
        elsif move.dir == :right
            raise "invalid move" if i >= cave.outer.length
            raise "invalid move #{move.inspect}" if !cave.outer[i+1].nil?
            new_outer[i+1] = cave.outer[i]
            new_outer[i] = nil
        elsif move.dir == :down
            room_index = OUTER_INDEX.index(i)
            if room_index.nil?
                # self.dump
                raise "invalid move #{i} #{move.inspect}" 
            end
            room = new_rooms[room_index]
            raise "invalid move" if !room[1].nil?
            raise "invalid move" if DESTINATIONS[room_index] != move.amphipod.kind
            room[1] = move.amphipod
            new_outer[i] = nil
        else
            raise "invalid move"
        end
        Cave.new(new_rooms, new_outer, new_applied)
    end

end

class CompoundMove
    attr_reader :moves

    class Builder
        def initialize(amphipod)
            @amphipod = amphipod
            @moves = []
        end

        def add(n, dir)
            @moves << [n, dir]
            self
        end
 
        def build
            m = []
            @moves.each do |pair|
                n, dir = pair
                n.times { m << Move.new(@amphipod, dir) }
            end
            CompoundMove.new(m)
        end
    end

    def self.builder(amphipod)
        CompoundMove::Builder.new(amphipod)
    end

    def initialize(moves)
        @moves = moves
    end
    def cost
        @moves.sum { |m| m.cost }
    end
    def ==(other)
        @moves == other.moves
    end

    def apply_move(cave)
        @moves.each do |submove| 
            cave = submove.apply_move(cave)
            # cave.dump() 
        end
        cave
    end
end


TEST_CASE = Cave.new([ 
    [Amphipod.new(:A), Amphipod.new(:B)],
    [Amphipod.new(:D), Amphipod.new(:C)],
    [Amphipod.new(:C), Amphipod.new(:B)],
    [Amphipod.new(:A), Amphipod.new(:D)]],
    EMPTY_OUTER.clone)

PUZZLE = Cave.new([ 
    [Amphipod.new(:C), Amphipod.new(:A)],
    [Amphipod.new(:C), Amphipod.new(:D)],
    [Amphipod.new(:D), Amphipod.new(:A)],
    [Amphipod.new(:B), Amphipod.new(:B)]],
    EMPTY_OUTER.clone)

PUZZLE_PART_B = Cave.new([ 
    [Amphipod.new(:C), Amphipod.new(:D), Amphipod.new(:D), Amphipod.new(:A)],
    [Amphipod.new(:C), Amphipod.new(:B), Amphipod.new(:C), Amphipod.new(:D)],
    [Amphipod.new(:D), Amphipod.new(:A), Amphipod.new(:B), Amphipod.new(:A)],
    [Amphipod.new(:B), Amphipod.new(:C), Amphipod.new(:A), Amphipod.new(:B)]],
    EMPTY_OUTER.clone)

def expected_remaining_cost(cave)
    cost = 0
    cave.rooms.each_with_index do |room, i|
        needs_to_move = false
        room.each_with_index do |am, j|
            home = DESTINATIONS[i]
            if !am.nil? && am.kind == home && needs_to_move
                up_and_down = 2 * (room.length - j)
                cost += COSTS[am.kind] * (1 + up_and_down)
            end
            if !am.nil? && am.kind != home
                dest = KIND_TO_ROOM[am.kind]
                needs_to_move = true
                cost += COSTS[am.kind] * num_spaces(FastMove::Room.new(i, room.length - j), FastMove::Room.new(dest, 1))
            end
        end
    end
    cave.outer.each_with_index do |outer, i|
        if !outer.nil?
            dest = KIND_TO_ROOM[outer.kind]
            cost += COSTS[outer.kind] * num_spaces(FastMove::Outer.new(i), FastMove::Room.new(dest, 1))
        end
    end
    cost
end

def null_heuristic(cave)
    0
end

alias :heuristic :expected_remaining_cost
#alias :heuristic :null_heuristic


def reconstruct_cost(last_cave, prev)
    iter = last_cave
    pairs = []
    cost = 0
    while !iter.nil?
        prev_cave, move = prev[iter]
        iter = prev_cave
        pairs << [prev_cave, move] unless prev_cave.nil?
    end
    puts "\n\nsolution!"
    pairs.reverse.each do |(c,m)| 
        c.dump 
        cost += m.cost
        puts "cost = #{m.cost} (#{cost})"
    end
    # puts moves.inspect
    cost
end
    
def search(cave)
    heap = DHeap::Map.new
    heap.push cave, 0
    steps = 0
    prev = {}
    prev[cave] = [nil, nil]
    # actual_costs = {}
    # actual_costs[cave] = 0
    # cave.dump
    while !heap.empty?
        current = heap.peek
        current_cost = heap.score(current)
        heap.pop
        steps += 1
        puts "step = #{steps}, heap = #{heap.size}, cost = #{current_cost}" if steps % 10000 == 1
        puts current.dump if steps % 10000 == 1
        moves = current.possible_moves
        if moves.empty?
            heap[current] = Float::INFINITY
            next
        end
        moves.each do |move|
            begin
                updated = move.apply_move current
                if updated.complete?
                    prev[updated] = [current, move]
                    return reconstruct_cost(updated, prev)
                else    
                    # actual_cost = actual_costs[current] + move.cost
                    actual_cost = current_cost + move.cost
                    heuristic_cost = actual_cost + heuristic(updated)
                    if heap[updated].nil?
                        prev[updated] = [current, move]
                        # actual_costs[updated] = actual_cost
                        heap.push updated, heuristic_cost
                    else
                        prev_cost = heap[updated]
                        if actual_cost < prev_cost
                            prev[updated] = [current, move]
                            heap[updated] = heuristic_cost
                            # actual_costs[updated] = actual_cost
                        end
                    end
                end
            rescue => e
                # puts "error ------------"
                # c = cave.clone
                # current.applied.each do |m|
                #     c.dump
                #     puts "--->"
                #     puts m.inspect
                #     c = c.apply_move m
                # end
                # c.dump
                # puts "failed on #{move.inspect}"
                raise e
            end
        end
    end
end

# if __FILE__ == $0
    puts search(PUZZLE_PART_B)
# end
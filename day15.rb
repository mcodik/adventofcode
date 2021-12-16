require 'pqueue'
require 'd_heap'

def parse(filename)
    lines = File.readlines(filename).map(&:strip)
    lines.map { |line| line.split("").map(&:to_i) }
end

def path_cost(path, input)
    cost = 0
    #puts path.inspect
    path.each do |(y,x)|
        puts "x = #{x} y = #{y}" if x.nil? || y.nil? || input[y][x].nil?
        cost += input[y][x]
    end
    cost
end

def dump(path, input)
    input.each_with_index do |row, i|
       rendered = []
       row.each_with_index do |cost, j|
        if path.include? [i,j]
            rendered << "\e[31m#{cost.to_s}\e[0m"
        else
            rendered << cost.to_s
        end
       end
       puts rendered.join("") 
    end
end

def slow_search(input)
    queue = PQueue.new() { |a,b| path_cost(a, input) < path_cost(b, input) }
    visited = {}
    queue.push([[0,0]])
    while queue.length > 0
        shortest_path = queue.pop
        y,x = shortest_path[-1]
        visited[[y,x]] = true
        [[0,1],[0,-1],[1,0],[-1,0]].each do |(dy,dx)|
            next if x+dx >= input.length || x+dx < 0 || y+dy >= input.length || y+dy < 0
            next if visited[[y+dy, x+dx]]
            if x+dx == input.length - 1 && y+dy == input[x+dx].length - 1
                shortest_path << [y+dy, x+dx]
                return shortest_path
            end
            queue.push shortest_path.clone + [[y+dy, x+dx]]
        end
    end
end

def process_paths(paths, finish)
    # puts "done!"
    # puts finish.inspect
    # puts paths.inspect
    path = []
    curr = finish
    while curr != [0,0]
        path << curr.clone
        curr = paths[curr]
    end
    path.reverse
end

def djikstra_search(input)
    heap = DHeap::Map.new
    input.each_with_index do |row, y|
        row.each_with_index do |cost, x|
            score = [y,x] == [0,0] ? 0 : Float::INFINITY
            heap.push [y,x], score
        end
    end
    paths = {}
    while !heap.empty?
        p = heap.peek
        score = heap.score(p)
        heap.pop
        y, x = p
        [[0,1],[0,-1],[1,0],[-1,0]].each do |(dy,dx)|
            next if x+dx >= input.length || x+dx < 0 || y+dy >= input.length || y+dy < 0
            next if heap[[y+dy,x+dx]].nil?
            if x+dx == input.length - 1 && y+dy == input[x+dx].length - 1
                paths[[y+dy, x+dx]] = [y,x]
                return process_paths(paths, [y+dy, x+dx])
            end
            alt = score + input[y+dy][x+dx]
            if alt < heap[[y+dy,x+dx]]
                heap.rescore [y+dy,x+dx], alt
                paths[[y+dy,x+dx]] = [y,x]
            end
        end
    end
end

def part_a(input)
    shortest_path = djikstra_search(input)
    dump(shortest_path, input)
    path_cost(shortest_path, input)
end

#puts part_a(parse("inputs/day15_test.txt"))
puts part_a(parse("inputs/day15.txt"))

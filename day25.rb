def parse(filename)
    cucumbers = []
    lines = File.readlines(filename).map(&:strip)
    lines.each { |line| cucumbers << line.split("") }
    cucumbers
end

def move(cucumbers, kind, next_pos)
    result = []
    cucumbers.each { |c| result << c.clone }
    any_moved = false
    cucumbers.each_with_index do |row, i|
        cucumbers[i].each_with_index do |cucumber, j|
            if cucumber == kind
                new_i, new_j = next_pos.call(cucumbers, i, j)
                if new_i != i || new_j != j
                    any_moved = true
                    result[i][j] = "."
                    result[new_i][new_j] = kind
                    # puts "moved #{kind} at #{[i,j].inspect} -> #{[new_i,new_j].inspect}"
                end
            end
        end
    end
    [result, any_moved]
end

def move_east(cucumbers, i, j)
    new_i, new_j = i, j+1
    new_j = 0 if new_j == cucumbers[i].length
    return [new_i, new_j] if cucumbers[new_i][new_j] == "."
    return [i, j]
end

def move_south(cucumbers, i, j)
    new_i, new_j = i+1, j
    new_i = 0 if new_i == cucumbers.length
    return [new_i, new_j] if cucumbers[new_i][new_j] == "."
    return [i, j]
end

def step(cucumbers)
    result, any_moved_east = move(cucumbers, ">", method(:move_east))
    result, any_moved_south = move(result, "v", method(:move_south))
    [result, any_moved_east || any_moved_south]
end

if $0 == __FILE__
    any_moved = true
    cucumbers = parse("inputs/day25.txt")
    # cucumbers = parse("inputs/day25_test.txt")
    steps = 0
    while any_moved
        # cucumbers.each { |l| puts l.join("") }
        cucumbers, any_moved = step(cucumbers)
        steps += 1
    end
    puts steps
end
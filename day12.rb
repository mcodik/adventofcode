
def parse(filename)
    result = {}
    File.readlines(filename).each do |line|
        from, to = line.strip.split("-")
        if result.key? from 
            result[from] << to 
        else
            result[from] = [to]
        end
        if result.key? to 
            result[to] << from 
        else
            result[to] = [from]
        end
    end
    result
end

def small_cave(label)
    label.downcase == label && label != "end"
end

def part_a(input)
    step(input, "start", ["start"], true)
end

def part_b(input)
    step(input, "start", ["start"], false)
end
    
def step(input, current, partial_path, did_double_stop)
    if current == "end"
        puts "!!! #{partial_path.inspect}"
        return [partial_path]
    else 
        puts "... #{partial_path.inspect}"
    end
    candidates = input[current]
    paths_via_current = []
    candidates.each do |next_step|
        next if next_step == "start"
        if small_cave(next_step) && partial_path.include?(next_step)
            if !did_double_stop
                paths_via_current.concat(step(input, next_step, partial_path + [next_step], true))
            else
                next
            end
        else
            paths_via_current.concat(step(input, next_step, partial_path + [next_step], did_double_stop))
        end
    end
    paths_via_current
end



#puts part_a(parse("inputs/day12_test_small.txt")).length
#puts part_a(parse("inputs/day12.txt")).length
#puts part_b(parse("inputs/day12_test_small.txt")).length
puts part_b(parse("inputs/day12.txt")).length

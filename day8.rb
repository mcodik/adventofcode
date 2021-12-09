input = File.readlines("day8.txt").map(&:strip).map do |line|
    signals, outputs = line.split(" | ")
    [ signals.split(" "), outputs.split(" ") ]
end

SEGMENTS = [ 
    "abcefg", # 0
    "cf", # 1
    "acdeg", # 2
    "acdfg", # 3
    "bcdf", # 4
    "abdfg", # 5
    "abdefg", # 6
    "acf", # 7
    "abcdefg", # 8
    "abcdfg" # 9
]

def part_a(input)
    # count 1, 4, 7, 8
    easy_segments = [1,4,7,8].map() { |i| SEGMENTS[i].length }
    count = 0
    input.each do |pair|
        output = pair[1]
        output.each do |signal|
            count += 1 if easy_segments.include? signal.length
        end
    end 
    count
end

#puts part_a(input)

INITIAL_CONSTRAINTS = { 
    "a" => "abcdefg".split(""),
    "b" => "abcdefg".split(""),
    "c" => "abcdefg".split(""),
    "d" => "abcdefg".split(""),
    "e" => "abcdefg".split(""),
    "f" => "abcdefg".split(""),
    "g" => "abcdefg".split(""),
}


def enumerate_mappings(chars, y, mapping, assigned, constraints)
    char = chars.take(1)[0]
    constraints[char].each do |dest|
        next if assigned.include? dest
        mapping[char] = dest
        if chars.length == 1
            y.yield mapping
        else
            enumerate_mappings(chars.drop(1), y, mapping, assigned + [dest], constraints)
        end
    end
end

def possible_mappings(constraints)
    Enumerator.new do |y|
        mapping = {}
        chars = "abcedfg".split("")
        assigned = []
        enumerate_mappings(chars, y, mapping, assigned, constraints)
    end
end

def map_digit(mapping, signal)
    mapped = signal.split("").map { |seg| mapping[seg] }.sort.join("")
    SEGMENTS.index(mapped)
end

def to_digit(mapping, signals)
    signals.map { |signal| map_digit(mapping, signal) }
end

def apply_constraint(constraints, signals)
    possible_outputs = []
    possible_mappings(constraints).each do |mapping| 
        digits = to_digit(mapping, signals)
        #puts digits.inspect
        if !digits.include? nil
            possible_outputs.append([digits.join("").to_i, mapping.clone])
        end
    end

    if possible_outputs.length == 1
        return possible_outputs[0]
    elsif possible_outputs.length == 0
        puts "no mappings found"
    else
        puts "ambiguous"
        puts possible_outputs.inspect
    end
    [nil, nil]
end

def solve(observations, signals)
    constraints = INITIAL_CONSTRAINTS.clone
    decoded, mapping = apply_constraint(constraints, observations)
    if !mapping.nil?
        to_digit(mapping, signals).join("").to_i
    end
end

def part_b(input)
    input.map { |pair| solve(pair[0], pair[1]) }.sum
end

# observations = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab".split(" ")
# signals = "cdfeb fcadb cdfeb cdbaf".split(" ")
# expected_mapping = { "a"=>"c", "b"=>"f", "c"=>"g", "d"=>"a", "e"=>"b", "f"=>"d", "g"=>"e" }
#puts to_digit(expected_mapping, observations).inspect

# possible_mappings(INITIAL_CONSTRAINTS.clone).each do |m|
#     #puts m.inspect
#     if m == expected_mapping
#         puts to_digit(m, observations).inspect
#     end
# end

#puts solve(observations, signals)

puts part_b(input)

# c = {
#    "a" => [ "g", "a" ],
#    "b" => [ "d" ],
#    "c" => [ "c" ],
#    "d" => [ "b" ],
#    "e" => [ "e" ],
#    "f" => [ "f" ],
#    "g" => [ "a", "g" ],
#}
#possible_mappings(c).each do |m|
#    puts m.inspect
#end

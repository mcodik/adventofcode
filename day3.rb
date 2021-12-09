
def bit_counts(input, bits)
    counts = Array.new(bits, 0)
    input.each do |line|
        line.each_char.with_index do |char, index|
            if char == "1"
                counts[index] += 1
            end
        end
    end
    counts
end

def count_ones(input, bit)
    count = 0
    input.each do |line|
        if line[bit] == "1"
            count += 1
        end
    end
    count
end

def debug_string(str, bit)
    bits = str.split("")
    bits[bit] = "*#{bits[bit]}*"
    bits.join("")
end

def filter_bit_position(input, bit, value)
    result = input.clone
    i = 0
    while result.length > 1 && i < result.length 
        entry = result[i]
        puts "-> considering #{value} vs #{debug_string(entry, bit)}"
        if entry[bit] != value
            result.delete_at(i)
            puts "removing"
        else 
            i += 1
            puts "keeping"
        end
    end
    result
end

def compute_part_a()
    input = File.readlines("day3.txt").map { |x| x.strip }
    bits = input[0].length

    one_counts = bit_counts(input, bits)

    puts "one_counts = #{one_counts.to_s}"

    gamma = ""
    epsilon = ""

    one_counts.each do |count|
        gamma += count > input.length/2 ? "1" : "0"
        epsilon += count < input.length/2 ? "1" : "0"
    end
    gamma = gamma.to_i(2)
    epsilon = epsilon.to_i(2)

    power = gamma * epsilon

    puts "bits = #{bits}"
    puts "gamma = #{gamma}, epsilon = #{epsilon}"
    puts power
end

def find_life_support_rating(input)
    candidates = input.clone
    bit = 0
    while candidates.length > 1 && bit < candidates[0].length
        ones = count_ones(candidates, bit)
        zeros = candidates.length - ones
        puts "at bit=#{bit}, ones=#{ones}, zeros=#{zeros}"
        filter = yield ones, zeros
        puts "removing items with #{filter}"
        candidates = filter_bit_position(candidates, bit, filter)
        bit += 1
    end
    candidates[0].to_i(2)
end

def compute_part_b()
    input = File.readlines("inputs/day3.txt").map { |x| x.strip }
    #input = ["00100", "11110", "10110", "10111", "10101",
    #         "01111", "00111","11100", "10000", "11001",
    #         "00010", "01010"]
    puts "*** CO2 SCRUBBER ***"
    co2_scrubber_rating = find_life_support_rating(input) do |co2_ones, co2_zeros|
        co2_ones >= co2_zeros ? "0" : "1"
    end
    puts "*** O2 GENERATOR ***"
    o2_generator_rating = find_life_support_rating(input) do |o2_ones, o2_zeros|
        o2_ones >= o2_zeros ? "1" : "0"
    end

    puts "co2_scrubber_rating = #{co2_scrubber_rating}, o2_generator_rating = #{o2_generator_rating}"
    puts co2_scrubber_rating * o2_generator_rating
end

compute_part_b()
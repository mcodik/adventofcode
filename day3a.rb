input = File.readlines("day3.txt")
bits = input[0].strip.length
one_counts = Array.new(bits, 0)

input.each do |line|
    line.strip.each_char.with_index do |char, index|
        if char == "1"
            one_counts[index] += 1
        end
    end
end

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

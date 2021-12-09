increases = 0
last = -1
File.readlines("inputs/day1.txt").each do |line|
    val = line.to_i
    if last > 0 && val > last
        increases += 1
    end
    last = val
end

puts increases
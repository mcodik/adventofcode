def windowed_increases(arr) 
    buffer = []
    increases = 0
    last = -1
    arr.each do |line|
        val = line.to_i
        buffer.push(val)
    
        next if buffer.length != 3
    
        window_sum = buffer.reduce(0, :+)
    
        if last > 0 && window_sum > last
            increases += 1
        end
        last = window_sum
        buffer.shift
    end
    return increases
end

#puts windowed_increases([199,200,208210,200,207,240,269,260,263])
# -> 5

puts windowed_increases(File.readlines("day1.txt"))
PUZZLE_TARGET = { :x => 240..292, :y => -90..-57 }

def step!(p, v)
    p[:x] += v[:x]
    p[:y] += v[:y]
    v[:x] += -(v[:x] <=> 0)
    v[:y] -= 1
end

def hit(p, v, target)
    return :hit if target[:x].cover?(p[:x]) && target[:y].cover?(p[:y])
    return :miss if v[:x] >= 0 && p[:x] > target[:x].max
    return :miss if v[:x] <= 0 && p[:x] < target[:x].min
    return :miss if v[:y] <= 0 && p[:y] < target[:y].min
    return :moving
end

def simulate(p0, v0, target)
    p = p0.clone
    v = v0.clone
    result = :moving
    loop do
        #puts "#{result} p = #{p.inspect}, v = #{v.inspect}"
        yield p, v, result if block_given?
        return result if result != :moving
        step!(p, v)
        result = hit(p, v, target)
    end
end

ORIGIN = { :x => 0, :y => 0 }

def part_a(target)
    max_y = 0
    v_max = {}
    hits = 0
    (0..293).each do |vx|
        (-1000..1000).each do |vy|
            v0 = { :x => vx, :y => vy }
            peak = 0
            result = simulate(ORIGIN, v0, target) do |p,v,r|
                peak = p[:y] if p[:y] > peak
            end
            if result == :hit
                puts ":hit #{v0.inspect} #{peak}"
                hits += 1
            end
            if result == :hit && peak > max_y
                max_y = peak
                v_max = v0
            end
        end
    end
    [max_y, hits]
end

puts part_a(PUZZLE_TARGET).inspect

def interpolate(pt1, pt2)
    result = []
    if pt1[0] == pt2[0]
        a, b = [pt1[1], pt2[1]].minmax
        result.concat(a.upto(b).map { |n| [pt1[0], n]})
    elsif pt1[1] == pt2[1]
        a, b = [pt1[0], pt2[0]].minmax
        result.concat(a.upto(b).map { |n| [n, pt1[1]]})
    else
       # diagonal
       rise = pt2[1] - pt1[1]
       run = pt2[0] - pt1[0]
       slope = rise/run
       return if !(slope == 1 || slope == -1)
       rightmost = pt1[0] > pt2[0] ? pt2 : pt1
       leftmost = pt1[0] > pt2[0] ? pt1 : pt2
       pt = rightmost.clone
       result.append(rightmost)
       while pt[0] != leftmost[0]
        pt[0] += 1
        pt[1] += slope
        result.append(pt.clone)
       end
    end
    result
end

def count_intersections()
    input = File.readlines("inputs/day5.txt").map(&:strip)
    h = Hash.new
    input.each do |line|
        endpoints = line.split(" -> ")
        line_start = endpoints[0].split(",").map(&:to_i)
        line_end = endpoints[1].split(",").map(&:to_i)
        interpolated = interpolate(line_start, line_end)
        interpolated.each do |point|
            str_point = point.map(&:to_s).join(",")
            if h.key? str_point
                h[str_point] += 1
            else
                h[str_point] = 1
            end
        end
    end
    count = 0
    h.each_value do |val|
        if val > 1
            count += 1
        end
    end
    count
end

#puts interpolate([1,1], [5, 5]).inspect


puts count_intersections()
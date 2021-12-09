PUZZLE_INPUT = File.readlines("day9.txt").map(&:strip).map { |line| line.split("").map(&:to_i) }

def neighbors(input, i, j)
    Enumerator.new do |y|
        if i > 0
            y.yield i-1, j
        end
        if i < input.length-1
            y.yield i+1, j
        end
        if j > 0
            y.yield i, j-1
        end
        if j < input[i].length - 1
            y.yield i, j+1
        end
    end
end

def find_low_points(input)
    Enumerator.new do |y|
        0.upto(input.length-1) do |i|
            0.upto(input[i].length-1) do |j|
                val = input[i][j]
                if neighbors(input, i, j).all? { |k,l| val < input[k][l] }
                    y.yield [i,j]
                end
            end
        end
    end
end

def recur_basin_size(x, y, input, visited)
    visited[x][y] = true
    #puts visited.inspect
    neighbors(input, x, y).each do |i, j|
        next if visited[i][j]
        neighbor = input[i][j]
        next if neighbor == 9
        recur_basin_size(i, j, input, visited) 
    end
end

def basin_size(x, y, input)
    visited = Array.new(input.length) { Array.new(input[0].length, false) }
    recur_basin_size(x, y, input, visited)
    visited.sum { |row| row.count(&:itself) }
end

def parta(input)
    risk = 0
    find_low_points(input).each do |i, j|
        val = input[i][j]
        risk += val + 1
    end
    risk
end

def partb(input)
    low_points = find_low_points(input)
    #puts "low_points=#{low_points.take(3).inspect}"
    top3 = low_points.map { |pt| basin_size(pt[0], pt[1], input) }.sort_by { |x| -x }.take 3
    top3[0] * top3[1] * top3[2]
end

test_input = [
    "2199943210".split("").map(&:to_i),
    "3987894921".split("").map(&:to_i),
    "9856789892".split("").map(&:to_i),
    "8767896789".split("").map(&:to_i),
    "9899965678".split("").map(&:to_i)]

#puts parta(PUZZLE_INPUT)
#test_basins = find_low_points(test_input).take(4)
#puts basin_size(test_basins[0][0], test_basins[0][1], test_input).inspect
#puts partb(test_input)
puts partb(PUZZLE_INPUT)

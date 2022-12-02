PUZZLE_INPUT = File.readlines("inputs/day11.txt").map { |line| line.strip.split("").map(&:to_i) }

def neighbors(x, y, input)
    deltas = [[1,0], [0, 1], [-1, 0], [0, -1], [-1, 1], [1, -1], [1, 1], [-1, -1]]
    result = []
    deltas.each do |(dx, dy)|
        next if x + dx < 0  || x + dx >= input.length || y + dy < 0  || y + dy >= input[x].length
        result << [x + dx, y + dy]
    end
    result
end

#puts neighbors(0,0, [[1,2,3],[1,2,3], [1,2,3]]).inspect

DEBUG = true

def dump(input, flashed)
    return unless DEBUG
    puts "\e[2J\e[f"
    input.each_with_index do |row, i|
        rendered = ""
        row.each_with_index do |energy, j|
            if flashed[[i,j]]
                rendered << "\e[31m#{energy.to_s}\e[0m "
            else 
                rendered << "#{energy.to_s} "
            end
        end
        puts rendered
    end
    sleep(1)
    #puts "-----"
end


def simulate(steps, input)
    flashes = 0
    steps.times do
        flashing = []
        flashed = {}
        input.each_with_index do |row, x|
            row.each_with_index do |energy, y|
                input[x][y] += 1 
                if input[x][y] > 9
                    flashing << [x,y]
                end
            end
        end
        #dump(input, flashed)
        while flashing.length > 0
            x, y = flashing.pop
            next if flashed[[x,y]]
            flashed[[x,y]] = true
            neighbors(x, y, input).each do |(i, j)|
                next if flashed[[i,j]]
                input[i][j] += 1 unless input[i][j] > 9
                if input[i][j] > 9
                    flashing << [i,j]
                end
            end
            #dump(input, flashed)
        end
        flashed.each_key do |(x, y)|
            input[x][y] = 0
        end
        dump(input, flashed)
        flashes += flashed.size
    end
    flashes
end

def sync(max, input)
    max.times do |i|
        flashes = simulate(1, input)
        if flashes == input.length * input[0].length
            return i+1
        end
        puts i+1 if i%100 == 0
    end
end

puts sync(1000, PUZZLE_INPUT)

#puts simulate(100, PUZZLE_INPUT)

#simple_input = "11111|19991|19191|19991|11111".split("|").map { |r| r.split("").map(&:to_i) }
#dump(simple_input, {})
#puts simulate(3, simple_input)
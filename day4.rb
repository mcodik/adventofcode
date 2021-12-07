class BingoBoard
    attr_reader :mask, :rows

    def initialize(rows)
        @rows = rows
        @mask = Array.new(rows.length) { Array.new(rows[0].length, false) }
    end

    def mark(num)
        @rows.each_with_index do |row, i|
            j = row.index(num)
            if !j.nil?
                @mask[i][j] = true
            end
        end
        if self.has_winner?
            self.score
        else 
            nil
        end
    end

    def has_winner?
        @mask.any? { |row| row.all? { |x| x }} || @mask.transpose().any? { |col| col.all? { |x| x }}
    end

    def score
        result = 0
        @mask.each_with_index do |mask_row, i|
            mask_row.each_with_index do |mask_bool, j|
                if !mask_bool
                    result += @rows[i][j]
                end
            end
        end
        result
    end
end

def consume_next_board(input)
    input.shift if input[0] == ""
    rows = []
    while input.length > 0 && input[0].length > 0
        rows.append(input[0].split(" ").map(&:to_i))
        input.shift
    end
    BingoBoard.new(rows)
end

def part_a(draws, boards)
    draws.each do |draw|
        boards.each do |board|
            score = board.mark(draw)
            if !score.nil?
                puts "winner! score=#{score}, result=#{score*draw}"
                puts board.mask.inspect
                puts board.rows.inspect
                return
            end
        end
    end    
end

def part_b(draws, boards)
    candidates = boards.clone
    last_winner = 0
    draws.each do |draw|
        boards.each_with_index do |board, i|
            next if board.has_winner?
            score = board.mark(draw)
            if !score.nil?
                last_winner = score*draw
                puts "winner #{i}! score=#{score}, result=#{score*draw}"
            end
        end
    end
    last_winner
end

input = File.readlines("day4.txt").map(&:strip)
draws = input.shift.split(",").map(&:to_i)
boards = []
while input.length > 0
    boards.append(consume_next_board(input))
end
puts "read #{draws.length} draws and #{boards.length} boards"
#part_a(draws, boards)
part_b(draws, boards)


#b = BingoBoard.new([[1,2,3],[4,5,6],[7,8,9]])
#b.mark(1)
#b.mark(2)
#puts b.mask.inspect
#puts b.has_winner?
#b.mark(3)
#puts b.has_winner?

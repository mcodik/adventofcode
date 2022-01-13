STEP5 = [1, 1, 1, 26, 1, 1, 26, 1, 1, 26, 26, 26, 26, 26]
STEP6 = [12, 11, 14, -6, 15, 12, -9, 14, 14, -5, -9, -5, -2, -7]
STEP16 = [4, 10, 12, 14, 6,  16,  1, 7,   8, 11,  8,  3,  1,  8]


class Monad
    def initialize
        @x = 0
        @y = 0
        @z = 0
        @w = 0
        raise if STEP5.length != 14
        raise if STEP6.length != 14
        raise if STEP16.length != 14
    end

    def valid?
        @z == 0
    end

    def literal_run(input, i)
        @w = input[i]
        @x *= 0
        @x += @z
        @x = @x % 26
        @z = @z / STEP5[i]
        @x += STEP6[i]
        @x = @x == @w ? 1 : 0
        @x = @x == 0 ? 1 : 0
        @y *= 0
        @y += 25
        @y *= @x
        @y += 1
        @z *= @y
        @y *= 0
        @y += @w
        @y += STEP16[i]
        @y *= @x
        @z += @y
        @z
    end
end

m = Monad.new
# input = [9,1,3,9,8,2,9,9,6,9,7,9,9,6]
input = [4,1,1,7,1,1,8,3,1,4,1,2,9,1]
raise "must be length 14, got #{input.length}" if input.length != 14
input.each_with_index do |_, i|
    m.literal_run(input, i)
    op = STEP5[i] == 1 ? "push" : "pop"
    puts "#{i}: #{op} input=#{input[i]} #{m.inspect}"
end
if m.valid?
    puts "VALID"
    puts input.join("")
    return
end

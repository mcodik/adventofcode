class Submarine
    attr_reader :depth, :position, :aim

    def initialize
        @depth = 0
        @position = 0
        @aim = 0
    end

    def up(n)
        @aim -= n
        @aim
    end

    def down(n)
        @aim += n
        @aim
    end

    def forward(n)
        @position += n
        @depth += (@aim * n)
        @position
    end

    def backward(n)
        @position -= n
        @depth -= (@aim * n)
        @position
    end
end

sub = Submarine.new
File.readlines("inputs/day2.txt").each do |line|
    op, num = line.match(/(\w+) (\d+)/i).captures
    num = num.to_i
    case op
    when "up"
        sub.up(num)
    when "down"
        sub.down(num)
    when "forward"
        sub.forward(num)
    when "backward"
        sub.backward(num)
    end
end

answer = sub.depth * sub.position
puts "depth = #{sub.depth}, position = #{sub.position}"
puts answer

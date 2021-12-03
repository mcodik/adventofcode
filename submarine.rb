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

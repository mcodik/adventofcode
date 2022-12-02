PUZZLE_INPUT = File.readlines("inputs/day10.txt").map(&:strip)

PAIRS = {
    "(" => ")",
    "{" => "}",
    "[" => "]",
    "<" => ">"
}

class MismatchedBracesException < StandardError
    attr_reader :mismatched
    def initialize(mismatched)
        @mismatched = mismatched
    end
end

def parse(line)
    stack = []
    line.chars.each do |char|
        if PAIRS.key? char
            stack.push(char)
        else
            last = stack[-1]
            expected = PAIRS[last]
            if expected != char
                raise MismatchedBracesException.new(char)
            else
                stack.pop()
            end
        end
    end
    stack
end

def part_a(input)
    score = 0
    input.each do |line|
        begin
            parse(line)
        rescue MismatchedBracesException => error
            points = {")" => 3, "]" => 57, "}" => 1197, ">" => 25137 }
            score += points[error.mismatched]
        end
    end
    score
end

#puts part_a(PUZZLE_INPUT)

def part_b(input)
    scores = []
    input.each do |line|
        begin
            score = 0
            stack = parse(line)
            points = { "(" => 1, "[" => 2, "{" => 3, "<" => 4 }
            stack.reverse.each do |char|
                score = (score*5) + points[char]
            end
            scores << score
        rescue MismatchedBracesException => error
            next
        end
    end
    scores.sort()[scores.length/2]
end

puts part_b(PUZZLE_INPUT)
require './submarine.rb'

sub = Submarine.new
File.readlines("day2.txt").each do |line|
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

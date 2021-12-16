def decode_packet(hex)
    hex.chars.map do |c|
        n = c.to_i(16)
        bits = n.to_s(2).split("")
        if bits.length < 4
            padding = 4 - bits.length
            bits = Array.new(padding, "0") + bits
        end
        bits
    end.flatten
end

def btoi(bits)
    bits.join("").to_i(2)
end

def itob(i)
    i.to_s(2).split("")
end

def parse_literal(bits)
    literal = []
    more = true
    while more
        chunk = bits.shift 5
        more = chunk[0] == "1"
        literal << chunk.drop(1)
    end
    btoi(literal)
end

def parse_operator(bits)
    length_type = bits.shift
    if length_type == "0"
        subpacket_length = btoi(bits.shift 15)
        # puts "operator #{length_type} #{subpacket_length} bits"
        subpacket_bits = bits.shift subpacket_length
        packets = []
        while true
            p = parse(subpacket_bits)
            return packets if p.nil?
            packets << p
        end 
        packets
    else
        n_subpackets = btoi(bits.shift 11)
        # puts "operator #{length_type} #{n_subpackets} subpackets"
        packets = []
        n_subpackets.times do
            p = parse(bits)
            return packets if p.nil?
            packets << p
        end 
        packets 
    end
end

def parse(bits)
    return nil if bits.length < 6 || bits.all? { |x| x == "0"} 
    version = btoi(bits.shift 3)
    type_id = bits.shift 3
    if type_id == itob(4)
        value = parse_literal(bits)
        return [version, :literal, value]
    else
        value = parse_operator(bits)
        return [version, btoi(type_id), value]
    end
end

def sum_versions(packet)
    version, type, value = packet
    if type == :literal
        return version
    else
        sum = 0
        value.each do |v|
            sum += sum_versions(v)
        end
        return version + sum
    end
end

DECODE = {
    :literal => :literal,
    0 => :sum,
    1 => :product,
    2 => :minimum,
    3 => :maximum,
    5 => :greater_than,
    6 => :less_than,
    7 => :equal_to
}

def eval(packet)
    version, type, value = packet
    case DECODE[type]
    when :literal
        return value
    when :sum
        sum = 0
        value.each do |subpacket|
            sum += eval(subpacket)
        end
        return sum
    when :product
        product = 1
        value.each do |subpacket|
            product *= eval(subpacket)
        end
        return product
    when :minimum
        return value.map { |subpacket| eval(subpacket) }.min
    when :maximum
        return value.map { |subpacket| eval(subpacket) }.max
    when :greater_than
        return eval(value[0]) > eval(value[1]) ? 1 : 0
    when :less_than
        return eval(value[0]) < eval(value[1]) ? 1 : 0
    when :equal_to
        return eval(value[0]) == eval(value[1]) ? 1 : 0
    end
end

def part_a(filename)
    lines = File.readlines(filename).map(&:strip)
    packet = parse(decode_packet(lines[0]))
    puts packet.inspect
    sum_versions(packet)
end

# puts part_a("inputs/day16.txt")

def part_b(filename)
    lines = File.readlines(filename).map(&:strip)
    packet = parse(decode_packet(lines[0]))
    puts packet.inspect
    eval(packet)
end

puts part_b("inputs/day16.txt")


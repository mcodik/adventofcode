def parse(filename)
    input = File.readlines(filename).map(&:strip)
    template = input[0].split("")
    rules = {}
    input[2..].each do |line|
        from, to = line.split(" -> ")
        rules[from.split("")] = to
    end
    [template, rules]
end

def step(template, rules)
    result = []
    0.upto(template.length-2).each do |i|
        chars = template.slice(i, 2)
        if rules[chars]
            newchar = rules[chars]
            result << chars[0]
            result << newchar
        end
    end
    result << template[-1]
    result
end

def do_count(template)
    freq = Hash.new { |h,k| h[k] = 0 }
    template.each do |c| 
        freq[c] += 1
    end
    freq
end

def n_steps(n, template, rules) 
    n.times do
        template = step(template, rules)
    end
    template
end

def freq_count(n, template, rules)
    result = n_steps(n, template, rules)
    do_count(result)
end

def part_a(input)
    template = input[0]
    rules = input[1]
    freq = freq_count(10, template, rules)
    puts freq.inspect
    min, max = freq.values.minmax
    max - min
end

#template, rules = parse("inputs/day14_test.txt")
#puts step(template, rules).inspect

#puts part_a(parse("inputs/day14.txt"))

def freq_map(steps, template, rules)
    pairs = do_count(0.upto(template.length-2).map { |i| template.slice(i, 2) })
    40.times do
        next_pairs = Hash.new { |h,k| h[k] = 0 }
        pairs.each_key do |pair|
            n = pairs[pair]
            to_insert = rules[pair]
            next_pairs[[pair[0], to_insert]] += n
            next_pairs[[to_insert, pair[1]]] += n
        end
        pairs = next_pairs
    end
    counts = Hash.new { |h,k| h[k] = 0 }
    pairs.each_key do |k|
        counts[k[0]] += pairs[k]
        counts[k[1]] += pairs[k]
    end
    counts[template[-1]] += 1
    counts.transform_values { |v| v/2 }
end

def part_b(input)
    template = input[0]
    rules = input[1]

    counts = freq_map(40, template, rules)
    puts counts.inspect
    min, max = counts.values.minmax
    max - min
end

# puts part_b(parse("inputs/day14_test.txt"))
puts part_b(parse("inputs/day14.txt"))
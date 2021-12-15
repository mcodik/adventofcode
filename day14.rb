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

MEMO = {}

def n_steps(n, template, rules)
    if MEMO.key? [n, template]
        return MEMO[[n, template]]
    end
    orig = template.clone
    if n <= 10
        n.times do
            template = step(template, rules)
        end
    else
        puts "reusing? #{n-10} #{MEMO.key? [n-10, template]}"
        template = n_steps(n-10, template, rules)
        template = n_steps(10, template, rules)
    end
    MEMO[[n, orig]] = template
    template
end

def freq_count(n, template, rules)
    result = n_steps(n, template, rules)
    do_count(result)
end

def freq_table_sum(a, b)
    sum = a.clone
    b.each_key do |k|
        if sum.key? k
            sum[k] += b[k]
        else
            sum[k] = b[k]
        end
    end
    sum
end

def base_precompute(n, rules, cache)
    cache[n] = {}
    rules.each_key do |key|
        key_freq = freq_count(n, key, rules)
        cache[n][key] = key_freq
    end
    cache
end

def freq_count_from_cache(steps, template, cache)
    result = nil
    0.upto(template.length-2).each do |i|
        key = template.slice(i, 2)
        freq = cache[steps][key]
        if result.nil?
            result = freq.clone
        else
            result = freq_table_sum(result, freq)
        end
        result[key[-1]] -= 1
    end
    result[template[-1]] += 1
    result
end

def induction_precompute(new_n, old_n, rules, cache)
    raise "no cache" unless cache[old_n]
    steps = new_n - old_n
    cache[new_n] = {}
    rules.each_key.with_index do |key, i|
        expanded = MEMO[[old_n, key]]
        if expanded.nil?
            puts "cache miss: #{i} #{old_n} #{key.inspect}"
            expanded = n_steps(old_n, key, rules)
        end
        cache[new_n][key] = freq_count_from_cache(steps, expanded, cache)
        # if key == ["C", "H"]
        #     puts "old_n = #{old_n}, new_n = #{new_n}, result = #{cache[new_n][key].inspect}"
        #     puts "expanded = #{expanded.inspect}"
        # end
    end
    new_n
end

def part_a(input)
    template = input[0]
    rules = input[1]
    freq = freq_count(10, template, rules)
    puts freq.inspect
    min, max = freq.values.minmax
    max - min
end

def part_a_induction(input)
    template = input[0]
    rules = input[1]
    cache = {}
    base_precompute(5, rules, cache)
    new_steps = induction_precompute(5, rules, cache)
    raise "wrong new steps" unless new_steps == 10
    result = freq_count_from_cache(10, template, cache)
    puts result.inspect
    min, max = result.values.minmax
    max - min
end

#puts test(parse("inputs/day14.txt")[1])

#template, rules = parse("inputs/day14_test.txt")
#puts step(template, rules).inspect

#puts part_a(parse("inputs/day14.txt"))
#puts part_a_induction(parse("inputs/day14.txt"))

# {"P"=>1777, "N"=>3661, "K"=>2467, "F"=>2160, "S"=>2399, "C"=>2872, "O"=>1094, "V"=>1340, "H"=>900, "B"=>787}

def part_b(input)
    template = input[0]
    rules = input[1]
    cache = {}
    puts "base 10"
    base_precompute(10, rules, cache)
    puts "induction 10 -> 20"
    induction_precompute(20, 10, rules, cache)
    puts "induction 20 -> 30"
    induction_precompute(30, 20, rules, cache)
    puts "induction 30 -> 40"
    induction_precompute(40, 30, rules, cache)
    puts "expanding template from caches"
    result = freq_count_from_cache(40, template, cache)
    min, max = result.values.minmax
    max - min
end

puts part_b(parse("inputs/day14.txt"))
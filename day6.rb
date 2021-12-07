def generation!(fish)
    new_fish = 0
    fish.each_with_index do |f, i|
        if f == 0
            new_fish += 1
            fish[i] = 6
        else
            fish[i] = f - 1
        end
    end
    fish.concat(Array.new(new_fish, 8))
end

def inplace_simulate(initial, days)
    current_gen = initial.clone
    0.upto(days-1).each do |day|
        generation!(current_gen)
        puts "After #{day}: #{current_gen.length}" 
    end 
    current_gen
end

def compact_simulate(initial, days)
    ages = Array.new(9, 0)
    initial.each do |age|
        ages[age] += 1
    end
    puts "compact: #{ages.inspect}"
    1.upto(days).each do |day|
        dead_fish = ages[0]
        1.upto(ages.length-1) { |i| ages[i-1] = ages[i] }
        ages[6] += dead_fish
        ages[8] = dead_fish
        puts "After #{day}: #{ages.inspect}, sum=#{ages.sum}" 
    end
    ages.sum
end

#compact_simulate([3,4,3,1,2], 18)
#compact_simulate([3,4,3,1,2], 80)

def run_input(days)
    input = File.readlines("day6.txt").map(&:strip)[0].split(",").map(&:to_i)
    puts compact_simulate(input, days)
end

# part a
#run_input(80)

# part b
run_input(256)
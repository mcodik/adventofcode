input = File.readlines("day7.txt")[0].strip.split(",").map(&:to_i)

def arith_cost(a, b)
    d = (b - a).abs
    0.5 * d * (d + 1)
end

def linear_cost(a, b)
    (b - a).abs
end

def total_fuel_spent(input, dest, cost_func)
    fuel_spent = 0
    input.each do |pos|
        fuel_spent += cost_func.call(pos, dest)
    end
    fuel_spent
end

def parta(input)
    input.sort!
    median = input[input.length/2]
    total_fuel_spent(input, median, method(:linear_cost)) 
end

def partb(input)
    avg = input.sum/input.length.to_f
    guesses = [avg.floor, avg.ceil]
    guesses.map { |g| total_fuel_spent(input, g, method(:arith_cost))}.min.to_i
end


#puts parta( [16,1,2,0,4,2,7,1,2,14])
#puts parta(input)

#puts partb( [16,1,2,0,4,2,7,1,2,14])
puts partb(input)
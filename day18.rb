class Node
    attr_accessor :left, :right, :parent

    def initialize(left, right)
        @left = left
        @right = right
        @parent = nil
        left.parent = self
        right.parent = self
    end

    def iterate_leaves
        Enumerator.new do |y|
            Node.do_iterate_leaves(self, 0, y)
        end
    end

    def self.do_iterate_leaves(n, depth, y)
        if n.leaf?
            y.yield n, depth
        else 
            Node.do_iterate_leaves(n.left, depth+1, y)
            Node.do_iterate_leaves(n.right, depth+1, y)
        end
    end

    def magnitude
        3*(@left.magnitude) + 2*(@right.magnitude)
    end

    def leaf?
        false
    end
end

class Leaf
    attr_accessor :val, :parent

    def initialize(val)
        @val = val
        @parent = nil
    end

    def leaf?
        true
    end

    def explode(depth)
        false
    end

    def magnitude
        @val
    end
end

def to_tree(pair)
    left = pair[0].kind_of?(Array) ? to_tree(pair[0]) : Leaf.new(pair[0])
    right = pair[1].kind_of?(Array) ? to_tree(pair[1]) : Leaf.new(pair[1])
    Node.new(left, right)
end

def to_array(node)
    if node.leaf?
        node.val
    else
        [to_array(node.left), to_array(node.right)]
    end
end

def add(left, right)
    root = Node.new(left, right)
    loop do
        did_explode = explode(root)
        if did_explode
            #puts "after explode: #{to_array(root).inspect}"
            next
        end
        did_split = split(root)
        if did_split
            # puts "after split: #{to_array(root).inspect}"
            next
        end
        return root
    end
end

def add_all(pairs)
    nodes = pairs.map { |p| to_tree(p) }
    result = add(nodes[0], nodes[1])
    nodes[2..].each do |n|
        result = add(result, n)
    end
    result
end

def explode(root)
    prev = nil
    enum = root.iterate_leaves()
    loop do 
        left_leaf, depth = enum.next
        if depth > 4
            if !prev.nil?
                prev.val += left_leaf.val
            end
            right_leaf, _ = enum.next
            begin
                n, _ = enum.next
                if !n.nil?
                    r = right_leaf.val
                    n.val += r
                end
            rescue StopIteration
            end
            grandparent = left_leaf.parent.parent
            if grandparent.left == left_leaf.parent
                grandparent.left = Leaf.new(0)
                grandparent.left.parent = grandparent
            else
                grandparent.right = Leaf.new(0)
                grandparent.right.parent = grandparent
            end
            return true
        else
            prev = left_leaf
        end
    end
    false
end

def split(root)
    root.iterate_leaves().each do |(leaf, _)|
        if leaf.val >= 10
            leftval = leaf.val/2
            rightval = (leaf.val/2.0).ceil
            n = Node.new(Leaf.new(leftval), Leaf.new(rightval))
            if leaf.parent.left == leaf
                leaf.parent.left = n
                n.parent = leaf.parent
            else
                leaf.parent.right = n
                n.parent = leaf.parent
            end
            return true
        end
    end
    false
end

def part_a(filename)
    lines = File.readlines(filename).map(&:strip)
    pairs = lines.map { |l| eval(l) }
    root = add_all(pairs)
    root.magnitude
end

#puts part_a("inputs/day18.txt")

def part_b(filename)
    lines = File.readlines(filename).map(&:strip)
    pairs = lines.map { |l| eval(l) }
    max_magnitude = 0
    a_max = nil
    b_max = nil
    pairs.each_with_index do |a, i|
        pairs.each_with_index do |b, j|
            if i != j
                m = add(to_tree(a), to_tree(b)).magnitude
                if m > max_magnitude
                    max_magnitude = m
                    a_max = a
                    b_max = b
                end
            end
        end
    end
    puts "mag = #{max_magnitude}: #{(a_max).inspect} + #{(b_max).inspect}"
    max_magnitude 
end

puts part_b("inputs/day18.txt")
#puts part_b("inputs/day18_test.txt")


require "test/unit"
require_relative "./day18"

class Day18 < Test::Unit::TestCase
    def test_iterate_leaves
        root = to_tree([[[[[9,8],1],2],3],4])
        leaves = root.iterate_leaves().map { |l| l.val }
        assert_equal [9,8,1,2,3,4], leaves
    end

    def test_explode
        assert_explode [[[[0,9],2],3],4], [[[[[9,8],1],2],3],4]
        assert_explode [7,[6,[5,[7,0]]]], [7,[6,[5,[4,[3,2]]]]]
        assert_explode [[6,[5,[7,0]]],3], [[6,[5,[4,[3,2]]]],1]
        assert_explode [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]], [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]
        assert_explode [[3,[2,[8,0]]],[9,[5,[7,0]]]], [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]
    end

    def test_split
        assert_split [[[[0,7],4],[[7,8],[0,13]]],[1,1]], [[[[0,7],4],[15,[0,13]]],[1,1]]
        assert_split [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]], [[[[0,7],4],[[7,8],[0,13]]],[1,1]]
    end

    def test_add
        a = to_tree([[[[4,3],4],4],[7,[[8,4],9]]])
        b = to_tree([1,1])
        assert_equal [[[[0,7],4],[[7,8],[6,0]]],[8,1]], to_array(add(a,b))
    end

    def test_add_all
        pairs = [[1,1], [2,2], [3,3], [4,4]]
        assert_equal [[[[1,1],[2,2]],[3,3]],[4,4]], to_array(add_all(pairs))
    end

    def test_magnitude
        assert_equal 29, to_tree([9, 1]).magnitude
        assert_equal 129, to_tree([[9,1],[1,9]]).magnitude
        assert_equal 3488, to_tree([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]).magnitude
    end

    private

    def assert_explode(expected, arry)
        root = to_tree(arry)
        assert_equal true, explode(root)
        assert_equal expected, to_array(root)
    end

    def assert_split(expected, arry)
        root = to_tree(arry)
        assert_equal true, split(root)
        assert_equal expected, to_array(root)
    end

end
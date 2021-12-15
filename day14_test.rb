require 'test/unit'
require_relative './day14'

TEMPLATE, RULES = parse("inputs/day14_test.txt")

class Day14Test < Test::Unit::TestCase
    def test_step
        assert_equal ["C","B", "H"], step(["C", "H"], RULES)
        assert_equal "NCNBCHB".split(""), step("NNCB".split(""), RULES)
    end

    def test_do_count
        assert_equal({ "N" => 2, "C" => 3}, do_count("NNCCC".split("")))
    end

    def test_n_steps
        assert_equal "NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB".split(""), n_steps(4, "NNCB".split(""), RULES)
    end

    def test_freq_count
        expected = {
            "N" => 865,
            "B" => 1749,
            "C" => 298,
            "H" => 161 
        }
        assert_equal expected, freq_count(10, "NNCB".split(""), RULES)
    end

    def test_freq_table_sum
        table1 = { "A" => 1, "B" => 2, "D" => 5}
        table2 = { "B" => 3, "C" => 4}
        assert_equal table1, freq_table_sum({}, table1)
        expected = { "A" => 1, "B" => 5, "C" => 4, "D" => 5}
        assert_equal expected, freq_table_sum(table1, table2)
    end

    def test_base_precompute
        cache1 = {}
        base_precompute(1, RULES, cache1)
        assert_equal({ "C" => 1, "B" => 1, "H" => 1}, cache1[1][["C","H"]])
        assert_equal({ "H" => 2, "N" => 1 }, cache1[1][["H","H"]])

        cache2 = {}
        base_precompute(2, RULES, cache2)
        # CH -> CBH -> CHBHH
        assert_equal "CHBHH".split(""), n_steps(2, ["C", "H"], RULES)
        assert_equal({ "C" => 1, "B" => 1, "H" => 3}, cache2[2][["C","H"]])
        # HH -> HNH -> HCNCH
        assert_equal({ "H" => 2, "N" => 1, "C" => 2 }, cache2[2][["H","H"]])
    end

    def test_freq_count_from_cache_2
        template = "NNCB".split("")
        cache = {}
        base_precompute(2, RULES, cache)
        from_cache = freq_count_from_cache(2, template, cache)
        assert_equal freq_count(2, template, RULES), from_cache
    end

    def test_freq_count_from_cache_10
        template = "NNCB".split("")
        cache = {}
        base_precompute(10, RULES, cache)
        from_cache = freq_count_from_cache(10, template, cache)
        expected = {
            "N" => 865,
            "B" => 1749,
            "C" => 298,
            "H" => 161 
        }
        assert_equal expected, from_cache
    end

    def test_freq_count_from_cache_6
        template = ["C","H"]
        cache = {}
        base_precompute(6, RULES, cache)
        from_cache = freq_count_from_cache(6, template, cache)
        expected = {"B"=>19, "C"=>17, "H"=>21, "N"=>8}
        assert_equal expected, from_cache
    end

    def test_induction_precompute_2
        cache = {}  
        base_precompute(1, RULES, cache)
        assert_equal 2, induction_precompute(1, RULES, cache)
        # CH -> CBH -> CHBHH
        assert_equal({ "C" => 1, "B" => 1, "H" => 3}, cache[2][["C","H"]])
    end

    def test_induction_precompute_6
        cache = {}
        template = ["C","H"]
        expanded_3 = ["C", "B", "H", "C", "B", "H", "H", "N", "H"]
        assert_equal expanded_3, n_steps(3, template, RULES)
        assert_equal n_steps(6, template, RULES), n_steps(3, expanded_3, RULES)
        assert_equal( { "C" => 2, "B" => 2, "H" => 4, "N" => 1 }, freq_count(3, template, RULES))
        base_precompute(3, RULES, cache)
        assert_equal expanded_3, MEMO[[3, template]]
        assert_equal 6, induction_precompute(3, RULES, cache)
        puts template.inspect
        assert_equal cache[6][template], freq_count_from_cache(3, expanded_3, cache)
        assert_equal(freq_count(6, template, RULES), freq_count_from_cache(3, expanded_3, cache))
        assert_equal(freq_count(6, template, RULES), cache[6][template])
    end
end
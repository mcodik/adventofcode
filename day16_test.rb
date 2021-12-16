require "test/unit"
require_relative "./day16"

class Day16Test < Test::Unit::TestCase
    def test_bits
        assert_equal "110100101111111000101000".split(""), decode_packet("D2FE28")
    end

    def test_itob
        assert_equal 4, btoi(itob(4))
        assert_equal ["1", "0", "0"], itob(4)
        assert_equal 4, btoi(["1","0","0"])
    end

    def test_parse_literal
        bits = decode_packet("D2FE28")
        version, type, literal = parse(bits)
        assert_equal 6, version
        assert_equal :literal, type
        assert_equal 2021, literal
    end

    def test_parse_operator_length_type_0
        bits = decode_packet("38006F45291200")
        version, type, subpackets = parse(bits)
        assert_equal 1, version
        assert_equal 6, type
        version1, type1, literal1 = subpackets[0]
        assert_equal 6, version1
        assert_equal :literal, type1
        assert_equal 10, literal1
        version2, type2, literal2 = subpackets[1]
        assert_equal 2, version2
        assert_equal :literal, type2
        assert_equal 20, literal2
    end

    def test_subliteral
        bits = "11010001010".split("")
        version, type, literal = parse(bits)
        assert_equal :literal, type
        assert_equal 10, literal
    end

    def test_parse_operator_length_type_1
        bits = decode_packet("EE00D40C823060")
        version, type, subpackets = parse(bits)
        assert_equal 7, version
        assert_equal 3, type
        version1, type1, literal1 = subpackets[0]
        assert_equal 2, version1
        assert_equal :literal, type1
        assert_equal 1, literal1
        version2, type2, literal2 = subpackets[1]
        assert_equal 4, version2
        assert_equal :literal, type2
        assert_equal 2, literal2
        version3, type3, literal3 = subpackets[2]
        assert_equal 1, version3
        assert_equal :literal, type3
        assert_equal 3, literal3
    end

    def test_sum_versions
        bits = decode_packet("EE00D40C823060")
        packet = parse(bits)
        sum = sum_versions(packet)
        assert_equal 14, sum

        bits = decode_packet("8A004A801A8002F478")
        sum = sum_versions(parse(bits))
        assert_equal 16, sum

        bits = decode_packet("620080001611562C8802118E34")
        sum = sum_versions(parse(bits))
        assert_equal 12, sum

        bits = decode_packet("C0015000016115A2E0802F182340")
        sum = sum_versions(parse(bits))
        assert_equal 23, sum

        bits = decode_packet("A0016C880162017C3686B18A3D4780")
        sum = sum_versions(parse(bits))
        assert_equal 31, sum
    end

    def test_eval
        assert_equal 3, eval(parse(decode_packet("C200B40A82")))
        assert_equal 54, eval(parse(decode_packet("04005AC33890")))
        assert_equal 7, eval(parse(decode_packet("880086C3E88112")))
        assert_equal 9, eval(parse(decode_packet("CE00C43D881120")))
        assert_equal 1, eval(parse(decode_packet("D8005AC2A8F0")))
        assert_equal 0, eval(parse(decode_packet("F600BC2D8F")))
        assert_equal 0, eval(parse(decode_packet("9C005AC2F8F0")))
        assert_equal 1, eval(parse(decode_packet("9C0141080250320F1802104A08")))
    end
end
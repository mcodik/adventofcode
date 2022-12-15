use std::cmp::{Eq, Ordering};

use json::JsonValue;

#[derive(Clone, Eq, PartialEq)]
struct Packet {
    n:Option<i32>,
    l:Vec<Packet>,
}

impl ToString for Packet {
    fn to_string(&self) -> String {
        if let Some(n) = self.n {
            return n.to_string();
        }
        let mut s = String::from("[");
        for elem in self.l.iter() {
            s.push_str(&elem.to_string());
        }
        s.push(']');
        return s;
    }
}

impl PartialOrd for Packet {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn wrap_n(k:i32) -> Packet {
    Packet{ n: Some(k), l: vec![]}
}

fn wrap_list(k:i32) -> Packet {
    Packet{n:None, l:vec![wrap_n(k)]}
}

impl Ord for Packet {
    fn cmp(&self, other: &Self) -> Ordering {
        if let (Some(a), Some(b)) = (self.n, other.n) {
            return a.cmp(&b);
        }
        if let (None, Some(b)) = (self.n, other.n) {
            let b_prime = wrap_list(b);
            return self.cmp(&b_prime);
        }
        if let (Some(a), None) = (self.n, other.n) {
            let a_prime = wrap_list(a);
            return a_prime.cmp(other);
        }
        let mut al = self.l.iter();
        let mut bl = other.l.iter();
        loop {
            let a_opt = al.next();
            let b_opt = bl.next();

            if a_opt.is_none() && b_opt.is_none() {
                return Ordering::Equal;
            } else if b_opt.is_none() {
                return Ordering::Greater;
            } else if a_opt.is_none() {
                return Ordering::Less;
            }
            let a_val = a_opt.unwrap();
            let b_val = b_opt.unwrap();
            let res = a_val.cmp(b_val);
            if res != Ordering::Equal {
                return res;
            }
        }
    }
}

fn parse(s:&str) -> Packet {
    let j = json::parse(s).unwrap();
    let mut v = vec![];
    for m in j.members() {
        v.push(parse_jsonvalue(m));
    }
    return Packet{n:None, l:v};
}

fn parse_jsonvalue(j:&JsonValue) -> Packet {
    if j.is_number() {
        let n = j.as_i32().unwrap();
        return Packet{n:Some(n), l:vec![]};
    } else if j.is_array() {
        let mut v = vec![];
        for m in j.members() {
            v.push(parse_jsonvalue(m));
        }
        return Packet{n:None, l:v};
    }
    panic!("unexpected");
}

pub fn run_part_1(contents:&String) -> i32 {
    let mut idx = 1;
    let mut ans = 0;
    let mut lines = contents.lines();
    loop {
        let a = lines.next();
        let b = lines.next();
        if a.is_none() || b.is_none() {
            return ans;
        }
        let a_packet = parse(a.unwrap().trim());
        let b_packet = parse(b.unwrap().trim());
        if a_packet.cmp(&b_packet) == Ordering::Less {
            ans += idx;
        }
        lines.next();
        idx += 1;
    }
}

pub fn run_part_2(contents:&String) -> i32 {
    let two = parse("[[2]]");
    let six = parse("[[6]]");
    let mut lt_two = 0;
    let mut lt_six = 0;
    let mut lines : Vec<&str> = contents.lines().collect();
    lines.push("[[2]]");
    lines.push("[[6]]");
    for line in lines {
        let line = line.trim();
        if line == "" {
            continue;
        }
        let p = parse(line);
        if p.cmp(&two).is_le() {
            lt_two += 1;
        }
        if p.cmp(&six).is_le() {
            lt_six += 1;
        }
    }
    dbg!((lt_two, lt_six));
    lt_two * lt_six
}

#[cfg(test)]
mod tests {
    use super::*;

    fn to_packet(v:Vec<i32>) -> Packet {
        let ps = v.iter().map(|x| wrap_n(*x)).collect();
        Packet{ n: None, l: ps }
    }

    #[test]
    fn ordering_1() {
        let a = to_packet(vec![1,1,3,1,1]);
        let b = to_packet(vec![1,1,5,1,1]);
        assert_eq!(Ordering::Less, a.cmp(&b));
        assert_eq!(Ordering::Greater, b.cmp(&a));
    }

    #[test]
    fn ordering_2() {
        let a = Packet{n:None, l:vec![wrap_n(1), to_packet(vec![2,3,4])]};
        let b = Packet{n:None, l:vec![wrap_n(1), wrap_n(4)]};
        assert_eq!(Ordering::Less, a.cmp(&b));
        assert_eq!(Ordering::Greater, b.cmp(&a));
    }

    #[test]
    fn test_part_2() {
        let input = "
        []
[[]]
[[[]]]
[1,1,3,1,1]
[1,1,5,1,1]
[[1],[2,3,4]]
[1,[2,[3,[4,[5,6,0]]]],8,9]
[1,[2,[3,[4,[5,6,7]]]],8,9]
[[1],4]
[3]
[[4,4],4,4]
[[4,4],4,4,4]
[7,7,7]
[7,7,7,7]
[[8,7,6]]
[9]
";
        assert_eq!(140, run_part_2(&input.to_string()));
    }

    #[test]
    fn test_part_2_b() {
        let input = "
    [1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
";        assert_eq!(140, run_part_2(&input.to_string()));
}

}
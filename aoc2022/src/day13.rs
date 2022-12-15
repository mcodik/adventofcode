use std::cmp::{Eq, Ordering};

#[derive(Clone, Eq, PartialEq)]
struct Packet {
    n:Option<i32>,
    l:Box<Vec<Packet>>,
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
    Packet{ n: Some(k), l: Box::new(vec![])}
}

fn wrap_list(k:i32) -> Packet {
    Packet{n:None, l:Box::new(vec![wrap_n(k)])}
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

pub fn run_part_1(contents:&String) -> i32 {
0
}

pub fn run_part_2(contents:&String) -> i32 {
    0  
}

#[cfg(test)]
mod tests {
    use super::*;

    fn to_packet(v:Vec<i32>) -> Packet {
        let ps = v.iter().map(|x| wrap_n(*x)).collect();
        Packet{ n: None, l: Box::new(ps) }
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
        let a = Packet{n:None, l:Box::new(vec![wrap_n(1), to_packet(vec![2,3,4])])};
        let b = Packet{n:None, l:Box::new(vec![wrap_n(1), wrap_n(4)])};
        assert_eq!(Ordering::Less, a.cmp(&b));
        assert_eq!(Ordering::Greater, b.cmp(&a));
    }

    #[test]
    fn test_part_2() {
        assert_eq!(0, run_part_2(&"1\n2\n3\n".to_string()));
    }
}
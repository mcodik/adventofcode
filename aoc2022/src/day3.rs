use std::collections::HashSet;

const PRIORITIES : &str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

pub fn run_part_1(contents:&String) -> i32 {
    let mut total = 0;
    for mut line in contents.lines() {
        line = line.trim();
        if line.len() == 0 {
            continue;
        }
        total += find_common_compartment_pri(line);
    }
    total
}

pub fn run_part_2(contents:&String) -> i32 {
    let mut total = 0;
    
    let mut iter = contents.lines();
    loop {
        let v : Vec<&str> = iter.by_ref().take(3).map(|l| l.trim()).collect();
        if v.len() != 3 {
            break;
        }
        total += find_common_sack_pri(&v[0], &v[1], &v[2]);
    }
    total
}

fn find_common_sack_pri(a:&str, b:&str, c:&str) -> i32 {
    let first : HashSet<char> = a.chars().collect();
    let second: HashSet<char> = b.chars().collect();
    let third: HashSet<char> = c.chars().collect();
    let inter : HashSet<char> = first.intersection(&second).copied().collect();
    let inter_2 : Vec<char> = inter.intersection(&third).copied().collect();
    let common = inter_2.last().expect("empty");
    pri(common)
}

fn find_common_compartment_pri(sack:&str) -> i32 {
    let mid = sack.len()/2;
    let mut first = HashSet::new();
    let mut second = HashSet::new();
    for c in sack.chars().take(mid) {
        first.insert(c);
    }
    for c in sack.chars().skip(mid) {
        second.insert(c);
    }
    let common = first.intersection(&second).last().expect("empty intersection");
    pri(common)
}

fn pri(c:&char) -> i32 {
    let prio : usize = PRIORITIES.chars().position(|a| a == *c).expect("missing char");
    (prio + 1) as i32
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part_1() {
        assert_eq!(16, run_part_1(&"vJrwpWtwJgWrhcsFMMfFFhFp\n".to_string()));
        assert_eq!(38, run_part_1(&"jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\n".to_string()));
        assert_eq!(157, run_part_1(&"vJrwpWtwJgWrhcsFMMfFFhFp\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\nPmmdzqPrVvPwwTWBwg\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\nttgJtRGJQctTZtZT\nCrZsJsPPZsGzwwsLwLmpwMDw".to_string()));
    }
}
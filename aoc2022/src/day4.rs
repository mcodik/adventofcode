
pub fn run_part_1(contents:&String) -> i32 {
    let mut count : i32 = 0;
    for line in contents.lines().map(|x| x.trim()) {
        if let Some((alice, bob)) = parse(line) {
            if fully_contains(alice, bob) || fully_contains(bob, alice) {
                count += 1;
            }
        }
    }
    count
}

type Range = (i32, i32);

fn fully_contains(a:Range, b:Range) -> bool {
    a.0 <= b.0 && a.1 >= b.1
}

fn overlaps(a:Range, b:Range) -> bool {
    (a.0 <= b.0 && a.1 >= b.0) || (a.0 <= b.1 && a.1 >= b.1) || fully_contains(a, b)
}

fn parse(line:&str) -> Option<(Range, Range)> {
    if line.len() == 0 {
        return None;
    }
    let parts : Vec<&str> = line.split(',').collect();
    let alice = parse_range(&parts[0]);
    let bob = parse_range(&parts[1]);
    Some((alice, bob))
}

fn parse_range(range_str:&str) -> Range {
    let parts_str : Vec<&str> = range_str.split('-').collect();
    let start : &i32 = &parts_str[0].parse().unwrap();
    let end : &i32 = &parts_str[1].parse().unwrap();
    (*start, *end)
}

pub fn run_part_2(contents:&String) -> i32 {
    let mut count : i32 = 0;
    for line in contents.lines().map(|x| x.trim()) {
        if let Some((alice, bob)) = parse(line) {
            if overlaps(alice, bob) || overlaps(bob, alice) {
                count += 1;
            }
        }
    }
    count
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part_1() {
        assert_eq!(0, run_part_1(&"2-4,5-6\n".to_string()));
        assert_eq!(1, run_part_1(&"2-8,3-7\n".to_string()));
        assert_eq!(1, run_part_1(&"6-6,4-6\n".to_string()));
    }

    #[test]
    fn part_2() {
        assert_eq!(0, run_part_2(&"2-4,5-6\n".to_string()));
        assert_eq!(1, run_part_2(&"2-8,3-7\n".to_string()));
        assert_eq!(1, run_part_2(&"6-6,4-6\n".to_string()));
        assert_eq!(1, run_part_2(&"2-4,3-6\n".to_string()));
        assert_eq!(1, run_part_2(&"2-8,1-3\n".to_string()));
        assert_eq!(1, run_part_2(&"1-2,1-2\n".to_string()));
    }
}
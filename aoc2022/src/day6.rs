use std::collections::{HashSet, VecDeque};

pub fn run_part_1(contents:&String) -> usize {
    solve(contents, 4)
}

pub fn run_part_2(contents:&String) -> usize {
    solve(contents, 14)
}

fn solve(contents:&String, n:usize) -> usize {
    let mut s = VecDeque::new();
    for (j, c) in contents.char_indices() {
        s.push_back(c);
        if j < n-1 {
            continue;
        }
        let set : HashSet<char> = s.iter().copied().collect();
        if set.len() == n {
            return j+1;
        }
        s.pop_front();
    }
    0
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part_1() {
        assert_eq!(7, run_part_1(&"mjqjpqmgbljsphdztnvjfqwrcgsmlb\n".to_string()));
        assert_eq!(5, run_part_1(&"bvwbjplbgvbhsrlpgdmjqwftvncz\n".to_string()));
        assert_eq!(10, run_part_1(&"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".to_string()));
    }

    #[test]
    fn part_2() {
        assert_eq!(19, run_part_2(&"mjqjpqmgbljsphdztnvjfqwrcgsmlb\n".to_string()));
        assert_eq!(23, run_part_2(&"bvwbjplbgvbhsrlpgdmjqwftvncz\n".to_string()));
        assert_eq!(29, run_part_2(&"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".to_string()));
    }
}
use std::collections::HashSet;


#[derive(PartialEq)]
enum Direction {
    UP, LEFT, RIGHT, DOWN
}

trait Navigable {
    fn next(&self, i:i32, j:i32) -> (i32, i32);
}

impl Navigable for Direction {
    fn next(&self, i:i32, j:i32) -> (i32, i32) {
        match self {
            Direction::UP => (i-1,j),
            Direction::DOWN => (i+1,j),
            Direction::LEFT => (i,j-1),
            Direction::RIGHT => (i,j+1),
        }
    }
}

pub fn run_part_1(contents:&String) -> usize {
    let cmds = parse(contents);
    let mut visited = HashSet::new();
    let mut head_i = 0; 
    let mut head_j = 0;
    let mut tail_i = 0; 
    let mut tail_j = 0;
    visited.insert((tail_i,tail_j));
    for (dir, len) in cmds {
        for _ in 0..len {
            (head_i, head_j) = dir.next(head_i, head_j);
            (tail_i, tail_j) = update_tail(&dir, tail_i, tail_j, head_i, head_j);
            visited.insert((tail_i, tail_j));
        }
    }
    visited.len()
}

fn update_tail(dir:&Direction, tail_i:i32, tail_j:i32, head_i:i32, head_j:i32) -> (i32, i32) {
    let i_dist = (tail_i - head_i).abs();
    let j_dist = (tail_j - head_j).abs();
    let dist = i_dist + j_dist;
    
    if dist <= 1 || (i_dist == 1 && j_dist == 1) {
        return (tail_i, tail_j);
    }
    
    if (i_dist == 2 && j_dist == 0) || (i_dist == 0 && j_dist == 2) {
        return dir.next(tail_i, tail_j);
    }

    let choices = vec![
        (Direction::UP, Direction::LEFT),
        (Direction::UP, Direction::RIGHT),
        (Direction::DOWN, Direction::LEFT),
        (Direction::DOWN, Direction::RIGHT),
    ];

    for choice in choices {
        let (i, j) = choice.0.next(tail_i, tail_j);
        let (i, j) = choice.1.next(i, j);
        let i_dist = (i - head_i).abs();
        let j_dist = (j - head_j).abs();
        if (i_dist + j_dist) == 1 {
            return (i, j);
        } 
    }
    panic!("unexpected");
    // if (head_i-2 == tail_i && head_j-1 == tail_j) || (head_i-1 == tail_i && head_j+2 == tail_j) {
    // /*
    //   H . .
    //   . . T  
    //  */
    //  /*
    //   H .
    //   . .
    //   . T  
    //  */
    //     (tail_i-1, tail_j-1)
    // } else if (head_i+2 == tail_i && head_j-1 == tail_j) || (head_i+1 == tail_i && head_j-2 == tail_j) {
    // /*
    //   T . .
    //   . . H  
    //  */
    //  /*
    //   T .
    //   . .
    //   . H  
    //  */
    //     (tail_i+1, tail_j+1)
    // } else if (head_i+1 == tail_i && head_j-2 == tail_j) || (head_i+2 == tail_i && head_j-1 == tail_j) {
    // /*
    //   . . H
    //   T . .  
    //  */
    //  /*
    //   . H
    //   . .
    //   T .  
    //  */
    //     (tail_i-1, tail_j+1)
    // } else if (head_i-2 == tail_i && head_j+1 == tail_j) || (head_i-1 == tail_i && head_j+2 == tail_j) {
    // /*
    //   . . T
    //   H . .  
    //  */
    //  /*
    //   . T
    //   . .
    //   H .  
    //  */    
    //     (tail_i+1, tail_j-1)
    // } else {
    //     panic!("unexpected");
    // }
}

pub fn run_part_2(contents:&String) -> i32 {
    0   
}

fn parse(contents:&String) -> Vec<(Direction, i32)> {
    let mut ops = vec![];
    for line in contents.lines() {
        let (d, n) = line.trim().split_at(1);
        let dir = match d {
            "R" => Direction::RIGHT,
            "U" => Direction::UP,
            "L" => Direction::LEFT,
            "D" => Direction::DOWN,
            _ => panic!("no match"),
        };
        let cnt : i32 = n.trim().parse().unwrap();
        ops.push((dir, cnt));
    }
    ops
}

   
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_1() {
        let input = "R 4
        U 4
        L 3
        D 1
        R 4
        D 1
        L 5
        R 2";

        assert_eq!(13, run_part_1(&input.to_string()));
    }

    #[test]
    fn part_2() {
        let input = "R 5
        U 8
        L 8
        D 3
        R 17
        D 10
        L 25
        U 20";
        assert_eq!(36, run_part_2(&input.to_string()));
    }
}
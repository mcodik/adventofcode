pub fn run_part_1(contents:&String) -> i32 {
    let forest = parse(contents);
    let mut visible = 0;
    for (i, row) in forest.iter().enumerate() {
        for (j, _) in row.iter().enumerate() {
            if is_visible(&forest, i, j) {
                visible += 1;
            }
        }
    }
    visible
}

pub fn run_part_2(contents:&String) -> i32 {
    let forest = parse(contents);
    let mut best_score = 0;
    for (i, row) in forest.iter().enumerate() {
        for (j, _) in row.iter().enumerate() {
            let score = scenic_score(&forest, i, j);
            if score > best_score {
                best_score = score;
            }
        }
    }
    best_score
}

#[derive(PartialEq)]
enum Direction {
    TOP, LEFT, RIGHT, BOTTOM
}

trait Navigable {
    fn next(&self, forest:&Vec<Vec<i32>>, i:usize, j:usize) -> Option<(usize, usize)>;
}

impl Navigable for Direction {
    fn next(self:&Direction, forest:&Vec<Vec<i32>>, i:usize, j:usize) -> Option<(usize, usize)> {
        if *self == Direction::TOP && i == 0 {
            return None;
        }
        if *self == Direction::LEFT && j == 0 {
            return None;
        }
        let coord  = match self {
            Direction::TOP => (i-1,j),
            Direction::BOTTOM => (i+1,j),
            Direction::LEFT => (i,j-1),
            Direction::RIGHT => (i,j+1),
        };
        if coord.0 < forest.len() && coord.1 < forest[0].len() {
            return Some(coord);
        }
        return None;
    }
}

fn scenic_score(forest:&Vec<Vec<i32>>, i:usize, j:usize) -> i32 {
    return count_visible(forest, i, j, Direction::TOP) 
        * count_visible(forest, i, j, Direction::LEFT) 
        * count_visible(forest, i, j, Direction::RIGHT) 
        * count_visible(forest, i, j, Direction::BOTTOM);
}

fn is_visible(forest:&Vec<Vec<i32>>, i:usize, j:usize) -> bool {
    if i == 0 || j == 0 {
        return true;
    }
    if i == forest.len()-1 || j == forest[i].len()-1 {
        return true;
    }

    is_visible_from(forest, i, j, Direction::TOP) 
        || is_visible_from(forest, i, j, Direction::LEFT)
        || is_visible_from(forest, i, j, Direction::RIGHT)
        || is_visible_from(forest, i, j, Direction::BOTTOM)
}

fn count_visible(forest:&Vec<Vec<i32>>, i:usize, j:usize, dir:Direction) -> i32 {
    let mut count = 0;
    let height = forest[i][j];
    let (mut y, mut x) = (i, j);
    loop {
        let next_tree = dir.next(forest, y, x);
        match next_tree {
            Some((a, b)) => {
                count += 1;                
                if forest[a][b] >= height {
                    return count;
                }

                y = a;
                x = b;
            },
            None => return count
        }
    }
}

fn is_visible_from(forest:&Vec<Vec<i32>>, i:usize, j:usize, dir:Direction) -> bool {
    let (mut y, mut x) = (i, j);
    let height = forest[i][j];
    loop {
        let next_tree = dir.next(forest, y, x);
        match next_tree {
            Some((a, b)) => {
                if forest[a][b] >= height {
                    return false;
                }
                y = a;
                x = b;
            },
            None => return true
        }
    }
}

fn parse(contents:&String) -> Vec<Vec<i32>> {
    let mut data = vec![];
    for line in contents.lines() {
        let row : Vec<char> = line.trim().chars().collect();
        data.push(row.iter().map(|x| {
            let v :i32 = x.to_string().parse().unwrap();
            v
        }).collect());
    }
    data
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_1() {
        let input = "30373
        25512
        65332
        33549
        35390";

        assert_eq!(21, run_part_1(&input.to_string()));
    }

    #[test]
    fn part_2() {
        let input = "30373
        25512
        65332
        33549
        35390";
        assert_eq!(8, run_part_2(&input.to_string()));
    }
}

pub fn run_part_1(contents:&String) -> i32 {
    let mut points = 0;
    for line in contents.lines() {
        if line.trim().len() == 0 {
            continue;
        }
        let opponent_char = &line.chars().nth(0).expect("empty");
        let opponent_move = match opponent_char {
            'A' => ROCK,
            'B' => PAPER,
            'C' => SCISSORS,
            _ => panic!("no match")
        };

        let my_char = &line.chars().nth(2).expect("too short");
        let my_move = match my_char {
            'X' => ROCK,
            'Y' => PAPER,
            'Z' => SCISSORS,
            _ => panic!("no match")
        };
        points += evaluate_round(my_move, opponent_move);
    }
    points
}

pub fn run_part_2(contents:&String) -> i32 {
    let mut points = 0;
    for line in contents.lines() {
        if line.trim().len() == 0 {
            continue;
        }
        let opponent_char = &line.chars().nth(0).expect("empty");
        let opponent_move = match opponent_char {
            'A' => ROCK,
            'B' => PAPER,
            'C' => SCISSORS,
            _ => panic!("no match")
        };

        let outcome_char = &line.chars().nth(2).expect("too short");
        let outcome = match outcome_char {
            'X' => LOST,
            'Y' => DRAW,
            'Z' => WON,
            _ => panic!("no match")
        };
        let my_move = find_my_move(opponent_move, outcome);
        points += evaluate_round(my_move, opponent_move);
    }
    points
}

const DRAW : i32 = 3;
const LOST : i32 = 0;
const WON : i32 = 6;

const ROCK : i32 = 1;
const PAPER : i32 = 2;
const SCISSORS : i32 = 3;

fn find_my_move(opponent_move : i32, outcome : i32) -> i32 {
    if outcome == DRAW {
        return opponent_move;
    } else if outcome == WON {
        return match opponent_move {
            ROCK => PAPER,
            PAPER => SCISSORS,
            SCISSORS => ROCK,
            _ => panic!("no match")
        }
    } else {
        return match opponent_move {
            ROCK => SCISSORS,
            PAPER => ROCK,
            SCISSORS => PAPER,
            _ => panic!("no match")
        }
    }
}

fn evaluate_round(my_move : i32, opponent_move : i32) -> i32 {
    if my_move == opponent_move {
        return my_move + DRAW;
    }
    if (my_move == ROCK && opponent_move == SCISSORS) 
      || (my_move == SCISSORS && opponent_move == PAPER) 
      ||  (my_move == PAPER && opponent_move == ROCK) {
        return my_move + WON;
      } else {
        return my_move + LOST;
      }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part_1() {
        assert_eq!(8, run_part_1(&"A Y\n".to_string()));
        assert_eq!(1, run_part_1(&"B X\n".to_string()));
        assert_eq!(9, run_part_1(&"A Y\nB X\n".to_string()));
        assert_eq!(15, run_part_1(&"A Y\nB X\nC Z\n\n".to_string()));
    }

    #[test]
    fn part_2() {
        assert_eq!(4, run_part_2(&"A Y\n".to_string()));
        assert_eq!(1, run_part_2(&"B X\n".to_string()));
        assert_eq!(5, run_part_2(&"A Y\nB X\n".to_string()));
        assert_eq!(12, run_part_2(&"A Y\nB X\nC Z\n\n".to_string()));
    }
}
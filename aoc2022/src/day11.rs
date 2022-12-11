
struct Monkey {
    update: fn (u64) -> u64,
    test: u64,
    if_true: usize,
    if_false: usize
}

const MONKEY_0 : Monkey = Monkey {
    update: |x| x*5,
    test: 11,
    if_true: 2,
    if_false: 3
};

const MONKEY_1 : Monkey= Monkey {
    update: |x| x*11,
    test: 5,
    if_true: 4,
    if_false: 0
};

const MONKEY_2 : Monkey= Monkey {
    update: |x| x+2,
    test: 19,
    if_true: 5,
    if_false: 6
};

const MONKEY_3 : Monkey= Monkey {
    update: |x| x+5,
    test: 13,
    if_true: 2,
    if_false: 6
};

const MONKEY_4 : Monkey= Monkey {
    update: |x| x*x,
    test: 7,
    if_true: 0,
    if_false: 3
};

const MONKEY_5 : Monkey= Monkey {
    update: |x| x+4,
    test: 17,
    if_true: 7,
    if_false: 1
};

const MONKEY_6 : Monkey= Monkey {
    update: |x| x+6,
    test: 2,
    if_true: 7,
    if_false: 5
};

const MONKEY_7 : Monkey= Monkey {
    update: |x| x+7,
    test: 3,
    if_true: 4,
    if_false: 1
};

const MONKEYS : [Monkey;8] = [MONKEY_0, MONKEY_1, MONKEY_2, MONKEY_3, MONKEY_4, MONKEY_5, MONKEY_6, MONKEY_7];
    
pub fn run_part_1() -> u64 {
    simulate(20, 3)
}

fn simulate(rounds:i32, relax_factor:u64) -> u64 {
    let mut state: [Vec<u64>;8] = [
        vec![83, 88, 96, 79, 86, 88, 70],
        vec![59, 63, 98, 85, 68, 72],
        vec![90, 79, 97, 52, 90, 94, 71, 70],
        vec![97, 55, 62],
        vec![74, 54, 94, 76],
        vec![58],
        vec![66, 63],
        vec![56, 56, 90, 96, 68],
    ];

    let mut observations : [u64; 8] = [0; 8];

    for _ in 0..rounds {
        for i in 0..8 {
            let monkey = &MONKEYS[i];
            let (mut true_vec, mut false_vec) = do_monkey_turn(&state[i], monkey, relax_factor);
            observations[i] += state[i].len() as u64;
            state[i] = vec![];
            state[monkey.if_true].append(&mut true_vec);
            state[monkey.if_false].append(&mut false_vec);
        }
    }
    // dbg!(observations);
    observations.sort();
    return observations[6] * observations[7];
}

fn do_monkey_turn(items:&[u64], monkey:&Monkey, relax_factor:u64) -> (Vec<u64>, Vec<u64>) {
    let mut true_vec = vec![];
    let mut false_vec = vec![];
    for worry in items {
        let updated_worry = (monkey.update)(*worry) % 9699690;
        let after_relax = updated_worry/relax_factor;
        let div = after_relax / monkey.test;
        let test = div*monkey.test == after_relax;
        if test {
            true_vec.push(after_relax);
        } else {
            false_vec.push(after_relax);
        }
    }
    return (true_vec, false_vec);
}

pub fn run_part_2() -> u64 {
    simulate(10000, 1)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_1() {
        assert_eq!(0, run_part_1());
    }

    #[test]
    fn test_part_2() {
        assert_eq!(0, run_part_2());
    }
}

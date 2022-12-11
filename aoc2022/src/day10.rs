pub fn run_part_1(contents:&String) -> i32 {
    let mut cycle = 0;
    let mut register = 1;
    let mut signal = 0;
    let targets = vec![20, 60, 100, 140, 180, 220];
    for line in contents.lines() {
        let cmd = line.trim();
        if cmd == "noop" {
            cycle += 1;
            if targets.contains(&cycle) {
                signal += cycle * register;
            }
        } else if cmd.starts_with("addx") {
            let (_, cnt) = cmd.split_at(5);
            let incr :i32 = cnt.parse().unwrap();
            cycle += 1;
            if targets.contains(&cycle) {
                signal += cycle * register;
            }
            cycle += 1;
            if targets.contains(&cycle) {
                signal += cycle * register;
            }
            register += incr;
        }

    }
    return signal;
}

pub fn run_part_2(contents:&String) -> String {
    let mut cycle:i32 = 0;
    let mut register = 1;
    let mut output : [char; 240] = ['.'; 240];
    for line in contents.lines() {
        let cmd = line.trim();
        if cmd == "noop" {
            cycle += 1;
            let position = (cycle -1)%40;
            if vec![register-1, register, register+1].contains(&position) {
                output[cycle as usize - 1] = '#';
            }
        } else if cmd.starts_with("addx") {
            let (_, cnt) = cmd.split_at(5);
            let incr :i32 = cnt.parse().unwrap();
            cycle += 1;
            let position = (cycle -1)%40;
            if vec![register-1, register, register+1].contains(&position) {
                output[cycle as usize - 1] = '#';
            }
            cycle += 1;
            let position = (cycle -1)%40;
            if vec![register-1, register, register+1].contains(&position) {
                output[cycle as usize - 1] = '#';
            }
            register += incr;
        }

    }
    let mut ret = String::from("");
    for row in output.chunks(40) {
        let row_str :String = row.iter().collect();
        ret.push_str(&row_str);
        ret.push('\n');
    }
    return ret;
}


   
#[cfg(test)]
mod tests {
    use super::*;

    const INPUT : &str = "addx 15
    addx -11
    addx 6
    addx -3
    addx 5
    addx -1
    addx -8
    addx 13
    addx 4
    noop
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx 5
    addx -1
    addx -35
    addx 1
    addx 24
    addx -19
    addx 1
    addx 16
    addx -11
    noop
    noop
    addx 21
    addx -15
    noop
    noop
    addx -3
    addx 9
    addx 1
    addx -3
    addx 8
    addx 1
    addx 5
    noop
    noop
    noop
    noop
    noop
    addx -36
    noop
    addx 1
    addx 7
    noop
    noop
    noop
    addx 2
    addx 6
    noop
    noop
    noop
    noop
    noop
    addx 1
    noop
    noop
    addx 7
    addx 1
    noop
    addx -13
    addx 13
    addx 7
    noop
    addx 1
    addx -33
    noop
    noop
    noop
    addx 2
    noop
    noop
    noop
    addx 8
    noop
    addx -1
    addx 2
    addx 1
    noop
    addx 17
    addx -9
    addx 1
    addx 1
    addx -3
    addx 11
    noop
    noop
    addx 1
    noop
    addx 1
    noop
    noop
    addx -13
    addx -19
    addx 1
    addx 3
    addx 26
    addx -30
    addx 12
    addx -1
    addx 3
    addx 1
    noop
    noop
    noop
    addx -9
    addx 18
    addx 1
    addx 2
    noop
    noop
    addx 9
    noop
    noop
    noop
    addx -1
    addx 2
    addx -37
    addx 1
    addx 3
    noop
    addx 15
    addx -21
    addx 22
    addx -6
    addx 1
    noop
    addx 2
    addx 1
    noop
    addx -10
    noop
    noop
    addx 20
    addx 1
    addx 2
    addx 2
    addx -6
    addx -11
    noop
    noop
    noop";

    #[test]
    fn test_part_1() {
        assert_eq!(13140, run_part_1(&INPUT.to_string()));
    }

    #[test]
    fn part_2() {
        let expected = "##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....
";
        assert_eq!(expected, run_part_2(&INPUT.to_string()));
    }
}
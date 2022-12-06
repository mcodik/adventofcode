use regex::Regex;


#[derive(Debug)]
#[derive(PartialEq)]
struct Move {
    cnt : usize,
    src : usize,
    dst : usize
}

pub fn run_part_1(init:&[&str], contents:&String) -> String {
    let mut stacks = prepare(init);
    for line in contents.lines() {
        let m = parse(line);
        let mut buf = Vec::new();
        {
            let src = &mut stacks[m.src - 1];
            for _ in 0..m.cnt {
                let v = src.pop().unwrap();
                buf.push(v);
            }
        }

        {
            let dest = &mut stacks[m.dst - 1];
            dest.append(&mut buf);
        }
    }
    let ans : String = stacks.iter().map(|x| x.last().unwrap_or(&&' ')).copied().collect();
    ans
 }
 
 pub fn run_part_2(init:&[&str], contents:&String) -> String {
    let mut stacks = prepare(init);
    for line in contents.lines() {
        let m = parse(line);
        let mut buf : Vec<char>;
        {
            let src = &mut stacks[m.src - 1];
            let n = src.len() - m.cnt;
            buf = src.drain(n..).collect();
        }

        {
            let dest = &mut stacks[m.dst - 1];
            dest.append(&mut buf);
        }
    }
    let ans : String = stacks.iter().map(|x| x.last().unwrap_or(&&' ')).copied().collect();
    ans }

 fn prepare(init:&[&str]) -> Vec<Vec<char>> {
    let mut v = Vec::new();
    for s in init {
        let c : Vec<char> = s.chars().collect();
        v.push(c);
    }
    v
 }

 fn parse(line:&str) -> Move {
    let pattern = Regex::new(r"move (\d+) from (\d)+ to (\d+)").unwrap();
    let parts  = pattern.captures_iter(line).last().unwrap();
    Move { cnt: parts[1].parse().unwrap(), src: parts[2].parse().unwrap(), dst: parts[3].parse().unwrap() }
 }

 #[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse() {
        let m = Move{cnt: 4, src: 1, dst: 4};
        assert_eq!(m, parse("move 4 from 1 to 4\n"));
    }

    #[test]
    fn test_part_1() {
        let init = ["zn","mcd","p"];
        assert_eq!("dcp", run_part_1(init.as_slice(), &"move 1 from 2 to 1\n".to_string()));
    }
}
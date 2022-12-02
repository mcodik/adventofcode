use std::fs;

fn main() {
    let contents = fs::read_to_string("inputs/day1.txt").expect("should open file");
    let result = aoc2022::day1(contents, 1);
    println!("done! {result}");

    let contents2 = fs::read_to_string("inputs/day1.txt").expect("should open file");
    let result2 = aoc2022::day1(contents2, 3);
    println!("done! {result2}");
}

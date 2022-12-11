use core::panic;
use std::fs;
use std::env;

pub mod day1;
pub mod day2;
pub mod day3;
pub mod day4;
pub mod day5;
pub mod day6;
pub mod day7;
pub mod day8;
pub mod day9;
pub mod day10;
pub mod day11;
// pub mod day12;
// pub mod day13;
// pub mod day14;
// pub mod day15;
// pub mod day16;
// pub mod day17;
// pub mod day18;
// pub mod day19;
// pub mod day20;
// pub mod day21;
// pub mod day22;
// pub mod day23;
// pub mod day24;
// pub mod day25;

fn main() {
    let args : Vec<String> = env::args().collect();
    let name = args.get(1);
    let default = "day11".to_string();
    let day = name.unwrap_or(&default);
    match day.as_str() {
    "day1" => run_day1(),
    "day2" => run_day2(),
    "day3" => run_day3(),
    "day4" => run_day4(),
    "day5" => run_day5(),
    "day6" => run_day6(),
    "day7" => run_day7(),
    "day8" => run_day8(),
    "day9" => run_day9(),
    "day10" => run_day10(),
    "day11" => run_day11(),
    // "day12" => run_day12(),
    // "day13" => run_day13(),
    // "day14" => run_day14(),
    // "day15" => run_day15(),
    // "day16" => run_day16(),
    // "day17" => run_day17(),
    // "day18" => run_day18(),
    // "day19" => run_day19(),
    // "day20" => run_day20(),
    // "day21" => run_day21(),
    // "day22" => run_day22(),
    // "day23" => run_day23(),
    // "day24" => run_day24(),
    // "day25" => run_day25(),
    _ => panic!("not a day"),
    }
}


fn run_day11() {
    let result = day11::run_part_1();
    println!("done! {result}");
    let result = day11::run_part_2();
    println!("done! {result}");
}

fn run_day10() {
    let contents = fs::read_to_string("inputs/day10.txt").expect("should open file");
    let result = day10::run_part_1(&contents);
    println!("done! {result}");
    let result = day10::run_part_2(&contents);
    println!("done!\n{result}");
}

fn run_day9() {
    let contents = fs::read_to_string("inputs/day9.txt").expect("should open file");
    let result = day9::run_part_1(&contents);
    println!("done! {result}");
    let result = day9::run_part_2(&contents);
    println!("done! {result}");
}

fn run_day8() {
    let contents = fs::read_to_string("inputs/day8.txt").expect("should open file");
    let result = day8::run_part_1(&contents);
    println!("done! {result}");
    let result = day8::run_part_2(&contents);
    println!("done! {result}");
}

fn run_day7() {
    let contents = fs::read_to_string("inputs/day7.txt").expect("should open file");
    let result = day7::run_part_1(&contents);
    println!("done! {result}");
    let result = day7::run_part_2(&contents);
    println!("done! {result}");
}

fn run_day6() {
    let contents = fs::read_to_string("inputs/day6.txt").expect("should open file");
    let result = day6::run_part_1(&contents);
    println!("done! {result}");
    let result = day6::run_part_2(&contents);
    println!("done! {result}");
}

fn run_day5() {
    /*
                [M]     [V]     [L]
[G]             [V] [C] [G]     [D]
[J]             [Q] [W] [Z] [C] [J]
[W]         [W] [G] [V] [D] [G] [C]
[R]     [G] [N] [B] [D] [C] [M] [W]
[F] [M] [H] [C] [S] [T] [N] [N] [N]
[T] [W] [N] [R] [F] [R] [B] [J] [P]
[Z] [G] [J] [J] [W] [S] [H] [S] [G]
 1   2   3   4   5   6   7   8   9 
*/

    const INITIAL : [&str; 9] = [
        "ztfrwjg", "gwm", "jnhg", "jrcnw", "wfsbgqvm", "srtdvwc", "hbncdzgv", "sjnmgc", "gpnwcjdl"
    ];
    let contents = fs::read_to_string("inputs/day5.txt").expect("should open file");
    let result = day5::run_part_1(INITIAL.as_slice(), &contents);
    println!("done! {result}");
    let result = day5::run_part_2(INITIAL.as_slice(), &contents);
    println!("done! {result}");
}

fn run_day4() {
    let contents = fs::read_to_string("inputs/day4.txt").expect("should open file");
    let result = day4::run_part_1(&contents);
    println!("done! {result}");
    let result = day4::run_part_2(&contents);
    println!("done! {result}");
}

fn run_day3() {
    let contents = fs::read_to_string("inputs/day3.txt").expect("should open file");
    let result = day3::run_part_1(&contents);
    println!("done! {result}");
    let result = day3::run_part_2(&contents);
    println!("done! {result}");
}

fn run_day2() {
    let contents = fs::read_to_string("inputs/day2.txt").expect("should open file");
    let result = day2::run_part_1(&contents);
    println!("done! {result}");

    let result = day2::run_part_2(&contents);
    println!("done! {result}");
}

fn run_day1() {
    let contents = fs::read_to_string("inputs/day1.txt").expect("should open file");
    let result = day1::run(&contents, 1);
    println!("done! {result}");

    let result2 = day1::run(&contents, 3);
    println!("done! {result2}");
}
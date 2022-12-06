use core::panic;
use std::fs;
use std::env;

pub mod day1;
pub mod day2;
pub mod day3;
pub mod day4;
pub mod day5;

fn main() {
    let args : Vec<String> = env::args().collect();
    let name = args.get(1);

    if name.is_none() {
        run_day5();
    } else {
        let day = name.expect("impossible");
        match day.as_str() {
        "day1" => run_day1(),
        "day2" => run_day2(),
        "day3" => run_day3(),
        "day4" => run_day4(),
        _ => panic!("not a day"),
        }
    }
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
use core::panic;
use std::fs;
use std::env;

pub mod day1;
pub mod day2;
pub mod day3;

fn main() {
    let args : Vec<String> = env::args().collect();
    let name = args.get(1);

    if name.is_none() {
        run_day3();
    } else {
        let day = name.expect("impossible");
        match day.as_str() {
        "day1" => run_day1(),
        "day2" => run_day2(),
        _ => panic!("not a day"),
        }
    }
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
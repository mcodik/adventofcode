use std::collections::HashMap;

use regex::Regex;

#[derive(PartialEq)]
enum Mode {
    LS, CMD
}

pub fn run_part_1(contents:&String) -> i32 {
    let map = size_map(contents);
    let mut sum = 0;
    for entry in map.iter() {
        if *entry.1 <= 100000 {
            sum += entry.1
        }
    }
    sum
}

fn to_path(cd:&Vec<String>) -> String {
    if cd.is_empty() {
        return "/".to_string();
    }
    return cd.join("/");
}

fn size_map(contents:&String) -> HashMap<String, i32> {
    let cd_pattern = Regex::new(r"\$ cd (.+)").unwrap();
    let dir_pattern = Regex::new(r"dir (\w+)").unwrap();
    let file_pattern = Regex::new(r"(\d+) (\w+)").unwrap();
    let mut mode = Mode::CMD;

    let mut cwd : Vec<String> = vec![];
    let mut file_sizes = HashMap::new();

    let iter = contents.lines();
    for line in iter {
        let entry = line.trim();
        if mode == Mode::LS {
            if dir_pattern.is_match(entry) {
                continue;
            } 
            else if file_pattern.is_match(entry) {
                let file_cap = file_pattern.captures_iter(entry).last().unwrap();
                let file_size : i32 = file_cap[1].parse().unwrap();
                for prefix in 0..cwd.len() {
                    let path = to_path(&cwd.get(0..prefix+1).unwrap().to_vec());
                    let dir_size = file_sizes.get(&path).unwrap_or(&0);
                    file_sizes.insert(path, dir_size + file_size);
                }
            }
            else {
                mode = Mode::CMD;
            }
        }
        if mode == Mode::CMD {
            if entry == "$ cd /" {
                cwd = vec!["".to_string()];
                continue;
            }
            if cd_pattern.is_match(entry) {
                let path_cap = cd_pattern.captures_iter(entry).last().unwrap();
                let new_dir = &path_cap[1];
                if new_dir == ".." {
                    cwd.pop();
                } else {
                    cwd.push(new_dir.to_string());
                }
            } else if entry == "$ ls" {
               mode = Mode::LS;
               continue;
           }
        }
    }
    file_sizes
}

pub fn run_part_2(contents:&String) -> i32 {
    const TOTAL_DISK:i32 = 70000000;
    const REQUIRED_UNUSED:i32 = 30000000;

    let sizes = size_map(contents);
    let actual_used = sizes.get("").unwrap();
    let actual_unused = TOTAL_DISK - actual_used;

    let mut dir_size = TOTAL_DISK;
    for entry in sizes {
        let size = entry.1;
        let new_unused = actual_unused + size;
        if new_unused > REQUIRED_UNUSED {
            if size < dir_size {
                dir_size = size;
            }
        }
    }
    dir_size
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_1() {
        let input = "$ cd /
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
        $ cd a
        $ ls
        dir e
        29116 f
        2557 g
        62596 h.lst
        $ cd e
        $ ls
        584 i
        $ cd ..
        $ cd ..
        $ cd d
        $ ls
        4060174 j
        8033020 d.log
        5626152 d.ext
        7214296 k";

        dbg!(size_map(&input.to_string()));
        assert_eq!(95437, run_part_1(&input.to_string()));
    }

    #[test]
    fn part_2() {
        let input = "$ cd /
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
        $ cd a
        $ ls
        dir e
        29116 f
        2557 g
        62596 h.lst
        $ cd e
        $ ls
        584 i
        $ cd ..
        $ cd ..
        $ cd d
        $ ls
        4060174 j
        8033020 d.log
        5626152 d.ext
        7214296 k";
        assert_eq!(24933642, run_part_2(&input.to_string()));
    }
}
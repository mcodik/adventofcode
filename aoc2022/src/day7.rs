use regex::Regex;

#[derive(Debug)]
#[derive(PartialEq)]
struct File {
    name : String,
    size : i32
}

#[derive(Debug)]
#[derive(PartialEq)]
struct Dir {
    name : String,
    dirs : Vec<Dir>,
    files : Vec<File>
}

#[derive(PartialEq)]
enum Mode {
    LS, CMD
}

pub fn run_part_1(contents:&String) -> i32 {
    let root = parse(contents);
    0
}

fn parse(contents:&String) -> Dir {
    let cd_pattern = Regex::new(r"\$ cd (.+)").unwrap();
    let dir_pattern = Regex::new(r"dir (\s+)").unwrap();
    let file_pattern = Regex::new(r"(\d+) (\s+)").unwrap();
    let mut mode = Mode::CMD;

    let mut root = Dir { name: "".to_string(), dirs: vec![], files: vec![] };
    let mut current_dir = &mut root;
    let mut cwd : Vec<String> = vec![];

    let iter = contents.lines();
    for line in iter {
        let entry = line.trim();
        if mode == Mode::LS {
            if dir_pattern.is_match(entry) {
                let dir_cap = dir_pattern.captures_iter(entry).last().unwrap();
                let dir_name = &dir_cap[1];
                let new_dir = Dir{name: dir_name.to_string(), dirs: vec![], files: vec![]};
                current_dir.dirs.push(new_dir);
            } 
            else if file_pattern.is_match(entry) {
                let file_cap = file_pattern.captures_iter(entry).last().unwrap();
                let file_size : i32 = file_cap[1].parse().unwrap();
                let file_name = &file_cap[2];
                let new_file = File{name: file_name.to_string(), size:file_size};
                current_dir.files.push(new_file);
            }
            else {
                mode = Mode::CMD;
            }
        }
        if mode == Mode::CMD {
            if entry == "$ cd /" {
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
                current_dir = find_dir(&mut root, &cwd, 0);
            } else if entry == "$ ls" {
               mode = Mode::LS;
               continue;
           }
        }
    }
    root
}

fn find_dir<'a>(dir:&'a mut Dir, path:&Vec<String>, offset:usize) -> &'a mut Dir {
    if path.is_empty() || offset == path.len() {
        return dir;
    }
    for child in &dir.dirs {
        if child.name == path[offset] {
            return find_dir(&child, path, offset+1);
        }
    }
    panic!("unknown dir");
}

pub fn run_part_2(contents:&String) -> i32 {
    0
}


#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse() {
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

        dbg!(parse(&input.to_string()));
    }

    #[test]
    fn part_1() {
        assert_eq!(7, run_part_1(&"mjqjpqmgbljsphdztnvjfqwrcgsmlb\n".to_string()));
        assert_eq!(5, run_part_1(&"bvwbjplbgvbhsrlpgdmjqwftvncz\n".to_string()));
        assert_eq!(10, run_part_1(&"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".to_string()));
    }

    #[test]
    fn part_2() {
        assert_eq!(19, run_part_2(&"mjqjpqmgbljsphdztnvjfqwrcgsmlb\n".to_string()));
        assert_eq!(23, run_part_2(&"bvwbjplbgvbhsrlpgdmjqwftvncz\n".to_string()));
        assert_eq!(29, run_part_2(&"nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg".to_string()));
    }
}
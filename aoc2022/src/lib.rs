
pub fn day1(contents:String, top:usize) -> i32 {
    let mut curr = 0;
    let mut v: Vec<i32> = Vec::new();

    for line in contents.lines() {
        let trimmed = line.trim();
        if trimmed == "" {
            v.push(curr);
            curr = 0;
        } else {
            let num : i32 = trimmed.parse().expect("not a number");
            curr = curr + num;
        }
    }

    if curr > 0 {
        v.push(curr);
    }

    if v.len() < top {
        panic!("not long enough");
    }

    v.sort_by(|a,b| b.cmp(a));
    v.truncate(top);
    return v.iter().sum();
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn simple() {
        assert_eq!(6, day1("1\n2\n3\n".to_string(), 1));
        assert_eq!(6, day1("1\n2\n3\n\n".to_string(), 1));
    }

    #[test]
    fn sections() {
        assert_eq!(6, day1("1\n2\n3\n\n1\n2\n".to_string(), 1));
        assert_eq!(8, day1("1\n2\n3\n\n1\n7\n".to_string(), 1));
    }
}
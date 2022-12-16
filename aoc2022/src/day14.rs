use std::collections::HashSet;

pub fn run_part_1(contents:&String) -> i32 {
    let (mut w, bound) = populate(contents);
    let mut grains = 0;
    loop {
        let x = simulate_abyss(&w, bound);
        if let Some(new_pt) = x {
            grains += 1;
            w.insert(new_pt);
        } else {
            return grains;
        }
    }
}

pub fn run_part_2(contents:&String) -> i32 {
    let (mut w, bound) = populate(contents);
    let mut grains = 0;
    loop {
        let x = simulate_floor(&w, bound+2);
        if let Some(new_pt) = x {
            grains += 1;
            w.insert(new_pt);
        } else {
            return grains+1;
        }
    }  
}

type Pt = (usize, usize);
type World = HashSet<Pt>;

fn simulate_abyss(w:&World, bound:usize) -> Option<Pt> {
    let mut x:usize = 500;
    let mut y:usize = 0;
    loop {
        if w.contains(&(x,y+1)) {
            if !w.contains(&(x-1, y+1)) {
                x = x-1
            } else if !w.contains(&(x+1, y+1)) {
                x = x+1
            } else {
                return Some((x,y));
            }
        }
        if y <= bound {
            y = y + 1;
        } else {
            return None;
        }
    }
}

fn simulate_floor(w:&World, floor:usize) -> Option<Pt> {
    let mut x:usize = 500;
    let mut y:usize = 0;
    if w.contains(&(500,1)) && w.contains(&(499,1)) && w.contains(&(501,1)) {
        return None;
    }
    loop {
        if y+1 == floor {
            return Some((x,y));
        }
        if w.contains(&(x,y+1)) {
            if !w.contains(&(x-1, y+1)) {
                x = x-1
            } else if !w.contains(&(x+1, y+1)) {
                x = x+1
            } else {
                return Some((x,y));
            }
        }
        y = y + 1;
    }
}

fn to_pt(s:&str) -> Pt {
    let p : Vec<&str> = s.split(",").collect();
    let x = p[0].parse().unwrap();
    let y = p[1].parse().unwrap();
    (x,y)
}

fn interpolate(a:Pt, b:Pt) -> Vec<Pt> {
    let mut v = vec![a,b];
    if a.0 == b.0 {
        let (s, e) = if a.1 > b.1 { (b.1, a.1) } else { (a.1, b.1) };
        for i in s..e {
            v.push((a.0, i));
        }
    } else if a.1 == b.1 {
        let (s, e) = if a.0 > b.0 { (b.0, a.0) } else { (a.0, b.0) };
        for i in s..e {
            v.push((i, a.1));
        }
    }
    v
}

fn populate(contents:&String) -> (World, usize) {
    let mut w = World::new();
    let mut bound = 0;
    for line in contents.lines() {
        let line = line.trim();
        if line == "" {
            continue;
        }
        let ptstrs : Vec<&str> = line.split(" -> ").collect();
        for i in 0..ptstrs.len()-1 {
            let start = to_pt(ptstrs[i]);
            let end = to_pt(ptstrs[i+1]);
            if start.1 > bound {
                bound = start.1;
            }
            if end.1 > bound {
                bound = end.1;
            }
            let vals = interpolate(start, end);
            w.extend(vals.iter());
        }
    }
    (w, bound)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_1() {
        let input = "498,4 -> 498,6 -> 496,6
        503,4 -> 502,4 -> 502,9 -> 494,9";
        assert_eq!(24, run_part_1(&input.to_string()));
    }

    #[test]
    fn test_part_2() {
        let input = "498,4 -> 498,6 -> 496,6
        503,4 -> 502,4 -> 502,9 -> 494,9";
        assert_eq!(93, run_part_2(&input.to_string()));
    }
}
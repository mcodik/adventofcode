use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap};

#[derive(Copy, Clone, Eq, PartialEq)]
struct State {
    cost: usize,
    position: (usize, usize),
}

// The priority queue depends on `Ord`.
// Explicitly implement the trait so the queue becomes a min-heap
// instead of a max-heap.
impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        // Notice that the we flip the ordering on costs.
        // In case of a tie we compare positions - this step is necessary
        // to make implementations of `PartialEq` and `Ord` consistent.
        other.cost.cmp(&self.cost)
            .then_with(|| self.position.cmp(&other.position))
    }
}

// `PartialOrd` needs to be implemented as well.
impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}


pub fn run_part_1(contents:&String) -> i32 {
    let map = parse(contents);
    let pos = (20,0);
    assert!(map[pos.0][pos.1] == 'S');
    shortest_path(&map, pos).unwrap().try_into().unwrap()
}

const HEIGHTS : &str = "abcdefghijklmnopqrstuvwxyz";
fn height(map: &Vec<Vec<char>>, pos: (usize, usize)) -> usize {
    let c = map[pos.0][pos.1];
    if c == 'E' {
        return 25;
    }
    if c == 'S' {
        return 0;
    }
    HEIGHTS.find(c).unwrap()
}

fn next_positions(map: &Vec<Vec<char>>, pos: (usize, usize)) -> Vec<(usize, usize)> {
    let mut next = vec![];
    let ds :[(i32,i32);4] = [(0,1),(0,-1),(1,0),(-1,0)];
    let ipos = (pos.0 as i32, pos.1 as i32);
    let h = height(map, pos);
    for d in ds {
        let ipt = (ipos.0+d.0, ipos.1+d.1);
        let pt = (ipt.0 as usize, ipt.1 as usize);
        if ipt.0 < 0 || ipt.1 < 0 || pt.0 >= map.len() || pt.1 >= map[0].len() {
            continue;
        }
        let pt_height = height(map, pt);
        if pt_height <= h+1 {
            next.push(pt);
        }
    }
    next
}

fn shortest_path(map: &Vec<Vec<char>>, start: (usize, usize)) -> Option<usize> {
    let mut dist: HashMap<(usize,usize), usize> = HashMap::new();
    let mut heap = BinaryHeap::new();

    // We're at `start`, with a zero cost
    dist.insert(start, 0);
    heap.push(State { cost: 0, position: start });

    // Examine the frontier with lower cost nodes first (min-heap)
    while let Some(State { cost, position }) = heap.pop() {
        // Alternatively we could have continued to find all shortest paths
        let value = map[position.0][position.1];
        if value == 'E' { return Some(cost); }

        // Important as we may have already found a better way
        if cost > *dist.get(&position).unwrap_or(&usize::MAX) { continue; }

        // For each node we can reach, see if we can find a way with
        // a lower cost going through this node
        for edge in next_positions(map, position) {
            let next = State { cost: cost + 1, position: edge };
            let next_cost = dist.get(&next.position).unwrap_or(&usize::MAX);
            // If so, add it to the frontier and continue
            if next.cost < *next_cost {
                heap.push(next);
                // Relaxation, we have now found a better way
                dist.insert(next.position, next.cost);
            }
        }
    }

    // Goal not reachable
    None
}


pub fn run_part_2(contents:&String) -> i32 {
    let map = parse(contents);
    let mut min = usize::MAX;
    for (i, row) in map.iter().enumerate() {
        for (j, c) in row.iter().enumerate() {
            if *c == 'a' {
                if let Some(dist) = shortest_path(&map, (i,j)) {
                    if dist < min {
                        min = dist;
                    }
                }
            }
        }
    }
    min.try_into().unwrap()
}

fn parse(contents:&String) -> Vec<Vec<char>> {
    let mut ret = vec![];
    for line in contents.lines() {
        let line = line.trim();
        let row : Vec<char> = line.chars().collect();
        ret.push(row);
    }
    ret
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_1() {
        assert_eq!(0, run_part_1(&"1\n2\n3\n".to_string()));
    }

    #[test]
    fn test_part_2() {
        assert_eq!(0, run_part_2(&"1\n2\n3\n".to_string()));
    }
}
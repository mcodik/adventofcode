use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap};

#[derive(Clone, Eq, PartialEq)]
struct State {
    projected_flow: i32,
    path: Vec<Action>,
}

impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        self.projected_flow.cmp(&other.projected_flow)
            .then_with(|| other.path.len().cmp(&self.path.len()))
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

struct Room {
    label: &'static str,
    valve_flow:i32,
    tunnels: Vec<&'static str>
}


#[derive(Eq, PartialEq, Clone, Hash, Copy, Debug)]
enum Action {
    OPEN(&'static str), 
    MOVE(&'static str)
}

type Graph<'a> = HashMap<&'a str, Room>;

pub fn run_part_1() -> i32 {
    let rooms : [Room; 55] = [
        Room { label : "AA", valve_flow:0, tunnels  : vec!["HH", "CO", "AS", "HK", "PQ"] },
        Room { label : "AB", valve_flow:0, tunnels  : vec!["BO", "RU"] },
        Room { label : "AR", valve_flow:0, tunnels  : vec!["IF", "FI"] },
        Room { label : "AS", valve_flow:0, tunnels  : vec!["AA", "AZ"] },
        Room { label : "AZ", valve_flow:12, tunnels  : vec!["QF", "PI", "AS", "PE"] },
        Room { label : "BA", valve_flow:0, tunnels  : vec!["RF", "GU"] },
        Room { label : "BL", valve_flow:0, tunnels  : vec!["BT", "RQ"] },
        Room { label : "BO", valve_flow:0, tunnels  : vec!["ME", "AB"] },
        Room { label : "BT", valve_flow:24, tunnels  : vec!["KB", "BL", "GA"] },
        Room { label : "CN", valve_flow:0, tunnels  : vec!["WQ", "XD"] },
        Room { label : "CO", valve_flow:0, tunnels  : vec!["AA", "FI"] },
        Room { label : "CQ", valve_flow:9, tunnels  : vec!["UU", "DR", "SS"] },
        Room { label : "DI", valve_flow:0, tunnels  : vec!["XA", "FI"] },
        Room { label : "DJ", valve_flow:0, tunnels  : vec!["RQ", "NT"] },
        Room { label : "DR", valve_flow:0, tunnels  : vec!["GA", "CQ"] },
        Room { label : "FI", valve_flow:11, tunnels  : vec!["PI", "MR", "AR", "CO", "DI"] },
        Room { label : "FS", valve_flow:0, tunnels  : vec!["HH", "MH"] },
        Room { label : "GA", valve_flow:0, tunnels  : vec!["DR","BT"] },
        Room { label : "GC", valve_flow:0, tunnels  : vec!["TD", "MR"] },
        Room { label : "GU", valve_flow:21, tunnels  : vec!["VJ", "BA", "YP"] },
        Room { label : "HH", valve_flow:0, tunnels  : vec!["AA", "FS"] },
        Room { label : "HK", valve_flow:0, tunnels  : vec!["AA", "IF"] },
        Room { label : "IE", valve_flow:22, tunnels  : vec!["YP", "UM", "XI", "XA"] },
        Room { label : "IF", valve_flow:7, tunnels  : vec!["AR", "JL", "HK", "PE", "XI"] },
        Room { label : "JL", valve_flow:0, tunnels  : vec!["IF", "WB"] },
        Room { label : "KB", valve_flow:0, tunnels  : vec!["BT", "NW"] },
        Room { label : "ME", valve_flow:18, tunnels  : vec!["OQ", "BO", "PH"] },
        Room { label : "MH", valve_flow:8, tunnels  : vec!["FS", "NW", "SS", "SY"] },
        Room { label : "MR", valve_flow:0, tunnels  : vec!["GC", "FI"] },
        Room { label : "MU", valve_flow:15, tunnels  : vec!["SY", "UU", "NA"] },
        Room { label : "NA", valve_flow:0, tunnels  : vec!["MU", "PH"] },
        Room { label : "NT", valve_flow:0, tunnels  : vec!["DJ", "UN"] },
        Room { label : "NW", valve_flow:0, tunnels  : vec!["KB", "MH"] },
        Room { label : "OQ", valve_flow:0, tunnels  : vec!["ME", "TD"] },
        Room { label : "PE", valve_flow:0, tunnels  : vec!["AZ", "IF"] },
        Room { label : "PH", valve_flow:0, tunnels  : vec!["ME", "NA"] },
        Room { label : "PI", valve_flow:0, tunnels  : vec!["FI", "AZ"] },
        Room { label : "PQ", valve_flow:0, tunnels  : vec!["TD", "AA"] },
        Room { label : "QF", valve_flow:0, tunnels  : vec!["TD", "AZ"] },
        Room { label : "RF", valve_flow:0, tunnels  : vec!["UN", "BA"] },
        Room { label : "RQ", valve_flow:13, tunnels  : vec!["BL", "DJ"] },
        Room { label : "RU", valve_flow:19, tunnels : vec!["AB"] },
        Room { label : "SS", valve_flow:0, tunnels  : vec!["CQ", "MH"] },
        Room { label : "SY", valve_flow:0, tunnels  : vec!["MH", "MU"] },
        Room { label : "TD", valve_flow:16, tunnels  : vec!["QF", "GC", "OQ", "WB", "PQ"] },
        Room { label : "UM", valve_flow:0, tunnels  : vec!["IE", "WQ"] },
        Room { label : "UN", valve_flow:20, tunnels  : vec!["NT", "XD", "RF"] },
        Room { label : "UU", valve_flow:0, tunnels  : vec!["CQ", "MU"] },
        Room { label : "VJ", valve_flow:0, tunnels  : vec!["WQ", "GU"] },
        Room { label : "WB", valve_flow:0, tunnels  : vec!["TD", "JL"] },
        Room { label : "WQ", valve_flow:23, tunnels  : vec!["VJ", "UM", "CN"] },
        Room { label : "XA", valve_flow:0, tunnels  : vec!["IE", "DI"] },
        Room { label : "XD", valve_flow:0, tunnels  : vec!["UN", "CN"] },
        Room { label : "XI", valve_flow:0, tunnels  : vec!["IE", "IF"] },
        Room { label : "YP", valve_flow:0, tunnels  : vec!["IE", "GU"] },
    ];

    let mut rs = HashMap::new();
    for r in rooms {
        rs.insert(r.label, r);
    }
    solve_part_1(&rs)
}

fn solve_part_1(graph:&Graph) -> i32 {
    if let Some(path) = shortest_path(graph) {
        dbg!(&path);
        return compute_flow(&path, graph);
    }
    panic!("no solution");
}

fn shortest_path(graph:&Graph) -> Option<Vec<Action>> {
    let mut dist: HashMap<&str, i32> = HashMap::new();
    let mut heap = BinaryHeap::new();

    dist.insert("AA", 0);
    heap.push(State { projected_flow: 0, path: vec![] });

    while let Some(State { path, projected_flow }) = heap.pop() {
        dbg!((path.len(), projected_flow));
        if path.len() == 30 {
            return Some(path);
        }

        for edge in next_positions(graph, &path) {
            let mut extended : Vec<Action> = path.iter().copied().collect();
            extended.push(edge);
            let projected = compute_flow(&extended, graph);
            if let Action::MOVE(current) = edge {
                let best_seen_flow = dist.get(current).unwrap_or(&0);
                if projected >= *best_seen_flow {
                    let next = State { projected_flow: projected, path: extended };
                    heap.push(next);
                    dist.insert(current, projected);        
                }
            } else {
                let next = State { projected_flow: projected, path: extended };
                heap.push(next);
            }
        }
    }

    None
}

fn compute_flow(path:&Vec<Action>, graph:&Graph) -> i32 {
    let mut current_flow = 0;
    let mut total_flow = 0;
    let size = path.len() as i32;
    for a in path  {
        total_flow += current_flow;
        if let Action::OPEN(v) = a {
            let node = graph.get(v).unwrap();
            current_flow += node.valve_flow;
        }
    }

    let remaining = 30 - size;
    total_flow + (current_flow * remaining)    
}

fn current_room(path:&Vec<Action>) -> &'static str {
    if path.is_empty() { 
        "AA" 
    } else {
        let i = path.len()-1;
        if let Action::MOVE(s) = path[i] {
            return s;
        } else {
            if i == 0 {
                return "AA";
            } else {
                if let Action::MOVE(s) = path[i-1] {
                    return s;
                } else {
                    panic!("two opens");
                }
            }
        }
    }
}

fn is_opened(l:&str, path:&Vec<Action>) -> bool {
    for a in path {
        if let Action::OPEN(x) = a {
            if *x == l {
                return true;
            }
        }
    }
    false
}

fn next_positions(graph:&Graph, path:&Vec<Action>) -> Vec<Action> {
    let mut result = vec![];
    if path.len() == 30 {
        return result;
    }
    let current = current_room(path);
    let node = graph.get(current).unwrap();
    for n in &node.tunnels {
        result.push(Action::MOVE(n));
    }
    if node.valve_flow > 0 && !is_opened(current, path) {
        result.push(Action::OPEN(current));
    }
    result
}


pub fn run_part_2() -> i32 {
    0  
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_part_1() {
        let rooms = [
            Room { label : "AA", valve_flow:0, tunnels: vec!["DD", "II", "BB"] },
            Room { label : "BB", valve_flow:13, tunnels: vec!["CC", "AA"] },
            Room { label : "CC", valve_flow:2, tunnels: vec!["DD", "BB"] },
            Room { label : "DD", valve_flow:20, tunnels: vec!["CC", "AA", "EE"] },
            Room { label : "EE", valve_flow:3, tunnels: vec!["FF", "DD"] },
            Room { label : "FF", valve_flow:0, tunnels: vec!["EE", "GG"] },
            Room { label : "GG", valve_flow:0, tunnels: vec!["FF", "HH"] },
            Room { label : "HH", valve_flow:22, tunnels: vec!["GG"] },
            Room { label : "II", valve_flow:0, tunnels: vec!["AA", "JJ"] },
            Room { label : "JJ", valve_flow:21, tunnels: vec!["II"] },
        ];
        let mut rs = HashMap::new();
        for r in rooms {
            rs.insert(r.label, r);
        }
        assert_eq!(1651, solve_part_1(&rs));
    }

    #[test]
    fn test_part_2() {
        // assert_eq!(0, run_part_2(&"1\n2\n3\n".to_string()));
    }
}
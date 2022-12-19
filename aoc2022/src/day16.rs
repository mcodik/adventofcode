use std::collections::HashMap;

struct Room {
    label: &'static str,
    valve_flow:i32,
    tunnels: Vec<&'static str>
}


enum Action {
    OPEN, 
    MOVE(&'static str)
}

pub fn run_part_1() -> i32 {
    
let rooms : [Room; 55] = [
    Room { label : "NA", valve_flow:0, tunnels  : vec!["MU", "PH"] },
    Room { label : "NW", valve_flow:0, tunnels  : vec!["KB", "MH"] },
    Room { label : "MR", valve_flow:0, tunnels  : vec!["GC", "FI"] },
    Room { label : "XD", valve_flow:0, tunnels  : vec!["UN", "CN"] },
    Room { label : "HK", valve_flow:0, tunnels  : vec!["AA", "IF"] },
    Room { label : "JL", valve_flow:0, tunnels  : vec!["IF", "WB"] },
    Room { label : "RQ", valve_flow:13, tunnels  : vec!["BL", "DJ"] },
    Room { label : "AB", valve_flow:0, tunnels  : vec!["BO", "RU"] },
    Room { label : "PE", valve_flow:0, tunnels  : vec!["AZ", "IF"] },
    Room { label : "QF", valve_flow:0, tunnels  : vec!["TD", "AZ"] },
    Room { label : "BA", valve_flow:0, tunnels  : vec!["RF", "GU"] },
    Room { label : "SY", valve_flow:0, tunnels  : vec!["MH", "MU"] },
    Room { label : "NT", valve_flow:0, tunnels  : vec!["DJ", "UN"] },
    Room { label : "GU", valve_flow:21, tunnels  : vec!["VJ", "BA", "YP"] },
    Room { label : "AZ", valve_flow:12, tunnels  : vec!["QF", "PI", "AS", "PE"] },
    Room { label : "WQ", valve_flow:23, tunnels  : vec!["VJ", "UM", "CN"] },
    Room { label : "DR", valve_flow:0, tunnels  : vec!["GA", "CQ"] },
    Room { label : "UM", valve_flow:0, tunnels  : vec!["IE", "WQ"] },
    Room { label : "XI", valve_flow:0, tunnels  : vec!["IE", "IF"] },
    Room { label : "SS", valve_flow:0, tunnels  : vec!["CQ", "MH"] },
    Room { label : "IE", valve_flow:22, tunnels  : vec!["YP", "UM", "XI", "XA"] },
    Room { label : "BT", valve_flow:24, tunnels  : vec!["KB", "BL", "GA"] },
    Room { label : "GA", valve_flow:0, tunnels  : vec!["DR","BT"] },
    Room { label : "AR", valve_flow:0, tunnels  : vec!["IF", "FI"] },
    Room { label : "DJ", valve_flow:0, tunnels  : vec!["RQ", "NT"] },
    Room { label : "PI", valve_flow:0, tunnels  : vec!["FI", "AZ"] },
    Room { label : "WB", valve_flow:0, tunnels  : vec!["TD", "JL"] },
    Room { label : "OQ", valve_flow:0, tunnels  : vec!["ME", "TD"] },
    Room { label : "RU", valve_flow:19, tunnels : vec!["AB"] },
    Room { label : "IF", valve_flow:7, tunnels  : vec!["AR", "JL", "HK", "PE", "XI"] },
    Room { label : "BO", valve_flow:0, tunnels  : vec!["ME", "AB"] },
    Room { label : "CN", valve_flow:0, tunnels  : vec!["WQ", "XD"] },
    Room { label : "HH", valve_flow:0, tunnels  : vec!["AA", "FS"] },
    Room { label : "AS", valve_flow:0, tunnels  : vec!["AA", "AZ"] },
    Room { label : "FS", valve_flow:0, tunnels  : vec!["HH", "MH"] },
    Room { label : "PQ", valve_flow:0, tunnels  : vec!["TD", "AA"] },
    Room { label : "AA", valve_flow:0, tunnels  : vec!["HH", "CO", "AS", "HK", "PQ"] },
    Room { label : "ME", valve_flow:18, tunnels  : vec!["OQ", "BO", "PH"] },
    Room { label : "RF", valve_flow:0, tunnels  : vec!["UN", "BA"] },
    Room { label : "MH", valve_flow:8, tunnels  : vec!["FS", "NW", "SS", "SY"] },
    Room { label : "YP", valve_flow:0, tunnels  : vec!["IE", "GU"] },
    Room { label : "FI", valve_flow:11, tunnels  : vec!["PI", "MR", "AR", "CO", "DI"] },
    Room { label : "UU", valve_flow:0, tunnels  : vec!["CQ", "MU"] },
    Room { label : "CO", valve_flow:0, tunnels  : vec!["AA", "FI"] },
    Room { label : "TD", valve_flow:16, tunnels  : vec!["QF", "GC", "OQ", "WB", "PQ"] },
    Room { label : "MU", valve_flow:15, tunnels  : vec!["SY", "UU", "NA"] },
    Room { label : "BL", valve_flow:0, tunnels  : vec!["BT", "RQ"] },
    Room { label : "PH", valve_flow:0, tunnels  : vec!["ME", "NA"] },
    Room { label : "XA", valve_flow:0, tunnels  : vec!["IE", "DI"] },
    Room { label : "GC", valve_flow:0, tunnels  : vec!["TD", "MR"] },
    Room { label : "KB", valve_flow:0, tunnels  : vec!["BT", "NW"] },
    Room { label : "DI", valve_flow:0, tunnels  : vec!["XA", "FI"] },
    Room { label : "CQ", valve_flow:9, tunnels  : vec!["UU", "DR", "SS"] },
    Room { label : "VJ", valve_flow:0, tunnels  : vec!["WQ", "GU"] },
    Room { label : "UN", valve_flow:20, tunnels  : vec!["NT", "XD", "RF"] },
];

    let mut rs = HashMap::new();
    for r in rooms {
        rs.insert(r.label, r);
    }
    solve_part_1(rs)
}

fn solve_part_1(graph:HashMap<&str, Room>) -> i32 {
    

0
}

pub fn run_part_2() -> i32 {
    0  
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
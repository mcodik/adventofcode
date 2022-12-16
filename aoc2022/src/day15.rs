const INPUT :[((i32,i32),(i32,i32));31]= 
[((1518415, 2163633), (1111304, 1535696)),
((2474609, 3598166), (2691247, 4007257)),
((426959, 473371), (-529106, 1145419)),
((3999598, 1984775), (3975468, 2000000)),
((2459256, 2951561), (2132806, 2866452)),
((2925882, 2862933), (3325001, 3024589)),
((3539174, 3882566), (3132375, 3541509)),
((3044887, 3798155), (3132375, 3541509)),
((1792818, 3506985), (2132806, 2866452)),
((3761945, 3304667), (3325001, 3024589)),
((71968, 3823892), (-1085197, 3401157)),
((2902345, 3999748), (2691247, 4007257)),
((2074989, 2347435), (2132806, 2866452)),
((1115220, 1782338), (1111304, 1535696)),
((369130, 2348958), (1111304, 1535696)),
((2525090, 1917940), (2603675, 2276026)),
((2861163, 3386968), (3132375, 3541509)),
((3995081, 2010596), (3975468, 2000000)),
((3038274, 534921), (4354209, -17303)),
((3646366, 2868267), (3325001, 3024589)),
((3308360, 1653497), (3975468, 2000000)),
((1996072, 995783), (1111304, 1535696)),
((3852158, 950900), (3975468, 2000000)),
((3061849, 2428914), (2603675, 2276026)),
((2788254, 3983003), (2691247, 4007257)),
((694411, 1882565), (1111304, 1535696)),
((2647250, 2551966), (2603675, 2276026)),
((1079431, 3166226), (2132806, 2866452)),
((3929172, 2196495), (3975468, 2000000)),
((3883296, 2487406), (3975468, 2000000)),
((1271911, 1529880), (1111304, 1535696))];


pub fn run_part_1() -> i32 {
 solve_part_1(&INPUT, 2000000)
}

fn solve_part_1(input:&[((i32,i32),(i32,i32))], row:i32) -> i32 {
    let mut ranges = vec![];
    for (sensor, beacon) in input {
        let x_dist = (beacon.0 - sensor.0).abs();
        let y_dist = (beacon.1 - sensor.1).abs();
        let radius = x_dist + y_dist;
        if radius == 0 {
            continue;
        }
        if sensor.1 + radius >= row && sensor.1 - radius <= row {
            let row_dy = (row - sensor.1).abs();
            let row_radius = (radius - row_dy).abs();
            let beacon_start_offset = if row == beacon.1 && beacon.0 > sensor.0 { 1 } else { 0 };
            let beacon_end_offset = if row == beacon.1 && beacon.0 < sensor.0 { -1 } else { 0 };
            ranges.push((sensor.0 - row_radius + beacon_start_offset, sensor.0 + row_radius + beacon_end_offset));
        }
    }
    if ranges.len() == 0 {
        return 0;
    }

    ranges.sort_by_key(|x| x.0);
    let coalesed = coalesce(ranges);
    let mut sum = 0;
    for range in coalesed {
        sum += range.1 - range.0 + 1;
    }
    sum
}

fn coalesce(ranges:Vec<(i32,i32)>) -> Vec<(i32,i32)> {
    let mut coalesced = vec![];
    let mut current_start = ranges[0].0;
    let mut current_end = ranges[0].1;
    for i in 1..ranges.len() {
        if current_end < ranges[i].0 {
            coalesced.push((current_start, current_end));
            current_start = ranges[i].0;
            current_end = ranges[i].1;
        } else if ranges[i].0 < current_end  {
            current_end = std::cmp::max(current_end, ranges[i].1);
        } else if current_end < ranges[i].1 {
            current_end = ranges[i].1;
        }
    }
    coalesced.push((current_start, current_end));
    coalesced
}

pub fn run_part_2() -> i32 {
    0  
}

#[cfg(test)]
mod tests {
    use super::*;

    const TEST : [((i32,i32),(i32,i32));14] = [((2, 18), (-2, 15)),
((9, 16), (10, 16)),
((13, 2), (15, 3)),
((12, 14), (10, 16)),
((10, 20), (10, 16)),
((14, 17), (10, 16)),
((8, 7), (2, 10)),
((2, 0), (2, 10)),
((0, 11), (2, 10)),
((20, 14), (25, 17)),
((17, 20), (21, 22)),
((16, 7), (15, 3)),
((14, 3), (15, 3)),
((20, 1), (15, 3))];

    #[test]
    fn test_part_1() {
        assert_eq!(26, solve_part_1(&TEST, 10));
    }

    #[test]
    fn test_part_1_trivial() {
        let test = [((2, 18), (-2, 15))];
        assert_eq!(0, solve_part_1(&test, 10));
        assert_eq!(1, solve_part_1(&test, 11));
        assert_eq!(3, solve_part_1(&test, 12));
        assert_eq!(5, solve_part_1(&test, 13));
        assert_eq!(7, solve_part_1(&test, 14));
        assert_eq!(9, solve_part_1(&test, 15));
        assert_eq!(11, solve_part_1(&test, 16));
        assert_eq!(13, solve_part_1(&test, 17));
        assert_eq!(15, solve_part_1(&test, 18));
        assert_eq!(13, solve_part_1(&test, 19));
        assert_eq!(11, solve_part_1(&test, 20));
        assert_eq!(9, solve_part_1(&test, 21));
        assert_eq!(7, solve_part_1(&test, 22));
        assert_eq!(5, solve_part_1(&test, 23));
        assert_eq!(3, solve_part_1(&test, 24));
        assert_eq!(1, solve_part_1(&test, 25));
        assert_eq!(0, solve_part_1(&test, 26));
    }

    #[test]
    fn test_part_1_two_with_overlap() {
        let test = [((2, 18), (-2, 15)), ((5, 24), (6, 22))];
        assert_eq!(0, solve_part_1(&test, 10));
        assert_eq!(1, solve_part_1(&test, 11));
        assert_eq!(3, solve_part_1(&test, 12));
        assert_eq!(5, solve_part_1(&test, 13));
        assert_eq!(7, solve_part_1(&test, 14));
        assert_eq!(9, solve_part_1(&test, 15));
        assert_eq!(11, solve_part_1(&test, 16));
        assert_eq!(13, solve_part_1(&test, 17));
        assert_eq!(15, solve_part_1(&test, 18));
        assert_eq!(13, solve_part_1(&test, 19));
        assert_eq!(11, solve_part_1(&test, 20));
        assert_eq!(9, solve_part_1(&test, 21));
        assert_eq!(8, solve_part_1(&test, 22));
        assert_eq!(8, solve_part_1(&test, 23));
        assert_eq!(8, solve_part_1(&test, 24));
        assert_eq!(6, solve_part_1(&test, 25));
        assert_eq!(3, solve_part_1(&test, 26));
        assert_eq!(1, solve_part_1(&test, 27));
        assert_eq!(0, solve_part_1(&test, 28));
    }

    #[test]
    fn test_part_1_two_adjacent() {
        let test = [((2, 18), (-2, 15)), ((5, 24), (6, 24))];
        assert_eq!(0, solve_part_1(&test, 10));
        assert_eq!(1, solve_part_1(&test, 11));
        assert_eq!(3, solve_part_1(&test, 12));
        assert_eq!(5, solve_part_1(&test, 13));
        assert_eq!(7, solve_part_1(&test, 14));
        assert_eq!(9, solve_part_1(&test, 15));
        assert_eq!(11, solve_part_1(&test, 16));
        assert_eq!(13, solve_part_1(&test, 17));
        assert_eq!(15, solve_part_1(&test, 18));
        assert_eq!(13, solve_part_1(&test, 19));
        assert_eq!(11, solve_part_1(&test, 20));
        assert_eq!(9, solve_part_1(&test, 21));
        assert_eq!(7, solve_part_1(&test, 22));
        assert_eq!(6, solve_part_1(&test, 23));
        assert_eq!(6, solve_part_1(&test, 24));
        assert_eq!(2, solve_part_1(&test, 25));
        assert_eq!(0, solve_part_1(&test, 26));
        assert_eq!(0, solve_part_1(&test, 27));
        assert_eq!(0, solve_part_1(&test, 28));
    }

    #[test]
    fn test_part_1_same_pt() {
        let test = [((2, 18), (2, 18))];
        assert_eq!(0, solve_part_1(&test, 17));
        assert_eq!(1, solve_part_1(&test, 18));
        assert_eq!(0, solve_part_1(&test, 19));
    }

    #[test]
    fn test_part_1_non_overlap() {
        let test = [((2, 18), (-2, 15))];
        assert_eq!(0, solve_part_1(&test, 1000));
    }

    #[test]
    fn test_part_2() {
        assert_eq!(0, run_part_2());
    }

    #[test]
    fn test_coalesce_disjoint() {
        let v = vec![(0,1), (2, 3), (4, 5)];
        assert_eq!(v, coalesce(vec![(0,1), (2, 3), (4, 5)]));
    }

    #[test]
    fn test_coalesce_expand() {
        let v = vec![(0,3), (4, 5)];
        assert_eq!(v, coalesce(vec![(0,2), (2, 3), (4, 5)]));
        let v = vec![(-1, 6)];
        assert_eq!(v, coalesce(vec![(-1, 5), (4, 6)]));
    }

    #[test]
    fn test_coalesce_contain() {
        let v = vec![(0,3)];
        assert_eq!(v, coalesce(vec![(0,3), (1, 2)]));
    }
}
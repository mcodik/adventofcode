import memoize from "npm:memoize";

export const SAMPLE = `
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
`

export const mem_solve = memoize(solve);

export function solve(pattern:string[], arrangement:number[]):number {
  const a = [...arrangement];
  for (let i = 0; i < pattern.length; i++) {
    console.log('loop', i, pattern.slice(i).join(''), a.join(','));
    if (pattern[i] == '.') {
      if (a[0] == 0) {
        a.shift();
      }
    } else if (pattern[i] == '#') {
      if (a[0] == 0) {
        return 0;
      }
      const sub = pattern.slice(i, i+a[0]+1);
      if (sub.length != (a[0]+1)) {
        return 0;
      }

      const last_sub = sub[sub.length-1];
      if (last_sub == '#') {
        return 0;
      }

      const dot = sub.indexOf('.');
      if (dot >= 0 && dot != sub.length-1) {
        return 0;
      }

      a.shift();
      return mem_solve(pattern.slice(i+a[0]+1), a);
    } else if (pattern[i] == '?') {
      const remaining_pattern = pattern.slice(i+1);
      let if_match = 0;
      const log = pattern.length == 12;
      if (a.length > 0 && a[0] > 0) {
        const match_pattern = ['#', ...remaining_pattern];        
        if_match = mem_solve(match_pattern, a);
        if (log) {
          console.log('# solve', remaining_pattern.join(''), a.join(','), if_match);
        }
      }
      const no_match_pattern = ['.', ...remaining_pattern]; 
      const no_match = mem_solve(no_match_pattern, a);
      if (log) {
        console.log('. solve', no_match_pattern.join(''), a.join(','), no_match);
      }
      return if_match + no_match;  
    }
  }

  if (a.length == 0 || (a.length == 1 && a[0] == 0)) {
    console.log('match', pattern.join(''), arrangement.join(','));
    return 1;
  }
  console.log('no', pattern.join(''), arrangement.join(','));
  return 0;
}

export function solve_str(line:string):number {
  const [pattern, arrangement_s] = line.split(' ');
  const arrangement = arrangement_s.split(',').map((i) => parseInt(i)); 
  return solve(pattern.split(''), arrangement);
}

export function part_1(lines:string[]): number {
  let sum = 0;
  lines.forEach((l) => {
    sum += solve_str(l);
  })
  return sum;
}

export function part_2(lines:string[]): number {
  return 0;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day12.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1([...lines]));
  console.log("part 2: ", part_2([...lines]));
}

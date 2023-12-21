import memoize from "npm:memoize";

export const SAMPLE = `
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
`

export const mem_solve = memoize(solve, {
  cacheKey: a => a[0].join('') + a[1].join(',')
});

function log_solve(pattern:string[], a:number[]):number {
  const ret = solve(pattern, a);
  console.log(`solve '${pattern.join('')}' '${a.join(',')}' = ${ret}`);
  return ret;
}

export function solve(pattern:string[], a:number[]):number {
  if (a.length == 0) {
    return pattern.indexOf('#') < 0 ? 1 : 0;
  }


  if (pattern.length == 0) {
    return 0;
  }


  if (pattern.length < a[0]) {
    return 0;
  }

  const p = pattern[0];
  if (p == '.') {
    for (let i = 1; i < pattern.length; i++) {
      if (pattern[i] != '.') {
        const next_pattern = pattern.slice(i, pattern.length);
        return mem_solve(next_pattern, a);
      }
    }
    return 0;
  } else if (p == '#') {
    if (a.length == 0) {
      return 0;
    }

    const sub = pattern.slice(0, a[0]);
    // console.log('consume', pattern.join(''), a[0], '->', sub.join(''));
    if (sub.length < a[0]) {
      return 0;
    }

    const dot = sub.indexOf('.');
    if (dot >= 0) {
      return 0;
    }

    if (pattern.length > a[0]) {
      const n = pattern[a[0]];
      if (n == '#') {
        return 0;
      }
    }

    if (pattern.length == a[0] && a.length == 1) {
      return 1;
    }

    const next_a = a.slice(1);
    const next_pattern = pattern.slice(a[0]+1);
    // console.log("->", next_pattern.join(''), next_a.join(','));
    return mem_solve(next_pattern, next_a);
  } else { // p == ?
    const remaining_pattern = pattern.slice(1);
    const match_pattern = ['#', ...remaining_pattern];        
    const if_match = mem_solve(match_pattern, a);
    
    const no_match_pattern = ['.', ...remaining_pattern]; 
    const no_match = mem_solve(no_match_pattern, a);
    return if_match + no_match;  
  }
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
  let sum = 0;
  lines.forEach((l) => {
    const [pattern, arrangement_s] = l.split(' ');
    const expanded_pattern = [pattern, pattern, pattern, pattern, pattern].join('?');
    const expanded_arrangement = [arrangement_s,arrangement_s,arrangement_s,arrangement_s,arrangement_s].join(',');
    const arrangement = expanded_arrangement.split(',').map((i) => parseInt(i)); 
    sum += solve(expanded_pattern.split(''), arrangement);
  })
  return sum;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day12.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1([...lines]));
  console.log("part 2: ", part_2([...lines]));
}

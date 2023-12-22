type Result = {
  left: number,
  top: number,
};

export function rotate(pattern:string[]):string[] {
  const rotated = [];
  for (let j = 0; j < pattern[0].length; j++) {
    const row = [];
    for (let i = 0; i < pattern.length; i++) {
      row.push(pattern[i][j]);
    }
    rotated.push(row.join(''));
  }
  return rotated;
}

export function solve_left(pattern:string[], allow_smudge:boolean):number {
  const rotated = rotate(pattern);
  return solve_top(rotated, allow_smudge);
}

export function is_top_sym(pattern:string[],sym:number, allow_smudge:boolean):boolean {
  let width = 1;
  let errors = 0;
  while (true) {
    const top_i = sym - width + 1;
    const bottom_i = sym + width;
    if (top_i < 0 || bottom_i >= pattern.length) {
      if (!allow_smudge) {
        return true;
      }
      return errors == 1;
    }
    // console.log(`comparing ${top_i} vs ${bottom_i}`);
    for (let j = 0; j < pattern[top_i].length; j++) {
      if (pattern[top_i][j] != pattern[bottom_i][j]) {
        if (!allow_smudge) {
          return false;
        }
        errors++;
      }
    }
    width++;
  }
}

export function solve_top(pattern:string[], allow_smudge:boolean):number {
  for (let i = 0; i < pattern.length-1; i++) {
    if (is_top_sym(pattern, i, allow_smudge)) {
      return i+1;
    }
  }
  return -1;
}

export function solve(pattern:string[], allow_smudge = false):Result {
  const left = solve_left(pattern, allow_smudge);
  if (left < 0) {
    const top = solve_top(pattern,allow_smudge);
    if (top < 0) {
      console.log("nonsym");
      console.log(pattern.join('\n'));
      return {left:0,top:0};
    }
    // console.log("top", top);
    return {left:0, top};
  }
  // console.log("left", left);

  return {left, top:0};
}

export function part_1(lines:string[]): number {
  let sum = 0;
  let pattern = [];
  for (const line of lines) {
    if (line == "") {
      const {left,top} = solve(pattern);
      sum += left + (100*top);
      pattern = [];
    } else {
      pattern.push(line);
    }
  }
  const {left,top} = solve(pattern);
  sum += left + (100*top);    
  return sum;
}

export function part_2(lines:string[]): number {
  let sum = 0;
  let pattern = [];
  for (const line of lines) {
    if (line == "") {
      const {left,top} = solve(pattern, true);
      sum += left + (100*top);
      pattern = [];
    } else {
      pattern.push(line);
    }
  }
  const {left,top} = solve(pattern, true);
  sum += left + (100*top);    
  return sum;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day13.txt");
  const lines = text.split("\n").map((l) => l.trim());
  console.log("part 1: ", part_1([...lines]));
  console.log("part 2: ", part_2([...lines]));
}

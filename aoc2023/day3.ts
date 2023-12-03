function look_for_sym(lines:string[], i:number, j:number, check_sym:(x:string) => boolean):number[] {
  const offsets = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,1],[1,-1,],[1,0],[1,1]];
  for (const [di,dj] of offsets) {
    if (i+di >= 0 && i+di < lines.length && j+dj >= 0 && j+dj < lines[i+di].length) {
      const char = lines[i+di][j+dj];
      if (char != "." && "0123456789".indexOf(char) < 0) {
        const ok = check_sym(char);
        if (ok) {
          return [i+di,j+dj];
        }
      }
    }
  }
  return [];
}

export function look_for_any_sym(lines:string[], i:number, j:number):boolean {
  return look_for_sym(lines, i, j, (_) => true).length > 0;
}


export function look_for_star(lines:string[], i:number, j:number):string {
  return look_for_sym(lines, i, j, (c) => c == "*").join(',');
}

export function part_1(lines:string[]): number {
  let sum = 0;
  for (let i = 0; i < lines.length; i++) {
    let current_num = [];
    let found_sym = false;
    for (let j = 0; j < lines[i].length; j++) {
      const char = lines[i][j];
      if ("0123456789".indexOf(char) >= 0) {
        current_num.push(lines[i][j]);
        if (!found_sym) {
          found_sym = look_for_any_sym(lines, i, j);
        }
        // console.log(i, j, current_num.join(''), found_sym);
      } 
      else {
        if (current_num.length > 0 && found_sym) {
          sum += parseInt(current_num.join(''));
        }
        current_num = [];
        found_sym = false;
      } 
    }
    if (current_num.length > 0 && found_sym) {
      sum += parseInt(current_num.join(''));
    }
  }
  return sum;
}

export function part_2(lines:string[]):number {
  const star_adj = new Map();
  for (let i = 0; i < lines.length; i++) {
    let current_num = [];
    let star_coord = "";
    for (let j = 0; j < lines[i].length; j++) {
      const char = lines[i][j];
      if ("0123456789".indexOf(char) >= 0) {
        current_num.push(lines[i][j]);
        if (star_coord.length == 0) {
          star_coord = look_for_star(lines, i, j);
        }
      } 
      else {
        if (current_num.length > 0 && star_coord.length > 0) {
          const num = parseInt(current_num.join(''));
          if (!star_adj.has(star_coord)) {
            star_adj.set(star_coord, [num]);
          } else {
            const c = star_adj.get(star_coord);
            c.push(num);
            star_adj.set(star_coord, c);
          }
          // console.log(i, j, current_num.join(''), star_coord, star_adj.get(star_coord));
        }
        current_num = [];
        star_coord = "";
      } 
    }
    if (current_num.length > 0 && star_coord.length > 0) {
      const num = parseInt(current_num.join(''));
      if (!star_adj.has(star_coord)) {
        star_adj.set(star_coord, [num]);
      } else {
        const c = star_adj.get(star_coord);
        c.push(num);
        star_adj.set(star_coord, c);
      }
    }
  }
  let sum = 0;
  // console.log(star_adj);
  for (const nums of star_adj.values()) {
    if (nums.length == 2) {
      sum += nums[0] * nums[1];
    }
  }
  return sum;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day3.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1(lines));
  console.log("part 2: ", part_2(lines));
}

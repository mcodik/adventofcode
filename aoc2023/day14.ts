type SearchFn = (i:number, j:number, lines:string[][]) => {new_i:number,new_j:number};

export function search_north(i:number, j:number, lines:string[][]):{new_i:number,new_j:number} {
  for (let new_i = i-1; new_i >= 0; new_i--) {
    if (lines[new_i][j] != '.') {
      return {new_i:new_i+1, new_j:j};
    }
  }
  return {new_i:0,new_j:j};
}

export function search_south(i:number, j:number, lines:string[][]):{new_i:number,new_j:number} {
  for (let new_i = i+1; new_i < lines.length; new_i++) {
    if (lines[new_i][j] != '.') {
      return {new_i:new_i-1, new_j:j};
    }
  }
  return {new_i:lines.length-1,new_j:j};
}

export function search_west(i:number, j:number, lines:string[][]):{new_i:number,new_j:number} {
  for (let new_j = j-1; new_j >= 0; new_j--) {
    if (lines[i][new_j] != '.') {
      return {new_i:i, new_j:new_j+1};
    }
  }
  return {new_i:i,new_j:0};
}
export function search_east(i:number, j:number, lines:string[][]):{new_i:number,new_j:number} {
  for (let new_j = j+1; new_j < lines[i].length; new_j++) {
    if (lines[i][new_j] != '.') {
      return {new_i:i, new_j:new_j-1};
    }
  }
  return {new_i:i,new_j:lines[i].length-1};
}


export function tilt_north(lines:string[][]) {
  for (let i = 0; i < lines.length; i++) {
    for (let j = 0; j < lines[i].length; j++) {
      if (lines[i][j] == 'O') {
        const {new_i,new_j} = search_north(i,j,lines);
        lines[i][j] = '.';
        lines[new_i][new_j] = 'O';
      }
    }
  }
}


export function tilt_east(lines:string[][]) {
  for (let i = 0; i < lines.length; i++) {
    for (let j = lines[i].length-1; j >= 0; j--) {
      if (lines[i][j] == 'O') {
        const {new_i,new_j} = search_east(i,j,lines);
        lines[i][j] = '.';
        lines[new_i][new_j] = 'O';
      }
    }
  }
}


export function tilt_south(lines:string[][]) {
  for (let i = lines.length-1; i >= 0; i--) {
    for (let j = 0; j < lines[i].length; j++) {
      if (lines[i][j] == 'O') {
        const {new_i,new_j} = search_south(i,j,lines);
        lines[i][j] = '.';
        lines[new_i][new_j] = 'O';
      }
    }
  }
}


export function tilt_west(lines:string[][]) {
  for (let i = 0; i < lines.length; i++) {
    for (let j = 0; j < lines[i].length; j++) {
      if (lines[i][j] == 'O') {
        const {new_i,new_j} = search_west(i,j,lines);
        lines[i][j] = '.';
        lines[new_i][new_j] = 'O';
      }
    }
  }
}

export function score(lines:string[][]): number {
  let sum = 0;
  for (let i = 0; i < lines.length; i++) {
    for (let j = 0; j < lines[i].length; j++) {
      if (lines[i][j] == 'O') {
        sum += lines.length - i;
      }
    }
  }
  return sum;
}

export function part_1(lines:string[][]): number {
  tilt_north(lines);
  return score(lines);
}

export function save(lines:string[][]):string {
  return lines.map((l) => l.join('')).join('\n');
}

export function cycle(lines:string[][], n:number):{fixed:number,cycle:number} {
  const seen = new Set();
  seen.add(save(lines));
  const spins = [];
  // console.log('start\n'+save(lines));
  for (let k = 0; k < n; k++) {
    tilt_north(lines);
    tilt_west(lines);
    tilt_south(lines);
    tilt_east(lines);
    const res = save(lines);
    // const s = score(lines);
    // console.log(k+'='+s+'\n'+res);
    if (seen.has(res)) {
      const first = spins.indexOf(res);
      return {fixed:first, cycle:k-first};
    }
    seen.add(res);
    spins.push(res);
  }
  throw new Error("no cycle");
}

export function spin(lines:string[][], n:number) {
  for (let k = 0; k < n; k++) {
    tilt_north(lines);
    // console.log(save(lines), "\n\n");

    tilt_west(lines);
    // console.log(save(lines), "\n\n");

    tilt_south(lines);
    // console.log(save(lines), "\n\n");

    tilt_east(lines);
    // console.log(save(lines), "\n\n");

  }
}

function copy(l:string[][]):string[][] {
  return l.map((m) => [...m]);
}

export function part_2(lines:string[][]): number {
  const pristine = copy(lines);
  const n = 1000000000;
  const res = cycle(lines, n);
  console.log(res);
  const num = (n-res.fixed) % res.cycle;
  const final = res.fixed+num;
  console.log('->', final);
  spin(pristine, final);
  return score(pristine);
  // return 0;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day14.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) => l.length>0).map((l) => l.split(''));
  console.log("part 1: ", part_1(copy(lines)));
  console.log("part 2: ", part_2(copy(lines)));
}

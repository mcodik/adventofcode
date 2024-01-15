type Node = {
  i:number,
  j:number,
  dir:string
}

function next_dir(l:string, dir:string):string[] {
  if (l == '.') {
    return [dir];
  }
  if (l == "/") {
    if (dir == 'R') {
      return ['U'];  
    }
    if (dir == 'L') {
      return ['D'];  
    }
    if (dir == 'D') {
      return ['L'];  
    }
    if (dir == 'U') {
      return ['R'];  
    }
  }
  if (l == "\\") {
    if (dir == 'R') {
      return ['D'];  
    }
    if (dir == 'L') {
      return ['U'];  
    }
    if (dir == 'D') {
      return ['R'];  
    }
    if (dir == 'U') {
      return ['L'];  
    }
  }
  if (l == "-") {
    if (dir == 'R' || dir == 'L') {
      return [dir];  
    }
    if (dir == 'D' || dir == 'U') {
      return ['R', 'L'];  
    }
  }
  if (l == "|") {
    if (dir == 'R' || dir == 'L') {
      return ['U', 'D'];
    }
    if (dir == 'D' || dir == 'U') {  
      return [dir];
    }
  }
  return [];
}

function next(n:Node, lines:string[][]):Node[] {
  const l = lines[n.i][n.j];
  const candidates:Node[] = [];
  const new_dirs = next_dir(l, n.dir);
  new_dirs.forEach((new_dir) => {
    if (new_dir == 'R') {
      candidates.push({i:n.i,j:n.j+1,dir:new_dir});
    }
    if (new_dir == 'L') {
      candidates.push({i:n.i,j:n.j-1,dir:new_dir});
    }
    if (new_dir == 'U') {
      candidates.push({i:n.i-1,j:n.j,dir:new_dir});
    }
    if (new_dir == 'D') {
      candidates.push({i:n.i+1,j:n.j,dir:new_dir});
    }});
  return candidates.filter((c) => {
    const {i,j,dir:_dir} = c;
    return i >= 0 && i < lines.length && j >= 0 && j < lines[i].length;
  });
}

function solve(start:Node, lines:string[][]):number {
  const nodes = [];
  const visited = new Set<string>();
  nodes.push(start);
  while (nodes.length > 0) {
    const n = nodes.shift()!;
    const key = `${n.i},${n.j},${n.dir}`;
    if (visited.has(key)) {
      continue;
    }
    visited.add(key);
    const next_nodes = next(n, lines);
    next_nodes.forEach((n) => {
      nodes.push(n);
    });
  }

  const energized = new Set<string>();
  visited.forEach((n) => {
    const [i,j,dir] = n.split(',');
    const key = `${i},${j}`;
    energized.add(key);
  });
  // dump(energized, lines);
  return energized.size;

}


export function part_1(lines:string[][]): number {
  const start = { i:0, j:0, dir:'R'};
  return solve(start, lines);
}


function dump(energized: Set<string>, lines: string[][]) {
  for (let i = 0; i < lines.length; i++) {
    const row = [];
    for (let j = 0; j < lines[i].length; j++) {
      const key = `${i},${j}`;
      if (energized.has(key)) {
        row.push('#');
      } else {
        row.push(lines[i][j]);
      }
    }
    console.log(row.join(''));
  }
}


export function part_2(lines:string[][]): number {
  const starts = [];
  for (let i = 0; i < lines.length; i++) {
    starts.push({i,j:0,dir:'R'});
    starts.push({i,j:lines[0].length-1,dir:'L'});
  }
  for (let j = 0; j < lines[0].length; j++) {
    starts.push({i:0,j,dir:'D'});
    starts.push({i:lines.length-1,j,dir:'U'});
  }
  let max = 0;
  starts.forEach((start) => {
    const e = solve(start, lines);
    if (e > max) {
      max = e;
    }
  });
  return max;
}


if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day16.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) => l.length>0).map((l) => l.split(''));
  console.log("part 1: ", part_1(lines));
  console.log("part 2: ", part_2(lines));
}

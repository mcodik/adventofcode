type Grid = string[];

function next_possible(i: number, j: number, pipe: string): number[][] {
  switch (pipe) {
    case "-":
      return [[i, j + 1], [i, j - 1]];
    case "|":
      return [[i + 1, j], [i - 1, j]];
    case "L":
      return [[i, j + 1], [i - 1, j]];
    case "J":
      return [[i - 1, j], [i, j - 1]];
    case "7":
      return [[i, j - 1], [i + 1, j]];
    case "F":
      return [[i + 1, j], [i, j + 1]];
    case ".":
      return [];
    case "S":
      return [];
    default:
      return [];
  }
}

function can_visit_loop(
  p: number[],
  visited: Set<string>,
  grid: Grid,
): boolean {
  const [i, j] = p;
  if (i < 0 || i >= grid.length) {
    return false;
  }
  if (j < 0 || j >= grid[i].length) {
    return false;
  }
  if (visited.has(p.join(","))) {
    return false;
  }
  if (grid[i][j] == ".") {
    return false;
  }
  return true;
}

export function next_loop(
  i: number,
  j: number,
  visited: Set<string>,
  grid: Grid,
): number[][] {
  const letter = grid[i][j];
  if (letter != "S") {
    const possible = next_possible(i, j, letter);
    return possible.filter((p) => can_visit_loop(p, visited, grid));
  }

  const s_next = [];
  for (const [di, dj] of [[-1, 0], [1, 0], [0, 1], [0, -1]]) {
    const [i_prime, j_prime] = [i + di, j + dj];
    if (can_visit_loop([i_prime, j_prime], visited, grid)) {
      const possible = next_possible(
        i_prime,
        j_prime,
        grid[i_prime][j_prime],
      );
      if (possible.map((s) => s.join(",")).indexOf([i, j].join(",")) >= 0) {
        s_next.push([i_prime, j_prime]);
      }
    }
  }
  return s_next;
}

function find_start(grid: Grid): number[] {
  for (let i = 0; i < grid.length; i++) {
    for (let j = 0; j < grid[i].length; j++) {
      if (grid[i][j] == "S") {
        return [i, j];
      }
    }
  }
  return [];
}

function main_loop(grid: Grid): Set<string> {
  const start = find_start(grid);
  const queue = [start];
  const visited = new Set<string>();
  while (queue.length > 0) {
    const curr = queue.pop()!;
    if (visited.has(curr.join(","))) {
      continue;
    }
    visited.add(curr.join(","));
    const nodes = next_loop(curr[0], curr[1], visited, grid);
    // console.log(curr, nodes);

    nodes.forEach((n) => queue.push(n));
  }
  return visited;
}

export function part_1(grid: Grid): number {
  const visited = main_loop(grid);
  return visited.size / 2;
}

function dump(
  grid: Grid,
  main: Set<string>,
  regions: Map<string, string>,
): void {
  for (let i = 0; i < grid.length; i++) {
    const line = [];
    for (let j = 0; j < grid[i].length; j++) {
      const key = [i, j].join(",");
      if (regions.has(key)) {
        line.push(regions.get(key));
      } else if (main.has(key)) {
        line.push(grid[i][j]);
      } else {
        console.log("unexpected", i, j);
      }
    }
    console.log(line.join(""));
  }
}

function flood_label_region(
  i: number,
  j: number,
  grid: Grid,
  regions: Map<string, string>,
  main: Set<string>,
): void {
  const key = [i, j].join(",");
  if (regions.has(key) || main.has(key)) {
    return;
  }

  const visited = new Set<string>();
  const queue = [[i, j]];
  let decision = "I";
  out: while (queue.length > 0) {
    const pt = queue.shift()!;
    const pt_key = pt.join(",");
    if (visited.has(pt_key)) {
      continue;
    }
    visited.add(pt_key);
    for (const [di, dj] of [[-1, 0], [1, 0], [0, 1], [0, -1]]) {
      const [i_prime, j_prime] = [pt[0] + di, pt[1] + dj];
      const prime_key = [i_prime, j_prime].join(",");
      if (main.has(prime_key)) {
        continue;
      } else if (i_prime < 0 || i_prime >= grid.length) {
        decision = "O";
        break out;
      } else if (j_prime < 0 || j_prime >= grid[i_prime].length) {
        decision = "O";
        break out;
      } else if (regions.get(prime_key) == "O") {
        decision = "O";
        break out;
      } else if (regions.get(prime_key) == "I") {
        decision = "I";
        break out;
      }
      queue.push([i_prime, j_prime]);
    }
  }

  visited.forEach((v) => regions.set(v, decision));
}

export function part_2_flood_wrong(grid: Grid): number {
  const main = main_loop(grid);
  const regions = new Map();
  for (let i = 0; i < grid.length; i++) {
    for (let j = 0; j < grid[i].length; j++) {
      flood_label_region(i, j, grid, regions, main);
    }
  }
  dump(grid, main, regions);
  return [...regions.values()].filter((x) => x == "I").length;
}

function ray_cast_region(
  i: number,
  j: number,
  grid: Grid,
  regions: Map<string, string>,
  main: Set<string>,
): void {
  const key = [i, j].join(",");
  if (main.has(key)) {
    return;
  }
  let crossing = 0;
  for (let j_prime = j; j_prime < grid[i].length; j_prime++) {
    const letter = grid[i][j_prime];
    if (!main.has([i, j_prime].join(","))) {
      continue;
    }

    if (letter == "|") {
      crossing += 1;
    } else if (letter == "F") { // FJ
      if (j_prime < grid[i].length - 1) {
        const next_letter = grid[i][j_prime + 1];
        if (main.has([i, j_prime + 1].join(",")) && next_letter == "J") {
          crossing += 1;
          j_prime++;
        }
      }
    } else if (letter == "L") { // L7
      if (j_prime < grid[i].length - 1) {
        const next_letter = grid[i][j_prime + 1];
        if (main.has([i, j_prime + 1].join(",")) && next_letter == "7") {
          crossing += 1;
          j_prime++;
        }
      }
    }
  }
  if (crossing == 0) {
    regions.set(key, "O");
  } else {
    regions.set(key, crossing % 2 == 0 ? "O" : "I");
  }
}

export function part_2(grid: Grid): number {
  const main = main_loop(grid);
  const regions = new Map();
  for (let i = 0; i < grid.length; i++) {
    for (let j = 0; j < grid[i].length; j++) {
      ray_cast_region(i, j, grid, regions, main);
    }
  }
  dump(grid, main, regions);
  return [...regions.values()].filter((x) => x == "I").length;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day10.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  // console.log("part 1: ", part_1([...lines]));
  part_2([...lines]);
  // console.log("part 2: ", part_2([...lines]));
}

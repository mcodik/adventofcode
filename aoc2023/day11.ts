function binarySearch(nums: number[], target: number): number {
  let left = 0;
  let right = nums.length - 1;

  while (left <= right) {
    const mid = Math.floor((left + right) / 2);

    if (nums[mid] === target) return mid;
    if (target < nums[mid]) right = mid - 1;
    else left = mid + 1;
  }

  return -left;
}

export function empty_dims(gaps:number[], start:number, end:number):number {
  const a = -binarySearch(gaps, start);
  const b = -binarySearch(gaps, end);
  return Math.abs(b-a);
}

export function dist(a:number[], b:number[], empty_rows:number[], empty_cols:number[], expansion:number):number {
  const row_dist = Math.abs(a[0]-b[0]);
  const col_dist = Math.abs(a[1]-b[1]);
  let sum = 0;
  sum += row_dist + col_dist;
  sum += (expansion-1)*empty_dims(empty_rows, a[0], b[0]);
  sum += (expansion-1)*empty_dims(empty_cols, a[1], b[1]);
  return sum;
}

export function find_empties(lines:string[]) {
  const empty_rows = [];
  const empty_cols = [];
  const galaxies = [];
  const cols_with_galaxies = new Set();
  for (let i = 0; i < lines.length; i++) {
    let row_has_galaxy = false;
    for (let j = 0; j < lines[i].length; j++) {
      if (lines[i][j] == '#') {
        galaxies.push([i,j]);
        cols_with_galaxies.add(j);
        row_has_galaxy = true;
      }
    }
    if (!row_has_galaxy) {
      empty_rows.push(i);
    }  
  }
  for (let j = 0; j < lines[0].length; j++) {
    if (!cols_with_galaxies.has(j)) {
      empty_cols.push(j);
    }
  }
  return {galaxies, empty_rows, empty_cols};
}

export function solve(lines:string[], expansion:number):number {
  const {galaxies, empty_cols, empty_rows} = find_empties(lines);
  let sum = 0;
  let i = 1;
  for (let a = 0; a < galaxies.length; a++) {
    for (let b = a+1; b < galaxies.length; b++) {
      const d = dist(galaxies[a], galaxies[b], empty_rows, empty_cols, expansion);
      // console.log(`${i} dist[${a+1}, ${b+1}] = ${d}`);
      i++;
      sum += d;
    }
  }
  return sum;
}

export function part_1(lines:string[]): number {
  return solve(lines, 2);
}

export function part_2(lines:string[]): number {
  return solve(lines, 1000000);
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day11.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1([...lines]));
  console.log("part 2: ", part_2([...lines]));
}

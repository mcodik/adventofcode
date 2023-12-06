import { intersection } from "https://deno.land/x/set_operations/mod.ts";

function count_winners(line:string):number {
  const [_, nums] = line.split(':');
  const [win_str, have_str] = nums.split("|");
  const winners = new Set(win_str.split(" ").filter((d) => d != "").map((s) => parseInt(s.trim())));
  const have = new Set(have_str.split(" ").filter((d) => d != "").map((s) => parseInt(s.trim())));
  return intersection(winners, have).size;
}

export function part_1(lines:string[]): number {
  let sum = 0;
  lines.forEach((line) => {
    const matches = count_winners(line);
    if (matches >= 1) {
      sum += 2**(matches-1);
    }
  });
  return sum;
}

export function part_2(lines:string[]):number {
  const table = new Array(lines.length).fill(1);
  for (let i = 0; i < lines.length; i++) {
    const winners = count_winners(lines[i]);
    const current_copies = table[i];
    for (let j = i+1; j < lines.length && j <= i+winners; j++) {
      table[j] += current_copies;
    }
  }
  let sum = 0;
  table.forEach((t) => {
    sum += t;
  });
  return sum;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day4.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1(lines));
  console.log("part 2: ", part_2(lines));
}

import { assertEquals } from "std/assert/mod.ts";
import { part_2, part_1, rotate, is_top_sym, solve_top, solve_left, solve } from "./day13.ts";

function prep(sample:string):string[] {
  return sample.split("\n").map((l) => l.trim()).filter((l) => l.length>0);
}

Deno.test("rotate", () => {
  const a = `....\n####`;
  const expected = `.#\n.#\n.#\n.#`;
  assertEquals(expected, rotate(prep(a)).join('\n'));
});

Deno.test("is_top_sym, simple", () => {
  const sample = `
  #####.##.
  #####.##.
  `;
  assertEquals(true, is_top_sym(prep(sample), 0, false));
});

Deno.test("is_top_sym, repeated", () => {
  const sample = `
  #####.##.
  #####.##.
  #####.##.
  #####.##.
  `;
  assertEquals(true, is_top_sym(prep(sample), 0, false));
  assertEquals(true, is_top_sym(prep(sample), 1, false));
  assertEquals(true, is_top_sym(prep(sample), 2, false));
});

Deno.test("is_top_sym, off by one", () => {
  const sample = `
  #####.##.
  #####.##.
  #####.##.
  #####.###
  `;
  assertEquals(true, is_top_sym(prep(sample), 0, false));
  assertEquals(false, is_top_sym(prep(sample), 1, false));
  assertEquals(false, is_top_sym(prep(sample), 2, false));
});

Deno.test("solve_top, simple", () => {
  const sample = `
  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#
  `;
  assertEquals(4, solve_top(prep(sample), false));
  assertEquals(-1, solve_left(prep(sample), false));
  assertEquals({top:4,left:0}, solve(prep(sample)));
});


Deno.test("solve_left, simple", () => {
  const sample = `
  #.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.
  `;
  assertEquals(-1, solve_top(prep(sample), false));
  assertEquals(5, solve_left(prep(sample), false));
  assertEquals({top:0,left:5}, solve(prep(sample)));
});


Deno.test("solve_left, simple", () => {
  const sample = `
  #.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.
  `;
  assertEquals(-1, solve_top(prep(sample), false));
  assertEquals(5, solve_left(prep(sample), false));
  assertEquals({top:0,left:5}, solve(prep(sample)));
});

Deno.test("nonsym 2", () => {
  const sample = `###.###.#
  ###.#....
  ##.#.###.
  ###.##.##
  ..#..#..#
  ######..#
  ##.###..#`;
  assertEquals(-1, solve_top(prep(sample), false));
  assertEquals(1, solve_left(prep(sample), false));
})

Deno.test("part1", () => {
  const sample = `#.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.
  
  #...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#`;
  assertEquals(405, part_1(sample.split("\n").map((l) => l.trim())));
});


Deno.test("part2", () => {
  const sample_1 = `#.##..##.
  ..#.##.#.
  ##......#
  ##......#
  ..#.##.#.
  ..##..##.
  #.#.##.#.`;
  assertEquals(3, solve_top(prep(sample_1), true));
  assertEquals(-1, solve_left(prep(sample_1), true));
  
  const sample_2 = `#...##..#
  #....#..#
  ..##..###
  #####.##.
  #####.##.
  ..##..###
  #....#..#`;
  assertEquals(1, solve_top(prep(sample_2), true));
  assertEquals(-1, solve_left(prep(sample_2), true));
});
import { assertEquals } from "std/assert/mod.ts";
import { part_1, solve, find_empties, dist, empty_dims } from "./day11.ts";

Deno.test("empty dims", () => {
  const gaps = [2, 5, 8];
  assertEquals(3, empty_dims(gaps, 1, 9));
  assertEquals(2, empty_dims(gaps, 3, 9));
  assertEquals(1, empty_dims(gaps, 6, 9));
  assertEquals(0, empty_dims(gaps, 9, 10));
});

Deno.test("part_1", () => {
  const data = `
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
  `;
  const lines = data.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  const expected_empty_rows = [3,7];
  const expected_empty_cols = [2,5,8];
  const {galaxies, empty_cols, empty_rows} = find_empties(lines);
  assertEquals(expected_empty_rows, empty_rows);
  assertEquals(expected_empty_cols, empty_cols);
  assertEquals([5,1], galaxies[5-1]);
  assertEquals([9,4], galaxies[9-1]);
  assertEquals(6, dist(galaxies[1-1], galaxies[3-1], empty_rows, empty_cols, 2));
  assertEquals(9, dist([5,1], [9,4], empty_rows, empty_cols, 2));
  assertEquals(15, dist(galaxies[1-1], galaxies[7-1], empty_rows, empty_cols, 2));
  assertEquals(17, dist(galaxies[3-1], galaxies[6-1], empty_rows, empty_cols,2));
  assertEquals(5, dist(galaxies[8-1], galaxies[9-1], empty_rows, empty_cols,2));
  assertEquals(374, part_1(lines));
});


Deno.test("part_2", () => {
  const data = `
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
  `;
  const lines = data.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  assertEquals(1030, solve(lines, 10));
  assertEquals(8410, solve(lines, 100));
});

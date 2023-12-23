import { assertEquals } from "std/assert/mod.ts";
import { score, spin, save, cycle, search_north, tilt_north, part_2 } from "./day14.ts";

function prep(sample:string):string[][] {
  return sample.split("\n").map((l) => l.trim()).filter((l) => l.length>0).map((l) => l.split(''));
}

Deno.test('search_north', () => {
  assertEquals({new_i:0, new_j: 1}, search_north(0, 1, [['a']]));
});

Deno.test("simple tilt", () => {
  const a = `O....#....`;
  const lines = prep(a);
  tilt_north(lines);
  // console.log(lines);
  assertEquals(a, lines.map((l) => l.join('')).join('\n'));
});


Deno.test("two line tilt", () => {
  const a = `O....#....\nOO...#....`;
  const expected = `OO...#....\nO....#....`;
  const lines = prep(a);
  tilt_north(lines);
  // console.log(lines);
  assertEquals(expected, lines.map((l) => l.join('')).join('\n'));
});

Deno.test("tilt", () => {
  const a = `O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
`;
  const expected = `OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#....`;
  const lines = prep(a);
  tilt_north(lines);
  // console.log(lines.map((l) => l.join('')).join('\n'));
  assertEquals(expected, lines.map((l) => l.join('')).join('\n'));
});

Deno.test("cycle", () => {
  const a = `O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
  `;
  // console.log(cycle(prep(a), 1000000000));
  //  const lines = prep(a);
  // for (let i = 0; i < 10; i++) {
  //   spin(lines, 1);
  //   const s = score(lines);
  //   const res = save(lines);
  //   console.log((i+1)+'='+s+'\n'+res);
  // }
  assertEquals(64, part_2(prep(a)));
});
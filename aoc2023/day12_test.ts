import { assertEquals } from "std/assert/mod.ts";
import { SAMPLE, part_1, solve, solve_str  } from "./day12.ts";

Deno.test("part1, simple", () => {
  assertEquals(1, solve_str("# 1"));
  assertEquals(0, solve_str("# 2"));
  assertEquals(0, solve_str(". 1"));
  assertEquals(0, solve_str("#.#.### 1,1,4"));
  assertEquals(1, solve_str("#.#.### 1,1,3"));
  assertEquals(1, solve_str("?.#.### 1,1,3"));
  assertEquals(1, solve_str("?.?.### 1,1,3"));
  assertEquals(1, solve_str("?.? 1,1"));
});

Deno.test("part1, edge", () => {
  assertEquals(1, solve_str("?### 3"));
  assertEquals(1, solve_str("?## 3"));
  assertEquals(1, solve_str("### 3"));
  assertEquals(1, solve_str("###. 3"));
  assertEquals(1, solve_str("?###? 3"));
});


Deno.test("part1, all wild", () => {
  assertEquals(4, solve_str("???? 1"));
  assertEquals(3, solve_str("???? 2"));
  assertEquals(2, solve_str(".??? 2"));
  assertEquals(1, solve_str("#??? 2"));
  assertEquals(2, solve_str("???? 3"));
  assertEquals(1, solve_str("???? 4"));
  assertEquals(0, solve_str("???? 5"));
});

Deno.test("part1, subproblems", () => {
  assertEquals(1, solve_str("#??? 2,1"));
  assertEquals(1, solve_str("...?##. 3"));
  assertEquals(0, solve_str("##. 3"));
  assertEquals(1, solve_str("###. 3"));
  assertEquals(1, solve_str("???? 2,1"));
  assertEquals(0, solve_str("#? 2,1"));
  assertEquals(1, solve_str("#? 1"));
  assertEquals(0, solve_str("##??.?#???. 3"));
  assertEquals(6, solve_str("?????? 2,1"));
});

Deno.test("part1, sample", () => {
  assertEquals(4, solve_str(".??..??...?##. 1,1,3"));
  assertEquals(1, solve_str("?#?#?#?#?#?#?#? 1,3,1,6"));
  assertEquals(1, solve_str("????.#...#... 4,1,1"));
  assertEquals(4, solve_str("????.######..#####. 1,6,5"));
  assertEquals(10, solve_str("?###???????? 3,2,1"));
  assertEquals(2, solve_str("?.????##??.?#???. 2,3"));
});

Deno.test("part_1", () => {
  const lines = SAMPLE.split("\n").map((l) => l.trim()).filter((l) =>
  l.length > 0
);

  assertEquals(21, part_1(lines));
})

import { assertEquals } from "std/assert/mod.ts";
import { part_1, part_2 } from "./day6.ts";

const times = [7, 15, 30];
const distances = [9, 40, 200];

Deno.test("part_1", () => {
   assertEquals(288, part_1(times, distances));
});

Deno.test("part_2", () => {
  assertEquals(4, part_2(7, 9));
  assertEquals(8, part_2(15, 40));
  assertEquals(9, part_2(30, 200));
  assertEquals(71503, part_2(71530, 940200));
});
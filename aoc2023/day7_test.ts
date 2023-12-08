import { assertEquals } from "std/assert/mod.ts";
import { part_1, part_2 } from "./day7.ts";

const data = `
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
`;
const lines = data.split("\n").map((l) => l.trim()).filter((l) =>
l.length > 0
);

Deno.test("part_1", () => {
   assertEquals(6440, part_1(lines));
});

Deno.test("part_2", () => {
  assertEquals(5905, part_2(lines));
});
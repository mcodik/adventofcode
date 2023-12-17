import { assertEquals } from "std/assert/mod.ts";
import { part_1, part_2 } from "./day10.ts";

Deno.test("part_1, simple", () => {
  const data = `
  .....
  .S-7.
  .|.|.
  .L-J.
  .....
  `;
  const lines = data.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  assertEquals(4, part_1(lines));
});

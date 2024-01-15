import { assertEquals } from "std/assert/mod.ts";
import { part_1 } from "./day16.ts";

function prep(s:string) {
  return s.split('\n').filter((l) => l.length>0).map((l) => l.trim().split(''));
}

Deno.test("part_1", () => {
  const n = `
  .|...\\....
  |.-.\\.....
  .....|-...
  ........|.
  ..........
  .........\\
  ..../.\\\\..
  .-.-/..|..
  .|....-|.\\
  ..//.|....
  `;
  assertEquals(46, part_1(prep(n)));
});
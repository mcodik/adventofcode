import { assertEquals } from "std/assert/mod.ts";
import { part_2 } from "./day15.ts";

Deno.test("part_2", () => {
  const n = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7";
  assertEquals(145, part_2(n));
});
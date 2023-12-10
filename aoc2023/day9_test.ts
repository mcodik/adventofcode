import { assertEquals } from "std/assert/mod.ts";
import { part_1, part_2 } from "./day9.ts";

Deno.test("part_1, simple", () => {
  const data = `0 3 6 9 12 15`;
  const lines = data.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  assertEquals(18, part_1(lines));
});

Deno.test("part_1, full", () => {
  const data = `
 0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
`;
  const lines = data.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  assertEquals(114, part_1(lines));
});

Deno.test("part_2, simple", () => {
  const data = `0 3 6 9 12 15`;
  const lines = data.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  assertEquals(-3, part_2(lines));
});



Deno.test("part_2, simple 2", () => {
  const data = `10 13 16 21 30 45`;
  const lines = data.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  assertEquals(5, part_2(lines));
});


Deno.test("part_2, simple 3", () => {
  const data = `1 3 6 10 15 21`;
  const lines = data.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  assertEquals(0, part_2(lines));
});
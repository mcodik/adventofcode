import { assertEquals } from "std/assert/mod.ts";
import { parse, part_1, part_2 } from "./day2.ts";

Deno.test("parse", () => {
  const game = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green";
  const expected = {
    id: 1,
    rounds: [
      { red: 4, blue: 3, green: 0 },
      { red: 1, blue: 6, green: 2 },
      { red: 0, blue: 0, green: 2 },
    ],
  };
  assertEquals(expected, parse(game));
});

Deno.test("part_1", () => {
  const lines = [
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
    "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
    "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
    "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
  ];
  assertEquals(8, part_1(lines));
});

Deno.test("part_2", () => {
  const lines = [
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
    "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
    "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
    "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
  ];
  assertEquals(2286, part_2(lines));
});
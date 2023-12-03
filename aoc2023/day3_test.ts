import { assertEquals } from "std/assert/mod.ts";
import { look_for_any_sym, part_1, part_2 } from "./day3.ts";

Deno.test("part_1", () => {
  const lines = [
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
    ".....+.58.",
    "..592.....",
    "......755.",
    "...$.*....",
    ".664.598..",
  ];
  assertEquals(4361, part_1(lines));
});

Deno.test("look_for_any_sym", () => {
  const lines = [
    "467..114..",
    "...*......",
    "..35..633.",
    "......#...",
    "617*......",
    ".....+.58.",
    "..592.....",
    "......755.",
    "...$.*....",
    ".664.598..",
  ];
  assertEquals(false, look_for_any_sym(lines, 0, 0));
  assertEquals(false, look_for_any_sym(lines, 0, 1));
  assertEquals(true, look_for_any_sym(lines, 0, 2));
});

Deno.test("part_2", () => {
  const lines = [
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
    "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
    "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
    "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
  ];
  assertEquals(0, part_2(lines));
});
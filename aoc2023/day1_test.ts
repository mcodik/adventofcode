import { assertEquals } from "std/assert/mod.ts";
import { part_1, part_2 } from "./day1.ts";

Deno.test("part_1", () => {
  const sample_part_1 = [
    "1abc2",
    "pqr3stu8vwx",
    "a1b2c3d4e5f",
    "treb7uchet",
  ];
  assertEquals(142, part_1(sample_part_1));
});

Deno.test("part_2, full", () => {
  const sample_part_2 = [
    "two1nine",
    "eightwothree",
    "abcone2threexyz",
    "xtwone3four",
    "4nineeightseven2",
    "zoneight234",
    "7pqrstsixteen",
  ];
  assertEquals(281, part_2(sample_part_2));
});

Deno.test("part_2, simple, words", () => {
  const sample_part_2 = [
    "two1nine",
  ];
  assertEquals(29, part_2(sample_part_2));
});

Deno.test("part_2, simple, mixed", () => {
  const sample_part_2 = [
    "two1",
  ];
  assertEquals(21, part_2(sample_part_2));
});


Deno.test("part_2, one word", () => {
    const sample_part_2 = [
      "one",
    ];
    assertEquals(11, part_2(sample_part_2));
  });
  

Deno.test("part_2, from input, mixed", () => {
  const sample_part_2 = [
    "3fiveone", // 31
    "eightnineseventwo1seven", // 87
    "9h1xcrcggtwo38", // 98
    "nine4pvtl", //94
  ];
  assertEquals(31+87+98+94, part_2(sample_part_2));
});

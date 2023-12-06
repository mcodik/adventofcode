import { assertEquals } from "std/assert/mod.ts";
import { project, project_many, parse, part_1, part_2 } from "./day5.ts";
const data = `seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
  `;

Deno.test("project_many", () => {
  const a = parse(data.split('\n').map((m) => m.trim()));
  assertEquals(81, project_many(79, a.m.seed_to_soil));
  assertEquals(14, project_many(14, a.m.seed_to_soil));
  assertEquals(57, project_many(55, a.m.seed_to_soil));
  assertEquals(13, project_many(13, a.m.seed_to_soil));
});


Deno.test("part_1", () => {
   assertEquals(35, part_1(data.split('\n').map((m) => m.trim())));
});



Deno.test("part_2", () => {
  
});
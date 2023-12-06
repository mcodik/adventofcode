type Mapping = {
  dest_start: number;
  src_start: number;
  length: number;
};

type Almanac = {
  seeds: number[];
  m: Record<Maps, Mapping[]>;
};

type Maps =
  | "seed_to_soil"
  | "soil_to_fertilizer"
  | "fertilizer_to_water"
  | "water_to_light"
  | "light_to_temperature"
  | "temperature_to_humidity"
  | "humidity_to_location";

export function project(n: number, m: Mapping): number | null {
  if (n < m.src_start || n > m.src_start + m.length) {
    return null;
  }
  return (n - m.src_start) + m.dest_start;
}

export function project_many(n: number, ms: Mapping[]): number {
  for (const m of ms) {
    const projected = project(n, m);
    if (projected != null) {
      return projected;
    }
  }
  return n;
}

export function parse(lines: string[]): Almanac {
  const a: Almanac = {
    seeds: [],
    m: {
      seed_to_soil: [],
      soil_to_fertilizer: [],
      fertilizer_to_water: [],
      water_to_light: [],
      light_to_temperature: [],
      temperature_to_humidity: [],
      humidity_to_location: [],
    },
  };
  const seed_str = lines.shift()!;
  const [_, seeds] = seed_str.split(":");
  a.seeds = seeds.split(" ").filter((s) => s.length > 0).map((s) => parseInt(s));
  lines.shift();
  let current_map: Maps = "seed_to_soil";
  while (lines.length > 0) {
    const line = lines.shift()!;
    if (line == "") {
      continue;
    }
    if (line.endsWith("map:")) {
      const key = line.split(" ")[0].replaceAll(/-/g, "_") as Maps;
      current_map = key;
      continue;
    }
    const [dest_start, src_start, length] = line.split(" ").map((o) =>
      parseInt(o)
    );
    const m = { dest_start, src_start, length };
    a.m[current_map].push(m);
  }
  return a;
}

export function part_1(lines: string[]): number {
  const almanac = parse(lines);
  let min = -1;
  for (const seed of almanac.seeds) {
    const p1 = project_many(seed, almanac.m.seed_to_soil);
    const p2 = project_many(p1, almanac.m.soil_to_fertilizer);
    const p3 = project_many(p2, almanac.m.fertilizer_to_water);
    const p4 = project_many(p3, almanac.m.water_to_light);
    const p5 = project_many(p4, almanac.m.light_to_temperature);
    const p6 = project_many(p5, almanac.m.temperature_to_humidity);
    const p7 = project_many(p6, almanac.m.humidity_to_location);
    if (min == -1 || p7 < min) {
      min = p7;
    }
  }
  return min;
}

export function part_2(lines: string[]): number {
  let sum = 0;
  return sum;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day5.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1(lines));
  console.log("part 2: ", part_2(lines));
}

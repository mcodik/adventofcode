
function* directions(cmds:string) {
  let i = 0;
  while (true) {
    i = i % cmds.length;
    yield cmds[i];
    i++;
  }
}

type Graph = Map<string, string[]>;

function parse(lines:string[]):Graph {
  const graph = new Map();
  lines.forEach((line) => {
    const matches = line.match(/([A-Z]+) = \(([A-Z]+), ([A-Z]+)\)/)!;
    graph.set(matches[1], [matches[2], matches[3]]);
    // console.log(matches[1], [matches[2], matches[3]]);
  });
  return graph;
}

function solve(start:string, cmds:string, graph:Graph, end:(x:string)=>boolean):number {
  let node = start;
  let steps = 0;
  for (const dir of directions(cmds)) {
    // console.log(node);
    const choices = graph.get(node)!;
    if (dir == "R") {
      node = choices[1];
    } else {
      node = choices[0];
    }
    steps += 1;
    if (end(node)) {
      break;
    }
  }
  return steps;
}

export function part_1(lines:string[]): number {
  const cmds = lines.shift()!;
  const graph = parse(lines);
  return solve('AAA', cmds, graph, (x) => x == 'ZZZ');
}

export function part_2(lines:string[]): number[] {
  const cmds = lines.shift()!;
  const graph = parse(lines);
  const nodes = [...graph.keys()].filter((n) => n[n.length - 1] == "A");
  const steps = nodes.map((n) => solve(n, cmds, graph, (x) => x[x.length-1] == "Z"));
  return steps;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day8.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1([...lines]));
  console.log("part 2: ", part_2([...lines]));
  console.log("use wolfram alpha to compute the least common multiple of the part2 nums!")
}

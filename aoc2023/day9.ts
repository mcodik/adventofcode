
export function solve_seq_end(line:string):number {
  let nums = line.split(' ').map((s) => parseInt(s));
  let extrapolated = nums[nums.length-1];
  while (true) {
    let all_zero = true;
    let deltas = [];
    for (let i = 1; i < nums.length; i++) {
      const delta = nums[i] - nums[i-1];
      if (delta != 0) {
        all_zero = false;
      }
      deltas.push(delta);
    }
    // console.log(deltas);
    if (all_zero) {
      return extrapolated;
    } else {
      nums = deltas;
      extrapolated += deltas[deltas.length-1];
      deltas = [];
    }
  }
}


export function solve_seq_start(line:string):number {
  let nums = line.split(' ').map((s) => parseInt(s));
  const seq = [nums];
  while (true) {
    let all_zero = true;
    let deltas = [];
    for (let i = 1; i < nums.length; i++) {
      const delta = nums[i] - nums[i-1];
      if (delta != 0) {
        all_zero = false;
      }
      deltas.push(delta);
    }
    if (!all_zero) {
      seq.push(deltas);
      nums = deltas;
      deltas = [];
    } else {
      break;
    }
  }
  // console.log(seq);
  let extrapolated = 0;
  for (let j = seq.length-1; j >= 0; j--) {
    extrapolated = seq[j][0] - extrapolated;
  }
  return extrapolated;
}

export function part_1(lines:string[]): number {
  const extrapolated = lines.map((l) => solve_seq_end(l));
  let sum = 0;
  extrapolated.forEach((l) => {
    sum += l;
  })
  return sum;
}

export function part_2(lines:string[]): number {
  const extrapolated = lines.map((l) => solve_seq_start(l));
  let sum = 0;
  extrapolated.forEach((l) => {
    sum += l;
  })
  return sum;
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day9.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1([...lines]));
  console.log("part 2: ", part_2([...lines]));
}

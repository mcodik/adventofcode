
function hash(s:string):number {
  let curr = 0;
  for (let i = 0; i < s.length; i++) {
    curr += s.charCodeAt(i);
    curr *= 17;
    curr %= 256;
  }
  return curr;
}

export function part_1(line:string): number {
  let sum = 0;
  line.split(',').forEach((s) => {
    sum += hash(s);
  })
  return sum;
}

type Entry = {
  label:string, num:number
}

export function part_2(line:string): number {
  const m:Entry[][] = [];
  line.split(',').forEach((s) => {
    if (s.indexOf('-') >= 0) {
      const label = s.substring(0, s.length-1);
      const i = hash(label);
      if (!m[i]) {
        return;
      }
      const new_m = m[i].filter((e) => e.label != label);
      m[i] = new_m;
    } else {
      const [label, num] = s.split('='); 
      const e = { label, num: parseInt(num) };
      const i = hash(label);
      // console.log(i, e);
      if (!m[i]) {
        m[i] = [e];
      } else {
        let added = false;
        for (let j = 0; j < m[i].length; j++) {
          if (m[i][j].label == label) {
            m[i][j].num = e.num;
            added = true;
            break;
          }
        }
        if (!added) {
          m[i].push(e);
        }
      }
    }
  });

  // console.log(m);

  let power = 0;
  for (let i = 0; i < m.length; i++) {
    if (!m[i]) {
      continue;
    }
    for (let j = 0; j < m[i].length; j++) {
      power += (i+1) * (j+1) * m[i][j].num;
    }
  }
  return power;
}


if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day15.txt");
  const lines = text.trim();
  console.log("part 1: ", part_1(lines));
  console.log("part 2: ", part_2(lines));
}

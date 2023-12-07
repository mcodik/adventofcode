/*
win: (time - hold) * hold > distance
-x*2 + tx - d = 0
-0.5*(-t+-sqrt(t**2 + 4d))
*/



function race(hold: number, time: number): number {
  return (time - hold) * hold;
}

function ways_to_win(time: number, distance: number): number {
  let s = 0;
  for (let i = 0; i <= time; i++) {
    const raced = race(i, time);
    if (raced > distance) {
      s += 1;
    }
  }
  return s;
}

export function part_1(times: number[], distances: number[]): number {
  let product = 1;
  for (let i = 0; i < times.length; i++) {
    product *= ways_to_win(times[i], distances[i]);
  }
  return product;
}

export function part_2(time: number, distance: number): number {
  const disc = Math.sqrt((time * time) - (4*distance));
  let low = Math.floor(-0.5*(-time + disc))-1;
  let high = Math.ceil(-0.5*(-time - disc))+1;
  // console.log(low, high);
  while (true) {
    if (race(low, time) <= distance) {
      low += 1;
    } else {
      low -= 1;
      break;
    }
  }
  while (true) {
    if (race(high, time) <= distance) {
      high -= 1;
    } else {
      high += 1;
      break;
    }
  }
  console.log(low, high);

  return high-low-1;
}

if (import.meta.main) {
  const times = [46, 85, 75, 82];
  const distances = [208, 1412, 1257, 1410];
  console.log("part 1: ", part_1(times, distances));
  console.log("part 2: ", part_2(46857582, 208141212571410));
}

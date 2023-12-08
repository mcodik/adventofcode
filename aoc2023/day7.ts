
type Hand = { cards:string, bid: number };

function parse(line:string):Hand {
  const [cards, bid_str] = line.split(' ').map((s) => s.trim());
  const bid = parseInt(bid_str);
  return {cards,bid};
}


function points(cards:string, jokers:boolean):number {
  const hist = new Map();
  for (let i = 0; i < cards.length; i++) {
    const card = cards[i];
    if (hist.has(card)) {
      hist.set(card, 1 + hist.get(card));
    } else {
      hist.set(card, 1);
    }
  }

  if (jokers && hist.has('J')) {
    const n_jokers = hist.get('J');
    if (n_jokers < 5) {
      hist.delete('J');
      const keys = [...hist.keys()];
      keys.sort((a,b) => hist.get(b) - hist.get(a));
      hist.set(keys[0], hist.get(keys[0]) + n_jokers);
    }
  }

  const vals = [...hist.values()];
  vals.sort((a,b) => b-a);
  const vals_str = vals.join('');
  // console.log(cards, vals_str);
  switch (vals_str) {
    case "5": return 7;
    case "41": return 6;
    case "32": return 5;
    case "311": return 4;
    case "221": return 3;
    case "2111": return 2;
    case "11111": return 1;
    default: return 0;
  }
}

export function compare_hands(a:Hand, b:Hand, jokers:boolean):number {
  const pts_a = points(a.cards, jokers);
  const pts_b = points(b.cards, jokers);
  // console.log(a.cards, pts_a, b.cards, pts_b);
  const diff = pts_a - pts_b;
  if (diff != 0) {
    return diff;
  }
  const ranks = jokers ? "J23456789TQKA" : "23456789TJQKA";
  for (let i = 0; i < 5; i++) {
    const a_idx = ranks.indexOf(a.cards[i]);
    const b_idx = ranks.indexOf(b.cards[i]);
    const diff_idx = a_idx-b_idx;
    if (diff_idx != 0) {
      return diff_idx;
    }
  }
  return 0;
}

function solve(lines:string[], jokers:boolean):number {
  const hands = lines.map((l) => parse(l));
  hands.sort((a, b) => compare_hands(a, b, jokers));
  let sum = 0;
  console.log(hands.slice(0, 10));
  hands.forEach((h, i) => {
    sum += h.bid * (i + 1);
  })
  return sum;
}

export function part_1(lines:string[]): number {
  return solve(lines, false);
}

export function part_2(lines:string[]): number {
  return solve(lines, true);
}

if (import.meta.main) {
  const text = await Deno.readTextFile("inputs/day7.txt");
  const lines = text.split("\n").map((l) => l.trim()).filter((l) =>
    l.length > 0
  );
  console.log("part 1: ", part_1(lines));
  console.log("part 2: ", part_2(lines));
}
